module reg_n #(parameter NUM_BITS) (
	input i_clk,
	input i_en,
	input [NUM_BITS-1:0] i_data,
	
	output logic [NUM_BITS-1:0] o_data
);

	always_ff @(posedge i_clk) begin
		if (i_en) o_data <= i_data;
	end

endmodule
