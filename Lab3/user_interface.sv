module user_interface (
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
	output o_start,
	output [8:0] o_x0,
	output [7:0] o_y0,
	output [8:0] o_x1,
	output [7:0] o_y1,
	output [2:0] o_col
);

// Logic between control and datapath
logic dp_setX, dp_setY, dp_setCol;

// Control module
UI_control control (
	.clk(clk),
	.reset(reset),
	.i_setX(i_setX),
	.i_setY(i_setY),
	.i_setCol(i_setCol),
	.i_go(i_go),
	.i_done(i_done),
	.o_start(o_start),
	.o_setX(dp_setX),
	.o_setY(dp_setY),
	.o_setCol(dp_setCol)
);

// Datapath module
UI_datapath datapath (
	.clk(clk),
	.reset(reset),
	.i_setX(dp_setX),
	.i_setY(dp_setY),
	.i_setCol(dp_setCol),
	.i_val(i_val),
	.i_done(i_done),
	.o_x0(o_x0),
	.o_y0(o_y0),
	.o_x1(o_x1),
	.o_y1(o_y1),
	.o_col(o_col)
);

endmodule
