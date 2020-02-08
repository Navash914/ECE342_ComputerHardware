module asc_datapath (
	input clk,
	input reset,
	
	input i_read,
	input [2:0] i_address,
	input [31:0] i_writedata,
	output logic [31:0] o_readdata,
	
	// Control
	input i_status,
	input i_ld_mode,
	input i_ld_sp,
	input i_ld_ep,
	input i_ld_col,
	output o_mode,
	
	output [8:0] o_x0,
	output [8:0] o_x1,
	output [7:0] o_y0,
	output [7:0] o_y1,
	output [2:0] o_col
);

logic [5:0] [31:0] data;

assign o_mode = data[0][0];
assign data[1][0] = i_status;

assign o_x0 = data[3][8:0];
assign o_y0 = data[3][16:9];

assign o_x1 = data[4][8:0];
assign o_y1 = data[4][16:9];

assign o_col = data[5][2:0];

always_ff @(posedge clk or posedge reset) begin
	if (reset) begin
		data[0] <= 0;
		data[2] <= 0;
		data[3] <= 0;
		data[4] <= 0;
		data[5] <= 0;
		o_readdata <= 0;
	end else begin
		if (i_read) begin
			o_readdata <= data[i_address];
		end else begin
			if (i_ld_mode) data[0] <= i_writedata;
			if (i_ld_sp) data[3] <= i_writedata;
			if (i_ld_ep) data[4] <= i_writedata;
			if (i_ld_col) data[5] <= i_writedata;
		end
	end
end

endmodule
