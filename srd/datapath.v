`timescale 1ns/1ps

module datapath (
    input        clk, reset,
    input  [1:0] ResultSrc,
    input        PCSrc, ALUSrc, SrcASelect, RegWrite,
    input  [3:0] ALUControl,
    output       Zero,
    output [31:0] PC,
    input  [31:0] Instr,
    output [31:0] Mem_WrAddr, Mem_WrData,
    input  [31:0] ReadData,
    output [31:0] Result
);

    wire [31:0] PCNext, PCPlus4, PCTarget, SrcA, SrcB, WriteData, ALUResult, RD1;
    reg  [31:0] ImmExt;

    always @(*) begin
        case (Instr[6:0])
            7'b0000011, 7'b1100111, 7'b0010011: ImmExt = {{20{Instr[31]}}, Instr[31:20]};
            7'b0100011: ImmExt = {{20{Instr[31]}}, Instr[31:25], Instr[11:7]};
            7'b1100011: ImmExt = {{19{Instr[31]}}, Instr[31], Instr[7], Instr[30:25], Instr[11:8], 1'b0};
            7'b0110111, 7'b0010111: ImmExt = {Instr[31:12], 12'b0};
            7'b1101111: ImmExt = {{11{Instr[31]}}, Instr[31], Instr[19:12], Instr[20], Instr[30:21], 1'b0};
            default: ImmExt = 32'hxxxxxxxx;
        endcase
    end

    reset_ff #(32) pcreg(clk, reset, PCNext, PC);
    adder        pcadd4(PC, 32'd4, PCPlus4);
    adder        pcaddbranch(PC, ImmExt, PCTarget);
    mux2 #(32)   pcmux(PCPlus4, PCTarget, PCSrc, PCNext);
    reg_file     rf ( .clk(clk), .reset(reset), .wr_en(RegWrite), .rd_addr1(Instr[19:15]), .rd_addr2(Instr[24:20]), .wr_addr(Instr[11:7]), .wr_data(Result), .rd_data1(RD1), .rd_data2(WriteData));
    mux2 #(32)   srcamux(RD1, PC, SrcASelect, SrcA);
    mux2 #(32)   srcbmux(WriteData, ImmExt, ALUSrc, SrcB);
    alu          alu (SrcA, SrcB, ALUControl, ALUResult, Zero);
    mux3 #(32)   resultmux(ALUResult, ReadData, PCPlus4, ResultSrc, Result);
    assign Mem_WrData = WriteData;
    assign Mem_WrAddr = ALUResult;
endmodule

