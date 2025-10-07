`timescale 1ns/1ps
module alu #(parameter WIDTH = 32) (
    input               [WIDTH-1:0] a, b,
    input               [3:0] alu_ctrl,
    output reg          [WIDTH-1:0] alu_out,
    output              Zero,
    output              LessThanS, 
    output              LessThanU  
);

always @(*) begin
    case (alu_ctrl)
        4'b0000: alu_out = a & b; // and
        4'b0001: alu_out = a | b;  // or
        4'b0010: alu_out = a + b;  // addition
        4'b0011: alu_out = a - b; // subtraction
        4'b0100: alu_out = a ^ b;  // xor
        4'b0101: alu_out = a << b[4:0];   // SHIFT LEFT LOGICAL (SLL)
        4'b0110: alu_out = a >> b[4:0];    // SHIFT RIGHT LOGICAL (SRL)
        4'b0111: alu_out = $signed(a) >>> b[4:0];    // SHIFT RIGHT LOGICAL (SRL)
        4'b1000: alu_out = ($signed(a) < $signed(b)) ? 1 : 0;  // SET LESS THAN (SLT, Signed)
        4'b1001: alu_out = (a < b) ? 1 : 0;  // SET LESS THAN (SLT)
        default: alu_out = 32'hxxxxxxxx;
    endcase
end

// direct way to check for equality for beq/bne
assign Zero = (a == b); 
// flags for signed and unsigned "less than" comparisons
assign LessThanS = ($signed(a) < $signed(b));
assign LessThanU = (a < b);

endmodule

