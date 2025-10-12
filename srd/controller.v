`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: controller
// Description: This module is the central control unit for the CPU. It contains
//              the main decoders and the final branch decision logic. It takes
//              fields from the instruction and status flags from the datapath
//              to generate all control signals for the datapath.
//////////////////////////////////////////////////////////////////////////////////
module controller (
    // INPUTS
    input  [6:0] op,        // Instruction opcode field [6:0]
    input  [2:0] funct3,    // Instruction funct3 field [14:12]
    input        funct7b5,  // Instruction funct7 bit 5 [30]
    input        Zero,      // ALU flag for equality (a == b)
    input        LessThanS, // ALU flag for signed less than (a < b)
    input        LessThanU, // ALU flag for unsigned less than (a < b)

    // OUTPUTS - Control signals for the datapath
    output [1:0] ResultSrc,
    output       MemWrite,
    output       PCSrc,
    output       ALUSrc,
    output       RegWrite,
    output       Jump,
    output       SrcASelect,
    output [3:0] ALUControl,
    output [2:0] LoadType,
    output       is_jalr     // Signal to identify JALR instruction
);

    // Internal wires connecting the decoders
    wire [1:0] ALUOp;
    wire       Branch;
    wire [2:0] BranchType;
    reg        TakeBranch;

    // The main_decoder identifies the instruction type from the opcode.
    main_decoder md (
        .op(op), .funct3(funct3), .ResultSrc(ResultSrc), .MemWrite(MemWrite),
        .Branch(Branch), .ALUSrc(ALUSrc), .RegWrite(RegWrite), .Jump(Jump),
        .SrcASelect(SrcASelect), .ALUOp(ALUOp), .BranchType(BranchType), .LoadType(LoadType), .is_jalr(is_jalr)
    );

    // The alu_decoder generates the specific ALU operation code.
    alu_decoder ad (
        .opb5(op[5]), .funct3(funct3), .funct7b5(funct7b5),
        .ALUOp(ALUOp), .ALUControl(ALUControl)
    );

    // This block is the Branch Decision Unit.
    // It determines if a conditional branch should be taken based on the specific branch type and the flags from the ALU.
    always @(*) begin
        case (BranchType)
            3'b000: TakeBranch = Zero;      // beq: Branch if Zero is true
            3'b001: TakeBranch = !Zero;     // bne: Branch if Zero is false
            3'b100: TakeBranch = LessThanS; // blt: Branch if LessThan (signed) is true
            3'b101: TakeBranch = !LessThanS;// bge: Branch if LessThan (signed) is false
            3'b110: TakeBranch = LessThanU; // bltu: Branch if LessThan (unsigned) is true
            3'b111: TakeBranch = !LessThanU;// bgeu: Branch if LessThan (unsigned) is false
            default: TakeBranch = 1'b0;
        endcase
    end

    // The final PCSrc decision. The PC should change from PC+4 if an unconditional jump occurs, OR if it's a branch and its condition is met.
    assign PCSrc = (Branch & TakeBranch) | Jump;

endmodule

