`timescale 1ns / 1ps
`default_nettype none


module imem(
            input wire [5:0] a,
            output wire [31:0] rd);
             
      reg [31:0] RAM[63:0];
       
       initial 
        begin
            $readmemh("/home/djoverflow/Documents/harrisExcercises/PiplinedMIPS/PiplinedMIPS.srcs/sim_1/new/memfile.mem",RAM);
        end
       
       assign rd = RAM[a];
       
endmodule

`default_nettype wire