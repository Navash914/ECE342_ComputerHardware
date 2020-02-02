module UI (
	input clk,
	input reset,

	// Button Inputs
	input i_setX,
	input i_setY,
	input i_setCol,
	input i_go,
	
	// SW Inputs
	input [8:0] i_val,
	
	// Input from LDA
	input i_done,
	
	// Outputs to LDA
	output logic o_start,
	output logic [8:0] o_x0,
	output logic [7:0] o_y0,
	output logic [8:0] o_x1,
	output logic [7:0] o_y1,
	output logic [2:0] o_col
);



endmodule
