module basemul(	i_clk, i_rstn, i_en, 
		i_p_h, i_p_l, i_q_h, i_q_l, i_zeta, 
		o_r_h, o_r_l,
		o_done
	);

	input			i_clk;
	input			i_rstn;
	input			i_en;

	input		[11:0]	i_p_h, i_p_l;
	input		[11:0]	i_q_h, i_q_l;
	input		[11:0]	i_zeta;

	output		[11:0]	o_r_h, o_r_l;
	output			o_done;

	localparam	IDLE 	= 3'd0;
	localparam	FIRST	= 3'd1;
	localparam	SECOND	= 3'd2;
	localparam	THIRD	= 3'd3;
	localparam	FOURTH	= 3'd4;
	localparam	DONE	= 3'd5;
	localparam	R_SQU	= 12'd2385;	// 4096^2 mod 3329 = 2385

	////////////////////////////////////////////////////
	// FlipFlops	
	reg		[2:0]	c_state, n_state;
	reg		[11:0]	c_temp1, n_temp1;
	reg		[11:0]	c_temp2, n_temp2;
	reg		[11:0]	c_temp3, n_temp3;
	reg		[11:0]	c_temp4, n_temp4;

	// wires
	reg		[11:0]	mont_in1, mont_in2, mont_in3, mont_in4;
	reg			mont_en;
	wire		[11:0]	mont_out1, mont_out2;
	wire			mont_done1, mont_done2;	
	wire		[13:0]	barret_in1, barret_in2;
	wire		[11:0]	barret_out1, barret_out2;
	////////////////////////////////////////////////////
	// State Transition logic
	always @(posedge i_clk, negedge i_rstn)
	begin
		if(!i_rstn)
		begin
		c_state	<= IDLE;
		c_temp1	<= 12'd0;
		c_temp2	<= 12'd0;
		c_temp3	<= 12'd0;
		c_temp4	<= 12'd0;
		end
		else
		begin
		c_state	<= n_state;
		c_temp1	<= n_temp1;
		c_temp2	<= n_temp2;
		c_temp3	<= n_temp3;
		c_temp4	<= n_temp4;
		end
	end

	// n_state
	always @(*)
	begin
		n_state = c_state;
		case(c_state)
		IDLE:		if(i_en)			n_state = FIRST;
		FIRST:		if(mont_done1 & mont_done2)	n_state = SECOND;	
		SECOND:		if(mont_done1 & mont_done2)	n_state = THIRD;
		THIRD:		if(mont_done1 & mont_done2)	n_state = FOURTH;
		FOURTH:		if(mont_done1 & mont_done2)	n_state = DONE;
		DONE:						n_state = IDLE;
		endcase
	end	


	// n_temp1 ~ n_temp4
	always @(*)
	begin
		n_temp1 = c_temp1;
		n_temp2 = c_temp2;
		n_temp3 = c_temp3;
		n_temp4 = c_temp4;
		case(c_state)
	//	IDLE:	
		FIRST:
			if(mont_done1 & mont_done2)
			begin
			n_temp1 = mont_out1;
			n_temp2 = mont_out2;
			end
		SECOND:
			if(mont_done1 & mont_done2)
			begin
			n_temp3 = mont_out1;
			n_temp4 = mont_out2;
			end
		THIRD:
			if(mont_done1)
			begin
			n_temp1 = mont_out1;
			end
		FOURTH:
			if(mont_done1 & mont_done2)
			begin
			n_temp1 = mont_out1;	
			n_temp2 = mont_out2;	
			end
		DONE:
			begin
			n_temp1 = 12'd0;	
			n_temp2 = 12'd0;	
			end
		endcase
	end


	///////////////////////////////////////////////////
	// montgomery	
	montgomery	m1(.i_clk(i_clk), .i_rstn(i_rstn), .i_en(mont_en), .i_a(mont_in1), .i_b(mont_in2), .o_c(mont_out1), .o_done(mont_done1) );
	montgomery	m2(.i_clk(i_clk), .i_rstn(i_rstn), .i_en(mont_en), .i_a(mont_in3), .i_b(mont_in4), .o_c(mont_out2), .o_done(mont_done2) );
	
	// mont_in1 ~ mont_in4
	always @(*)
	begin
		mont_in1 = 12'd0;
		mont_in2 = 12'd0;
		mont_in3 = 12'd0;
		mont_in4 = 12'd0;
		case(c_state)
		IDLE:
			begin
			mont_in1 = i_p_h;	// p[1]
			mont_in2 = i_q_h;	// q[1]
			mont_in3 = i_p_l;	// p[0]
			mont_in4 = i_q_l;	// q[0]
			end
		FIRST:
			begin
			mont_in1 = i_p_l;	// p[0]
			mont_in2 = i_q_h;	// q[1]
			mont_in3 = i_p_h;	// p[1]
			mont_in4 = i_q_l;	// q[0]
			end	
		SECOND:
			begin
			mont_in1 = c_temp1;	// p[1]q[1]
			mont_in2 = i_zeta;	// zeta
			end
		THIRD:
			begin
			mont_in1 = barret_out1;	// barret output1
			mont_in2 = R_SQU;	// R_SQUARE
			mont_in3 = barret_out2;	// barret output2
			mont_in4 = R_SQU;	// R_SQUARE
			end	
	//	FOURTH:
	//	DONE:	
		endcase
	end

	always @(*)
	begin
		mont_en = 1'd0;
		case(c_state)
		IDLE:	if(i_en)	mont_en = 1'd1;
		FIRST:	if(i_en)	mont_en = 1'd1;
		SECOND:	if(i_en)	mont_en = 1'd1;
		THIRD:	if(i_en)	mont_en = 1'd1;
	//	FOURTH:
	//	DONE:
		endcase
	end
	

	// barret
	
//	assign	barret_in1 = c_temp1 + c_temp2;
	assign	barret_in1 = n_temp1 + c_temp2;		// logic 복잡도 증가?
//	assign	barret_in1 = mont_out1 + c_temp2;	same
	assign	barret_in2 = c_temp3 + c_temp4;

	barrett		b1(.i_in(barret_in1), .o_out(barret_out1) );
	barrett		b2(.i_in(barret_in2), .o_out(barret_out2) );

	
	
	////////////////////////////////////////////////////
	// Output logic
	assign	o_r_h 	= o_done ? c_temp2 : 12'd0;	// r[1]		
	assign	o_r_l 	= o_done ? c_temp1 : 12'd0;	// r[0]
	assign	o_done	= (c_state==DONE);	



endmodule
