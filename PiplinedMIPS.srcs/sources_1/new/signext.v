`timescale 1ns / 1ps
`default_nettype none 

module signext(input wire [15:0] a,
               output wire [31:0] y);
               
       assign y = {{16{a[15]}},a};
endmodule


`default_nettype wire