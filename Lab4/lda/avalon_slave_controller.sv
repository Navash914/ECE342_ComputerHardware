module avalon_slave_controller (
	input clk,
	input reset,
	
	// Slave Signals
	input i_read,
	input i_write,
	input [31:0] i_address,
	input [31:0] i_writedata,
	output [31:0] o_readdata,
	output o_waitrequest
);



endmodule
