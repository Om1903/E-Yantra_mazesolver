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

//    // This combinational block determines the immediate value based on the opcode.
//    always @(*) begin
//        // Default to a known value (can help in debugging)
//        imm_out = 32'hxxxxxxxx;

//        case (op)
//            // I-Type (Loads, JALR, I-type ALU)
//            7'b0000011, 7'b1100111, 7'b0010011:
//                // Sign-extend from bit 11 of the immediate (bit 31 of instruction)
//                imm_out = {{20{instruction[31]}}, instruction[31:20]};

//            // S-Type (Stores)
//            7'b0100011:
//                // Sign-extend from bit 11 of the immediate (bit 31 of instruction)
//                imm_out = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};

//            // B-Type (Branches)
//            7'b1100011:
//                // Sign-extend from bit 12 of the immediate (bit 31 of instruction)
//                // Note the non-contiguous bits are assembled into the correct order.
//                imm_out = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0};

//            // U-Type (LUI, AUIPC)
//            7'b0110111, 7'b0010111:
//                // The lower 12 bits are zero, no sign extension needed.
//                imm_out = {instruction[31:12], 12'b0};

//            // J-Type (JAL)
//            7'b1101111:
//                // Sign-extend from bit 20 of the immediate (bit 31 of instruction)
//                imm_out = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};

//            // R-Type has no immediate, so we don't need a case for it.
//            // Other opcodes can default to 'x'.
//            default: imm_out = 32'hxxxxxxxx;
//        endcase
//    end

endmodule
