module LDA_datapath (
	input clk,
	input reset,
	
	input [8:0] i_x0,
	input [7:0] i_y0,
	input [8:0] i_x1,
	input [7:0] i_y1,
	input [2:0] i_col,
	
	input i_setup,
	input i_step,
	
	// VGA
	output logic o_plot,
	output logic [8:0] o_x,
	output logic [7:0] o_y,
	output logic [2:0] o_col,
	
	output o_done
);

logic [8:0] x, x0, x1, dx;
logic [8:0] y, y0, y1, dy;

logic steep;
logic [8:0] error;
logic [1:0] y_step;

wire [8:0] abs_dx = x1 > x0 ? x1 - x0 : x0 - x1;
wire [8:0] abs_dy = y1 > y0 ? y1 - y0 : y0 - y1;

assign steep = abs_dy > abs_dx;
assign dx = x1 - x0;
assign dy = abs_dy;
assign y_step = y1 > y0 ? 2'b1 : -2'b1;

assign o_col = i_col;

always_ff @(posedge clk or posedge reset) begin
	if (reset) begin
		x <= 9'b0;
		x0 <= 9'b0;
		x1 <= 9'b0;
		o_x <= 9'b0;
		
		y <= 9'b0;
		y0 <= 9'b0;
		y1 <= 9'b0;
		o_y <= 8'b0;
		
		o_col <= 3'b0;
		
		error <= 9'b0;
	end else begin
		if (i_setup) begin
			if (steep) begin
				if (i_y0 > i_y1) begin
					x0 <= i_y1;
					y1 <= i_x0;
					y0 <= i_x1;
					x1 <= i_y0;
					
					x <= i_y1;
					y <= i_x1;
					error <= -((i_y0 - i_y1) >> 1);
				end else begin
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
					x0 <= i_x1;
					x1 <= i_x0;
					y0 <= i_y1;
					y1 <= i_y0;
					
					x <= i_x1;
					y <= i_y1;
					error <= -((i_x0 - i_x1) >> 1);
				end else begin
					x0 <= i_x0;
					x1 <= i_x1;
					y0 <= i_y0;
					y1 <= i_y1;
					
					x <= i_x0;
					y <= i_y0;
					error <= -((i_x1 - i_x0) >> 1);
				end
			end
		end
	end
end

always_comb begin
	o_plot = 1'b0;
	o_done = 1'b0;
	if (i_step) begin
		if (x > x1) begin
			o_done = 1'b1;
		end else begin
			if (steep) begin
				o_x = y;
				o_y = x[7:0];
			end else begin
				o_x = x;
				o_y = y[7:0];
			end
			o_plot = 1'b1;
			error = error + dy;
			if (error > 0) begin
				y = y + y_step;
				error = error - dx;
			end
			x = x + 1'b1;
		end
	end
end

endmodule
