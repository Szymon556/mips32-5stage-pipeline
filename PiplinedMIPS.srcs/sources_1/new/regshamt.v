`timescale 1ns / 1ps
`default_nettype none


module regshamt(
                input wire [31:0] aluout,
                input wire [1:0] shifterControl,
                input wire [4:0] shamt,
                output reg [31:0] shifterout 
            
    );
    
    always @ (*)
    case(shifterControl)
        2'b00 : shifterout = aluout;
        2'b01: shifterout = (aluout << shamt);
        2'b10: shifterout = (aluout >> shamt);
        2'b11: shifterout = $signed(aluout) >>> shamt;
    endcase
    
endmodule

`default_nettype wire