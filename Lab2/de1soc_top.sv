module de1soc_top 
(
	// These are the board inputs/outputs required for all the ECE342 labs.
	// Each lab can use the subset it needs -- unused pins will be ignored.
	
    // Clock pins
    input                     CLOCK_50,

    // Seven Segment Displays
    output      [6:0]         HEX0,
    output      [6:0]         HEX1,
    output      [6:0]         HEX2,
    output      [6:0]         HEX3,
    output      [6:0]         HEX4,
    output      [6:0]         HEX5,

    // Pushbuttons
    input       [3:0]         KEY,

    // LEDs
    output      [9:0]         LEDR,

    // Slider Switches
    input       [9:0]         SW,

    // VGA
    output      [7:0]         VGA_B,
    output                    VGA_BLANK_N,
    output                    VGA_CLK,
    output      [7:0]         VGA_G,
    output                    VGA_HS,
    output      [7:0]         VGA_R,
    output                    VGA_SYNC_N,
    output                    VGA_VS
);
	
	logic [8:0] data;
	logic select;
	logic clk;
	
	logic [8:0] reg_x;
	logic [8:0] reg_y;
	logic [15:0] reg_out;
	
	logic [15:0] mult_out;
	
	
	assign data = SW[7:0];
	assign select = SW[9];
	assign clk = CLOCK_50;
	
	// Input registers
	reg_n #(8) regx (
		.i_clk(clk),
		.i_en(select),
		.i_data(data),
		.o_data(reg_x)
	);
	
	reg_n #(8) regy (
		.i_clk(clk),
		.i_en(~select),
		.i_data(data),
		.o_data(reg_y)
	);
	
	// Output register
	reg_n #(16) regout (
		.i_clk(clk),
		.i_en(1'b1),
		.i_data(mult_out),
		.o_data(reg_out)
	);
	
	// Multiplier module
	array_multiplier mult (
		.i_m(reg_x),
		.i_q(reg_y),
		.o_p(mult_out)
	);
	
	// Output on hexes
	hex_decoder hex3 (
		.hex_digit(reg_out[15:12]),
		.segments(HEX3)
	);
	
	hex_decoder hex2 (
		.hex_digit(reg_out[11:8]),
		.segments(HEX2)
	);
	
	hex_decoder hex1 (
		.hex_digit(reg_out[7:4]),
		.segments(HEX1)
	);
	
	hex_decoder hex0 (
		.hex_digit(reg_out[3:0]),
		.segments(HEX0)
	);
	
	// Zero out other hexes
	assign HEX4 = '1;
	assign HEX5 = '1;
	
endmodule
