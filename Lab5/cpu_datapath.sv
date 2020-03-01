module cpu_datapath(
    input clk,
    input reset,

    // Interface with top level
    input [15:0] i_mem_rddata,
    output logic [15:0] o_mem_addr,
    output logic [15:0] o_mem_wrdata,

    // Interface with control
    input [2:0] sel,
    input addsub,
    input pc_incr,
    input h,
    input [14:0] r_enable,
    output [15:0] instruction,
    output N,
    output Z
);

// Databus
logic [15:0] bus;

// Instantiate general purpose registers
logic [7:0] [15:0] R;

genvar i;
generate
    for (i=0; i<8; i++) begin : reg_inst
        reg_n_h #(16) (clk, r_enable[i], h, bus, R[i]);
    end 
endgenerate

// Enable bit values for bits above 7 (0-7 are just corresponding registers)
localparam ENABLE_A = 8, ENABLE_S = 9, ENABLE_FLAGS = 10, ENABLE_IR = 11,
            ENABLE_ADDR = 12, ENABLE_WRDATA = 13, ENABLE_PC = 14;

// Instantiate Program Counter
logic [15:0] PC;
program_counter #(16) pc (clk, reset, pc_incr, r_enable[ENABLE_PC], bus, PC);

// Other data registers
logic [15:0] A, S;
logic [15:0] sum;

// N and Z logic
wire z = sum == 16'b0;
wire n = sum[15];

reg_n #(16) (clk, r_enable[ENABLE_A], bus, A);
reg_n #(16) (clk, r_enable[ENABLE_S], sum, S);
reg_n #(1) (clk, r_enable[ENABLE_FLAGS], z, Z);
reg_n #(1) (clk, r_enable[ENABLE_FLAGS], n, N);
reg_n #(16) (clk, r_enable[ENABLE_IR], i_mem_rddata, instruction);
reg_n #(16) (clk, r_enable[ENABLE_ADDR], bus, o_mem_addr);
reg_n #(16) (clk, r_enable[ENABLE_WRDATA], bus, o_mem_wrdata);

// Arithmetic logic
always_comb begin
    if (!addsub)
        sum = A + bus;
    else
        sum = A - bus;
end

// Rx and Ry register selectors
logic [2:0] Rx, Ry;
assign Rx = instruction[7:5];
assign Ry = instruction[10:8];

// Select register value based on Rx and Ry
logic [15:0] reg_x, reg_y;
assign reg_x = R[Rx];
assign reg_y = R[Ry];

// Sign extended immediate values
logic [15:0] imm8, imm11;
wire imm_signbit = instruction[15];
assign imm8 = { {8{imm_signbit}} , instruction[15:8]};
assign imm11 = { {5{imm_signbit}} , instruction[15:5]};

// Big mux for bus value selector

// sel value constants
localparam SEL_RX = 3'd0, SEL_RY = 3'd1, SEL_PC = 3'd2,
            SEL_S = 3'd3, SEL_IMM8 = 3'd4, SEL_IMM11 = 3'd5,
            SEL_RDATA = 3'd6;

always_comb begin
    case(sel)
        SEL_RX: bus = reg_x;
        SEL_RY: bus = reg_y;
        SEL_PC: bus = PC;
        SEL_S: bus = S;
        SEL_IMM8: bus = imm8;
        SEL_IMM11: bus = imm11 << 1;
        SEL_RDATA: bus = i_mem_rddata;
        default: bus = i_mem_rddata;
    endcase
end

endmodule