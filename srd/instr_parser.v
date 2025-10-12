`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: instr_parser
// Description: This is a purely combinational module that is additionally made as an instruction
//              decoder. It takes the 32-bit instruction word as input and breaks
//              it down into its constituent fields (opcode, register numbers,
//              function codes, etc.) as separate outputs. This simplifies wiring
//              in the higher-level modules.
//////////////////////////////////////////////////////////////////////////////////
module instr_parser (
    input  [31:0] instr,      // The 32-bit instruction from memory

    // Decoded fields as outputs
    output [6:0]  op,         // Opcode field [6:0]
    output [4:0]  rd,         // Destination register address [11:7]
    output [2:0]  funct3,     // 3-bit function field [14:12]
    output [4:0]  rs1,        // Source register 1 address [19:15]
    output [4:0]  rs2,        // Source register 2 address [24:20]
    output [6:0]  funct7,     // 7-bit function field [31:25]

    // Specific bits extracted for convenience in the decoders
    output        funct7b5,   // Bit 5 of funct7 (instruction bit 30)
    output        opb5        // Bit 5 of the opcode (instruction bit 5)
);

   
    // according to the standard RISC-V instruction format.
    assign op       = instr[6:0];
    assign rd       = instr[11:7];
    assign funct3   = instr[14:12];
    assign rs1      = instr[19:15];
    assign rs2      = instr[24:20];
    assign funct7   = instr[31:25];

    // These specific bits are frequently used by the decoders to differentiate between similar instructions (e.g., ADD vs SUB, or R-type vs I-type).
    assign funct7b5 = instr[30];
    assign opb5     = instr[5];

endmodule
