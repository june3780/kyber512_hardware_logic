module montgomery(i_a, i_b, i_clk, i_rstn, i_en, o_c, o_done);
	
	parameter KYBER_Q= 12'd3329;
	parameter Q_INVn = 12'd3327;
	parameter KYBER_R = 1<<12;

	input 		i_clk, i_rstn, i_en; // i_en : start signal
	input 	[11:0] 	i_a, i_b;
	output 	[11:0] 	o_c;
	output		o_done;
	
	
	reg	[11:0] mult_in1, mult_in2;	// for multiplication
	wire	[23:0] mult_out;		// for multiplication

//	assign w_ab = temp_a * temp_b;         ///////multiplication

///////////////////////////////////////////////////////////////////////////////	
	
	// FlipFlop
	reg	signed 	[23:0] 	c_temp, n_temp;
	reg	signed 	[23:0] 	c_ab, n_ab;
	reg		[1:0]	c_state, n_state;
	reg			c_done, n_done;
	
    	wire signed [24:0] temp_test1;
    	wire signed [23:0] temp_test2;
    
    	assign temp_test1 = c_ab + mult_out; // multiplication      +) 24bit + 24bit = 25bit
	assign temp_test2 = { {11{1'd0}}, temp_test1[24:12]};	// 25bit - 12bit = 13bit
	
	// output	
	assign o_c	= c_temp[11:0];
	assign o_done	= c_done;

	always @(posedge i_clk, negedge i_rstn)
	begin
		if(!i_rstn)
		begin
		c_temp 	<= 30'd0;
		c_state <= 2'd0;
		c_ab	<= 24'd0;
		c_done	<= 1'd0;
		end	
		else
		begin
		c_temp 	<= n_temp;
		c_state <= n_state;
		c_ab	<= n_ab;
		c_done	<= n_done;
		end
	end
	
	
	// n_state
	always @(*)
	begin
		n_state = c_state + 1;
		if( (c_state == 2'd0) && (!i_en) ) n_state = 2'd0;	
	end	
	
	// n_done
	always @(*)
	begin
		n_done = 1'd0;
		if( c_state == 2'd3 )	n_done = 1'd1;
	end

	// n_ab (24bit)
	always @(*)
	begin
		n_ab = c_ab;
		if( c_state == 2'd0 ) n_ab = mult_out;	
	end	

	// n_temp (24bit)
	always @(*)
	begin
		case(c_state)
		2'd0: n_temp = mult_out;
		2'd1: n_temp = mult_out; // multiplication
		//2'd2: n_temp = ( {{4{c_ab[23]}},c_ab} - ({{14{c_temp[27]}}, c_temp[15:0]} * KYBER_Q) ) >> 16;
		2'd2: n_temp = temp_test2;
		2'd3: 
			begin
			if	( c_temp > 3328 ) 	n_temp = c_temp - 3329;
			else				n_temp = c_temp;
			end

		endcase	
	end
	
	 // multiplication
	 // 24bit = 12bit * 12bit
	 assign mult_out = mult_in1 * mult_in2;

	always @(*)
	begin
		case(c_state)
		2'd0:
			begin
			mult_in1 = i_a;
			mult_in2 = i_b;
			end
		2'd1:
			begin
			mult_in1 = c_temp[11:0];
			mult_in2 = Q_INVn; 
			end
		2'd2:
			begin
			mult_in1 = c_temp[11:0];
			mult_in2 = KYBER_Q;
			end
		2'd3:
			begin
			mult_in1 = 12'd0;
			mult_in2 = 12'd0;
			end
		endcase
	end	

/*	

	always @(*)
	begin
	temp_u 	= {8'd0, temp_T[15:0]}	* Q_INVn ;
	temp_t 	= {8'd0, temp_u[15:0]} 	* KYBER_Q;	
	temp_c 	= ( temp_T - temp_t )	>> 16;
	end
*/

endmodule
