module cpu_rf_write(
input [15:0] instr,

output logic rf_wr,
output logic [2:0] rfw_sel
);

wire [3:0] op = instr[3:0];
wire imm = instr[4];

always_comb begin
    rf_wr = 1'b1;
    rfw_sel = 3'd0;

	case(op)
		4'd0: begin // mv
			rfw_sel = imm ? 3'd5 : 3'd0;
		end
		4'd1, 4'd2: begin // add or sub
			rfw_sel = 3'd2;
		end
		4'd5: begin // ld
			rfw_sel = 3'd4;
		end
		4'd6: begin // mvhi
			rfw_sel = 3'd1;
		end
		// TODO: jump instructions
        default: begin
            rf_wr = 1'b0;
        end
	endcase
end
 
endmodule