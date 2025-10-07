`timescale 1ns/1ps
module controller (
    input  [6:0] op,
    input  [2:0] funct3,
    input        funct7b5,
    input        Zero, LessThanS, LessThanU,
    output [1:0] ResultSrc,
    output       MemWrite,
    output       PCSrc,
    output       ALUSrc,
    output       RegWrite,
    output       Jump,
    output       SrcASelect,
    output [3:0] ALUControl,
    output [2:0] LoadType ,
    output        is_jalr
);

    wire [1:0] ALUOp;
    wire       Branch;
    wire [2:0] BranchType;
    reg        TakeBranch;

    main_decoder md (
        .op(op), .funct3(funct3), .ResultSrc(ResultSrc), .MemWrite(MemWrite),
        .Branch(Branch), .ALUSrc(ALUSrc), .RegWrite(RegWrite), .Jump(Jump),
        .SrcASelect(SrcASelect), .ALUOp(ALUOp), .BranchType(BranchType), .LoadType(LoadType), .is_jalr(is_jalr)
    );

    alu_decoder ad (
        .opb5(op[5]), .funct3(funct3), .funct7b5(funct7b5),
        .ALUOp(ALUOp), .ALUControl(ALUControl)
    );

    always @(*) begin
        case (BranchType)
            3'b000: TakeBranch = Zero;      // beq
            3'b001: TakeBranch = !Zero;     // bne
            3'b100: TakeBranch = LessThanS; // blt
            3'b101: TakeBranch = !LessThanS;// bge
            3'b110: TakeBranch = LessThanU; // bltu
            3'b111: TakeBranch = !LessThanU;// bgeu
            default: TakeBranch = 1'b0;
        endcase
    end

    assign PCSrc = (Branch & TakeBranch) | Jump;

endmodule

