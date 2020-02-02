module LDA_control (
	input clk,
	input reset,

	input i_start,
	
	// Datapath
	input i_done,
	output logic o_setup,
	output logic o_step
);

// States
enum int unsigned
{
	S_REST,
	S_SETUP,
	S_SETUP_WAIT,
	S_STEP
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
	o_setup = 1'b0;
	o_step = 1'b0;
	
	case (state)
		S_REST: begin
			// Wait for start signal
			if (i_start) nextstate = S_SETUP;
		end
		
		S_SETUP: begin
			// Let datapath setup values
			o_setup = 1'b1;
			nextstate = S_SETUP_WAIT;
		end
		
		S_SETUP_WAIT: begin
			// Wait an additional clock cycle for setup to finish
			o_setup = 1'b1;
			nextstate = S_STEP;
		end
		
		S_STEP: begin
			// Let datapath loop until done signal is received
			if (i_done) nextstate = S_REST;
			else o_step = 1'b1;
		end
	endcase
end

endmodule
