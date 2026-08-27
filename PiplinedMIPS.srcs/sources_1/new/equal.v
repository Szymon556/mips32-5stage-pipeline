`timescale 1ns / 1ps
`default_nettype none


module equal #(parameter WIDTH = 8)(
        input wire [WIDTH - 1:0] a, b, 
        output wire [WIDTH - 1:0] y
    );
    
    assign y = (a == b);
endmodule


`default_nettype wire