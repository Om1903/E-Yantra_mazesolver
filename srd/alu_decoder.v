`timescale 1ns/1ps

module alu_decoder (
    input        opb5,
    input [2:0]  funct3,
    input        funct7b5,
    input [1:0]  ALUOp,
    output reg [3:0] ALUControl
);

always @(*) begin
    case (ALUOp)
        2'b00: ALUControl = 4'b0010; // ADD
        2'b01: ALUControl = 4'b0011; // SUB
        2'b10: begin
            case (funct3)
                3'b000: if (funct7b5 & opb5) ALUControl = 4'b0011; else ALUControl = 4'b0010;
                3'b001: ALUControl = 4'b0101; // SLL
                3'b010: ALUControl = 4'b1000; // SLT
                3'b011: ALUControl = 4'b1001; // SLTU
                3'b100: ALUControl = 4'b0100; // XOR
                3'b101: if (funct7b5) ALUControl = 4'b0111; else ALUControl = 4'b0110; // SRA/SRL
                3'b110: ALUControl = 4'b0001; // OR
                3'b111: ALUControl = 4'b0000; // AND
                default: ALUControl = 4'bxxxx;
            endcase
        end
        default: ALUControl = 4'bxxxx;
    endcase
end

endmodule

