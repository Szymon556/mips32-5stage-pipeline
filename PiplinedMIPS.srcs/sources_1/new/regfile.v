`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/23/2026 04:01:20 PM
// Design Name: 
// Module Name: regfile
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module regfile(input wire clk,
               input wire lwinc,
               input wire [1:0] we,
               input wire [4:0] ra1, ra2, wa3, wa4,
               input wire [31:0] wd3,wd4,
               output wire [31:0] rd1, rd2);
               
       reg [31:0] rf[31:0];
       wire we3,we4;
       // rejestr z czterema portami
       // dwa porty są oczytywane kombinacyjne a
       // dwa zapisywane są sekwencyjnie
       assign we4 = we[0];
       assign we3 = we[1];
       
       always @(posedge clk)
        begin
            if(we3 && wa3 != 0) rf[wa3] <= wd3;
            if(we4 && wa4 != 0) begin
                if (lwinc == 1) rf[wa4] <= wd4;
            end
        end
        
      assign rd1 = (ra1 != 0) ? rf[ra1] : 0;
      assign rd2 = (ra2 != 0) ? rf[ra2] : 0;
       
endmodule
`default_nettype wire