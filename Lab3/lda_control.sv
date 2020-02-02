module LDA_control (
	input clk,
	input reset,

	input i_start,
	
	// Datapath
	input i_done,
	output logic o_setup,
	output logic o_step
);

enum int unsigned
{
	S_REST,
	S_SETUP,
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
	
	case (state) begin
		S_REST: begin
			if (i_start) nextstate = S_SETUP;
		end
		
		S_SETUP: begin
			o_setup = 1'b1;
			nextstate = S_STEP;
		end
		
		S_STEP: begin
			o_step = 1'b1;
			if (i_done) nextstate = S_REST;
		end
	endcase
end

endmodule
