`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: riscv_cpu
// Description: This module represents the top-level CPU core. It integrates the
//              'controller' (control path) and 'datapath' (data path) modules
//              and defines the core's interface to external instruction and
//              data memories.
//////////////////////////////////////////////////////////////////////////////////
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
    wire [2:0]  BranchType;
    wire        is_jalr;

  
    // The controller decodes the instruction and generates all control signals.
    controller c (
        .op(Instr[6:0]), .funct3(Instr[14:12]), .funct7b5(Instr[30]),
        .Zero(Zero), .LessThanS(LessThanS), .LessThanU(LessThanU),
        .ResultSrc(ResultSrc), .MemWrite(MemWrite), .PCSrc(PCSrc), .ALUSrc(ALUSrc),
        .RegWrite(RegWrite), .Jump(Jump), .SrcASelect(SrcASelect), .ALUControl(ALUControl),
        .LoadType(LoadType), .BranchType(BranchType), .is_jalr(is_jalr)
    );

    // The datapath contains the functional units (PC, RegFile, ALU) and executes the instruction based on the control signals from the controller.
    datapath dp (
        .clk(clk), .reset(reset), .ResultSrc(ResultSrc), .PCSrc(PCSrc),
        .ALUSrc(ALUSrc), .RegWrite(RegWrite), .SrcASelect(SrcASelect),
        .ALUControl(ALUControl), .LoadType(LoadType), .is_jalr(is_jalr),
        .Zero(Zero), .LessThanS(LessThanS), .LessThanU(LessThanU),
        .PC(PC), .Instr(Instr), .Mem_WrAddr(Mem_WrAddr), .Mem_WrData(Mem_WrData),
        .ReadData(ReadData), .Result(Result)
    );

endmodule

