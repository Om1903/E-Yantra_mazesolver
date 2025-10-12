`timescale 1ns / 1ps



module instr_parser (
    input  [31:0] instr, // The 32-bit instruction from memory

    output [6:0]  op,          // Opcode
    output [4:0]  rd,          // Destination register
    output [2:0]  funct3,      // 3-bit function field
    output [4:0]  rs1,         // Source register 1
    output [4:0]  rs2,         // Source register 2
    output [6:0]  funct7,      // 7-bit function field

    // Specific bits for convenience
    output        funct7b5,    // Bit 5 of funct7 (bit 30 of instruction)
    output        opb5      // Bit 5 of the opcode (bit 5 of instruction)

   
);


    assign op       = instr[6:0];
    assign rd       = instr[11:7];
    assign funct3   = instr[14:12];
    assign rs1      = instr[19:15];
    assign rs2      = instr[24:20];
    assign funct7   = instr[31:25];
    assign funct7b5 = instr[30];
    assign opb5     = instr[5];


endmodule
