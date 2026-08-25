`timescale 1ns / 1ps
`default_nettype none

module floprclr #(parameter WIDTH = 8)
    (input wire clk, reset,
    input wire clr,
     input wire [WIDTH-1:0] d,
     output reg [WIDTH -1:0] q);
     
     always @(posedge clk, posedge reset)
     begin
        if(reset | clr ) q <= 0;
        else q <= d;
     end
      
endmodule
    
`default_nettype wire
