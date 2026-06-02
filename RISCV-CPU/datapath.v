`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: datapath
// Description: The core datapath of the RISC-V CPU. It contains the PC logic,
//              register file, ALU, and data routing paths. It executes instructions
//              based on control signals from the controller.
//////////////////////////////////////////////////////////////////////////////////
module datapath (
 
    input        clk, reset,
    input  [1:0] ResultSrc,
    input        PCSrc, ALUSrc, SrcASelect, RegWrite,
    input  [3:0] ALUControl,
    input  [2:0] LoadType,
    input        is_jalr,

    // Status Flags to Controller
    output       Zero,
    output       LessThanS, LessThanU,

    // Main Data I/O
    output [31:0] PC,
    input  [31:0] Instr,
    output [31:0] Mem_WrAddr, Mem_WrData,
    input  [31:0] ReadData,
    output [31:0] Result
);

    // --- Internal Wires ---
    wire [31:0] PCNext, PCPlus4, PCTarget, SrcA, SrcB, WriteData, ALUResult, RD1;
    reg  [31:0] ImmExt;
    wire [31:0] PC_modified;
    reg  [31:0] LoadData;

 
    always @(*) begin
        case (Instr[6:0])
            7'b0000011, 7'b1100111, 7'b0010011: ImmExt = {{20{Instr[31]}}, Instr[31:20]}; // I-Type
            7'b0100011: ImmExt = {{20{Instr[31]}}, Instr[31:25], Instr[11:7]};         // S-Type
            7'b1100011: ImmExt = {{19{Instr[31]}}, Instr[31], Instr[7], Instr[30:25], Instr[11:8], 1'b0}; // B-Type
            7'b0110111, 7'b0010111: ImmExt = {Instr[31:12], 12'b0};                         // U-Type
            7'b1101111: ImmExt = {{11{Instr[31]}}, Instr[31], Instr[19:12], Instr[20], Instr[30:21], 1'b0}; // J-Type
            default: ImmExt = 32'hxxxxxxxx;
        endcase
    end

  
    reset_ff #(32) pcreg(clk, reset, PCNext, PC);
    adder        pcadd4(PC, 32'd4, PCPlus4);
    
    // This mux is critical for JALR. It selects the base for the jump target calculation.
    // For JALR, the base is a register value (SrcA); for all other branches/jumps, it's the PC.
    mux2 #(32)   pc_select_jal(PC, SrcA, is_jalr, PC_modified);
    
    adder        pcaddbranch(PC_modified, ImmExt, PCTarget);
    mux2 #(32)   pcmux(PCPlus4, PCTarget, PCSrc, PCNext); // this mux decides whether to take PC+4 or PC Target based on select line PCSrc

   
    reg_file     rf ( .clk(clk), .reset(reset), .wr_en(RegWrite), .rd_addr1(Instr[19:15]), .rd_addr2(Instr[24:20]), .wr_addr(Instr[11:7]), .wr_data(Result), .rd_data1(RD1), .rd_data2(WriteData));
    
    // Selects the first ALU operand. For AUIPC, it selects the PC.
    mux2 #(32)   srcamux(RD1, PC, SrcASelect, SrcA);
    
    // Selects the second ALU operand between a register value and the immediate.
    mux2 #(32)   srcbmux(WriteData, ImmExt, ALUSrc, SrcB);
    
    alu          alu (SrcA, SrcB, ALUControl, ALUResult, Zero, LessThanS, LessThanU);


    // (lhu, lh, lbu, lb).
    // It extracts the correct byte/halfword from the 32-bit word read from memory,
  always @(*) begin
        case (LoadType)
            // LHU (Load Halfword Unsigned)
            3'b101: begin
                LoadData = {16'b0, ReadData[15:0]};
            end
            // LH (Load Halfword Signed)
            3'b001: begin
                LoadData = {{16{ReadData[15]}}, ReadData[15:0]};
            end
            // LBU (Load Byte Unsigned)
            3'b100: begin
                    LoadData = {24'b0, ReadData[7:0]};
            end
            // LB (Load Byte Signed)
            3'b000: begin
                     LoadData = {{24{ReadData[7]}}, ReadData[7:0]};
            end
            // LW (Load Word) and default
            default: LoadData = ReadData;
        endcase
    end
    
    //  Write-Back Mux 
    mux3 #(32)   resultmux(ALUResult, LoadData, PCPlus4, ResultSrc, Result);


    assign Mem_WrData = WriteData;
    assign Mem_WrAddr = ALUResult;
endmodule

