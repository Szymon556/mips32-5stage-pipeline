`timescale 1ns / 1ps
`default_nettype none


module hazardunit(
           input wire [4:0] rsE,
           input wire [4:0] rtE,
           input wire [4:0] rsD,
           input wire [4:0] rtD,
           input wire memtoregE,
           input wire memtoregM,
           input wire branchD,
           input wire [1:0] regwriteM,
           input wire [1:0] regwriteE,
           input wire [1:0]regwriteW,
           input wire [4:0] writeregM,
           input wire [4:0] writeregW,
           input wire [4:0] writeregE,
           output reg [1:0] forwardAE,
           output reg [1:0] forwardBE,
           output wire forwardAD,
           output wire forwardBD,
           output wire stallF,
           output wire stallD,
           output wire flushE
            
    );
    
    wire lwstall;
    wire branchstall;
    
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
    
    assign forwardAD = (rsD != 0) && (rsD == writeregM) && regwriteM;
    assign forwardBD = (rtD != 0) && (rtD == writeregM) && regwriteM;
    
   assign branchstall = branchD && regwriteE && (writeregE == rsD || writeregE == rtD) || 
                        branchD && memtoregM && (writeregM == rsD || writeregM == rtD);
    
    //Debug info: 
    // branchD - zatrzymuje się ten sygnał najprawdopodbniej na stanie wysokim
    // regwriteE - wynosi 0
    // writeregE - daje 0 i 1 w zależności do isntrukcji więc działa dobrze
    // rsD - wygląda ze działa dobrze
    // memtoregM - tutaj był błąd
    
  
    
    assign lwstall = (((rsD == rtE) || (rtD == rtE)) && memtoregE) || branchstall;
    assign stallF = lwstall;
    assign stallD = lwstall;
    assign flushE = lwstall;
endmodule





























`default_nettype wire