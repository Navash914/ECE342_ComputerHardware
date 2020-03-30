module cpu_fetch
(
output logic pc_ld,
output logic rfr_pc_ld,
output logic rfr_ir_ld,
output logic pc_rd
);

// TODO: edit for jump ops
always_comb begin
	pc_ld = 1'b1;
	rfr_pc_ld = 1'b1;
	rfr_ir_ld = 1'b1;
	pc_rd = 1'b1;
end

endmodule