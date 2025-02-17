module cpu_datapath
(
input clk,
input reset,

// Memory PC Port
input [15:0] i_pc_rddata,
output logic [15:0] o_pc_addr,

// Memory Data Port
input [15:0] i_mem_rddata,
output logic [15:0] o_mem_wrdata,
output logic [15:0] o_mem_addr,
output logic o_mem_valid,

// Fetch Signals
input i_pc_ld,
input i_rfr_pc_ld,
input i_rfr_ir_ld,
input i_sel_pc,

// Read RF Signals
output [15:0] o_rfr_ir,
input i_ex_pc_ld,
input i_ex_ir_ld,
input i_rfr_rx,
input i_rfr_ry,

// Execute Signals
output [15:0] o_ex_ir,
output [15:0] o_rfw_ir,
output logic o_N,
output logic o_Z,
input i_rfw_pc_ld,
input i_rfw_ir_ld,
input i_alu_imm, 
input i_flag_ld,
input i_alu_addsub,
input i_S_ld,

input i_rfw_rx,
input i_rfw_ry,

//rf writeback
input i_rf_wr,
input i_ld_r7,
input [2:0] i_rfw_sel,

//tb regs
output logic [7:0][15:0] o_tb_regs
);

// PC Registers
logic [15:0] pc, pc_in, pc_next, pc_jump, pc_jump_r, pc_rfr, pc_ex, pc_rfw;

// Instruction Registers
logic [15:0] ir_rfr, ir_ex, ir_rfw;

// Valid Register
logic [1:0] valid_reg_ex, valid_reg_rfw;
wire valid_ex = valid_reg_ex == 2'b0;
wire valid_rfw = valid_reg_rfw == 2'b0;

// Register Selectors
logic [15:0] Rx_ex, Ry_ex;
logic [15:0] Rx_rfw, Ry_rfw;
logic [15:0] Rx, Ry;
logic [15:0] Rin;
logic [7:0] R_enable;
logic [2:0] Rx_sel_rfr, Rx_sel_ex, Rx_sel_rfw;
logic [2:0] Ry_sel_rfr, Ry_sel_ex, Ry_sel_rfw;

// General Registers
logic [7:0] [15:0] R;

genvar i;
generate
    for (i=0; i<8; i++) begin : reg_inst
        reg_n #(16) gen_reg_i (clk, valid_rfw & R_enable[i], Rin, R[i]);
    end 
endgenerate

// imm values
logic [15:0] imm8_rfr, imm8_ex, imm8_rfw;
logic [15:0] imm11_rfr, imm11_ex, imm11_rfw;

// ALU
logic [15:0] S, sum;
logic [15:0] alu_a;
logic [15:0] alu_b;
logic [15:0] alu_out;

always_comb begin
    if (!i_alu_addsub)
        sum = alu_a + alu_b;
    else
        sum = alu_a - alu_b;
end

// Z, N flags
wire z = sum == 16'b0;
wire n = sum[15];

reg_n #(1) regZ (clk, valid_ex & i_flag_ld, z, o_Z);
reg_n #(1) regN (clk, valid_ex & i_flag_ld, n, o_N);

// Assign Outputs
assign o_rfr_ir = ir_rfr;
assign o_ex_ir = ir_ex;
assign o_rfw_ir = ir_rfw;
assign o_tb_regs = R;
assign o_mem_valid = valid_ex;

// PC Logic
wire [15:0] rx, ry;
assign pc_next = pc + 2;
assign pc_jump = pc_ex + (imm11_ex << 1);
assign pc_jump_r = rx;
assign o_pc_addr = pc;

always_comb begin
	if (valid_ex & i_sel_pc) pc_in = i_alu_imm ? pc_jump : pc_jump_r;
	else pc_in = pc_next;
end

// ================ RFR Logic ================ //

// IR
assign ir_rfr = i_pc_rddata;

// Reg Select
assign Rx_sel_rfr = ir_rfr[7:5];
assign Ry_sel_rfr = ir_rfr[10:8];
assign Rx_sel_ex = ir_ex[7:5];
assign Ry_sel_ex = ir_ex[10:8];
assign Rx_sel_rfw = ir_rfw[7:5];
assign Ry_sel_rfw = ir_rfw[10:8];

assign Rx = (valid_rfw & Rx_sel_rfr == Rx_sel_rfw) ? Rin : R[Rx_sel_rfr];
assign Ry = (valid_rfw & Ry_sel_rfr == Rx_sel_rfw) ? Rin : R[Ry_sel_rfr];

// imm values
assign imm8_rfr = {{8{ir_rfr[15]}},{ir_rfr[15:8]}};
assign imm11_rfr = {{5{ir_rfr[15]}},{ir_rfr[15:5]}};


// ================ Execute Logic ================ //

// imm values
assign imm8_ex = {{8{ir_ex[15]}},{ir_ex[15:8]}};
assign imm11_ex = {{5{ir_ex[15]}},{ir_ex[15:5]}};

assign rx = (valid_rfw & Rx_sel_ex == Rx_sel_rfw) ? Rin : Rx_ex;
assign ry = (valid_rfw & Ry_sel_ex == Rx_sel_rfw) ? Rin : Ry_ex;

// ALU inputs
assign alu_a = rx;
assign alu_b = i_alu_imm ? imm8_ex : ry;

// st or ld addresses
assign o_mem_wrdata = rx;
assign o_mem_addr = ry;


// ================ RFW Logic ================ //

// imm values
assign imm8_rfw = {{8{ir_rfw[15]}},{ir_rfw[15:8]}};
assign imm11_rfw = {{5{ir_rfw[15]}},{ir_rfw[15:5]}};

always_comb begin
    R_enable = 8'd0;
    R_enable[Rx_sel_rfw] = i_rf_wr;
	if (i_ld_r7) R_enable[7] = 1'b1;
	
	// Rin data multiplexer
	case (i_rfw_sel)
		3'd0: Rin = R[Ry_sel_rfw]; //mv 
		3'd1: Rin = {imm8_rfw[7:0], R[Rx_sel_rfw][7:0]}; //mvhi
		3'd2: Rin = S; // add or sub
		3'd3: Rin = pc_rfw; //call
		3'd4: Rin = i_mem_rddata; //ld
		3'd5: Rin = imm8_rfw; //mvi
		default: Rin = {'0};
    endcase
end


//pipeline registers
always_ff @ (posedge clk, posedge reset) begin
	if (reset) begin
		pc <= 0;
		valid_reg_ex <= 0;
		valid_reg_rfw <= 0;
		pc_rfr <= 0;
		pc_ex <= 0;
		pc_rfw <= 0;
		ir_ex <= 0;
		ir_rfw <= 0;
		Rx_ex <= 0;
		Ry_ex <= 0;
		Rx_rfw <= 0;
		Ry_rfw <= 0;
	end
	else begin
		// Validity
		if (valid_ex & i_sel_pc) begin
			valid_reg_ex <= 2'd2;
		end else begin
			valid_reg_ex <= valid_reg_ex >> 1;
		end
		valid_reg_rfw <= valid_reg_ex;

		// Fetch
		if(i_pc_ld) pc <= pc_in;

		// RFR
		if(i_rfr_pc_ld) pc_rfr <= pc_in;
		if(i_rfr_rx) Rx_ex <= Rx;
		if(i_rfr_ry) Ry_ex <= Ry;

		// Execute
		if(i_ex_pc_ld) pc_ex <= pc_rfr;
		if(i_ex_ir_ld) ir_ex <= ir_rfr;
		if(valid_ex & i_S_ld) S <= sum;

		// RFW
		if(i_rfw_pc_ld) pc_rfw <= pc_ex;
		if(i_rfw_ir_ld) ir_rfw <= ir_ex;
		if(i_rfw_rx) Rx_rfw <= rx;
		if(i_rfw_ry) Ry_rfw <= ry;
	end
end


endmodule

