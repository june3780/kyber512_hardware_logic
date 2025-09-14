module KECCAK(i_clk, i_rstn, i_en, i_in, o_state, o_out);
	
	input 		 	i_clk;
	input 		 	i_rstn;
	input 	[1:0]	 	i_en;		// 2'b00 : WAIT, 2'b01: START, 2'b10: STOP
	input 	[1599:0] 	i_in;
	output 	[1599:0] 	o_out;
//	output 		 	o_done_pre;
	output 	[1:0]	 	o_state;

	parameter IDLE	=	2'd0;
	parameter ROUND	=	2'd1;
	parameter DONE	=	2'd2;

	reg	[63:0]		array	[0:4][0:4];		// array[y][x]. msb는 array[0][0][63]=[0,0,0]에 저장. lsb는 array[4][4][0]=[4,4,63]에 저장됨.
	reg	[63:0]		lane	[0:4][0:4];		// array[y][x]. msb는 array[0][0][63]=[0,0,0]에 저장. lsb는 array[4][4][0]=[4,4,63]에 저장됨.
	reg	[63:0]		theta	[0:4][0:4];					 
	wire	[63:0]		rho	[0:4][0:4];					 
	wire	[63:0]		pi	[0:4][0:4];					 
	reg	[63:0]		chi	[0:4][0:4];					 
	wire	[63:0]		iota	[0:4][0:4];
	reg	[63:0]		Rcon;
	reg	[1599:0]	buffer;	
	reg	[1599:0]	input_reverse;	
	reg	[1599:0]	output_reverse;	
	
	// Registers
	reg	[1:0] 		c_state, n_state;
	reg	[1599:0] 	c_StateArray, n_StateArray;
	reg	[4:0]	 	c_cnt, n_cnt;

	// FlipFlops	
	always @(posedge i_clk, negedge i_rstn)
	begin
		if(!i_rstn)
		begin
		c_state <= IDLE;
		c_StateArray <= 1600'd0;
		c_cnt <= 5'd0;
		end
		else
		begin
		c_state <= n_state;
		c_StateArray <= n_StateArray;
		c_cnt <= n_cnt;
		end
	end	

	// n_state
	always @(*)
	begin
		n_state = IDLE;
		case(c_state)
		IDLE:
			if( i_en == 2'b01 )		n_state = ROUND;
		ROUND:
	/*
			begin
			if( c_cnt == 5'd23 ) 	n_state = DONE;
			else			n_state = ROUND;	
			end
	*/			
			begin
			if( i_en == 2'b10 )		n_state = IDLE;
			else if( c_cnt == 5'd23 )	n_state = DONE;
			else				n_state = ROUND;
			end
		
		DONE:
			if( i_en == 2'b01 )		n_state = ROUND;
			else if( i_en == 2'b10)		n_state = IDLE;
			else if( i_en == 2'b00)		n_state = DONE;
		endcase
	end

	/*
	// n_StateArray
	always @(*)
	begin
		n_StateArray = input_reverse;
		if ( c_state == ROUND )	
		begin
			if ( c_cnt == 5'd23 ) 	n_StateArray = output_reverse;
			else			n_StateArray = buffer;
		end
	end
*/
	// n_StateArray
	always @(*)
	begin
		n_StateArray = 1600'd0;
		case(c_state)
		IDLE:
			n_StateArray = input_reverse;
		ROUND:
			if ( c_cnt == 5'd23 ) 	n_StateArray = output_reverse;
			else			n_StateArray = buffer;
		DONE:
			if (i_en==2'b01)	n_StateArray = input_reverse;

			else if(i_en==2'b00)	n_StateArray = c_StateArray;

		//	else if(i_en==2'b10)	n_StateArray = 1600'd0;	

		endcase
	end	

	// n_cnt
	always @(*)
	begin
		n_cnt = 5'd0;
		if( c_state == ROUND ) 	n_cnt = c_cnt + 1;

	end

	// input_reverse
	integer i;
	always @(*)
	begin
		for(i=0;i<25;i=i+1)
		input_reverse[1599-64*i -:64] = {i_in[1599-64*i-8*7 -:8],i_in[1599-64*i-8*6 -:8],i_in[1599-64*i-8*5 -:8],i_in[1599-64*i-8*4 -:8],i_in[1599-64*i-8*3 -:8],i_in[1599-64*i-8*2 -:8],i_in[1599-64*i-8 -:8],i_in[1599-64*i -:8] };
	end

	// array assign
	integer y,x;
	always @(*)
	begin
		for ( y=0; y<5; y=y+1 )
			for( x=0; x<5; x=x+1 )
			array[y][x] = c_StateArray[1599-64*5*y-64*x -: 64];
	end
	

	// lane assign
	always @(*)
	begin
		for(y=0;y<5;y=y+1)
			for(x=0;x<5;x=x+1)
			lane[y][x] = array[(y+3)%5][(x+3)%5];
	end


	// theta : z-1은 left shift로 구현
//	theta[y][x] = lane[y][x] ^ ( lane[0][x-1] ^ lane[1][x-1] ^ lane[2][x-1] ^ lane[3][x-1] ^ lane[4][x-1] ) ^ 
//				( {lane[0][x+1][62:0],lane[0][x+1][63]} ^ {lane[1][x+1][62:0],lane[1][x+1][63]} ^ {lane[2][x+1][62:0],lane[2][x+1][63]} ^ {lane[3][x+1][62:0],lane[3][x+1][63]} ^ {lane[4][x+1][62:0],lane[4][x+1][63]} );

	always @(*)
	begin
		for ( y=0; y<5; y=y+1 )
			for ( x=0; x<5 ; x= x+1)
			theta[y][x] = lane[y][x] ^ ( lane[0][(x+4)%5] ^ lane[1][(x+4)%5] ^ lane[2][(x+4)%5] ^ lane[3][(x+4)%5] ^ lane[4][(x+4)%5] ) ^ 
					( {lane[0][(x+1)%5][62:0],lane[0][(x+1)%5][63]} ^ {lane[1][(x+1)%5][62:0],lane[1][(x+1)%5][63]} ^ {lane[2][(x+1)%5][62:0],lane[2][(x+1)%5][63]} ^ {lane[3][(x+1)%5][62:0],lane[3][(x+1)%5][63]} ^ {lane[4][(x+1)%5][62:0],lane[4][(x+1)%5][63]} );
	end

	
	// rho : t만큼 left shift
	assign rho[0][0] = { theta[0][0][63-21:0] , theta[0][0][63:63-20] };	
	assign rho[0][1] = { theta[0][1][63- 8:0] , theta[0][1][63:63- 7] };	
	assign rho[0][2] = { theta[0][2][63-41:0] , theta[0][2][63:63-40] };	
	assign rho[0][3] = { theta[0][3][63-45:0] , theta[0][3][63:63-44] };	
	assign rho[0][4] = { theta[0][4][63-15:0] , theta[0][4][63:63-14] };	
	
	assign rho[1][0] = { theta[1][0][63-56:0] , theta[1][0][63:63-55] };	
	assign rho[1][1] = { theta[1][1][63-14:0] , theta[1][1][63:63-13] };	
	assign rho[1][2] = { theta[1][2][63-18:0] , theta[1][2][63:63-17] };	
	assign rho[1][3] = { theta[1][3][63- 2:0] , theta[1][3][63:63- 1] };	
	assign rho[1][4] = { theta[1][4][63-61:0] , theta[1][4][63:63-60] };	
	
	assign rho[2][0] = { theta[2][0][63-28:0] , theta[2][0][63:63-27] };	
	assign rho[2][1] = { theta[2][1][63-27:0] , theta[2][1][63:63-26] };	
	assign rho[2][2] =   theta[2][2][63:0] ;	
	assign rho[2][3] = { theta[2][3][63-1:0] 	, theta[2][3][63] };	
	assign rho[2][4] = { theta[2][4][63-62:0] , theta[2][4][63:63-61] };	
	
	assign rho[3][0] = { theta[3][0][63-55:0] , theta[3][0][63:63-54] };	
	assign rho[3][1] = { theta[3][1][63-20:0] , theta[3][1][63:63-19] };	
	assign rho[3][2] = { theta[3][2][63-36:0] , theta[3][2][63:63-35] };	
	assign rho[3][3] = { theta[3][3][63-44:0] , theta[3][3][63:63-43] };	
	assign rho[3][4] = { theta[3][4][63- 6:0] , theta[3][4][63:63- 5] };		
	
	assign rho[4][0] = { theta[4][0][63-25:0] , theta[4][0][63:63-24] };	
	assign rho[4][1] = { theta[4][1][63-39:0] , theta[4][1][63:63-38] };	
	assign rho[4][2] = { theta[4][2][63- 3:0] , theta[4][2][63:63- 2] };	
	assign rho[4][3] = { theta[4][3][63-10:0] , theta[4][3][63:63- 9] };	
	assign rho[4][4] = { theta[4][4][63-43:0] , theta[4][4][63:63-42] };	

	
	// pi
	assign pi[0][0] = rho[0][4];	
	assign pi[0][1] = rho[1][0];	
	assign pi[0][2] = rho[2][1];	
	assign pi[0][3] = rho[3][2];	
	assign pi[0][4] = rho[4][3];	
	
	assign pi[1][0] = rho[0][2];	
	assign pi[1][1] = rho[1][3];	
	assign pi[1][2] = rho[2][4];	
	assign pi[1][3] = rho[3][0];	
	assign pi[1][4] = rho[4][1];	
		
	assign pi[2][0] = rho[0][0];	
	assign pi[2][1] = rho[1][1];	
	assign pi[2][2] = rho[2][2];	
	assign pi[2][3] = rho[3][3];	
	assign pi[2][4] = rho[4][4];	
	
	assign pi[3][0] = rho[0][3];	
	assign pi[3][1] = rho[1][4];	
	assign pi[3][2] = rho[2][0];	
	assign pi[3][3] = rho[3][1];	
	assign pi[3][4] = rho[4][2];	
	
	assign pi[4][0] = rho[0][1];	
	assign pi[4][1] = rho[1][2];	
	assign pi[4][2] = rho[2][3];	
	assign pi[4][3] = rho[3][4];	
	assign pi[4][4] = rho[4][0];	
	
	// chi
	always @(*)
	begin
		for ( y=0; y<5; y=y+1 ) 
			for ( x=0 ; x<5; x=x+1 )
			chi[y][x] = pi[y][x] ^ ( ( ~pi[y][(x+1)%5] ) & pi[y][(x+2)%5] );
	end

	// iota
	assign iota[0][0] = chi[0][0];	
	assign iota[0][1] = chi[0][1];
	assign iota[0][2] = chi[0][2];
	assign iota[0][3] = chi[0][3];
	assign iota[0][4] = chi[0][4];
	
	assign iota[1][0] = chi[1][0];	
	assign iota[1][1] = chi[1][1];
	assign iota[1][2] = chi[1][2];
	assign iota[1][3] = chi[1][3];
	assign iota[1][4] = chi[1][4];	
	
	assign iota[2][0] = chi[2][0];	
	assign iota[2][1] = chi[2][1];
	assign iota[2][2] = chi[2][2] ^ Rcon;
	assign iota[2][3] = chi[2][3];
	assign iota[2][4] = chi[2][4];
	
	assign iota[3][0] = chi[3][0];	
	assign iota[3][1] = chi[3][1];
	assign iota[3][2] = chi[3][2];
	assign iota[3][3] = chi[3][3];
	assign iota[3][4] = chi[3][4];
	
	assign iota[4][0] = chi[4][0];	
	assign iota[4][1] = chi[4][1];
	assign iota[4][2] = chi[4][2];
	assign iota[4][3] = chi[4][3];
	assign iota[4][4] = chi[4][4];
	
	// Rcon
	always @(*)
	begin
		case(c_cnt)
		5'd0 	: Rcon = 64'h0000_0000_0000_0001;	
		5'd1 	: Rcon = 64'h0000_0000_0000_8082;	
		5'd2 	: Rcon = 64'h8000_0000_0000_808A;
		5'd3 	: Rcon = 64'h8000_0000_8000_8000;
		5'd4 	: Rcon = 64'h0000_0000_0000_808B;
		5'd5 	: Rcon = 64'h0000_0000_8000_0001;
		5'd6 	: Rcon = 64'h8000_0000_8000_8081;
		5'd7	: Rcon = 64'h8000_0000_0000_8009;
		5'd8 	: Rcon = 64'h0000_0000_0000_008A;
		5'd9 	: Rcon = 64'h0000_0000_0000_0088;
		5'd10 	: Rcon = 64'h0000_0000_8000_8009;
		5'd11 	: Rcon = 64'h0000_0000_8000_000A;
		5'd12 	: Rcon = 64'h0000_0000_8000_808B;
		5'd13 	: Rcon = 64'h8000_0000_0000_008B;
		5'd14 	: Rcon = 64'h8000_0000_0000_8089;
		5'd15 	: Rcon = 64'h8000_0000_0000_8003;
		5'd16 	: Rcon = 64'h8000_0000_0000_8002;
		5'd17 	: Rcon = 64'h8000_0000_0000_0080;
		5'd18 	: Rcon = 64'h0000_0000_0000_800A;
		5'd19 	: Rcon = 64'h8000_0000_8000_000A;
		5'd20 	: Rcon = 64'h8000_0000_8000_8081;
		5'd21 	: Rcon = 64'h8000_0000_0000_8080;
		5'd22 	: Rcon = 64'h0000_0000_8000_0001;
		5'd23 	: Rcon = 64'h8000_0000_8000_8008;
		default	: Rcon = 64'd0;
		endcase
	end

	// output string : buffer에는 iota[2,2]>[2,3]>[2,4]>[2,0]>[2,1]. ...[3,2]>[3,3]>...>[1,0]>[1,1]순으로 MSB부터 채워지도록
	
	always @(*)
	begin
		for ( y=0; y<5; y=y+1 )
			for( x=0; x<5; x=x+1 )
			buffer[1599-64*5*y-64*x -: 64] = iota[(y+2)%5][(x+2)%5];
	end

	// Output
	// output_reverse
	always @(*)
	begin
		for(i=0;i<25;i=i+1)
		output_reverse[1599-64*i -:64] = {buffer[1599-64*i-8*7 -:8],buffer[1599-64*i-8*6 -:8],buffer[1599-64*i-8*5 -:8],buffer[1599-64*i-8*4 -:8],buffer[1599-64*i-8*3 -:8],buffer[1599-64*i-8*2 -:8],buffer[1599-64*i-8 -:8],buffer[1599-64*i -:8] };
	end

	assign o_state 	=  c_state;
//	assign	o_done_pre	= ( n_state == DONE );	
	assign 	o_out 		= ( c_state == DONE ) ? c_StateArray : 1600'd0;	

endmodule

