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
    input [11:0] r_enable,
    output logic [15:0] instruction,
    output N,
    output Z,
    output done
);



endmodule