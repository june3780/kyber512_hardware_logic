module G_func(i_clk, i_rstn, i_start, i_seed, o_rho, o_sigma, o_done);
	
	input 				i_clk;
	input				i_rstn;
	input				i_start;
	input		[255:0]		i_seed;

	output		[255:0]		o_rho;
	output		[255:0]		o_sigma;
	output				o_done;

	wire		[1343:0]	hash_out;
	wire				hash_done;
	wire		[271:0]		hash_in;
	reg		[1:0]		hash_enable;

///////////////////////////////////////////////////////////////

	always @(*)
	begin
		hash_enable = 2'b00;
		if(hash_done)		hash_enable = 2'b10;
		else if(i_start)	hash_enable = 2'b01;

	end
	
	wire	[1:0]		hash_mode;
	assign	hash_mode = 2'd2;	// SHA3_512
	assign	hash_in = {16'd0, i_seed};

	hash	h1(	.i_clk(i_clk), .i_rstn(i_rstn), 
			.i_en(hash_enable), .i_in(hash_in), .i_mode(hash_mode), 
			.o_done(hash_done), .o_out(hash_out) );

	assign	o_rho 	= hash_out[575 -:256];
	assign	o_sigma	= hash_out[319 -:256];
	assign	o_done	= hash_done;

endmodule

