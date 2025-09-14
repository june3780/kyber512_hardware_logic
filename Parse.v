module Parse(i_clk, i_rstn, i_start, i_rho, i_i, i_j, o_first, o_second, o_first_en, o_second_en, o_done);
	
	input 				i_clk;
	input				i_rstn;
	input				i_start;
	input		[255:0]		i_rho;
	input		[7:0]		i_i;
	input		[7:0]		i_j;

	output		[11:0]		o_first;
	output		[11:0]		o_second;
	output				o_first_en;
	output				o_second_en;
	output				o_done;

	localparam	IDLE		= 2'd0;
	localparam	HASH		= 2'd1;
	localparam	PARSING		= 2'd2;
	localparam	DONE		= 2'd3;	

///////////////////////////////////////////////////////////////
	reg		[1:0]		c_state,	n_state;
	reg		[5:0]		c_cnt_hash, 	n_cnt_hash;
	reg		[8:0]		c_cnt_A, 	n_cnt_A;
	reg				c_first_en, 	n_first_en;	
	reg				c_second_en, 	n_second_en;	
	reg		[11:0]		c_first,	n_first;
	reg		[11:0]		c_second,	n_second;
	reg		[7:0]		c_temp[0:167],	n_temp[0:167];

	wire		[271:0]		hash_in;
	wire		[1343:0]	hash_out;
	wire				hash_done;
	reg		[1:0]		hash_enable;

	wire		[11:0]		first, second;

	integer	i;

	always @(posedge i_clk, negedge i_rstn)
	begin
		if(!i_rstn)
		begin
		for(i=0; i<168; i=i+1)	c_temp[i] <= 8'd0;		
		c_state		<= IDLE;
		c_cnt_hash	<= 6'd0;
		c_cnt_A		<= 9'd0;
		c_first_en	<= 1'd0;
		c_second_en	<= 1'd0;
		c_first		<= 12'd0;
		c_second	<= 12'd0;
		end
		else
		begin
		for(i=0; i<168; i=i+1)	c_temp[i] <= n_temp[i];		
		c_state		<= n_state;
		c_cnt_hash	<= n_cnt_hash;
		c_cnt_A		<= n_cnt_A;
		c_first_en	<= n_first_en;
		c_second_en	<= n_second_en;
		c_first		<= n_first;
		c_second	<= n_second;
		end
	end

	
	// n_state
	always @(*)
	begin
		n_state = c_state;
		case(c_state)
		IDLE:		if(i_start)			n_state = HASH;
		HASH:		if(hash_done)			n_state = PARSING;
		PARSING:	if( c_cnt_A[8] )		n_state = DONE;		// c_cnt_A == 9'd256
				else if( c_cnt_hash == 6'd55 )	n_state = HASH;
		//		else				n_state = PARSING;	
		DONE:						n_state = IDLE;
		endcase
	end	
	
	// n_temp
	always @(*)
	begin
		for(i=0; i<168; i=i+1)	n_temp[i] = c_temp[i];	
		case(c_state)
	//	IDLE:
		HASH:		if(hash_done)
					for(i=0; i<168; i=i+1)	n_temp[i] = hash_out[1343-8*i -:8];	
	//	PARSING:	
		DONE:			for(i=0; i<168; i=i+1)	n_temp[i] = 8'd0;
		endcase
	end	
	
	// n_cnt_hash
	always @(*)
	begin
		n_cnt_hash = 6'd0;
		case(c_state)
	//	IDLE:
	//	HASH:		n_cnt_hash = 6'd0;
		PARSING:	n_cnt_hash = c_cnt_hash + 1;
	//	DONE:		n_cnt_hash = 6'd0;
		endcase
	end	
	
	// n_cnt_A
	always @(*)
	begin	
		n_cnt_A = 9'd0;
		case(c_state)
	//	IDLE:
		HASH:	n_cnt_A = c_cnt_A;
		PARSING:	
			begin
				if(n_first_en & n_second_en)		n_cnt_A = c_cnt_A + 2;
				else if(!n_first_en & !n_second_en)	n_cnt_A = c_cnt_A;
				else					n_cnt_A = c_cnt_A + 1;	
			end
	//	DONE:		n_cnt_A = 9'd0;
		endcase
	end
	
	// n_first_en, n_second_en
	always @(*)
	begin
		n_first_en = 1'd0;
		n_second_en = 1'd0;
		case(c_state)
	//	IDLE:
	//	HASH:
		PARSING:	
			begin
				if(first<3329)	n_first_en = 1'd1;
				if(second<3329)	n_second_en = 1'd1;
			end
/*		DONE:							/////////////////////// DONE에도 추가?
			begin
				if(first<3329)	n_first_en = 1'd1;
				if(second<3329)	n_second_en = 1'd1;
			end */
		endcase
	end	
	
	// n_first, n_second
	always @(*)
	begin
		n_first = 12'd0;
		n_second = 12'd0;
		case(c_state)
	//	IDLE:
	//	HASH:
		PARSING:
			begin
			n_first = first;
			n_second = second;
			end				
	//	DONE:
		endcase
	end	
	
	// hash_enable
	always @(*)
	begin
		hash_enable = 2'b00;
		case(c_state)
		IDLE:	if(i_start)	hash_enable = 2'b01;
	//	HASH:			hash_enable = 2'b00;
		PARSING:		if( c_cnt_A[8] )		hash_enable = 2'b10;	// c_cnt_A == 9'd256
					else if( c_cnt_hash == 6'd25 )	hash_enable = 2'b01;
	//				else				hash_enable = 2'b00;	
	//	DONE:			hash_enable = 2'b00;
		endcase
	end	

	// first, second
	assign	first 	= {c_temp[3*c_cnt_hash+1][3:0],	c_temp[3*c_cnt_hash]};		//
	assign	second 	= {c_temp[3*c_cnt_hash+2],	c_temp[3*c_cnt_hash+1][7:4]};	// 곱셈기 사용... 줄이는법?


//////////////////////////////////////////////////////////

	wire	[1:0]		hash_mode;
	assign	hash_mode = 2'd0;	// SHAKE_128
	assign	hash_in = { i_rho, i_i, i_j };	

	hash	h0(	.i_clk(i_clk), .i_rstn(i_rstn), 
			.i_en(hash_enable), .i_in(hash_in), .i_mode(hash_mode), 
			.o_done(hash_done), .o_out(hash_out) );



////////////	Output Logic	/////////////////////////

	assign	o_first		= c_first_en ? c_first : 12'd0;
	assign	o_second	= c_second_en ? c_second : 12'd0;
	assign	o_first_en	= c_first_en;
	assign	o_second_en	= c_second_en;
	assign	o_done		= (c_state==DONE);



endmodule
