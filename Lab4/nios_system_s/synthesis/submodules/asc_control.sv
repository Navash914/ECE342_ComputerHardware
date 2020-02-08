module asc_control (
	input clk,
	input reset,
	
	input i_write,
	input [2:0] i_address,
	output logic o_waitrequest,
	
	input i_done,
	output logic o_start,
	output logic o_status,
	
	
	// Datapath
	input i_mode,
	output logic o_ld_mode,
	output logic o_ld_sp,
	output logic o_ld_ep,
	output logic o_ld_col
);

// States
enum int unsigned
{
	S_REST,
	S_RUN,
	S_WAIT
} state, nextstate;

// Address Values
localparam	MODE 					= 3'd0;
localparam	STATUS 				= 3'd1;
localparam	GO 					= 3'd2;
localparam	START_POINT 		= 3'd3;
localparam	END_POINT			= 3'd4;
localparam	COLOR					= 3'd5;

always_ff @(posedge clk or posedge reset) begin
	if (reset) begin
		state <= S_REST;
	end else begin
		state <= nextstate;
	end
end

always_comb begin
	// Default Values
	o_start = 1'b0;
	o_status = 1'b0;
	o_waitrequest = 1'b0;
	o_ld_mode = 1'b0;
	o_ld_sp = 1'b0;
	o_ld_ep = 1'b0;
	o_ld_col = 1'b0;
	nextstate = state;
	
	case (state)
		S_REST: begin
			if (i_write) begin
				case (i_address)
					MODE: o_ld_mode = 1'b1;
					// Writing to status not allowed
					GO: begin
						o_start = 1'b1;
						nextstate = S_RUN;
						o_status = 1'b1;
						if (~i_mode) o_waitrequest = 1'b1;
					end
					START_POINT: o_ld_sp = 1'b1;
					END_POINT: o_ld_ep = 1'b1;
					COLOR: o_ld_col = 1'b1;
					default: ;	// Do nothing
				endcase
			end
		end
		
		S_RUN: begin
			o_status = 1'b1;
			if (~i_mode) o_waitrequest = 1'b1;
			else if (i_write) begin
				// Allow writing start/end points and color
				// even when LDA is still running
				case (i_address)
					START_POINT: o_ld_sp = 1'b1;
					END_POINT: o_ld_ep = 1'b1;
					COLOR: o_ld_col = 1'b1;
					default: ;	// Do nothing
				endcase
			end
			if (i_done) begin
				if (i_mode) nextstate = S_REST;
				else nextstate = S_WAIT;
			end
		end
		
		S_WAIT: nextstate = S_REST;	// Wait a clock cycle in stall mode to let signals go low
	endcase
end

endmodule
