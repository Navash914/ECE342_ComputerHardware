module array_multiplier(
	input [7:0] i_m,
	input [7:0] i_q,
	
	output [15:0] o_p
);

// Full adder outputs
logic [7:0] [15:0] fa_out;
logic [7:0] [15:0] fa_cout;

genvar row;
genvar col;

generate

	for (row = 0; row < 8; row++) begin : mult_row
		// Assign lower outputs
		assign o_p[row] = fa_out[row][row];
	
		// Instantiate booth encoder
		logic [1:0] be_q;
		logic be_p;
		logic be_m;
		
		if (row == 0) begin
			assign be_q[0] = 1'b0;	// q[-1] = 0
		end else begin
			assign be_q[0] = i_q[row-1];
		end
		assign be_q[1] = i_q[row];
		
		booth_encoder be (
			.i_q(be_q),
			.o_plus(be_p),
			.o_minus(be_m)
		);
		
		for (col = row; col < 16; col++) begin : mult_col
			// assign higher outputs
			if (row == 7 && col > row) begin
				assign o_p[col] = fa_out[row][col];
			end
			
			// Inputs to full adder
			logic fa_a;
			logic fa_b;
			logic fa_cin;
			
			// Drive fa_b input
			if (row == 0) begin
				assign fa_b = 0;
			end else begin
				assign fa_b = fa_out[row-1][col];
			end
			
			// Drive cin input
			if (col == row) begin
				assign fa_cin = be_m;
			end else begin
				assign fa_cin = fa_cout[row][col-1];
			end
			
			// Drive fa_a input
			if (col < row + 8) begin
				// Multiplier units
				assign fa_a = (i_m[col-row] & be_p) | (~i_m[col-row] & be_m);
			end else begin
				// Sign extension units
				assign fa_a = (i_m[7] & be_p) | (~i_m[7] & be_m);
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

endgenerate

endmodule
