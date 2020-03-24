module cpu_rf_read(

input [15:0] instr,

output logic ex_pc_ld,
output logic ex_ir_ld,
output logic rfr_rx,
output logic rfr_ry

);

// TODO: Edit for jump ops

always_comb begin
    ex_pc_ld = 1'b1;
    ex_ir_ld = 1'b1;
    rfr_rx = 1'b1;
    rfr_ry = 1'b1;
end

endmodule