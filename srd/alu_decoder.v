`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: alu_decoder
// Description: This module decodes the high-level ALUOp and instruction-specific
//              fields (funct3, etc.) into a 4-bit control signal that commands
//              the ALU to perform a specific operation.
//////////////////////////////////////////////////////////////////////////////////
module alu_decoder (
    input        opb5,
    input [2:0]  funct3,
    input        funct7b5,
    input [1:0]  ALUOp,
    output reg [3:0] ALUControl
);

// Combinational block to generate the final ALUControl signal.
always @(*) begin
    // The primary decoding is based on the high-level ALUOp from the main decoder.
    case (ALUOp)
        // For memory access (lw, sw), the ALU must perform an addition for address calculation.
        2'b00: ALUControl = 4'b0010; // ADD

        // For branch instructions (beq, bne, etc.), the ALU performs a subtraction for comparison.
        2'b01: ALUControl = 4'b0011; // SUB

        // For R-type and I-type ALU instructions, further decoding of funct3 is required.
        2'b10: begin
            case (funct3)
                // Differentiated by funct7b5 and opb5 to handle ADD/ADDI vs SUB.
                3'b000: if (funct7b5 & opb5) ALUControl = 4'b0011; else ALUControl = 4'b0010;
                3'b001: ALUControl = 4'b0101; // SLL
                3'b010: ALUControl = 4'b1000; // SLT
                3'b011: ALUControl = 4'b1001; // SLTU
                3'b100: ALUControl = 4'b0100; // XOR
                // Differentiated by funct7b5 to handle Arithmetic vs Logical shift.
                3'b101: if (funct7b5) ALUControl = 4'b0111; else ALUControl = 4'b0110; // SRA/SRL
                3'b110: ALUControl = 4'b0001; // OR
                3'b111: ALUControl = 4'b0000; // AND
                default: ALUControl = 4'bxxxx;
            endcase
        end
        default: ALUControl = 4'bxxxx;
    endcase
end

endmodule

