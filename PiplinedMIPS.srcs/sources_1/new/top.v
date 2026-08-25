`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Szymon Mazur
// 
// Create Date: 08/23/2026 02:14:40 PM
// Design Name: 
// Module Name: top
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
module top(input wire clk,reset,
            output wire [31:0] writedata, dataadr,
            output wire memwrite,pcsrc,jump,
            output wire [31:0] pcnext,
            output wire [9:0] controls,
            output wire [31:0] pc,
            output wire [1:0] shiftercontrol,
            output wire branch,
            output wire [31:0] aluoutE,
            output wire [31:0] srcaE,
            output wire [31:0] srcbE,
            output wire [2:0] alucontrolE,
            output wire [1:0] forwardAE,
            output wire [1:0] forwardBE);
            
       wire [31:0] instr, readdata;
       
      mips mips (
            .clk       (clk),
            .reset     (reset),
            .pc        (pc),
            .instr     (instr),
            .memwriteM  (memwrite),
            .aluout    (dataadr),
            .writedata (writedata),
            .readdata  (readdata),
            .pcsrc     (pcsrc),
            .jump      (jump),
            .pcnext    (pcnext),
            .controls  (controls),
            .shiftercontrol (shiftercontrol),
            .branch (branch),
            .aluoutE (aluoutE),
            .srcaE             (srcaE),
            .srcbE             (srcbE),
            .alucontrolE       (alucontrolE),
            .forwardAE   (forwardAE),
            .forwardBE   (forwardBE) );
                  
       imem imem(
           .a(pc[7:2]),
           .rd(instr));
           
       dmem dmem(
           .clk(clk),
           .we(memwrite),
           .a(dataadr),
           .wd(writedata),
           .rd(readdata));
       
endmodule
`default_nettype wire