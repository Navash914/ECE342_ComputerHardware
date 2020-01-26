module array_multiplier(
	input [7:0] i_m,
	input [7:0] i_q,
	
	output [15:0] o_p
);

logic [7:0] plus;
logic [7:0] minus;

logic [7:0] [8:0] fa_out;
logic [7:0] [8:0] fa_cout;

genvar row;
genvar col;

generate

	for (row = 0; row < 8; row++) begin : mult_row
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
		
		for (col = 0; col < 9; col++) begin : mult_col
			// assign output
			if (row == 7) begin
				assign o_p[row + col] = fa_out[row][col];
			end else begin
				assign o_p[row] = fa_out[row][0];
			end
			
			// Inputs to full adder
			logic fa_a;
			logic fa_b;
			logic fa_cin;
			
			//assign be_se[row][col] = (i_m[col] & be_p) | (~i_m[col] & be_m);
			if (col == 8) begin
				assign fa_a = (i_m[col-1] & be_p) | (~i_m[col-1] & be_m);
			end else begin
				assign fa_a = (i_m[col] & be_p) | (~i_m[col] & be_m);
			end
			
			if (row == 0) begin
				assign fa_b = 1'b0;
			end else if (col == 8) begin
				assign fa_b = fa_cout[row-1][col];
			end else begin
				assign fa_b = fa_out[row-1][col+1];
			end
			
			if (col == 0) begin
				assign fa_cin = be_m;
			end else begin
				assign fa_cin = fa_cout[row][col-1];
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
	
	//assign o_p[15] = fa_cout[7][7];

endgenerate

endmodule
