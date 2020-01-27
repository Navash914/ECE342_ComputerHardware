module carry_lookahead_adder(
  input [7:0] i_a,
  input [7:0] i_b,
  input i_cin,

  output [7:0] o_sum,
  output o_cout
);

  logic [8:0] cin;
  assign cin[0] = i_cin;
  assign o_cout = cin[8];

  logic [7:0] g;
  logic [7:0] p;

  genvar i;
  generate
  
	logic g;
	logic p;

    for (i = 0; i < 8; i++) begin : gp_loop
      assign g = i_a[i] & i_b[i];
      assign p = i_a[i] | i_b[i];
      assign cin[i+1] = g | (p & cin[i]);
		
		assign o_sum[i] = i_a[i] ^ i_b[i] ^ cin[i];
    end

  endgenerate

endmodule
