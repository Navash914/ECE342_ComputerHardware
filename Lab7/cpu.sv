module cpu
(
	input clk,
	input reset,
	
	output [15:0] o_pc_addr,
	output o_pc_rd,
	input [15:0] i_pc_rddata,
	
	output [15:0] o_ldst_addr,
	output o_ldst_rd,
	output o_ldst_wr,
	input [15:0] i_ldst_rddata,
	output [15:0] o_ldst_wrdata,
	
	output [7:0][15:0] o_tb_regs
);

// Memory
logic mem_valid, mem_rd, mem_wr;

assign o_ldst_rd = mem_rd & mem_valid;
assign o_ldst_wr = mem_wr & mem_valid;

// Fetch
logic rfr_pc_ld, rfr_ir_ld;
logic pc_ld, pc_addr_sel;

// RFR
logic [15:0] ir_rfr;
logic ex_pc_ld, ex_ir_ld;
logic rfr_rx, rfr_ry;

// Execute
logic [15:0] ir_ex, ir_rfw;
logic N, Z;
logic rfw_pc_ld, rfw_ir_ld;

logic alu_imm; 
logic ld_flags;
logic alu_addsub;
logic ld_S;

logic rfw_rx;
logic rfw_ry;

// RFW
logic rf_wr, ld_r7;
logic [2:0] rfw_sel;

cpu_control cpu_control0
(
	.clk(clk),
	.reset(reset),


	.o_rfr_pc_ld(rfr_pc_ld),
	.o_rfr_ir_ld(rfr_ir_ld),
	.o_pc_ld(pc_ld),
	.o_pc_rd(o_pc_rd),
	.o_pc_addr_sel(pc_addr_sel),

	.i_ir_rfr(ir_rfr),
	.o_ex_pc_ld(ex_pc_ld),
	.o_ex_ir_ld(ex_ir_ld),
	.o_rfr_rx(rfr_rx),
	.o_rfr_ry(rfr_ry),

	.i_ir_ex(ir_ex),
	.i_ir_rfw(ir_rfw),
	.i_N(N),
	.i_Z(Z),
	.o_rfw_pc_ld(rfw_pc_ld),
	.o_rfw_ir_ld(rfw_ir_ld),

	.o_alu_imm(alu_imm), 
	.o_ld_flags(ld_flags),
	.o_alu_addsub(alu_addsub),
	.o_S_ld(ld_S),

	.o_rfw_rx(rfw_rx),
	.o_rfw_ry(rfw_ry),

	.o_mem_rd(mem_rd),
	.o_mem_wr(mem_wr),

	.o_rf_wr(rf_wr),
	.o_ld_r7(ld_r7),
	.o_rfw_sel(rfw_sel)
);

cpu_datapath cpu_datapath0
(
	.clk(clk),
	.reset(reset),

	.i_pc_rddata(i_pc_rddata),
	.o_pc_addr(o_pc_addr),

	.i_mem_rddata(i_ldst_rddata),
	.o_mem_wrdata(o_ldst_wrdata),
	.o_mem_addr(o_ldst_addr),
	.o_mem_valid(mem_valid),

	.i_pc_ld(pc_ld),
	.i_rfr_pc_ld(rfr_pc_ld),
	.i_rfr_ir_ld(rfr_ir_ld),
	.i_sel_pc(pc_addr_sel),

	.o_rfr_ir(ir_rfr),
	.i_ex_pc_ld(ex_pc_ld),
	.i_ex_ir_ld(ex_ir_ld),
	.i_rfr_rx(rfr_rx),
	.i_rfr_ry(rfr_ry),

	.o_ex_ir(ir_ex),
	.o_rfw_ir(ir_rfw),
	.o_N(N),
	.o_Z(Z),
	.i_rfw_pc_ld(rfw_pc_ld),
	.i_rfw_ir_ld(rfw_ir_ld),
	
	.i_alu_imm(alu_imm), 
	.i_flag_ld(ld_flags),
	.i_alu_addsub(alu_addsub),
	.i_S_ld(ld_S),

	.i_rfw_rx(rfw_rx),
	.i_rfw_ry(rfw_ry),

	.i_rf_wr(rf_wr),
	.i_ld_r7(ld_r7),
	.i_rfw_sel(rfw_sel),

	.o_tb_regs(o_tb_regs)
);

endmodule

