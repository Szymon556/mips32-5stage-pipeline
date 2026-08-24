`timescale 1ns / 1ps
`default_nettype none

module datapath(input wire  clk, reset,
                input wire memtoregD,
                input wire alusrcD, regdstD,
                input wire [1:0] regwriteD, 
                input wire jumpD,
                input wire memwriteD,
                input wire branchD,
                input wire [2:0] alucontrolD,
                input wire [1:0] shiftercontrolD,
                input wire shiftenableD,
                input wire pcsrcM,
                output wire zeroM,
                output wire [31:0] pcF,
                input wire [31:0] instrF,
                output wire [31:0] aluoutM,
                input wire [31:0] readdataM,
                output wire [31:0] pcnextF,
                output wire [31:0] writedataM,
                output wire branchM,
                output wire memwriteM,
                output wire [31:0] instrD     
                );
      
      // rejestrowanie sygnałów z datapath          
      wire [4:0] writeregE, writeregM, writeregW;
      wire [31:0] pcbranch;
      wire [31:0] signimmD, signimmE, signimmshE,ra1inc;
      wire [31:0] srcaD,srcaE; 
      wire [31:0] srcbE;
      wire [31:0] resultW;
      wire [31:0] shifteroutM;
      wire [31:0] aluoutmuxM, aluoutmuxW;
      wire [31:0] pcplus4F,pcplus4D,pcplus4E;
      wire [31:0] pcbranchM, pcbranchE;
      wire [31:0] writedataD, writedataE;
      wire [31:0] aluoutE, aluoutM;
      wire [31:0] readdataW;
      wire zeroE;
      wire [4:0]  rsindexE, rsindexM, rsindexW;
      wire [31:0] rsplus4D, rsplus4E, rsplus4M, rsplus4W;
      wire lwincD, lwincE, lwincM, lwincW;  
          
      // rejestrowane control signals
      wire [1:0] regwriteE, regwriteM, regwriteW;
      wire memtoregE, memtoregM, memtoregW;
      wire [1:0] shiftercontrolE, shiftercontrolM;
      wire memwriteE;
      wire branchE, branchM;
      wire [2:0] alucontrolE;
      wire alusrcE;
      wire regdstE;
      wire [31:0] instrD, instrE, instrM;
      wire shiftenableE, shiftenableM;
      
      
      // rejestrowane sygnały poszczególnych etapów wykonywania instrukcji
      wire [63:0] fetchreg_signals_in, fetchreg_signals_out; 
      wire [210:0] decoderreg_signals_in, decoderreg_signals_out;
      wire [179:0] executereg_signals_in, executereg_signals_out;
      wire [109:0] memreg_signals_in, memreg_signals_out;


      
       
      
     
      // rejestry poszczególnych etapów
      
      //**********************etap 1***************************//
      
      
      // next PC logic
      flopr #(32) pcreg(
          .clk(clk), 
          .reset(reset), 
          .d(pcnextF), 
          .q(pcF));
          
      adder pcadd1(
                .a(pcF),
                .b(32'b100),
                .y(pcplus4F));
                
      
      mux2 #(32) pcbrmux(
          .d0(pcplus4F), 
          .d1(pcbranchM), 
          .s(pcsrcM), 
          .y(pcnextF)
      );
      
      assign fetchreg_signals_in = {instrF,pcplus4F};
      
      flopr #(64) fetchreg(
                 .clk(clk),
                 .reset(reset),
                 .d(fetchreg_signals_in),
                 .q(fetchreg_signals_out) 
      );
      
      assign {instrD, pcplus4D} = fetchreg_signals_out;
                
      //*********************** ETAP 2***************************// 
    
      
      // register file logic
      regfile rf(
               .clk(clk),
               .we (regwriteW), 
               .ra1(instrD[25:21]),
               .ra2(instrD[20:16]),
               .wa3(writeregW),
               .wd3(resultW),
               .wd4(rsplus4W),
               .wa4(rsindexW),
               .lwinc (lwincW),
               .rd1(srcaD),
               .rd2(writedataD));
         
               
       // adder będacy częścią implementacji lwinc
       adder pcadd3(
                 .a(srcaD),
                 .b(32'd4),
                 .y(rsplus4D));
                 
       assign lwincD = (instrD[31:26] == 6'b111111) ? 1'b1 : 1'b0;
       
               
       signext se(
                .a(instrD[15:0]),
                .y(signimmD));
      
                         
       assign decoderreg_signals_in = {regwriteD, memtoregD, memwriteD, branchD, alucontrolD, alusrcD,
       regdstD, srcaD, writedataD,instrD, signimmD, shiftercontrolD, shiftenableD, pcplus4D,pcplus4D,instrD[25:21], lwincD};
       
       flopr #(211) decodereg(
                 .clk(clk),
                 .reset(reset),
                 .d(decoderreg_signals_in),
                 .q(decoderreg_signals_out) 
      );
      assign {regwriteE, memtoregE, memwriteE, branchE, alucontrolE, alusrcE,
       regdstE, srcaE, writedataE, instrE, signimmE, shiftercontrolE, shiftenableE, pcplus4E, rsplus4E, rsindexE, lwincE } = decoderreg_signals_out;
       
                 
     //***************************ETAP 3************************//           
               
     
                     
      mux2 #(5) wrmux(
                .d0(instrE[20:16]),
                .d1(instrE[15:11]),
                .s(regdstE),
                .y(writeregE));
                
     alu alu(
            .srca(srcaE),
            .srcb(srcbE),
            .alucontrol(alucontrolE),
            .aluout(aluoutE),
            .zero(zeroE));
      
      
      sl2 immsh(
            .signimm(signimmE),
            .signishm(signimmshE));
       
      mux2 #(32) srcbmux(
                .d0(writedataE),
                .d1(signimmE),
                .s(alusrcE),
                .y(srcbE));
      
      adder rsadd2(
                .a(pcplus4E), 
                .b(signimmshE), 
                .y(pcbranchE));
                
       assign executereg_signals_in = {regwriteE, memtoregE, memwriteE, branchE,
       zeroE, writedataE, writeregE, pcbranchE, aluoutE, instrE, shiftercontrolE, shiftenableE,  rsplus4E, rsindexE, lwincE };
       
       flopr #(180) executionreg(
                 .clk(clk),
                 .reset(reset),
                 .d(executereg_signals_in),
                 .q(executereg_signals_out) 
      );
      assign {regwriteM, memtoregM, memwriteM, branchM,
      zeroM, writedataM, writeregM, pcbranchM, aluoutM, instrM, shiftercontrolM,shiftenableM, rsplus4M, rsindexM, lwincM} =  executereg_signals_out;
 //**********************ETAP 4************************//
        
      regshamt shifter (
            .aluout          (aluoutM),
            .shifterControl  (shiftercontrolM),
            .shamt           (instrM[10:6]),
            .shifterout      (shifteroutM)
      );
                 
    
        mux2 #(32) outmux(
        .d0(aluoutM),
        .d1(shifteroutM),
        .s(shiftenableM),
        .y(aluoutmuxM)
    );         
     
    assign memreg_signals_in = {regwriteM, memtoregM, aluoutmuxM, readdataM, writeregM,  rsplus4M, rsindexM, lwincM};
       
       flopr #(110) memreg(
                 .clk(clk),
                 .reset(reset),
                 .d(memreg_signals_in),
                 .q(memreg_signals_out) 
      );
      assign {regwriteW, memtoregW, aluoutmuxW, readdataW, writeregW,  rsplus4W, rsindexW, lwincW }  =  memreg_signals_out;   
      
//********************* ETAP 5***************************//      
      
   
                  
    mux2 #(32) resmux(
               .d0(aluoutmuxW), 
               .d1(readdataW),
               .s(memtoregW),
               .y(resultW));
     
      
      
endmodule
`default_nettype wire