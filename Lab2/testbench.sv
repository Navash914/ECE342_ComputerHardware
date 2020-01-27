`timescale 1ns/1ns

module tb();

	logic [7:0] dut_m, dut_q;
	logic [15:0] dut_p;

	array_multiplier am (
		.i_m(dut_m),
		.i_q(dut_q),
		.o_p(dut_p)
	);
	
	initial begin
		for (integer m = -128; m < 128; m++) begin
			for (integer q = -128; q < 128; q++) begin
				logic [15:0] real_product;
				real_product = m * q;
				
				dut_m = m;
				dut_q = q;
				
				#5;
				
				if (dut_p !== real_product) begin
					$display("Mismatch! %d * %d should be %d, got %d instead.", m, q, real_product, dut_p);
					$stop();
				end
			end
		end
		
		$display("Test passed!");
		$stop();
	end

endmodule
