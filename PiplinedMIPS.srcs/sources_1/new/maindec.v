`timescale 1ns / 1ps
`default_nettype none 

module maindec(
                input  wire [5:0] op,
                output wire memtoreg,memwrite,
                output wire branch, alusrc,
                output wire regdst, 
                output wire [1:0] regwrite,
                output wire jump,
                output wire [1:0] aluop,
                output reg [9:0] controls
              );
                
      reg [9:0] controls;
      assign {regwrite,regdst,alusrc,
              branch,memwrite,
              memtoreg,jump,aluop} = controls;
              
     always @(*)
    case(op)
        6'b000000: controls <= 10'b1010000010; // R-type
        6'b100011: controls <= 10'b1001001000; // LW
        6'b101011: controls <= 10'b0001010000; // SW
        6'b000100: controls <= 10'b0000100001; // BEQ
        6'b001000: controls <= 10'b1001000000; // ADDI
        6'b000010: controls <= 10'b0000000100; // J
        6'b111111: controls <= 10'b1101001000; // LWINC
        default:   controls <= 10'bxxxxxxxxx; // ???
    endcase
endmodule


`default_nettype wire