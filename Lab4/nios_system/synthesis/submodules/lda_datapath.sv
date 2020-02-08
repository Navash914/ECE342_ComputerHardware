module LDA_datapath (
	input clk,
	input reset,
	
	input [8:0] i_x0,
	input [7:0] i_y0,
	input [8:0] i_x1,
	input [7:0] i_y1,
	input [2:0] i_col,
	
	// From Control
	input i_setup,
	input i_step,
	
	// VGA
	output logic o_plot,
	output logic [8:0] o_x,
	output logic [7:0] o_y,
	output logic [2:0] o_col,
	
	output logic o_done
);

// All values are 9 bits long even though y values are 8 bits because
// x and y values can swap during the algorithm
logic [8:0] x, x0, x1, dx;		// Current, start, end and delta values for x
logic [8:0] y, y0, y1, dy;		// Current, start, end and delta values for y

logic steep;	// If line is steep
logic signed [8:0] error;	// Error
logic signed [8:0] y_step;	// Whether y should increase or decrease. Has to be same number of bits as y.

// Absolute values for steep logic
wire [8:0] abs_dx = i_x1 > i_x0 ? i_x1 - i_x0 : i_x0 - i_x1;
wire [8:0] abs_dy = i_y1 > i_y0 ? i_y1 - i_y0 : i_y0 - i_y1;

// Assign logic values
assign steep = abs_dy > abs_dx ? 1'b1 : 1'b0;
assign dx = x1 - x0;
assign dy = y1 > y0 ? y1 - y0 : y0 - y1;
assign y_step = y1 > y0 ? 2'b1 : -2'b1;

// Datapath does not change color
assign o_col = i_col;

always_ff @(posedge clk or posedge reset) begin
	if (reset) begin
		// Default values
		x0 <= 9'b0;
		x1 <= 9'b0;
		x <= 9'b0;
		
		y0 <= 9'b0;
		y1 <= 9'b0;
		y <= 9'b0;
		
		error <= 9'b0;
		
		o_plot <= 1'b0;
		o_done <= 1'b0;
	end else begin
		if (i_setup) begin
			// No plot or done for setup
			o_plot <= 1'b0;
			o_done <= 1'b0;
			if (steep) begin
				if (i_y0 > i_y1) begin
					// Values for steep and backward line
					x0 <= i_y1;
					y1 <= i_x0;
					y0 <= i_x1;
					x1 <= i_y0;
					
					x <= i_y1;
					y <= i_x1;
					error <= -((i_y0 - i_y1) >> 1);
				end else begin
					// Values for steep and forward line
					x0 <= i_y0;
					y0 <= i_x0;
					x1 <= i_y1;
					y1 <= i_x1;
					
					x <= i_y0;
					y <= i_x0;
					error <= -((i_y1 - i_y0) >> 1);
				end
			end else begin
				if (i_x0 > i_x1) begin
					// Values for not steep and backward line
					x0 <= i_x1;
					x1 <= i_x0;
					y0 <= i_y1;
					y1 <= i_y0;
					
					x <= i_x1;
					y <= i_y1;
					error <= -((i_x0 - i_x1) >> 1);
				end else begin
					// Values for not steep and forward line
					x0 <= i_x0;
					x1 <= i_x1;
					y0 <= i_y0;
					y1 <= i_y1;
					
					x <= i_x0;
					y <= i_y0;
					error <= -((i_x1 - i_x0) >> 1);
				end
			end
		end else if (i_step) begin
			// One iteration of the loop.
			if (x > x1) begin
				// We are done looping
				o_plot <= 1'b0;
				o_done <= 1'b1;
			end else begin
				// Plot (x, y) point
				o_done <= 1'b0;
				o_plot <= 1'b1;
				if (steep) begin
					o_x <= y;
					o_y <= x[7:0];
				end else begin
					o_x <= x;
					o_y <= y[7:0];
				end
				// Update error
				error = error + dy;
				if (error > 0) begin
					// Increment y by +1 or -1 based on y_step
					y <= y + y_step;
					
					// Update error
					error = error - dx;
				end
				
				// Update x for next iteration
				x <= x + 1'b1;
			end
		end else begin
			// Datapath is not calculating anything
			o_plot <= 1'b0;
			o_done <= 1'b0;
		end
	end
end

endmodule
