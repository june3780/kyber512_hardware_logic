module butterfly_unit(i_clk, i_rstn, i_x, i_y, i_zeta, i_en, o_z_h, o_z_l, o_done);
    
	input 	[11:0] 	i_x, i_y;
    	input 	[11:0]	i_zeta;
    	input 		i_clk, i_en, i_rstn;
    	output 	[11:0]	o_z_h;
    	output 	[11:0]	o_z_l;
	output		o_done;

    	//flipflop
    	reg             c_state, n_state;
    	wire	[11:0]  montgo_output, montgo_output_temp;
    	wire            montgo_done, montgo_done_temp; 

    	reg     [11:0] n_bout_h, c_bout_h;
    	reg     [11:0] n_bout_l, c_bout_l;
    	reg		[11:0] n_1x, c_1x;
    	reg		[11:0] n_2x, c_2x;
    	reg		[11:0] n_3x, c_3x;
    	reg		[11:0] n_4x, c_4x;


    	wire    signed  [13:0] barret_in1;
    	wire    signed  [13:0] barret_in2;
    	wire    [11:0] temp_h;
    	wire    [11:0] temp_l;
		wire	[11:0] temp_h_temp;
		wire	[11:0] temp_l_temp;
    
    	always @(posedge i_clk, negedge i_rstn)
    	begin
        	if (!i_rstn)
       		begin
            	c_state <= 2'd0;
            	c_bout_h <=12'd0;
            	c_bout_l <=12'd0;
            	c_1x <= 12'd0;
            	c_2x <= 12'd0;
            	c_3x <= 12'd0;
            	c_4x <= 12'd0;

        	end
        	else
        	begin
            	c_state <= n_state;
            	c_bout_h <=n_bout_h;
            	c_bout_l <=n_bout_l;
            	c_1x <= n_1x;
            	c_2x <= n_2x;
            	c_3x <= n_3x;
            	c_4x <= n_4x;
        	end
    	end

    //montgomery
    montgomery u1 (
        .i_a(i_y), 
        .i_b(i_zeta), 
        .i_clk(i_clk), 
        .i_rstn(i_rstn), 
        .i_en(i_en), 
        .o_c(montgo_output),
        .o_done(montgo_done)
    );
    montgomery_temp tu1 (
        .i_a(i_y), 
        .i_b(i_zeta), 
        .i_clk(i_clk), 
        .i_rstn(i_rstn), 
        .i_en(i_en),
        .i_morb(2'b10),
        .o_c(montgo_output_temp),
        .o_done(montgo_done_temp)
    );

    //barrett_1

    assign barret_in1 = {1'd0,c_4x} + {1'd0,montgo_output};	// i_x + montgo_output ( 14bit = 13bit + 13bit )
    assign barret_in2 = {1'd0,c_4x} - {1'd0,montgo_output};	// i_x - montgo_output ( 14bit = 13bit - 13bit )

    barrett u2 (
        .i_in(barret_in1),
        .o_out(temp_h)
    );
    //barrett_2
    barrett u3 (
        .i_in(barret_in2),
        .o_out(temp_l)
    );
	
    
    // n_bout_h, n_bout_l
    always @(*)
    begin
        n_bout_h = temp_h;
        n_bout_l = temp_l;
    end
 
    assign o_z_h = c_state ? c_bout_h : 12'd0;
    assign o_z_l = c_state ? c_bout_l : 12'd0;
    assign o_done = c_state; 

    // n_state
    always @(*)
    begin
        n_state = 2'd0;
        case(c_state)
        2'd0: if(montgo_done == 1'd1) n_state = 2'd1;
        endcase
    end
    
    // n_1x, n_2x, n_3x, n_4x
    always @(*)
    begin
    	n_1x = i_x;
    	n_2x = c_1x;
    	n_3x = c_2x;
    	n_4x = c_3x;
    end

endmodule
