`timescale 1ns / 1ps
`default_nettype none


module hazardunit(
           input wire [4:0] rsE,
           input wire [4:0] rtE,
           input wire [1:0] regwriteM,
           input wire [1:0]regwriteW,
           input wire [4:0] writeregM,
           input wire [4:0] writeregW,
           output reg [1:0] forwardAE,
           output reg [1:0] forwardBE
            
    );
    
    always @(*) begin
        forwardAE = 2'b00;
        if((rsE != 0) && (rsE == writeregM) && regwriteM)
            forwardAE = 2'b10;
        else if ((rsE != 0) && (rsE == writeregW) && regwriteW)
            forwardAE = 2'b01;
        else
            forwardAE = 2'b00;
    end
    
    
    always @(*) begin
        forwardBE = 2'b00;
        if((rtE != 0) && (rtE == writeregM) && regwriteM)
            forwardBE = 2'b10;
        else if ((rtE != 0) && (rtE == writeregW) && regwriteW)
            forwardBE = 2'b01;
        else
            forwardBE = 2'b00;
    end
    
endmodule





























`default_nettype wire