module NTT(	i_clk, i_rstn, i_start, 
		i_poly, 
		o_ntt,
		o_done
	);

	localparam		IDLE 	= 2'd0;
	localparam		START 	= 2'd1;
	localparam		NTT 	= 2'd2;
	localparam		DONE 	= 2'd3;

	
	input 				i_clk;
	input				i_rstn;
	input				i_start;	// start siganl
	input		[3071:0]	i_poly;
	output	reg	[3071:0]	o_ntt;
	output				o_done;

/////////////////////////////////////////
	wire			BU_done;
	wire	[11:0]		BU_x_input;
	wire	[11:0]		BU_y_input;
	wire	[11:0]		zeta;
	wire	[11:0]		BU_h_output;
	wire	[11:0]		BU_l_output;
	
	wire	[7:0]		selector_first, selector_first_pre;	
	wire	[7:0]		selector_second, selector_second_pre;	

	integer i;


	// FlipFlops //	
	reg	[11:0]		c_temp[0:255], 	n_temp[0:255];
	reg	[1:0]		c_state, 	n_state;
	reg	[2:0]		c_cnt_stage, 	n_cnt_stage;	// 0 ~ 6
	reg	[6:0]		c_cnt_num, 	n_cnt_num;	// 0 ~ 127
//	reg			c_BU_enable,	n_BU_enable;	

	reg			BU_enable;

	always @(posedge i_clk, negedge i_rstn)
	begin
		if(!i_rstn)
		begin
			for(i=0; i<256; i=i+1)	c_temp[i] <= 12'd0;		// possible??
			c_state		<= 2'd0;
			c_cnt_stage	<= 3'd0;
			c_cnt_num	<= 7'd0;
//			c_BU_enable	<= 1'd0;
		end
		else
		begin
			for(i=0; i<256; i=i+1)	c_temp[i] <= n_temp[i];		// possible??
			c_state		<= n_state;
			c_cnt_stage	<= n_cnt_stage;
			c_cnt_num	<= n_cnt_num;	
//			c_BU_enable	<= n_BU_enable;	
		end
	end
	
	
	// n_temp
	always @(*)
	begin
		for(i=0; i<256; i=i+1)	n_temp[i] = c_temp[i];
		case(c_state)
		IDLE:	
			if(i_start)
				for(i=0; i<256; i=i+1)	n_temp[i] = i_poly[12*i +:12];		// i_poly : a_255, a_254, ... , a_1, a_0
		NTT:	if(BU_done)
			begin
						n_temp[selector_first] 	= BU_h_output;	
						n_temp[selector_second] = BU_l_output;	
					end
		endcase
	end	
	
	// n_state
	always @(*)
	begin
		n_state = c_state;
		case(c_state)
		IDLE:	if(i_start)	n_state = START;
		START:			n_state = NTT;
		NTT:			if( (c_cnt_stage == 3'd6) & (c_cnt_num == 7'd127) & BU_done )	n_state = DONE;
					else								n_state = NTT;
		DONE:			n_state = IDLE;
		endcase
	end	
	
	// n_cnt_stage
	always @(*)
	begin	
		n_cnt_stage = c_cnt_stage;
		case(c_state)
		IDLE:	n_cnt_stage = 1'd0;
		NTT:	if( (c_cnt_num == 7'd127) && (BU_done) )	n_cnt_stage = c_cnt_stage+1;	
		endcase
	end

	
	// n_cnt_num
	always @(*)
	begin
		n_cnt_num = c_cnt_num;
		case(c_state)
		IDLE:	n_cnt_num = 1'd0;
		NTT:	if(BU_done)	n_cnt_num = c_cnt_num + 1;	
		endcase
	end	

/*
	// n_BU_enable
	always @(*)
	begin
		n_BU_enable = 1'd0;
		case(c_state)
		IDLE:	if(i_start)	n_BU_enable = 1'd1;	
	//	NTT:	if(BU_done)	n_BU_enable = 1'd1;
		NTT:	if( ( (c_cnt_stage != 3'd6) | (c_cnt_num != 7'd127) ) & BU_done )	n_BU_enable = 1'd1;	// 가장 마지막에는 BU_enable = 1'd0으로.
		endcase
	end
*/	
	// BU_enable
	always @(*)
	begin
		BU_enable = 1'd0;
		case(c_state)
		START:	BU_enable = 1'd1;
		NTT:	if( ( (c_cnt_stage != 3'd6) | (c_cnt_num != 7'd127) ) & BU_done )	BU_enable = 1'd1;
		endcase
	end
	
	
	

	selector	s0(.i_cnt_stage(c_cnt_stage), .i_cnt_num(c_cnt_num), .o_first(selector_first), .o_second(selector_second) );
	selector_zeta	s1(.i_cnt_stage(n_cnt_stage), .i_cnt_num(n_cnt_num), .o_first(selector_first_pre), .o_second(selector_second_pre), .o_zeta(zeta) );
//	zetas		z0(.i_cnt_stage(n_cnt_stage), .i_cnt_num(n_cnt_num), .o_zeta(zeta) );	
	// 여기 들어가는 i_cnt_stage, i_cnt_num을 control 필요.
	// BU_x_input, BU_y_input, zeta는 c_cnt_stage, c_cnt_num보다 앞선 cnt 필요		

	assign		BU_x_input = c_temp[selector_first_pre];
	assign		BU_y_input = c_temp[selector_second_pre];

	
	butterfly_unit	b0(	.i_clk(i_clk), .i_rstn(i_rstn), 
				.i_x(BU_x_input), .i_y(BU_y_input), .i_zeta(zeta), .i_en(BU_enable), 
				.o_z_h(BU_h_output), .o_z_l(BU_l_output), .o_done(BU_done) 
			);



//////// 	Output logic 	///////////////	
	
	always @(*)
	begin
	for(i=0; i<256; i=i+1)
		o_ntt[12*i +:12] = c_temp[i];		// o_ntt : c_255, c_254, ... , c_1, c_0
	//	o_ntt[3071-12*i -:12] = c_temp[i];	// o_ntt : c_0, c_1, ... , c_254, c_255            
	end	

	assign	o_done = ( c_state == DONE );

endmodule
