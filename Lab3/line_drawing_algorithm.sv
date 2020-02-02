module LDA (
	input clk,
	input reset,

	input i_start,
	input [8:0] i_x0,
	input [7:0] i_y0,
	input [8:0] i_x1,
	input [7:0] i_y1,
	input [2:0] i_col,
	
	// VGA
	output logic o_plot,
	output logic [8:0] o_x,
	output logic [7:0] o_y,
	output logic [2:0] o_col,
	
	output o_done
);

logic dp_setup, dp_step;

LDA_control control (
	.clk(clk),
	.reset(reset),
	.i_start(i_start),
	.i_done(o_done),
	.o_setup(dp_setup),
	.o_step.(dp_step)
);

LDA_datapath datapath (
	.clk(clk),
	.reset(reset),
	.i_x0(i_x0),
	.i_y0(i_y0),
	.i_x1(i_x1),
	.i_y1(i_y1),
	.i_col(i_col),
	.i_setup(dp_setup),
	.i_step(dp_step),
	.o_plot(o_plot),
	.o_x(o_x),
	.o_y(o_y),
	.o_col(o_col),
	.o_done(o_done)
);


endmodule
