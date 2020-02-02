module UI_datapath (
	input clk,
	input reset,
	
	input i_done,

	// Selector inputs
	input i_setX,
	input i_setY,
	input i_setCol,
	
	// Value input
	input [8:0] i_val,
	
	// Outputs
	output logic [8:0] o_x0,
	output logic [7:0] o_y0,
	output logic [8:0] o_x1,
	output logic [7:0] o_y1,
	output logic [2:0] o_col
);

always_ff @(posedge clk or posedge reset) begin
	if (reset) begin
		o_x0 <= 9'b0;
		o_y0 <= 8'b0;
		o_x1 <= 9'b0;
		o_y1 <= 8'b0;
		o_col <= 3'b0;
	end else begin
		if (i_setX) o_x1 <= i_val;
		if (i_setY) o_y1 <= i_val[7:0];
		if (i_setCol) o_col <= i_val[2:0];
		if (i_done) begin
			o_x0 <= o_x1;
			o_y0 <= o_y1;
		end
	end
end

endmodule
