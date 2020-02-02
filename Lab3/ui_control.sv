module UI_control (
	input clk,
	input reset,
	
	// Button Inputs
	input i_setX,
	input i_setY,
	input i_setCol,
	input i_go,
	
	// Datapath
	output logic o_setX,
	output logic o_setY,
	output logic o_setCol,
	
	// LDA
	input i_done,
	output logic o_start
);

// States
enum int unsigned
{
	S_REST,
	S_GO_WAIT,
	S_GO,
	S_WAIT_DONE
} state, nextstate;

always_ff @(posedge clk or posedge reset) begin
	if (reset) begin
		state <= S_REST;
	end else begin
		state <= nextstate;
	end
end

always_comb begin
	// Default values
	nextstate = state;
	o_start = 1'b0;
	o_setX = 1'b0;
	o_setY = 1'b0;
	o_setCol = 1'b0;
	
	case (state)
		S_REST: begin
			// Set x, y and color values in this state
			if (i_go) nextstate = S_GO_WAIT;
			o_setX = i_setX;
			o_setY = i_setY;
			o_setCol = i_setCol;
		end
		
		S_GO_WAIT: begin
			// Wait for user to release button
			if (~i_go) nextstate = S_GO;
		end
		
		S_GO: begin
			o_start = 1'b1;	// Start LDA
			nextstate = S_WAIT_DONE;
		end
		
		S_WAIT_DONE: begin
			// Wait for done signal from LDA
			if (i_done) nextstate = S_REST;
		end
	endcase
end

endmodule
