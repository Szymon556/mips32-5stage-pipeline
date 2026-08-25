`timescale 1ns / 1ps


module testbench();
    reg clk;
    reg reset;
    
    wire [31:0] writedata, dataadr, aluoutE;
    wire memwrite;
    wire pcsrc;
    wire jump;
    wire [31:0] pcnext;
    wire [9:0] controls;
    wire [31:0] pc;
    wire [1:0] shiftercontrol;
    wire branch;
    wire [31:0] srcaE, srcbE;
    wire [2:0] alucontrolE;
    wire [1:0] forwardAE;
    wire [1:0] forwardBE;
    
    integer store_count = 0;
    // jednostka która będzie testowana
    top dut(
            .clk(clk), 
            .reset(reset), 
            .writedata(writedata), 
            .dataadr(dataadr), 
            .memwrite(memwrite),
            .pcsrc(pcsrc),
            .jump(jump),
            .pcnext(pcnext),
            .controls(controls),
            .pc(pc),
            .shiftercontrol(shiftercontrol),
            .branch(branch), 
            .aluoutE(aluoutE),
            .srcaE(srcaE),
            .srcbE(srcbE),
            .alucontrolE(alucontrolE),
            .forwardAE(forwardAE),
            .forwardBE(forwardBE));
    
    // inicjalizuj test
    initial
        begin
            reset <= 1; #22; reset <= 0;
        end
        
     // generowanie sygnału zegarowego
     always
        begin
            clk <= 1; #5; clk <= 0; #5;
        end



always @(negedge clk)
begin
    if (memwrite) begin
        store_count = store_count + 1;

        if (store_count == 1) begin
            if (dataadr === 32'd84 && writedata === 32'd5)
                $display("First store OK");
            else begin
                $display("First store failed");
                $stop;
            end
        end

        if (store_count == 2) begin
            if (dataadr === 32'd84 && writedata === 32'd7) begin
                $display("LWINC test succeeded");
                $stop;
            end
            else begin
                $display("Second store failed");
                $stop;
            end
        end
    end
    
    if(aluoutE === 32'd10) begin
        $display("Test passed!!!");
        $stop;
    end
end
endmodule
