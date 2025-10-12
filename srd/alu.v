`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: alu
// Description: Core Arithmetic Logic Unit for the RISC-V CPU.
//              Performs arithmetic, logical, and shift operations.
//              Also generates flags for branch condition evaluation.
//////////////////////////////////////////////////////////////////////////////////
module alu #(parameter WIDTH = 32) (
    // INPUTS
    input               [WIDTH-1:0] a, b,
    input               [3:0] alu_ctrl,

    // OUTPUTS
    output reg          [WIDTH-1:0] alu_out,
    output              Zero,
    output              LessThanS,
    output              LessThanU
);

// Combinational block to compute the ALU result based on the control signal.
always @(*) begin
    case (alu_ctrl)
        4'b0000: alu_out = a & b;                   // AND
        4'b0001: alu_out = a | b;                   // OR
        4'b0010: alu_out = a + b;                   // ADD
        4'b0011: alu_out = a - b;                   // SUBTRACT
        4'b0100: alu_out = a ^ b;                   // XOR
        
        // RISC-V ISA specifies using only the lower 5 bits of the second operand for shift amounts.
        4'b0101: alu_out = a << b[4:0];             // Shift Left Logical (SLL)
        4'b0110: alu_out = a >> b[4:0];             // Shift Right Logical (SRL)
        
        // Arithmetic right shift requires casting 'a' as signed to preserve the sign bit.
        4'b0111: alu_out = $signed(a) >>> b[4:0];   // Shift Right Arithmetic (SRA)

        // Signed comparison requires casting both operands to ensure a two's complement comparison.
        4'b1000: alu_out = ($signed(a) < $signed(b)) ? 1 : 0; // Set Less Than (SLT, Signed)
        
        // Unsigned comparison is the default behavior for vectors in Verilog.
        4'b1001: alu_out = (a < b) ? 1 : 0;                   // Set Less Than (SLTU, Unsigned)

        default: alu_out = 32'hxxxxxxxx;
    endcase
end


// For 'beq' and 'bne' instructions.
assign Zero = (a == b);

// For 'blt' and 'bge' instructions (signed branches).
assign LessThanS = ($signed(a) < $signed(b));

// For 'bltu' and 'bgeu' instructions (unsigned branches).
assign LessThanU = (a < b);

endmodule

