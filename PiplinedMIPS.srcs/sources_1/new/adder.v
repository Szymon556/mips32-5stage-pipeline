`timescale 1ns / 1ps
`default_nettype none


module adder(input  wire [31:0] a,b,
             output wire [31:0] y);
             
       assign y = a + b;
endmodule

`default_nettype wire