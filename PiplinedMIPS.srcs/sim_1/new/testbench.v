`timescale 1ns / 1ps


module testbench();
    reg clk;
    reg reset;
    
    wire [31:0] writedata, dataadr;
    wire memwrite;
    wire pcsrc;
    wire jump;
    wire [31:0] pcnext;
    wire [9:0] controls;
    wire [31:0] pc;
    wire [1:0] ShifterControl;
    integer store_count = 0;
    // jednostka która będzie testowana
    top dut(clk, reset, writedata, dataadr, memwrite,pcsrc,jump,pcnext,controls,pc,
    ShifterControl);
    
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
            if (dataadr === 32'd80 && writedata === 32'd7)
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
end
endmodule
