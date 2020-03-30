module cpu_execute
(
    input [15:0] instr,
	input i_N,
	input i_Z,

    output logic rfw_pc_ld,
    output logic rfw_ir_ld,
	output logic pc_addr_sel,

    output logic alu_imm, 
    output logic ld_flags,
    output logic alu_addsub,
    output logic ld_S,

    output logic rfw_rx,
    output logic rfw_ry,

    output logic mem_rd,
    output logic mem_wr
);

wire [3:0] op = instr[3:0];
wire imm = instr[4];

always_comb begin

	rfw_pc_ld = 1'b1;
	rfw_ir_ld = 1'b1;
	pc_addr_sel = 1'b0;

	// ALU
	alu_addsub = 1'b0;
	alu_imm = 1'b0;
	ld_flags = 1'b0;
	ld_S = 1'b0;
	
	// RFW
	rfw_rx = 1'b1;
	rfw_ry = 1'b1;
	
	// ld or st signals
	mem_rd = 1'b0;
	mem_wr = 1'b0;

	case (op)
		4'd0, 4'd6: ;	// Do stuff in rfw for mv/mvi/mvhi
		4'd1, 4'd2, 4'd3: begin	// add/sub/cmp
			ld_flags = 1'b1;
			ld_S = 1'b1;
			alu_addsub = op != 4'd1;
			alu_imm = imm;
		end
		4'd4, 4'd5: begin // ld/st
			mem_rd = op == 4'd4;
			mem_wr = op == 4'd5;
		end
		4'd8, 4'd9, 4'd10, 4'd12: begin	// branch
			if (op == 4'd8 || (op == 4'd9 && i_Z)
				|| (op == 4'd10 && i_N) || op == 4'd12) 
			begin
				pc_addr_sel = 1'b1;
				alu_imm = imm;
			end
		end
		default: ;
	endcase
end

endmodule