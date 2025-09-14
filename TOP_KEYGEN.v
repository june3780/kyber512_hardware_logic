module TOP_KEYGEN(	i_clk, i_rstn, i_start, 
			i_seed, 
			o_PublicKey, o_SecretKey,
			o_done
	);

	input				i_clk;
	input				i_rstn;
	input				i_start;
	input		[255:0]		i_seed;

	output		[6143:0]	o_PublicKey;	// 6144 = 3072*2
	output		[6143:0]	o_SecretKey;
	output				o_done;

	localparam	IDLE 	= 2'd0;
	localparam	RUN	= 2'd1;
	localparam	DONE	= 2'd2;

	//////////////////////////////////////////////////////////////////////
	// FlipFlops
	reg	[1:0]		c_state,	n_state;

	reg	[1:0]		c_cnt_CBD,	n_cnt_CBD;
	reg	[1:0]		c_cnt_Parse,	n_cnt_Parse;
	reg	[1:0]		c_cnt_NTT, 	n_cnt_NTT;
	reg	[1:0]		c_cnt_Basemul, 	n_cnt_Basemul;
	reg	[1:0]		c_cnt_Add,	n_cnt_Add;

	reg	[7:0]		c_cnt_se,	n_cnt_se;	// for s & e flipflop count
	reg	[7:0]		c_cnt_A,	n_cnt_A;	// for A flipflop count
	reg	[7:0]		c_cnt_result,	n_cnt_result;	// for result Addition

	reg			c_en_G,		n_en_G;		
	reg			c_en_CBD,	n_en_CBD;
	reg			c_en_Parse,	n_en_Parse;
	reg			c_en_NTT,	n_en_NTT;
	reg			c_en_Basemul,	n_en_Basemul;
	reg			c_en_Add,	n_en_Add;
	
	reg			c_temp,		n_temp;		// for c_en_Basemul Control

	reg	[255:0]		c_rho,		n_rho;
	reg	[255:0]		c_sigma,	n_sigma;

	reg	[3071:0]	c_s_0,		n_s_0;
	reg	[3071:0]	c_s_1,		n_s_1;
	reg	[3071:0]	c_e_0,		n_e_0;
	reg	[3071:0]	c_e_1,		n_e_1;
	reg	[3071:0]	c_A_0,		n_A_0;
	reg	[3071:0]	c_A_1,		n_A_1;
	reg	[3071:0]	c_result_0,	n_result_0;
	reg	[3071:0]	c_result_1,	n_result_1;

	// wire
	wire	[255:0]		G_out_rho, G_out_sigma;	
	wire			G_out_done;
	
	wire	[7:0]		CBD_in_N;
	wire	signed	[2:0]	CBD_out1, CBD_out2, CBD_out3, CBD_out4, CBD_out5, CBD_out6, CBD_out7;	// -3~3
	wire	[2:0]		CBD_out_num;	// 7 or 6 or 5	
	wire			CBD_out_done;
	
	wire	[7:0]		Parse_in_i, Parse_in_j;
	wire	[11:0]		Parse_out_first, Parse_out_second;
	wire			Parse_out_first_en, Parse_out_second_en;
	wire			Parse_out_done;

	reg	[3071:0]	NTT_in_poly;
	wire	[3071:0]	NTT_out_ntt;
	wire			NTT_out_done;

	reg	[3071:0]	Basemul_in_p, Basemul_in_q;
	wire	[3071:0]	Basemul_out;
	wire			Basemul_out_done;

	wire			Add_done;
	assign	Add_done = &c_cnt_result;	// Add_done = (c_cnt_result==8'd255)
	
	//////////////////////////////////////////////////////////////////////
	// State Transition Logic
	always @(posedge i_clk, negedge i_rstn)
	begin
		if(!i_rstn)
		begin
		c_state		<= 2'd0;
		c_cnt_CBD	<= 2'd0;
		c_cnt_Parse	<= 2'd0;
		c_cnt_NTT	<= 2'd0;
		c_cnt_Basemul	<= 2'd0;
		c_cnt_Add	<= 2'd0;
		
		c_cnt_se	<= 8'd0;
		c_cnt_A		<= 8'd0;
		c_cnt_result	<= 8'd0;

		c_en_G		<= 1'd0;
		c_en_CBD	<= 1'd0;
		c_en_Parse	<= 1'd0;
		c_en_NTT	<= 1'd0;
		c_en_Basemul	<= 1'd0;
		c_en_Add	<= 1'd0;

		c_temp		<= 1'd0;

		c_rho		<= 256'd0;
		c_sigma		<= 256'd0;	

		c_s_0		<= 3072'd0;
		c_s_1		<= 3072'd0;
		c_e_0		<= 3072'd0;
		c_e_1		<= 3072'd0;
		c_A_0		<= 3072'd0;
		c_A_1		<= 3072'd0;
		c_result_0	<= 3072'd0;
		c_result_1	<= 3072'd0;
		end
		else
		begin
		c_state		<= n_state;
		c_cnt_CBD	<= n_cnt_CBD;
		c_cnt_Parse	<= n_cnt_Parse;
		c_cnt_NTT	<= n_cnt_NTT;
		c_cnt_Basemul	<= n_cnt_Basemul;
		c_cnt_Add	<= n_cnt_Add;

		c_cnt_se	<= n_cnt_se;
		c_cnt_A		<= n_cnt_A;
		c_cnt_result	<= n_cnt_result;

		c_en_G		<= n_en_G;
		c_en_CBD	<= n_en_CBD;
		c_en_Parse	<= n_en_Parse;
		c_en_NTT	<= n_en_NTT;
		c_en_Basemul	<= n_en_Basemul;
		c_en_Add	<= n_en_Add;

		c_temp		<= n_temp;

		c_rho		<= n_rho;
		c_sigma		<= n_sigma;

		c_s_0		<= n_s_0;
		c_s_1		<= n_s_1;
		c_e_0		<= n_e_0;
		c_e_1		<= n_e_1;
		c_A_0		<= n_A_0;
		c_A_1		<= n_A_1;
		c_result_0	<= n_result_0;
		c_result_1	<= n_result_1;	
		end
	end	

	// n_state
	always @(*)
	begin
		n_state = c_state;
		case(c_state)
		IDLE:	if( i_start )					n_state = RUN;
		RUN:	if( Add_done & (c_cnt_Add==2'd3) )		n_state = DONE;
		DONE:							n_state = IDLE;
		endcase
	end

	// n_cnt
	always @(*)
	begin
		if(CBD_out_done)	n_cnt_CBD 	= c_cnt_CBD + 1;
		else			n_cnt_CBD	= c_cnt_CBD;
		
		if(Parse_out_done)	n_cnt_Parse 	= c_cnt_Parse + 1;
		else			n_cnt_Parse 	= c_cnt_Parse;

		if(NTT_out_done)	n_cnt_NTT 	= c_cnt_NTT + 1;
		else			n_cnt_NTT 	= c_cnt_NTT;

		if(Basemul_out_done & Add_done )				n_cnt_Basemul	= c_cnt_Basemul + 1;	// DONE 상태일 때 cnt 유지 후 마지막에 +1
		else if(Basemul_out_done & !c_cnt_Basemul[0] & c_en_Basemul )	n_cnt_Basemul	= c_cnt_Basemul + 1;	// c_cnt_Basemul==0 or 2 & done
		else								n_cnt_Basemul	= c_cnt_Basemul;

		if( Add_done )		n_cnt_Add	= c_cnt_Add + 1;	
		else			n_cnt_Add	= c_cnt_Add;
	end

	//////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////
	// n_cnt_se
	always @(*)
	begin
		if(CBD_out_done)	n_cnt_se = 8'd0;
		else
		begin
			n_cnt_se = c_cnt_se;
			case(CBD_out_num)
			3'd5:	n_cnt_se = c_cnt_se + 5;
			3'd6:	n_cnt_se = c_cnt_se + 6;
			3'd7:	n_cnt_se = c_cnt_se + 7;
			endcase
		end
	end
	
	// n_cnt_A
	always @(*)
	begin
		if(Parse_out_done)	n_cnt_A = 8'd0;
		else
		begin
			n_cnt_A = c_cnt_A;
			case( {Parse_out_first_en, Parse_out_second_en} )
		//	2'b00:	n_cnt_A = c_cnt_A;
			2'b01:	n_cnt_A = c_cnt_A + 1;
			2'b10:	n_cnt_A = c_cnt_A + 1;
			2'b11:	n_cnt_A = c_cnt_A + 2;
			endcase
		end
	end

	// n_cnt_result
	always @(*)
	begin
		if(c_en_Add)		n_cnt_result = c_cnt_result + 1;
		else			n_cnt_result = c_cnt_result;
	end


	//////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////
	// c_en_G
	always @(*)
	begin
		if((c_state==IDLE) & i_start)		n_en_G = 1'd1;
		else					n_en_G = 1'd0;
	end	


	// n_en_CBD
	always @(*)
	begin
		n_en_CBD 	= c_en_CBD;
		if(G_out_done)					n_en_CBD = 1'd1;
		else if( CBD_out_done & (c_cnt_CBD==2'd3) )	n_en_CBD = 1'd0;	
	end

	// n_en_Parse
	always @(*)
	begin
		n_en_Parse 	= c_en_Parse;
		if(G_out_done)								n_en_Parse = 1'd1;
		else if(Parse_out_done & (c_cnt_Parse!=2'd0) )				n_en_Parse = 1'd0;
		else if(Basemul_out_done & !c_cnt_Basemul[1] & c_cnt_Parse[1] )		n_en_Parse = 1'd1;	// when c_cnt_Basemul == 0 or 1	& c_cnt_Parse == 2 or 3
	end

	// n_en_NTT
	always @(*)
	begin
		n_en_NTT 	= c_en_NTT;
		if(CBD_out_done & (c_cnt_CBD==2'd0) )		n_en_NTT = 1'd1;
		else if(NTT_out_done & (c_cnt_NTT==2'd3) )	n_en_NTT = 1'd0;	
	end


	////////////////////////// n_en_Basemul	/////////////////////////////////////
	// n_temp
	always @(*)
	begin
		if( Add_done & (c_cnt_Add==2'd0) )				n_temp = 1'd1;
		else if( Basemul_out_done & (c_cnt_Basemul==2'd2) )		n_temp = 1'd1;
		else								n_temp = 1'd0;
	end
	// n_en_Basemul
	always @(*)
	begin
		n_en_Basemul	= c_en_Basemul;
		if(NTT_out_done & !c_cnt_NTT[1] )			n_en_Basemul = 1'd1;		// when c_cnt_NTT == 0 or 1
		else if( c_temp )					n_en_Basemul = 1'd1;		// 꺼진 후 바로 다시 on . Basemul_out_done보다 priority 높아야함.
		else if(Basemul_out_done & !c_cnt_Basemul[0] )		n_en_Basemul = 1'd0;		// when c_cnt_Basemul== 0 or 2
		else if(Add_done & !c_cnt_Add[0] )			n_en_Basemul = 1'd0;		// when c_cnt_Add==0 or 2
	end


	//////////////////////// n_en_Add //////////////////////////////////////////
	always @(*)
	begin
		n_en_Add	= c_en_Add;
		if(NTT_out_done & c_cnt_NTT[1] )		n_en_Add = 1'd1;	// when c_cnt_NTT = 2 or 3
		else if(Add_done)				n_en_Add = 1'd0;	// Add_done이 Basemul_out_done보다 priority 높아야함.
		else if(c_en_Basemul & Basemul_out_done & c_cnt_Basemul[0] )	n_en_Add = 1'd1;	// when c_cnt_Basemul == 1 or 3
											// priority 중요
	end

	//////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////
	// n_rho, n_sigma
	always @(*)
	begin
		if(G_out_done)
		begin
			n_rho 	= G_out_rho;
			n_sigma	= G_out_sigma;
		end
		else
		begin
			n_rho	= c_rho;
			n_sigma	= c_sigma;
		end
	end	
	
	//////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////
	


	// n_s_0, n_s_1, n_e_0, n_e_1	
	// CBD output, NTT output 모두 저장
	// -3 ~ -1 -> 3326, 3327, 3328

	reg		[11:0]	temp_CBD_out1, temp_CBD_out2, temp_CBD_out3, temp_CBD_out4, temp_CBD_out5, temp_CBD_out6, temp_CBD_out7;
	
	always @(*)
	begin
		if(CBD_out1[2]) temp_CBD_out1 = CBD_out1 + 3329;	// CBD_out1 < 0
		else		temp_CBD_out1 = CBD_out1;
		
		if(CBD_out2[2]) temp_CBD_out2 = CBD_out2 + 3329;	// CBD_out2 < 0
		else		temp_CBD_out2 = CBD_out2;	

		if(CBD_out3[2]) temp_CBD_out3 = CBD_out3 + 3329;	// CBD_out3 < 0
		else		temp_CBD_out3 = CBD_out3;

		if(CBD_out4[2]) temp_CBD_out4 = CBD_out4 + 3329;	// CBD_out4 < 0
		else		temp_CBD_out4 = CBD_out4;
		
		if(CBD_out5[2]) temp_CBD_out5 = CBD_out5 + 3329;	// CBD_out5 < 0
		else		temp_CBD_out5 = CBD_out5;

		if(CBD_out6[2]) temp_CBD_out6 = CBD_out6 + 3329;	// CBD_out6 < 0
		else		temp_CBD_out6 = CBD_out6;

		if(CBD_out7[2]) temp_CBD_out7 = CBD_out7 + 3329;	// CBD_out7 < 0
		else		temp_CBD_out7 = CBD_out7;
	end

	always @(*)
	begin
		n_s_0 		= c_s_0;
		n_s_1 		= c_s_1;
		n_e_0		= c_e_0;
		n_e_1		= c_e_1;
		if(NTT_out_done)
			case(c_cnt_NTT)
			2'd0:	n_s_0 = NTT_out_ntt;
			2'd1:	n_s_1 = NTT_out_ntt;
			2'd2:	n_e_0 = NTT_out_ntt;
			2'd3:	n_e_1 = NTT_out_ntt;
			endcase	
		else
		begin
			case(c_cnt_CBD)
			2'd0:	// s_0 update
			begin
				case(CBD_out_num)
				3'd5:
					begin
					n_s_0[12*c_cnt_se	+:12] = temp_CBD_out1;
					n_s_0[12*c_cnt_se+12*1	+:12] = temp_CBD_out2;
					n_s_0[12*c_cnt_se+12*2	+:12] = temp_CBD_out3;
					n_s_0[12*c_cnt_se+12*3	+:12] = temp_CBD_out4;
					n_s_0[12*c_cnt_se+12*4	+:12] = temp_CBD_out5;
					end
				3'd6:
					begin
					n_s_0[12*c_cnt_se	+:12] = temp_CBD_out1;
					n_s_0[12*c_cnt_se+12*1	+:12] = temp_CBD_out2;
					n_s_0[12*c_cnt_se+12*2	+:12] = temp_CBD_out3;
					n_s_0[12*c_cnt_se+12*3	+:12] = temp_CBD_out4;
					n_s_0[12*c_cnt_se+12*4	+:12] = temp_CBD_out5;
					n_s_0[12*c_cnt_se+12*5	+:12] = temp_CBD_out6;
					end
				3'd7:
					begin
					n_s_0[12*c_cnt_se	+:12] = temp_CBD_out1;
					n_s_0[12*c_cnt_se+12*1	+:12] = temp_CBD_out2;
					n_s_0[12*c_cnt_se+12*2	+:12] = temp_CBD_out3;
					n_s_0[12*c_cnt_se+12*3	+:12] = temp_CBD_out4;
					n_s_0[12*c_cnt_se+12*4	+:12] = temp_CBD_out5;
					n_s_0[12*c_cnt_se+12*5	+:12] = temp_CBD_out6;	
					n_s_0[12*c_cnt_se+12*6	+:12] = temp_CBD_out7;
					end
				endcase	
			end
			2'd1:	// s_1 update
			begin
				case(CBD_out_num)
				3'd5:
					begin
					n_s_1[12*c_cnt_se	+:12] = temp_CBD_out1;
					n_s_1[12*c_cnt_se+12*1	+:12] = temp_CBD_out2;
					n_s_1[12*c_cnt_se+12*2	+:12] = temp_CBD_out3;
					n_s_1[12*c_cnt_se+12*3	+:12] = temp_CBD_out4;
					n_s_1[12*c_cnt_se+12*4	+:12] = temp_CBD_out5;
					end
				3'd6:
					begin
					n_s_1[12*c_cnt_se	+:12] = temp_CBD_out1;
					n_s_1[12*c_cnt_se+12*1	+:12] = temp_CBD_out2;
					n_s_1[12*c_cnt_se+12*2	+:12] = temp_CBD_out3;
					n_s_1[12*c_cnt_se+12*3	+:12] = temp_CBD_out4;
					n_s_1[12*c_cnt_se+12*4	+:12] = temp_CBD_out5;
					n_s_1[12*c_cnt_se+12*5	+:12] = temp_CBD_out6;
					end
				3'd7:
					begin
					n_s_1[12*c_cnt_se	+:12] = temp_CBD_out1;
					n_s_1[12*c_cnt_se+12*1	+:12] = temp_CBD_out2;
					n_s_1[12*c_cnt_se+12*2	+:12] = temp_CBD_out3;
					n_s_1[12*c_cnt_se+12*3	+:12] = temp_CBD_out4;
					n_s_1[12*c_cnt_se+12*4	+:12] = temp_CBD_out5;
					n_s_1[12*c_cnt_se+12*5	+:12] = temp_CBD_out6;	
					n_s_1[12*c_cnt_se+12*6	+:12] = temp_CBD_out7;
					end
				endcase	
			end
			2'd2:	// e_0 update
			begin
				case(CBD_out_num)
				3'd5:
					begin
					n_e_0[12*c_cnt_se	+:12] = temp_CBD_out1;
					n_e_0[12*c_cnt_se+12*1	+:12] = temp_CBD_out2;
					n_e_0[12*c_cnt_se+12*2	+:12] = temp_CBD_out3;
					n_e_0[12*c_cnt_se+12*3	+:12] = temp_CBD_out4;
					n_e_0[12*c_cnt_se+12*4	+:12] = temp_CBD_out5;
					end
				3'd6:
					begin
					n_e_0[12*c_cnt_se	+:12] = temp_CBD_out1;
					n_e_0[12*c_cnt_se+12*1	+:12] = temp_CBD_out2;
					n_e_0[12*c_cnt_se+12*2	+:12] = temp_CBD_out3;
					n_e_0[12*c_cnt_se+12*3	+:12] = temp_CBD_out4;
					n_e_0[12*c_cnt_se+12*4	+:12] = temp_CBD_out5;
					n_e_0[12*c_cnt_se+12*5	+:12] = temp_CBD_out6;
					end
				3'd7:
					begin
					n_e_0[12*c_cnt_se	+:12] = temp_CBD_out1;
					n_e_0[12*c_cnt_se+12*1	+:12] = temp_CBD_out2;
					n_e_0[12*c_cnt_se+12*2	+:12] = temp_CBD_out3;
					n_e_0[12*c_cnt_se+12*3	+:12] = temp_CBD_out4;
					n_e_0[12*c_cnt_se+12*4	+:12] = temp_CBD_out5;
					n_e_0[12*c_cnt_se+12*5	+:12] = temp_CBD_out6;	
					n_e_0[12*c_cnt_se+12*6	+:12] = temp_CBD_out7;
					end
				endcase	
			end
			2'd3:	// e_1 update
			begin
				case(CBD_out_num)
				3'd5:
					begin
					n_e_1[12*c_cnt_se	+:12] = temp_CBD_out1;
					n_e_1[12*c_cnt_se+12*1	+:12] = temp_CBD_out2;
					n_e_1[12*c_cnt_se+12*2	+:12] = temp_CBD_out3;
					n_e_1[12*c_cnt_se+12*3	+:12] = temp_CBD_out4;
					n_e_1[12*c_cnt_se+12*4	+:12] = temp_CBD_out5;
					end
				3'd6:
					begin
					n_e_1[12*c_cnt_se	+:12] = temp_CBD_out1;
					n_e_1[12*c_cnt_se+12*1	+:12] = temp_CBD_out2;
					n_e_1[12*c_cnt_se+12*2	+:12] = temp_CBD_out3;
					n_e_1[12*c_cnt_se+12*3	+:12] = temp_CBD_out4;
					n_e_1[12*c_cnt_se+12*4	+:12] = temp_CBD_out5;
					n_e_1[12*c_cnt_se+12*5	+:12] = temp_CBD_out6;
					end
				3'd7:
					begin
					n_e_1[12*c_cnt_se	+:12] = temp_CBD_out1;
					n_e_1[12*c_cnt_se+12*1	+:12] = temp_CBD_out2;
					n_e_1[12*c_cnt_se+12*2	+:12] = temp_CBD_out3;
					n_e_1[12*c_cnt_se+12*3	+:12] = temp_CBD_out4;
					n_e_1[12*c_cnt_se+12*4	+:12] = temp_CBD_out5;
					n_e_1[12*c_cnt_se+12*5	+:12] = temp_CBD_out6;	
					n_e_1[12*c_cnt_se+12*6	+:12] = temp_CBD_out7;
					end
				endcase
			end
			endcase	
		end
	end	
	

	// n_A_0, n_A_1
	// Parse outupt 저장
	always @(*)
	begin
		n_A_0 = c_A_0;
		n_A_1 = c_A_1;
		if(!Parse_out_done)
		begin
			if(c_cnt_Parse[0])	// c_cnt_Parse == 1 or 3
			begin
				case({Parse_out_first_en, Parse_out_second_en})
			//	2'b00:
				2'b01:	n_A_1[12*c_cnt_A	+:12] = Parse_out_second;
				2'b10:	n_A_1[12*c_cnt_A	+:12] = Parse_out_first;
				2'b11:	
					begin
							n_A_1[12*c_cnt_A	+:12] = Parse_out_first;
					if(!(&c_cnt_A))	n_A_1[12*c_cnt_A+12	+:12] = Parse_out_second;	// c_cnt_A !=8'd255
					end
				endcase
			end
			else			// c_cnt_Parse == 0 or 2
			begin
				case({Parse_out_first_en, Parse_out_second_en})
			//	2'b00:
				2'b01:	n_A_0[12*c_cnt_A	+:12] = Parse_out_second;
				2'b10:	n_A_0[12*c_cnt_A	+:12] = Parse_out_first;
				2'b11:	
					begin
							n_A_0[12*c_cnt_A	+:12] = Parse_out_first;
					if(!(&c_cnt_A))	n_A_0[12*c_cnt_A+12	+:12] = Parse_out_second;	// c_cnt_A !=8'd255
					end
				endcase	
				
			end
		end
	//	else	그대로 유지
	end

	

	// n_result_0, n_result_1
	// Basemul output, Add output 누적 (barrett reduction 필요)
	reg	[12:0]	barrett_in;	// 13bit
	reg	[11:0]	barrett_out;	// 12bit

	// barrett_in(13bit)	
	always @(*)
	begin
		barrett_in = 13'd0;
		if(c_en_Add)
		begin
			case(c_cnt_Add)
			2'd0:	barrett_in = c_result_0[3071-12*c_cnt_result -:12] + Basemul_out[3071-12*c_cnt_result -:12];
			2'd1:	barrett_in = c_result_0[3071-12*c_cnt_result -:12] + c_e_0[3071-12*c_cnt_result -:12];
			2'd2:	barrett_in = c_result_1[3071-12*c_cnt_result -:12] + Basemul_out[3071-12*c_cnt_result -:12];
			2'd3:	barrett_in = c_result_1[3071-12*c_cnt_result -:12] + c_e_1[3071-12*c_cnt_result -:12];		// 곱셈기사용...
			endcase
		end
	end

	// barrett_out(12bit)
	always @(*)
	begin
		if(barrett_in > 3328)	barrett_out = barrett_in - 3329;
		else			barrett_out = barrett_in;
	end

	// n_result_0, n_result_1 ( Basemul & Add )	각각 3번씩, 총 6번 업데이트
	always @(*)
	begin
		n_result_0 = c_result_0;
		n_result_1 = c_result_1;
		if( Basemul_out_done & (c_cnt_Basemul==2'd0) & c_en_Basemul)
			n_result_0 = Basemul_out;
		else if( Basemul_out_done & (c_cnt_Basemul==2'd2) & c_en_Basemul )
			n_result_1 = Basemul_out;
		else if( c_en_Add & (!c_cnt_Add[1]))	// c_en_Add & ( c_cnt_Add == 0 or 1 )
			n_result_0[3071-12*c_cnt_result -:12] = barrett_out;				// 곱셈기 사용
		else if( c_en_Add & c_cnt_Add[1] )	// c_en_Add & ( c_cnt_Add == 2 or 3 )
			n_result_1[3071-12*c_cnt_result -:12] = barrett_out;				// 곱셈기 사용
	end
		
	
	//////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////
	assign	CBD_in_N	= { 6'd0, c_cnt_CBD };	
	assign	Parse_in_i	= { 7'd0, c_cnt_Parse[0] };
	assign	Parse_in_j	= { 7'd0, c_cnt_Parse[1] };
	// NTT_in_poly
	always @(*)
	begin
		case(c_cnt_NTT)
		2'd0:	NTT_in_poly = c_s_0;
		2'd1:	NTT_in_poly = c_s_1;
		2'd2:	NTT_in_poly = c_e_0;
		2'd3:	NTT_in_poly = c_e_1;
		endcase
	end

	// Basemul_in_p, Basemul_in_q
	always @(*)
	begin
		if(c_cnt_Basemul[0])	// c_cnt_Basemul == 1 or 3
		begin
		Basemul_in_p = c_A_1;
		Basemul_in_q = c_s_1;
		end
		else			// c_cnt_Basemul == 0 or 2
		begin
		Basemul_in_p = c_A_0;
		Basemul_in_q = c_s_0;
		end
	end
	

	// Module Instance
	G_func		g0(.i_clk(i_clk), .i_rstn(i_rstn), .i_start(c_en_G), .i_seed(i_seed), .o_rho(G_out_rho), .o_sigma(G_out_sigma), .o_done(G_out_done) );
	CBD		c0(.i_clk(i_clk), .i_rstn(i_rstn), .i_start(c_en_CBD), .i_sigma(c_sigma), .i_N(CBD_in_N), 
			.o_out1(CBD_out1), .o_out2(CBD_out2), .o_out3(CBD_out3), .o_out4(CBD_out4), .o_out5(CBD_out5), .o_out6(CBD_out6), .o_out7(CBD_out7), 
			.o_num(CBD_out_num), .o_done(CBD_out_done) ); 
	Parse		p0(.i_clk(i_clk), .i_rstn(i_rstn), .i_start(c_en_Parse), .i_rho(c_rho), .i_i(Parse_in_i), .i_j(Parse_in_j), 
			.o_first(Parse_out_first), .o_second(Parse_out_second), .o_first_en(Parse_out_first_en), .o_second_en(Parse_out_second_en), .o_done(Parse_out_done) );
	NTT		n0(.i_clk(i_clk), .i_rstn(i_rstn), .i_start(c_en_NTT), .i_poly(NTT_in_poly), .o_ntt(NTT_out_ntt), .o_done(NTT_out_done) );
	Basemul_TOP	b0(.i_clk(i_clk), .i_rstn(i_rstn), .i_en(c_en_Basemul), .i_p(Basemul_in_p), .i_q(Basemul_in_q), .o_basemul(Basemul_out), .o_done(Basemul_out_done) );


	//////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////
	// Output logic
	assign	o_done		= ( c_state==DONE );
	assign	o_PublicKey 	= o_done ? {c_result_0, c_result_1}	: 6144'd0;	// BitsToBytes 필요
	assign	o_SecretKey 	= o_done ? {c_s_0, c_s_1} 		: 6144'd0;	// BitsToBytes 필요

endmodule
