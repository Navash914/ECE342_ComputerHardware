module lda_system (
  input clk,
  input reset,

  // Avalon Slave Signals
  input [2:0] avs_s1_address,
  input avs_s1_read,
  input avs_s1_write,
  output [31:0] avs_s1_readdata,
  input [31:0] avs_s1_writedata,
  output avs_s1_waitrequest,

  // VGA Signals
  output [7:0] coe_VGA_R_export,
  output [7:0] coe_VGA_G_export,
  output [7:0] coe_VGA_B_export,
  output coe_VGA_HS_export,
  output coe_VGA_VS_export,
  output coe_VGA_SYNC_N_export,
  output coe_VGA_BLANK_N_export,
  output coe_VGA_CLK_export
);

// Local logic
logic lda_done, lda_start;
logic [8:0] lda_x0, lda_x1;
logic [7:0] lda_y0, lda_y1;
logic [2:0] lda_col;

logic vga_plot;
logic [8:0] vga_x;
logic [7:0] vga_y;
logic [2:0] vga_col;

// Avalon Slave Controller
avalon_slave_controller ASC (
	.clk(clk),
	.reset(reset),
	
	.i_read(avs_s1_read),
	.i_write(avs_s1_write),
	.i_address(avs_s1_address),
	.i_writedata(avs_s1_writedata),
	.o_readdata(avs_s1_readdata),
	.o_waitrequest(avs_s1_waitrequest),
	
	.i_done(lda_done),
	.o_start(lda_start),
	.o_x0(lda_x0),
	.o_y0(lda_y0),
	.o_x1(lda_x1),
	.o_y1(lda_y1),
	.o_col(lda_col)
);

// Line Drawing Algorithm Unit
line_drawing_algorithm LDA (
	.clk(clk),
	.reset(reset),
	
	.i_start(lda_start),
	.i_x0(lda_x0),
	.i_y0(lda_y0),
	.i_x1(lda_x1),
	.i_y1(lda_y1),
	.i_col(lda_col),
	.o_plot(vga_plot),
	.o_x(vga_x),
	.o_y(vga_y),
	.o_col(vga_col),
	.o_done(lda_done)
);

// VGA Unit
vga_adapter #
(
	.BITS_PER_CHANNEL(1)
)
vga_inst
(
	.clk(clk),
	.VGA_R(coe_VGA_R_export),
	.VGA_G(coe_VGA_G_export),
	.VGA_B(coe_VGA_B_export),
	.VGA_HS(coe_VGA_HS_export),
	.VGA_VS(coe_VGA_VS_export),
	.VGA_SYNC_N(coe_VGA_SYNC_N_export),
	.VGA_BLANK_N(coe_VGA_BLANK_N_export),
	.VGA_CLK(coe_VGA_CLK_export),
	.x(vga_x),
	.y(vga_y),
	.color(vga_col),
	.plot(vga_plot)
);

endmodule
