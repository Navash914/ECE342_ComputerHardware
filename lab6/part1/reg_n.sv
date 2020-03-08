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

module reg_n_h #(parameter n) (
	input i_clk,
	input i_en,
	input i_h,
	input [n-1:0] i_data,
	
	output logic [n-1:0] o_data
);
	localparam half = (n % 2) == 0 ? (n/2) - 1 : (n/2);
	always_ff @(posedge i_clk) begin
		if (i_en) begin
			if (i_h)
				o_data[n-1:(n/2)] <= i_data[half:0];
			else
				o_data <= i_data;
		end
	end

endmodule