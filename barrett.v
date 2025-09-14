module barrett(i_in, o_out);

    input 	signed 	[13:0] i_in;
    output  	reg	[11:0] o_out;


    always @(*)
    begin
        if      (i_in < 0 )      	o_out = i_in + 3329;
        else if (i_in > 3328 )       	o_out = i_in - 3329;
        else                           	o_out = i_in; 

    end

endmodule
