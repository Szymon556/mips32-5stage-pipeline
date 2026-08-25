`timescale 1ns / 1ps
`default_nettype none

module mips(
    input  wire        clk,
    input  wire        reset,

    // Instruction Memory - etap Fetch
    output wire [31:0] pc,
    input  wire [31:0] instr,

    // Data Memory - etap Memory
    output wire        memwriteM,
    output wire [31:0] aluout,
    output wire [31:0] writedata,
    input  wire [31:0] readdata,

    // Debug
    output wire        pcsrc,
    output wire        jump,
    output wire [31:0] pcnext,
    output wire [9:0]  controls,
    output wire [1:0]  shiftercontrol,
    output wire branch,
    output wire [31:0] aluoutE,
    output wire [31:0] srcaE,
    output wire [31:0] srcbE,
    output wire [2:0] alucontrolE
);

 
   wire [31:0] instrD;
    // ---------------------------------------------------------
    // Control signals generowane w Decode
    // ---------------------------------------------------------

    wire        memtoregD;
    wire        alusrcD;
    wire        regdstD;
    wire        shiftenableD;
    wire        branchD;
    wire        branchM;
    wire        jumpD;
    wire        memwriteD;

    wire [1:0]  regwriteD;
    wire [2:0]  alucontrolD;
    wire [1:0]  shiftercontrolD;
    wire zeroM;
   
    // ---------------------------------------------------------
    // CONTROLLER
    //
    // Controller dekoduje instrukcję znajdującą się w Decode,
    // a nie nową instrukcję znajdującą się aktualnie w Fetch.
    // ---------------------------------------------------------

    controller c (
        .op             (instrD[31:26]),
        .funct          (instrD[5:0]),

        .memtoreg       (memtoregD),
        .memwrite       (memwriteD),
        .branch        (branchD),
        .branchM        (branchM),
        .alusrc         (alusrcD),
        .regdst         (regdstD),
        .regwrite       (regwriteD),
        .jump           (jumpD),
        .alucontrol     (alucontrolD),
        .shiftercontrol (shiftercontrolD),
        .shiftenable    (shiftenableD),
        .zero          (zeroM),
        .pcsrc         (pcsrc),
        
        .controls       (controls)
    );

    // Debug outputs
    assign jump = jumpD;
    assign branch = branchD;
    assign shiftercontrol = shiftercontrolD;

    // ---------------------------------------------------------
    // DATAPATH
    //
    // Sygnały z końcówką D wchodzą do datapath.
    // Datapath rejestruje je razem z instrukcją i przesuwa:
    //
    // D -> E -> M -> W
    //
    // MemWrite wychodzi dopiero jako MemWriteM.
    // Branch jest rejestrowany i używany w odpowiednim etapie.
    // ---------------------------------------------------------

    datapath dp (
        .clk             (clk),
        .reset           (reset),

        // Control - Decode
        .memtoregD       (memtoregD),
        .branchD         (branchD),
        .branchM         (branchM),
        .alusrcD         (alusrcD),
        .regdstD         (regdstD),
        .regwriteD       (regwriteD),
        .jumpD           (jumpD),
        .alucontrolD     (alucontrolD),
        .shiftercontrolD (shiftercontrolD),
        .shiftenableD    (shiftenableD),
        .zeroM           (zeroM),
        

        // Instruction Memory
        .pcF              (pc),
        .instrF          (instr),
        .instrD          (instrD),

        // Data Memory
        .aluoutM          (aluout),
        .writedataM       (writedata),
        .readdataM        (readdata),
        .memwriteM       (memwriteM),
        .memwriteD       (memwriteD),
        // PC logic / debug
        .pcsrcM           (pcsrc),
        .pcnextF          (pcnext),
        .aluoutE           (aluoutE),
        .srcaE             (srcaE),
        .srcbE             (srcbE),
        .alucontrolE       (alucontrolE)
    );

endmodule

`default_nettype wire