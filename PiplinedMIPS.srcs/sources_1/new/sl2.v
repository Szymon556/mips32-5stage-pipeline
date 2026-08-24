`timescale 1ns / 1ps
`default_nettype none


module sl2(
        input wire [31:0] signimm,
        output wire  [31:0] signishm);
        
        
        assign signishm = signimm << 2;
endmodule


`default_nettype wire