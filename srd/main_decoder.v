`timescale 1ns/1ps
module main_decoder (
    input  [6:0] op,
    input  [2:0] funct3, 
    output [1:0] ResultSrc,
    output       MemWrite,
    output       Branch,
    output       ALUSrc,
    output       RegWrite,
    output       Jump,
    output       SrcASelect,
    output [1:0] ALUOp,
    output [2:0] BranchType, // distinguishes between beq, bne, etc. based on funct3
    output [2:0] LoadType   //  distinguishes between  lw, lh, lb, etc. based on funct3
);

    reg [17:0] controls;

    // Control bits: {RegWrite, SrcASelect, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump, BranchType, LoadType}
    always @(*) begin
        case (op)
            7'b0110011: controls = 18'b1_0_0_0_00_0_10_0_xxx_xxx; // R-Type
            7'b0010011: controls = 18'b1_0_1_0_00_0_10_0_xxx_xxx; // I-Type ALU
            7'b0000011: controls = {1'b1, 1'b0, 1'b1, 1'b0, 2'b01, 1'b0, 2'b00, 1'b0, 3'bxxx, funct3}; // Load
            7'b0100011: controls = 18'b0_0_1_1_00_0_00_0_xxx_xxx; // sw
            7'b1100011: controls = {1'b0, 1'b0, 1'b0, 1'b0, 2'b00, 1'b1, 2'b01, 1'b0, funct3, 3'bxxx}; // B-Type
            7'b1101111: controls = 18'b1_0_0_0_10_0_00_1_xxx_xxx; // jal
            7'b1100111: controls = 18'b1_0_1_0_10_0_00_1_xxx_xxx; // jalr
            7'b0110111: controls = 18'b1_0_1_0_00_0_10_0_xxx_xxx; // LUI
            7'b0010111: controls = 18'b1_1_1_0_00_0_10_0_xxx_xxx; // AUIPC
            default:    controls = 18'hxxxxx;
        endcase
    end

    assign {RegWrite, SrcASelect, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump, BranchType, LoadType} = controls;

endmodule

