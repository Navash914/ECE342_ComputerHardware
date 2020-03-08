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
    output logic [2:0] sel,
    output logic addsub,
    output logic pc_incr,
    output logic h,
    output logic [14:0] r_enable
);

// States
enum int unsigned
{
	FETCH,
	READ,
	STORE,
	STEP_1,
    STEP_2,
    STEP_3
} state, nextstate;

always_ff @(posedge clk or posedge reset) begin
	if (reset) begin
		state <= FETCH;
	end else begin
		state <= nextstate;
	end
end

wire [3:0] op = instruction[3:0];   // What operation to perform
wire imm = instruction[4];          // Whether the op uses immediate value
wire [2:0] rx = instruction[7:5];   // Rx selected by instruction
wire [2:0] ry = instruction[10:8];  // Ry selected by instruction

// Enable bit values for bits above 7 (0-7 are just corresponding registers)
localparam ENABLE_A = 8, ENABLE_S = 9, ENABLE_FLAGS = 10, ENABLE_IR = 11,
            ENABLE_ADDR = 12, ENABLE_WRDATA = 13, ENABLE_PC = 14;

// sel value constants
localparam SEL_RX = 3'd0, SEL_RY = 3'd1, SEL_PC = 3'd2,
            SEL_S = 3'd3, SEL_IMM8 = 3'd4, SEL_IMM11 = 3'd5,
            SEL_RDATA = 3'd6;

// Instruction OP codes:
localparam mv = 4'b0000, add = 4'b0001, sub = 4'b0010, cmp = 4'b0011, ld = 4'b0100, st = 4'b0101,
            mvhi = 4'b0110, j = 4'b1000, jz = 4'b1001, jn = 4'b1010, call = 4'b1100;

always_comb begin
    // Default values
    // By default move to the next step in execution
    nextstate = state.next();
    sel = 3'd0;
    addsub = 1'b0;
    pc_incr = 1'b0;
    h = 1'b0;
    r_enable = 14'd0;
    o_mem_rd = 1'd0;
    o_mem_wr = 1'd0;

    case (state)
        // Initial instruction get and store
        FETCH: begin
            // Put PC value in address
            sel = SEL_PC;
            r_enable[ENABLE_ADDR] = 1'd1;
            pc_incr = 1'b1; // Increment pc to next instruction
        end
        READ: begin
            // Request read and wait for data on next cycle
            o_mem_rd = 1'b1;
        end
        STORE: begin
            // Store instruction on register
            r_enable[ENABLE_IR] = 1'd1;
        end

        // Instruction execution steps
        STEP_1: begin
            case(op)
                mv: begin
                    sel = imm ? SEL_IMM8 : SEL_RY;
                    r_enable[rx] = 1'b1;
                    nextstate = FETCH;
                end
                mvhi: begin
                    if (imm) begin
                        sel = SEL_IMM8;
                        r_enable[rx] = 1'b1;
                        h = 1'b1;
                        nextstate = FETCH;
                    end
                end
                add, sub, cmp: begin
                    sel = SEL_RX;
                    r_enable[ENABLE_A] = 1'b1;
                end
                ld, st: begin
                    sel = SEL_RY;
                    r_enable[ENABLE_ADDR] = 1'b1;
                end
                j, jz, jn: begin
                    if ((op == jz && Z == 0) || (op == jn && N == 0)) nextstate = FETCH;
                    else if (imm) begin
                        sel = SEL_PC;
                        r_enable[ENABLE_A] = 1'b1;
                    end else begin
                        sel = SEL_RX;
                        r_enable[ENABLE_PC] = 1'b1;
                        nextstate = FETCH;
                    end
                end
                call: begin
                    sel = SEL_PC;
                    r_enable[7] = 1'b1;
                    if (imm) r_enable[ENABLE_A] = 1'b1;
                end
                default: nextstate = FETCH; // Invalid op code. Do no-op.
            endcase
        end
            
        STEP_2: begin
            case (op)
                add, sub, cmp: begin
                    sel = imm ? SEL_IMM8 : SEL_RY;
                    addsub = (op == sub) || (op == cmp);
                    r_enable[ENABLE_S] = 1'b1;
                    r_enable[ENABLE_FLAGS] = 1'b1;
                    if (op == cmp) nextstate = FETCH;
                end
                ld: o_mem_rd = 1'b1;
                st: begin
                    sel = SEL_RX;
                    r_enable[ENABLE_WRDATA] = 1'b1;
                end
                j, jz, jn: begin
                    // At this step only if imm is 1 and Z/N flag checks passed
                    sel = SEL_IMM11;
                    r_enable[ENABLE_S] = 1'b1;
                end 
                call: begin
                    if (imm) begin
                        sel = SEL_IMM11;
                        r_enable[ENABLE_S] = 1'b1;
                    end else begin
                        sel = SEL_RX;
                        r_enable[ENABLE_PC] = 1'b1;
                        nextstate = FETCH;
                    end
                end
                default: nextstate = FETCH; // Should not happen
            endcase
        end

        STEP_3: begin
            nextstate = FETCH;  // All operations end at most here
            case (op)
                add, sub: begin
                    sel = SEL_S;
                    r_enable[rx] = 1'b1;
                end
                ld: begin
                    sel = SEL_RDATA;
                    r_enable[rx] = 1'b1;
                end
                st: o_mem_wr = 1'b1;
                j, jz, jn, call: begin
                    sel = SEL_S;
                    r_enable[ENABLE_PC] = 1'b1;
                end
                default: nextstate = FETCH; // Should not happen
            endcase
        end

        default: nextstate = FETCH; // Should not happen
    endcase
end

endmodule