`timescale 1ns/1ps

module alu #(parameter WIDTH = 32) (
    input               [WIDTH-1:0] a, b,      // Operands
    input               [3:0] alu_ctrl,        // 4-bit ALU control signal
    output reg          [WIDTH-1:0] alu_out,   // ALU output
    output              zero                 // Zero flag
);


always @(*) begin
    case (alu_ctrl)
        4'b0000: alu_out = a & b;                   // AND
        4'b0001: alu_out = a | b;                   // OR
        4'b0010: alu_out = a + b;                   // ADD
        4'b0011: alu_out = a - b;                   // SUBTRACT
        4'b0100: alu_out = a ^ b;                   // XOR
        4'b0101: alu_out = a << b[4:0];             // SHIFT LEFT LOGICAL (SLL)
        4'b0110: alu_out = a >> b[4:0];             // SHIFT RIGHT LOGICAL (SRL)
        4'b0111: alu_out = $signed(a) >>> b[4:0];   // SHIFT RIGHT ARITHMETIC (SRA)
        4'b1000: alu_out = ($signed(a) < $signed(b)) ? 1 : 0; // SET LESS THAN (SLT, Signed)
        4'b1001: alu_out = (a < b) ? 1 : 0;                   // SET LESS THAN (SLTU, Unsigned)
        default: alu_out = 32'hxxxxxxxx;           // Default to unknown for safety
    endcase
end

// The zero flag is asserted if the ALU's output is exactly zero.
assign zero = (alu_out == 0);

endmodule



