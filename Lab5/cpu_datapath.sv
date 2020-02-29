module cpu_datapath(
    input clk,
    input reset,

    // Interface with top level
    input [15:0] i_mem_rddata,
    output logic [15:0] o_mem_addr,
    output logic [15:0] o_mem_wrdata,

    // Interface with control
    input [2:0] sel,
    input sub,
    input pc_incr,
    input [13:0] r_enable,
    output logic [15:0] instruction,
    output N,
    output Z,
    output done
);

// Databus
logic [15:0] bus;

// Instantiate general purpose registers
logic [7:0] [15:0] R;

genvar i;
generate
    for (i=0; i<8; i++) begin : reg_inst
        reg_n #(16) (clk, r_enable[i], bus, R[i]);
    end 
endgenerate

// Instantiate Program Counter
logic [15:0] PC;
program_counter pc (#16) (clk, reset, pc_incr, r_enable[13], bus, PC);

// Other data registers
logic [15:0] A, S;
logic sum;

reg_n #(16) (clk, r_enable[8], bus, A);
reg_n #(16) (clk, r_enable[9], sum, S);
reg_n #(16) (clk, r_enable[10], bus, instruction);
reg_n #(16) (clk, r_enable[11], bus, o_mem_addr);
reg_n #(16) (clk, r_enable[12], bus, o_mem_wrdata);

// Arithmetic logic
always_comb begin
    if (!sub)
        sum = A + bus;
    else
        sum = A - bus;
end

// N and Z logic
assign N = S[15];
assign Z = S == 16'b0;

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
assign imm8 = { {8,{imm_signbit}} , instruction[15:8]};
assign imm8 = { {5,{imm_signbit}} , instruction[15:5]};

// Big mux for bus value selector
always_comb begin
    case(sel)
        3'd0: bus = reg_x;
        3'd1: bus = reg_y;
        3'd2: bus = PC;
        3'd3: bus = S;
        3'd4: bus = imm8;
        3'd5: bus = imm11 << 1;
        default: bus = i_mem_rddata;
    endcase
end

endmodule