`timescale 1ns / 1ps
`default_nettype none



module mux2
#(parameter WIDTH = 8)(
    input wire [WIDTH - 1:0] d0, d1,
    input wire s,
    output wire [WIDTH -1:0] y);
    
    assign y = s ? d1 : d0;
endmodule
`default_nettype wire