module control
(
	input clk,
	input reset,
	
	// Button input
	input i_enter,
	
	// Datapath
	output logic o_inc_actual,
	input i_over,
	input i_under,
	input i_equal,
	
	// LED Control: Setting this to 1 will copy the current
	// values of over/under/equal to the 3 LEDs. Setting this to 0
	// will cause the LEDs to hold their current values.
	output logic o_update_leds,
	
	output logic [3:0] o_num_guesses
);

// Declare two objects, 'state' and 'nextstate'
// that are of enum type.
enum int unsigned
{
	S_REST,
	S_KEY_DOWN,
	S_GUESS,
	S_END
} state, nextstate;

logic started;

// Clocked always block for making state registers
always_ff @ (posedge clk or posedge reset) begin
	if (reset) begin
		state <= S_REST;
		started <= 1'b0;
		o_num_guesses <= 4'd7;
	end
	else begin
		state <= nextstate;
		if (state == S_KEY_DOWN) started = 1'b1;
		if (state == S_GUESS && o_num_guesses > 4'b0) o_num_guesses = o_num_guesses - 1;
	end
end

// always_comb replaces always @* and gives compile-time errors instead of warnings
// if you accidentally infer a latch
always_comb begin
	// Set default values for signals here, to avoid having to explicitly
	// set a value for every possible control path through this always block
	nextstate = state;
	o_inc_actual = 1'b0;
	o_update_leds = 1'b0;
	
	case (state)
		S_REST: begin
			if (~started) o_inc_actual = 1'b1;
			if (i_enter) nextstate = S_KEY_DOWN;
		end
		
		S_KEY_DOWN: begin
			if (~i_enter) nextstate = S_GUESS;
		end
		
		S_GUESS: begin
			o_update_leds = 1'b1;
			if (o_num_guesses == 4'b0) nextstate = S_END;
			else nextstate = S_REST;
		end
	endcase
end

endmodule
