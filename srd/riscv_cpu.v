`timescale 1ns/1ps
module riscv_cpu (
    input        clk, reset,
    output [31:0] PC,
    input  [31:0] Instr,
    output        MemWrite,
    output [31:0] Mem_WrAddr,
    output [31:0] Mem_WrData,
    input  [31:0] ReadData,
    output [31:0] Result
);

    wire [1:0]  ResultSrc;
    wire        PCSrc, ALUSrc, RegWrite, Jump, SrcASelect;
    wire        Zero, LessThanS, LessThanU;
    wire [3:0]  ALUControl;
    wire [2:0]  LoadType; 
    wire        is_jalr ;

    controller c (
        .op(Instr[6:0]), .funct3(Instr[14:12]), .funct7b5(Instr[30]),
        .Zero(Zero), .LessThanS(LessThanS), .LessThanU(LessThanU),
        .ResultSrc(ResultSrc), .MemWrite(MemWrite), .PCSrc(PCSrc), .ALUSrc(ALUSrc),
        .RegWrite(RegWrite), .Jump(Jump), .SrcASelect(SrcASelect), .ALUControl(ALUControl),
        .LoadType(LoadType) , .is_jalr(is_jalr)
    );

    datapath dp (
        .clk(clk), .reset(reset), .ResultSrc(ResultSrc), .PCSrc(PCSrc),
        .ALUSrc(ALUSrc), .RegWrite(RegWrite), .SrcASelect(SrcASelect),
        .ALUControl(ALUControl), .LoadType(LoadType), .is_jalr(is_jalr),
        .Zero(Zero), .LessThanS(LessThanS), .LessThanU(LessThanU),
        .PC(PC), .Instr(Instr), .Mem_WrAddr(Mem_WrAddr), .Mem_WrData(Mem_WrData),
        .ReadData(ReadData), .Result(Result)
    );

endmodule

