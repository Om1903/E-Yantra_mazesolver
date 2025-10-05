`timescale 1ns/1ps

module main_decoder (
    input  [6:0] op,
    output [1:0] ResultSrc,
    output       MemWrite,
    output       Branch,
    output       ALUSrc,
    output       RegWrite,
    output       Jump,
    output       SrcASelect,
    output [1:0] ALUOp
);

    reg [11:0] controls;

    // Control bits: {RegWrite, SrcASelect, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump}
    always @(*) begin
        case (op)
            7'b0110011: controls = 12'b1_0_0_0_00_0_10_0; // R-Type
            7'b0010011: controls = 12'b1_0_1_0_00_0_10_0; // I-Type ALU
            7'b0000011: controls = 12'b1_0_1_0_01_0_00_0; // lw
            7'b0100011: controls = 12'b0_0_1_1_00_0_00_0; // sw
            7'b1100011: controls = 12'b0_0_0_0_00_1_01_0; // beq
            7'b1101111: controls = 12'b1_0_0_0_10_0_00_1; // jal
            7'b1100111: controls = 12'b1_0_1_0_10_0_00_1; // jalr
            7'b0110111: controls = 12'b1_0_1_0_00_0_10_0; // LUI
            7'b0010111: controls = 12'b1_1_1_0_00_0_10_0; // AUIPC
            default:    controls = 12'hxxx;
        endcase
    end

    assign {RegWrite, SrcASelect, ALUSrc, MemWrite, ResultSrc, Branch, ALUOp, Jump} = controls;

endmodule

