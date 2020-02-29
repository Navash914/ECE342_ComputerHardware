module program_counter #(parameter n) (
    input clk,
    input reset,

    input i_en,
    input i_ld,
    input [n-1:0] i_data,

    output logic [n-1:0] o_data
);	
	always_ff @(posedge clk)
	 	if (reset)
			o_data <= 0;
		else if (i_ld)
			o_data <= i_data;
		else if (i_en)
			o_data <= o_data + 2;
endmodule