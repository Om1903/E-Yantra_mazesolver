`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: main_decoder
// Description: This module is the primary control unit for the CPU. It decodes
//              the instruction's opcode to determine the instruction type (R, I, S,
//              B, U, J) and generates all necessary control signals for the datapath.
//////////////////////////////////////////////////////////////////////////////////
module main_decoder (
    // INPUTS
    input  [6:0] op,
    input  [2:0] funct3,

    // OUTPUTS 
    output [1:0] ResultSrc,
    output       MemWrite,
    output       Branch,
    output       ALUSrc,
    output       RegWrite,
    output       Jump,
    output       is_jalr,
    output       SrcASelect,
    output [1:0] ALUOp,
    output [2:0] BranchType,
    output [2:0] LoadType
);

    reg [16:0] controls;
    always @(*) begin
        case (op)
            7'b0110011: controls = 17'b1_0_0_0_00_0_10_0_xxx_xxx_0; // R-Type
            7'b0010011: controls = 17'b1_0_1_0_00_0_10_0_xxx_xxx_0; // I-Type ALU
            
            // For Loads, the specific type (lw, lh, etc.) is determined by funct3.
            7'b0000011: controls = {1'b1, 1'b0, 1'b1, 1'b0, 2'b01, 1'b0, 2'b00, 1'b0, 3'bxxx, funct3, 1'b0}; // Load
            
            7'b0100011: controls = 17'b0_0_1_1_00_0_00_0_xxx_xxx_0; // S-Type (sw)
            
            // For Branches, the specific type (beq, bne, etc.) is determined by funct3.
            7'b1100011: controls = {1'b0, 1'b0, 1'b0, 1'b0, 2'b00, 1'b1, 2'b01, 1'b0, funct3, 3'bxxx, 1'b0}; // B-Type
            
            7'b1101111: controls = 17'b1_0_0_0_10_0_00_1_xxx_xxx_0; // J-Type (jal)
            
            // For JALR, the 'is_jalr' signal is asserted to enable special datapath logic.
            7'b1100111: controls = 17'b1_0_1_0_10_0_00_1_xxx_xxx_1; // I-Type (jalr)
            
            7'b0110111: controls = 17'b1_0_1_0_00_0_10_0_xxx_xxx_0; // U-Type (LUI)
            7'b0010111: controls = 17'b1_1_1_0_00_0_10_0_xxx_xxx_0; // U-Type (AUIPC)
            
            default:    controls = 17'hxxxxx; 
        endcase
    end

    
    assign {RegWrite, SrcASelect, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump, BranchType, LoadType, is_jalr} = controls;

endmodule

