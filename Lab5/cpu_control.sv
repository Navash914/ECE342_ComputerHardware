module cpu_control(
    input clk,
    input reset,

    // Interface with top level
    output logic o_mem_rd,
    output logic o_mem_wr,

    // Interface with datapath
    input [15:0] instruction,
    input N,
    input Z,
    input done,
    output [2:0] sel,
    output sub,
    output pc_incr,
    output logic [11:0] r_enable
);



endmodule