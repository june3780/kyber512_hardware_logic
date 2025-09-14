module hash(i_clk, i_rstn, i_en, i_in, i_mode, o_done, o_out);
	
	input				i_clk;
	input				i_rstn;
	input		[1:0]		i_en;		// 2'b00 : WAIT, 2'b01: START, 2'b10: STOP
	input		[1:0]		i_mode;
	input		[271:0]		i_in;
	output				o_done;	
	output	reg	[1343:0]	o_out;	

	localparam IDLE		= 2'd0;	
	localparam ROUND	= 2'd1;	
	localparam DONE		= 2'd2;
	
	localparam SHAKE_128	= 2'd0;
	localparam SHAKE_256	= 2'd1;
	localparam SHA3_512	= 2'd2;

	
	reg	[1599:0]		keccak_in;
	wire	[1599:0]		keccak_out;
	wire	[1:0]			keccak_state;	



	///////////////////////////////////////////
	// keccak_in
	always @(*)
	begin
		keccak_in = 1600'd0;
		case(keccak_state)
		IDLE:
			case(i_mode)
			SHAKE_128:	keccak_in = { i_in       , 8'h1F, {132{8'h00}}, 8'h80, 256'd0  };	// r = 1344(272+8+132*8+8), c = 256
			SHAKE_256:	keccak_in = { i_in[263:0], 8'h1F, {101{8'h00}}, 8'h80, 512'd0  };	// r = 1088(264+8+101*8+8), c = 512
			SHA3_512:	keccak_in = { i_in[255:0], 8'h06, { 38{8'h00}}, 8'h80, 1024'd0 };	// r = 576 (256+8+ 38*8+8), c = 1024
			endcase

		DONE:			keccak_in = keccak_out;

		endcase
	end




	KECCAK	k0( .i_clk(i_clk), .i_rstn(i_rstn), .i_en(i_en), .i_in(keccak_in), .o_state(keccak_state), .o_out(keccak_out) );
	

	// Output logic
	
	// o_out (1344bit)
	always @(*)
	begin
		case(i_mode)
		SHAKE_128:	o_out = keccak_out[1599 -:1344];		// r = 1344
		SHAKE_256:	o_out = { 256'd0, keccak_out[1599 -:1088]};	// r = 1088
		SHA3_512:	o_out = { 768'd0, keccak_out[1599 -:576]};	// r = 576
		default:	o_out = 1344'd0;
		endcase
	end

	// o_done
	assign o_done = (keccak_state == DONE);

endmodule