
module nios_system (
	clk_clk,
	reset_reset_n,
	switches_export,
	leds_export,
	vga_r_export,
	vga_g_export,
	vga_b_export,
	vga_hs_export,
	vga_vs_export,
	vga_sync_n_export,
	vga_blank_n_export,
	vga_clk_export);	

	input		clk_clk;
	input		reset_reset_n;
	input	[7:0]	switches_export;
	output	[7:0]	leds_export;
	output	[7:0]	vga_r_export;
	output	[7:0]	vga_g_export;
	output	[7:0]	vga_b_export;
	output		vga_hs_export;
	output		vga_vs_export;
	output		vga_sync_n_export;
	output		vga_blank_n_export;
	output		vga_clk_export;
endmodule
