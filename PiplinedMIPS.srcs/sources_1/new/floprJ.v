`timescale 1ns / 1ps
`default_nettype none

module floprj #(parameter WIDTH = 8)
    (input wire clk, reset,
     input wire jump,
     input wire stall,
     input wire [WIDTH-1:0] d,
     output reg [WIDTH -1:0] q);
     
    
      
      
     // czyszcznie kolejnej pobranej instrukcji po nop
       always @ (posedge clk, posedge reset)
       begin
            if(reset)
            begin
                q <=0;
            end else begin
                if (jump == 1) begin
                    q <= 0;
                end else if (!stall) begin
                    q <= d;
                end
             end
          end 
          
endmodule
    
`default_nettype wire
