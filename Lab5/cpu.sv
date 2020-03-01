module cpu(
    input clk,
    input reset,

    output [15:0] o_mem_addr,
    output o_mem_rd,
    input [15:0] i_mem_rddata,
    output o_mem_wr,
    output [15:0] o_mem_wrdata
);

// Signals to interface control and datapath
logic [15:0] instruction;
logic [14:0] r_enable;
logic [2:0] sel;
logic N, Z;
logic pc_incr, addsub, h;

cpu_control control(.*);
cpu_datapath datapath(.*);

endmodule