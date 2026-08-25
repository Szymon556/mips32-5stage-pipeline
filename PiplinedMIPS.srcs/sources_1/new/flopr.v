`timescale 1ns / 1ps
`default_nettype none

module flopr#(parameter WIDTH = 8)
    (input wire clk, reset,
     input wire [WIDTH-1:0] d,
     output reg [WIDTH -1:0] q);
     
     always @(posedge clk, posedge reset)
     begin
        if(reset) q <= 0;
        else q <= d;
     end
      
endmodule
    
`default_nettype wire
