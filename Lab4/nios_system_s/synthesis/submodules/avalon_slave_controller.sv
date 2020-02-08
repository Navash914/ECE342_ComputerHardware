module avalon_slave_controller (
	input clk,
	input reset,
	
	// Slave Signals
	input i_read,
	input i_write,
	input [2:0] i_address,
	input [31:0] i_writedata,
	output [31:0] o_readdata,
	output o_waitrequest,
	
	// LDA
	input i_done,
	output o_start,
	output [8:0] o_x0,
	output [7:0] o_y0,
	output [8:0] o_x1,
	output [7:0] o_y1,
	output [2:0] o_col
);

// Logic between control and datapath
logic dp_mode, dp_status;
logic dp_ld_mode, dp_ld_sp, dp_ld_ep, dp_ld_col;

// Control FSM Module
asc_control ASC_Control (
	.clk(clk),
	.reset(reset),
	
	.i_write(i_write),
	.i_address(i_address),
	.o_waitrequest(o_waitrequest),
	.i_done(i_done),
	.o_start(o_start),
	.o_status(dp_status),
	.i_mode(dp_mode),
	.o_ld_mode(dp_ld_mode),
	.o_ld_sp(dp_ld_sp),
	.o_ld_ep(dp_ld_ep),
	.o_ld_col(dp_ld_col)
);

// Datapath Module
asc_datapath ASC_Datapath (
	.clk(clk),
	.reset(reset),
	
	.i_read(i_read),
	.i_address(i_address),
	.i_writedata(i_writedata),
	.o_readdata(o_readdata),
	.i_status(dp_status),
	.i_ld_mode(dp_ld_mode),
	.i_ld_sp(dp_ld_sp),
	.i_ld_ep(dp_ld_ep),
	.i_ld_col(dp_ld_col),
	.o_mode(dp_mode),
	.o_x0(o_x0),
	.o_x1(o_x1),
	.o_y0(o_y0),
	.o_y1(o_y1),
	.o_col(o_col)
);

endmodule
