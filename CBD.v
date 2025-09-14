module CBD(i_clk, i_rstn, i_start, i_sigma, i_N, o_out1, o_out2, o_out3, o_out4, o_out5, o_out6, o_out7, o_done, o_num);
	
	input 				i_clk;
	input				i_rstn;
	input				i_start;
	input		[255:0]		i_sigma;
	input		[7:0]		i_N;

	output	signed	[2:0]		o_out1;		// -3~3
	output	signed	[2:0]		o_out2;
	output	signed	[2:0]		o_out3;
	output	signed	[2:0]		o_out4;
	output	signed	[2:0]		o_out5;
	output	signed	[2:0]		o_out6;
	output	signed	[2:0]		o_out7;
	output				o_done;
	output		[2:0]		o_num;

	localparam	IDLE		= 2'd0;
	localparam	HASH		= 2'd1;
	localparam	SAMPLING	= 2'd2;
	localparam	DONE		= 2'd3;	

///////////////////////////////////////////////////////////////
	reg		[1:0]		c_state,	n_state;
	reg		[5:0]		c_cnt_hash, 	n_cnt_hash;
	reg	signed	[2:0]		c_out[0:6],	n_out[0:6];	// 3비트로 -3~3 저장후 최종 output은 바로 출력되도록 하면 면적 save가능.
									// or 어짜피 TOP모듈에서 s,e FF에 저장해줄 것이므로 -3~3을 출력해도 okay!.
	reg		[1087:0]	c_temp,		n_temp;
	reg		[2:0]		c_num,		n_num;	

	wire		[271:0]		hash_in;
	wire		[1343:0]	hash_out;
	reg		[1087:0]	hash_reverse;
	wire				hash_done;
	reg		[1:0]		hash_enable;

	reg	[5:0]	temp_cnt_hash;

	integer i,j;	

	always @(posedge i_clk, negedge i_rstn)
	begin
		if(!i_rstn)
		begin
		for(i=0;i<7;i=i+1)	c_out[i] <= 3'd0;
		c_state		<= IDLE;
		c_cnt_hash	<= 6'd0;
		c_temp		<= 1088'd0;
		c_num		<= 3'd0;
		end
		else
		begin
		for(i=0;i<7;i=i+1)	c_out[i] <= n_out[i];
		c_state		<= n_state;
		c_cnt_hash	<= n_cnt_hash;
		c_temp		<= n_temp;
		c_num		<= n_num;	
		end
	end

	
	// n_state
	always @(*)
	begin
		n_state = c_state;
		case(c_state)
		IDLE:		if(i_start)			n_state = HASH;
		HASH:		if(hash_done)			n_state = SAMPLING;
		SAMPLING:	if( c_cnt_hash == 6'd25 )	n_state = HASH;
				else if( c_cnt_hash == 6'd36 )	n_state = DONE;
		//		else				n_state = SAMPLING;	
		DONE:						n_state = IDLE;
		endcase
	end	
	
	// n_temp
	always @(*)
	begin
		n_temp = c_temp;
		case(c_state)
	//	IDLE:
		HASH:		
				if(hash_done)
					if(c_cnt_hash==6'd0)			n_temp = hash_reverse;
					else					n_temp = {c_temp[1:0], hash_reverse[1087 -:448], 638'd0};	// if(hash_done & c_cnt_hash==6'd26)?
	//	SAMPLING:	
		DONE:								n_temp = 1088'd0;	
		endcase
	end	
	
	// n_cnt_hash
	always @(*)
	begin
		n_cnt_hash = 6'd0;
		case(c_state)
	//	IDLE:
		HASH:		n_cnt_hash = c_cnt_hash;
		SAMPLING:	n_cnt_hash = c_cnt_hash + 1;
	//	DONE:		n_cnt_hash = 6'd0;
		endcase
	end	
	
	
	// n_out[0:6]
	always @(*)
	begin
		for(i=0;i<7;i=i+1)	n_out[i] = 3'd0;
		case(c_state)
	//	IDLE:
	//	HASH:
		SAMPLING:
			begin
			if(c_cnt_hash==6'd25)	n_out[6] = 3'd0;
			else                    n_out[6] = (c_temp[1087-42*temp_cnt_hash-6*6] +c_temp[1087-42*temp_cnt_hash-6*6-1]+c_temp[1087-42*temp_cnt_hash-6*6-2])
						-(c_temp[1087-42*temp_cnt_hash-6*6-3]+c_temp[1087-42*temp_cnt_hash-6*6-4]+c_temp[1087-42*temp_cnt_hash-6*6-5]);
				

			for(i=0;i<6;i=i+1)	
				n_out[i] = 	(c_temp[1087-42*temp_cnt_hash-6*i] +c_temp[1087-42*temp_cnt_hash-6*i-1]+c_temp[1087-42*temp_cnt_hash-6*i-2])
						-(c_temp[1087-42*temp_cnt_hash-6*i-3]+c_temp[1087-42*temp_cnt_hash-6*i-4]+c_temp[1087-42*temp_cnt_hash-6*i-5]);		// 곱셈기 사용됨.
			end				
	//	DONE:
		endcase
	end

	// n_num -> 7개/5개/5개/6개 정의 필요	
	always @(*)
	begin
		n_num = 3'd0;
		case(c_state)
	//	IDLE:
	//	HASH:
		SAMPLING:
			if(c_cnt_hash<25)	n_num = 3'd7;
			else if(c_cnt_hash==25)	n_num = 3'd6;
			else if(c_cnt_hash<36)	n_num = 3'd7;
			else if(c_cnt_hash==36)	n_num = 3'd5;	
	//	DONE:
		endcase
	end
	

	// temp_cnt_hash	
	always @(*)
	begin
		if(c_cnt_hash<26)	temp_cnt_hash = c_cnt_hash;
		else			temp_cnt_hash = c_cnt_hash - 26;	
	end

	
	// hash_enable
	always @(*)
	begin
		hash_enable = 2'b00;
		case(c_state)
		IDLE:	if(i_start)	hash_enable = 2'b01;
	//	HASH:			hash_enable = 2'b00;
		SAMPLING:		if( c_cnt_hash == 6'd27 )	hash_enable = 2'b10;
					else if( c_cnt_hash == 6'd1 )	hash_enable = 2'b01;
	//				else				hash_enable = 2'b00;	
	//	DONE:			hash_enable = 2'b00;
		endcase
	end	



//////////////////////////////////////////////////////////

	wire	[1:0]		hash_mode;
	assign	hash_mode = 2'd1;	// SHAKE_256
	assign	hash_in = { 8'd0, i_sigma, i_N };	

	hash	h0(	.i_clk(i_clk), .i_rstn(i_rstn), 
			.i_en(hash_enable), .i_in(hash_in), .i_mode(hash_mode), 
			.o_done(hash_done), .o_out(hash_out) );		
	
	always @(*)
	begin
		for(i=0;i<136;i=i+1)
			for(j=0;j<8;j=j+1)
				hash_reverse[1087-8*i-j] = hash_out[1080-8*i+j];
	end

////////////	Output Logic	/////////////////////////

	assign 	o_out1	= c_out[0];
	assign 	o_out2	= c_out[1];
	assign 	o_out3	= c_out[2];
	assign 	o_out4	= c_out[3];
	assign 	o_out5	= c_out[4];
	assign 	o_out6	= c_out[5];
	assign 	o_out7	= c_out[6];	// c_cnt_hash==25 & i=6일 때, 시뮬레이션 결과:X. but, 실제로는 문제x?
	assign	o_done	= (c_state==DONE);
	assign	o_num	= c_num;	
       

endmodule
