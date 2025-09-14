module montgomery_temp(i_a, i_b, i_clk, i_rstn, i_en, , i_morb, o_c, o_done);
	
	parameter KYBER_Q= 12'd3329;
	parameter Q_INVn = 12'd3327;
	parameter KYBER_R = 1<<12;

	input 		i_clk, i_rstn, i_en; // i_en : start signal
	input	[1:0]	i_morb;				//i_morb : montgomery or barrett signal
										//			10 : montgomery
										//			00 : plus and barrett 	(i_a + i_b)
										//			01 : minus and barrett	(i_a - i_b)
	input 	[11:0] 	i_a, i_b;
	output 	[11:0] 	o_c;
	output		o_done;
	
		
	reg	[11:0]	mux_1;
	reg	[11:0]	mux_2;
	reg	[23:0]	mux_3;

	reg	[2:0]	c_state;
	reg	[2:0]	n_state;
	reg	[23:0]	c_reg1;
	reg	[23:0]	n_reg1;
	reg	[23:0]	c_reg2;
	reg	[23:0]	n_reg2;
	reg	[24:0]	c_reg3;
	reg	[24:0]	n_reg3;
	reg	c_done;
	reg	n_done;

	wire	[23:0]	temp_add1;
	wire	[23:0]	temp_add2;
	wire	[23:0]	padded_a1;
	wire	[23:0]	padded_b1;
	wire	[23:0]	padded_b2;
	wire	[23:0]	mul_out;
	wire	[24:0]	add_out;

	wire	[23:0]	mont_out;
	wire	[23:0]	aom_out;	// add or minus out
	wire	[23:0]	temp_output;

////@@@
	always @(posedge i_clk, negedge i_rstn)
	begin
		if(!i_rstn)
		begin
		c_state = 3'd0;
		c_reg1 	= mul_out;
		c_reg2 	= 24'd0;
		c_reg3 	= 25'd0;
		c_done	= 1'd0;
		end	
		else
		begin
		c_state = n_state;
		c_reg1	= n_reg1;
		c_reg2	= n_reg2;
		c_reg3	= n_reg3;
		c_done	= n_done;
		end
	end
///@@@
	assign padded_a1 = {{12{1'd0}},i_a}; 
	assign padded_b1 = {{12{1'd0}},i_b}; 
	assign padded_b2 = {{12{1'd0}},{12'd3329 - i_b}}; 

	assign temp_add1 = (i_morb[1]) ? c_reg1 : padded_a1;
	assign temp_add2 = (i_morb[1]) ? c_reg2 : (i_morb[0]) ? padded_b1 : padded_b2;

	assign o_done = (c_done == 2'd1) ? 1 : 0;
	assign mul_out = mux_1 * mux_2;
	assign add_out = temp_add1 + temp_add2;
	assign o_c = c_reg3[11:0];
	assign mont_out = {{11{1'd0}},add_out[24:12]};
	assign aom_out = {{11{1'd0}},add_out[12:0]};
	assign temp_output = (i_morb[1]) ? mont_out	: aom_out;

	//n_state
	always @(*) begin
	n_state = c_state +1;
	if (c_state == 3'd3 && i_morb[1] == 1) n_state = 0;
	else if (c_state == 3'd0 && i_morb[1] == 0) n_state = 0;
	end
	
	always @(*) begin
	if (c_state == 3'd3 && i_morb[1] == 1)	n_done = 1;
	else if (c_state == 3'd0 && i_morb[1] == 0) n_done = 1;
	else					n_done = 0;
	end

	//n_reg1
	always @(*) begin
	n_reg1 = mul_out;
	end

	always @(*) begin
	n_reg2 = mux_3;
	end


	always@(*) begin
	if (c_state == 3'd0)	mux_1 = i_a;
	else					mux_1 = c_reg1[11:0];
	end

	always@(*) begin
	mux_2 = i_b;
	case(c_state)
		3'd0 : mux_2 = i_b;
		3'd1 : mux_2 = Q_INVn;
		3'd2 : mux_2 = KYBER_Q;
		3'd3 : mux_2 = KYBER_Q;
	endcase
	end
	
	always@(*) begin
	mux_3 = mul_out;
	case(c_state)
		3'd0 : mux_3 = mul_out;
		3'd1 : mux_3 = c_reg2;
		3'd2 : mux_3 = c_reg2;
		3'd3 : mux_3 = c_reg2;
	endcase
	end
	
	always@(*) begin
			if 		( temp_output > 6657 ) 	n_reg3	= temp_output - 6658;
			else if	( temp_output > 3328 ) 	n_reg3	= temp_output - 3329;
			else				n_reg3 = temp_output;

	end



endmodule
