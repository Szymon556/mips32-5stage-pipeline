`timescale 1ns / 1ps
`default_nettype none

module alu(
            input wire [31:0] srca,srcb,
            input wire [2:0] alucontrol,
            output reg [31:0] aluout,
            output wire  zero);
            
       wire [31:0] B_reg;
       wire [31:0] S;       
       
       assign B_reg = (alucontrol[2]) ? ~srcb : srcb;
       assign S = srca + B_reg + alucontrol[2];
       
       
       always @ (*)
        case(alucontrol[1:0])
        2'b00 : aluout =  srca & B_reg;
        2'b01 : aluout =  srca | B_reg;
        2'b10 : aluout =  S;
        2'b11 : aluout =  {31'b0,{S[31]}};
        endcase
       
       assign zero = (S == 32'b0);
       
endmodule

`default_nettype wire