`timescale 1ns / 1ps
`default_nettype none

module controller(input wire [5:0] op,funct,
                 input wire equalD,
                 output wire memtoreg,memwrite,
                 output wire pcsrc, alusrc,
                 output wire branch,
                 output wire regdst,
                 output wire [1:0] regwrite,
                 output wire jump,
                 output wire [2:0] alucontrol,
                 output wire [9:0] controls,
                 output wire [1:0] shiftercontrol,
                 output wire shiftenable);
     wire [1:0] aluop;
     
     
     // regwrite[1] - służy do zapisu WE3
     // regwrite[0] - służy do zapisu WE4
     maindec md(
                .op(op),
                .memtoreg(memtoreg),
                .memwrite(memwrite),
                .branch(branch),
                .alusrc(alusrc),
                .regdst(regdst),
                .regwrite(regwrite),
                .jump(jump),
                .aluop(aluop),
                .controls(controls));
                
    aludec ad(
               .funct(funct), 
               .aluop(aluop), 
               .alucontrol(alucontrol),
               .shiftercontrol(shiftercontrol),
               .shiftenable(shiftenable));
    
    assign pcsrc = branch & equalD;
endmodule

`default_nettype wire