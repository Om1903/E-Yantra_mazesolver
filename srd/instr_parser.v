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
    input  [31:0] instr,     

    
    output [6:0]  op,         
    output [4:0]  rd,         
    output [2:0]  funct3,  
    output [4:0]  rs1,        
    output [4:0]  rs2,        
    output [6:0]  funct7,     

    // Specific bits extracted for convenience in the decoders
    output        funct7b5,   
    output        opb5      
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
