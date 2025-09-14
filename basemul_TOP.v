module Basemul_TOP(	i_clk, i_rstn, i_en, 
			i_p, i_q, 
			o_basemul, o_done
	);

	input				i_clk;
	input				i_rstn;
	input				i_en;
	
	input		[3071:0]	i_p;	// a_255, a_254, ... , a_1, a_0
	input		[3071:0]	i_q;	// b_255, b_254, ... , b_1, b_0

	output	reg	[3071:0]	o_basemul;
	output				o_done;

	localparam	IDLE	= 2'd0;
	localparam	BASE	= 2'd1;
	localparam	DONE	= 2'd2;
	localparam	COUNT	= 3'd6;

	////////////////////////////////////////////////////
	// FlipFlops
	reg		[1:0]	c_state, 		n_state;
	reg		[6:0]	c_cnt_num,		n_cnt_num;
	reg		[23:0]	c_o_temp[0:127],	n_o_temp[0:127];	// NTT의 FF 이용불가?

	// wires
	integer		i;
	wire		BM_done;	
	reg	[23:0]	p_temp[0:127], q_temp[0:127];	
	wire 	[11:0] 	p_h_input;
	wire 	[11:0]	p_l_input;	
	wire 	[11:0] 	q_h_input;
	wire 	[11:0] 	q_l_input;	
	wire	[11:0]	zeta;
	reg	[11:0]	temp_zeta;
	wire	[11:0]	r_h_output;
	wire	[11:0]	r_l_output;
	
	wire	[11:0]	o_f, o_s;	// not used

	/////////////////////////////////////////////////////
	// State Transition logic
	always @(posedge i_clk, negedge i_rstn)
	begin
		if(!i_rstn)
		begin
		for(i=0;i<128;i=i+1)	c_o_temp[i] <= 24'd0;
		c_state		<= IDLE;
		c_cnt_num	<= 7'd0;
		end
		else
		begin
		for(i=0;i<128;i=i+1)	c_o_temp[i] <= n_o_temp[i];
		c_state		<= n_state;
		c_cnt_num	<= n_cnt_num;
		end
	end	

	// n_state
	always @(*)
	begin
		n_state = c_state;
		case(c_state)
		IDLE:	if(i_en)				n_state = BASE;
		BASE:	if( (c_cnt_num==7'd127) & BM_done )	n_state = DONE;
		DONE:						n_state = IDLE;
		endcase
	end	

	// n_o_temp
	always @(*)
	begin
		for(i=0;i<128;i=i+1)	n_o_temp[i] = c_o_temp[i];
		case(c_state)
	//	IDLE:
		BASE:
			if(BM_done)
			begin
						n_o_temp[c_cnt_num][23:12] = r_h_output;	// r[1]
						n_o_temp[c_cnt_num][11:0]  = r_l_output;	// r[0]
			end
		DONE:
			for(i=0;i<128;i=i+1)	n_o_temp[i] = 24'd0;
		endcase
	end

	// n_cnt_num
	always @(*)
	begin
		if( (c_state==BASE) & BM_done)	n_cnt_num = c_cnt_num+1;
		else				n_cnt_num = c_cnt_num;
	end	

	//////////////////////////////////////////////////////////////////////////
	// basemul
	basemul		bm0(	.i_clk(i_clk), .i_rstn(i_rstn), .i_en(i_en), 
				.i_p_h(p_h_input), .i_p_l(p_l_input), .i_q_h(q_h_input), .i_q_l(q_l_input), .i_zeta(temp_zeta),
				.o_r_h(r_h_output), .o_r_l(r_l_output), .o_done(BM_done) );	

	always @(*)
	begin
		for (i=0; i<128; i=i+1)	
		begin	
		//	p_temp[i] <= i_p[3071-(i*24) -:24];
		//	q_temp[i] <= i_q[3071-(i*24) -:24];
			p_temp[i] <= i_p[i*24 +:24];
			q_temp[i] <= i_q[i*24 +:24];
		end	
	end
	
	assign p_h_input = p_temp[c_cnt_num][23:12];	// p[1]
	assign p_l_input = p_temp[c_cnt_num][11: 0];	// p[0]
	assign q_h_input = q_temp[c_cnt_num][23:12];	// q[1]
	assign q_l_input = q_temp[c_cnt_num][11: 0];	// q[0]
	

	selector_zeta sz0 (
		.i_cnt_stage(COUNT),
		.i_cnt_num(c_cnt_num),
		.o_zeta(zeta),
		.o_first(o_f),
		.o_second(o_s)
		);


	always @(*)
	begin
		if (c_cnt_num[0] == 0)	temp_zeta = zeta;
		else			temp_zeta = 3329-zeta;
	end


	//////////////////////////////////////////////////////////////////////////////
	// Output logic
	always @(*)
	begin
		for (i=0; i<128; i=i+1) 
			o_basemul[i*24 +:24] = c_o_temp[i];	
	end

	assign	o_done = (c_state==DONE);
	

endmodule
