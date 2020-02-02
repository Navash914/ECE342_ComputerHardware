`timescale 1ns/1ns

module tb();

logic clk;
initial clk = 1'b0;
always #10 clk = ~clk;

logic reset;

logic setX, setY, setCol, go;
logic [8:0] val;

logic start, done;
logic [8:0] x0, x1;
logic [7:0] y0, y1;
logic [2:0] col;

logic [8:0] vga_x;
logic [7:0] vga_y;
logic [2:0] vga_color;
logic vga_plot;

//
// PUT YOUR UI AND LDA MODULE INSTANTIATIONS HERE
//

user_interface UI (
	.clk(clk),
	.reset(reset),
	.i_setX(setX),
	.i_setY(setY),
	.i_setCol(setCol),
	.i_go(go),
	.i_val(val),
	.i_done(done),
	.o_start(start),
	.o_x0(x0),
	.o_y0(y0),
	.o_x1(x1),
	.o_y1(y1),
	.o_col(col)
);

line_drawing_algorithm LDA (
	.clk(clk),
	.reset(reset),
	.i_start(start),
	.i_x0(x0),
	.i_y0(y0),
	.i_x1(x1),
	.i_y1(y1),
	.i_col(col),
	.o_plot(vga_plot),
	.o_x(vga_x),
	.o_y(vga_y),
	.o_col(vga_color),
	.o_done(done)
);

vga_bmp bmp (
	.clk(clk),
	.x(vga_x),
	.y(vga_y),
	.color(vga_color),
	.plot(vga_plot)
);

initial begin
	setX = 1'b0;
	setY = 1'b0;
	setCol = 1'b0;
	val = 9'b0;
	go = 1'b0;
	
	reset = 1'b1;
   @(posedge clk);
	reset = 1'b0;
	
	// Currently at (0, 0)
	// Steep, forward, downward
	
	val = 9'd100;
	setX = 1'b1;
	@(posedge clk);
	setX = 1'b0;
	
	val = 9'd200;
	setY = 1'b1;
	@(posedge clk);
	setY = 1'b0;
	
	val = 9'd1;
	setCol = 1'b1;
	@(posedge clk);
	setCol = 1'b0;
	
	go = 1'b1;
	@(posedge clk);
	go = 1'b0;
	
	wait(done);
	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	
	// Currently at (100, 200)
	// Steep, forward, upward
	
	val = 9'd200;
	setX = 1'b1;
	@(posedge clk);
	setX = 1'b0;
	
	val = 9'd0;
	setY = 1'b1;
	@(posedge clk);
	setY = 1'b0;
	
	val = 9'd2;
	setCol = 1'b1;
	@(posedge clk);
	setCol = 1'b0;
	
	go = 1'b1;
	@(posedge clk);
	go = 1'b0;
	
	wait(done);
	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	
	// Currently at (200, 0)
	// Steep, backward, downward
	
	val = 9'd150;
	setX = 1'b1;
	@(posedge clk);
	setX = 1'b0;
	
	val = 9'd100;
	setY = 1'b1;
	@(posedge clk);
	setY = 1'b0;
	
	val = 9'd3;
	setCol = 1'b1;
	@(posedge clk);
	setCol = 1'b0;
	
	go = 1'b1;
	@(posedge clk);
	go = 1'b0;
	
	wait(done);
	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	
	// Currently at (150, 100)
	// Steep, backward, upward
	
	val = 9'd100;
	setX = 1'b1;
	@(posedge clk);
	setX = 1'b0;
	
	val = 9'd0;
	setY = 1'b1;
	@(posedge clk);
	setY = 1'b0;
	
	val = 9'd4;
	setCol = 1'b1;
	@(posedge clk);
	setCol = 1'b0;
	
	go = 1'b1;
	@(posedge clk);
	go = 1'b0;
	
	wait(done);
	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	
	// Currently at (100, 0)
	// Unsteep, forward, downward
	
	val = 9'd200;
	setX = 1'b1;
	@(posedge clk);
	setX = 1'b0;
	
	val = 9'd125;
	setY = 1'b1;
	@(posedge clk);
	setY = 1'b0;
	
	val = 9'd5;
	setCol = 1'b1;
	@(posedge clk);
	setCol = 1'b0;
	
	go = 1'b1;
	@(posedge clk);
	go = 1'b0;
	
	wait(done);
	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	
	// Currently at (225, 150)
	// Unsteep, forward, upward
	
	val = 9'd300;
	setX = 1'b1;
	@(posedge clk);
	setX = 1'b0;
	
	val = 9'd100;
	setY = 1'b1;
	@(posedge clk);
	setY = 1'b0;
	
	val = 9'd6;
	setCol = 1'b1;
	@(posedge clk);
	setCol = 1'b0;
	
	go = 1'b1;
	@(posedge clk);
	go = 1'b0;
	
	wait(done);
	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	
	// Currently at (300, 100)
	// Unsteep, backward, downward
	
	val = 9'd150;
	setX = 1'b1;
	@(posedge clk);
	setX = 1'b0;
	
	val = 9'd200;
	setY = 1'b1;
	@(posedge clk);
	setY = 1'b0;
	
	val = 9'd7;
	setCol = 1'b1;
	@(posedge clk);
	setCol = 1'b0;
	
	go = 1'b1;
	@(posedge clk);
	go = 1'b0;
	
	wait(done);
	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	
	// Currently at (150, 200)
	// Unsteep, backward, upward
	
	val = 9'd50;
	setX = 1'b1;
	@(posedge clk);
	setX = 1'b0;
	
	val = 9'd150;
	setY = 1'b1;
	@(posedge clk);
	setY = 1'b0;
	
	val = 9'd1;
	setCol = 1'b1;
	@(posedge clk);
	setCol = 1'b0;
	
	go = 1'b1;
	@(posedge clk);
	go = 1'b0;
	
	wait(done);
	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	
	// Draw a box from (50, 150) to test horizontal and vertical lines
	
	val = 9'd100;
	setX = 1'b1;
	@(posedge clk);
	setX = 1'b0;
	
	go = 1'b1;
	@(posedge clk);
	go = 1'b0;
	
	wait(done);
	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	
	val = 9'd200;
	setY = 1'b1;
	@(posedge clk);
	setY = 1'b0;
	
	go = 1'b1;
	@(posedge clk);
	go = 1'b0;
	
	wait(done);
	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	
	val = 9'd50;
	setX = 1'b1;
	@(posedge clk);
	setX = 1'b0;
	
	go = 1'b1;
	@(posedge clk);
	go = 1'b0;
	
	wait(done);
	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	
	val = 9'd150;
	setY = 1'b1;
	@(posedge clk);
	setY = 1'b0;
	
	go = 1'b1;
	@(posedge clk);
	go = 1'b0;
	
	wait(done);
	
	@(posedge clk);
	@(posedge clk);
	@(posedge clk);
	
	bmp.write_bmp();
	$stop();
	
end

endmodule
