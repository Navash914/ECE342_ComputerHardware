module cpu_control (
    input clk,
    input reset,

    // Fetch
    output logic o_rfr_pc_ld,
    output logic o_rfr_ir_ld,
    output logic o_pc_ld,
    output logic o_pc_rd,
    output logic o_pc_addr_sel,

    // RFR
    input [15:0] i_ir_rfr,
    output logic o_ex_pc_ld,
    output logic o_ex_ir_ld,
    output logic o_rfr_rx,
    output logic o_rfr_ry,

    // Execute
    input [15:0] i_ir_ex,
    input [15:0] i_ir_rfw,
    input i_N,
    input i_Z,
    output logic o_rfw_pc_ld,
    output logic o_rfw_ir_ld,

    output logic o_alu_imm, 
    output logic o_ld_flags,
    output logic o_alu_addsub,
    output logic o_S_ld,

    output logic o_rfw_rx,
    output logic o_rfw_ry,

    output o_mem_rd,
    output o_mem_wr,

    // RFW
    output logic o_rf_wr,
    output logic o_ld_r7,
    output logic [2:0] o_rfw_sel
);

cpu_fetch cpu_fetch0
(
	.pc_ld(o_pc_ld),
	.rfr_pc_ld(o_rfr_pc_ld),
	.rfr_ir_ld(o_rfr_ir_ld),
	.pc_rd(o_pc_rd)
);

cpu_rf_read cpu_rfr0
(
	.instr(i_ir_rfr),
	.ex_pc_ld(o_ex_pc_ld),
	.ex_ir_ld(o_ex_ir_ld),
	.rfr_rx(o_rfr_rx),
	.rfr_ry(o_rfr_ry)
);

cpu_execute cpu_ex0
(
	.instr(i_ir_ex),
    .i_N(i_N),
    .i_Z(i_Z),
	
	.rfw_pc_ld(o_rfw_pc_ld),
	.rfw_ir_ld(o_rfw_ir_ld),
    .pc_addr_sel(o_pc_addr_sel),
	
	.alu_imm(o_alu_imm),
	.ld_flags(o_ld_flags),
	.alu_addsub(o_alu_addsub),
	.ld_S(o_S_ld),
	
	.rfw_rx(o_rfw_rx),
	.rfw_ry(o_rfw_ry),

	.mem_rd(o_mem_rd),
	.mem_wr(o_mem_wr)
);


cpu_rf_write cpu_rfw0
(
	.instr(i_ir_rfw),

	.rf_wr(o_rf_wr),
    .ld_r7(o_ld_r7),
	.rfw_sel(o_rfw_sel)
);

endmodule