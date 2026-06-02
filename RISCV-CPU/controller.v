`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: controller
// Description: This module is the central control unit for the CPU. It contains
//              the main decoders and the final branch decision logic. It takes
//              fields from the instruction and status flags from the datapath
//              to generate all control signals for the datapath.
//////////////////////////////////////////////////////////////////////////////////
module controller (
 
    input  [6:0] op,        
    input  [2:0] funct3,   
    input        funct7b5, 
    input        Zero,     
    input        LessThanS,
    input        LessThanU, 


    output [1:0] ResultSrc,
    output       MemWrite,
    output       PCSrc,
    output       ALUSrc,
    output       RegWrite,
    output       Jump,
    output       SrcASelect,
    output [3:0] ALUControl,
    output [2:0] LoadType,
    output       is_jalr     // to identify JALR instruction
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

    // The final PCSrc decision. The PC should change from PC+4 if an unconditional jump occurs, OR if it's a branch and its condition is met.
    assign PCSrc = (Branch & TakeBranch) | Jump;

endmodule

