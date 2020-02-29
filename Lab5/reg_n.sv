module reg_n #(parameter n) (
	input i_clk,
	input i_en,
	input [n-1:0] i_data,
	
	output logic [n-1:0] o_data
);

	always_ff @(posedge i_clk) begin
		if (i_en) o_data <= i_data;
	end

endmodule
