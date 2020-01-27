module carry_save_multiplier (
	input [7:0] i_m,
	input [7:0] i_q,
	
	output [15:0] o_p
);

// Full adder outputs
logic [7:0] [7:0] fa_out;
logic [7:0] [7:0] fa_cout;

genvar row;
genvar col;

generate

	for (row = 0; row < 8; row++) begin : mult_row
	
		// Assign lower bit outputs
		assign o_p[row] = fa_out[row][0];
	
		for (col = 0; col < 8; col++) begin : mult_col
			// Inputs to full adder
			logic fa_a;
			logic fa_b;
			logic fa_cin;
			
			// Drive fa_a input
			assign fa_a = i_m[col] & i_q[row];
			
			// Drive fa_b and fa_cin inputs
			if (row == 0) begin
				assign fa_b = 0;
				assign fa_cin = 0;
			end else begin
				if (col == 7) begin
					assign fa_b = 0;
				end else begin
					assign fa_b = fa_out[row-1][col+1];
				end
				
				assign fa_cin = fa_cout[row-1][col];
			end
			
			// Instantiate full adder
			full_adder fa(
				  .i_a(fa_a),
				  .i_b(fa_b),
				  .i_cin(fa_cin),
				  .o_sum(fa_out[row][col]),
				  .o_cout(fa_cout[row][col])
			);
		end	// mult_col
	end	// mult_row
	
	// Instantiate carry looakahead adder for higher bit outputs
	logic [7:0] cla_cout;
	carry_lookahead_adder cla (
		.i_a({1'b0, fa_out[7][7:1]}),
		.i_b(fa_cout[7:0]),
		.i_cin(1'b0),
		.o_sum(o_p[15:8]),
		.o_cout(cla_cout)
	);

endgenerate

endmodule
