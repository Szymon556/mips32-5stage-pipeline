`timescale 1ns / 1ps
`default_nettype none

module flopren #(parameter WIDTH = 8)
    (input wire clk, reset,
     input wire stall,
     input wire [WIDTH-1:0] d,
     output reg [WIDTH -1:0] q);
     
     always @(posedge clk, posedge reset)
     begin
        if(reset) q <= 0;
        else if (!stall) q <= d;
     end
      
endmodule
    
`default_nettype wire
