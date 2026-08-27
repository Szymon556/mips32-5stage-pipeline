`timescale 1ns / 1ps
`default_nettype none

module testbench();
    
    // ----------------------------------------------
    // Testbench signals
    // ----------------------------------------------
    
    
    reg clk;
    reg reset;
    
    wire [31:0] writedata;
    wire [31:0] dataadr; 
    wire memwrite;;
    
    
    // -----------------------------------------
    // Test control
    // -----------------------------------------
    
    integer cycle_count;
    integer error_count;
    integer store_count;
    
    localparam integer MAX_CYCLES = 200;
    
    localparam [31:0] EXPECTED_ADDR = 32'h00000054;
    localparam [31:0] EXPECTED_DATA =  32'h00000007;
    localparam [31:0] FIRSTSTORE_ADDR = 32'h00000050;
    localparam [31:0] FIRSTSTORE_DATA = 32'h00000007;
    // ------------------------------------------
    // Device under test
    // ------------------------------------------
    
    top dut(
            // -----------------------------------------
            //  Main I/O signals 
            // -----------------------------------------
            
            .clk(clk), 
            .reset(reset), 
            .writedata(writedata), 
            .dataadr(dataadr), 
            .memwrite(memwrite),
            
            // ----------------------------------------
            // Debug Signals for future use
            // ----------------------------------------
            
            .jump(),
            .pcnext(),
            .controls(),
            .pc(),
            .shiftercontrol(),
            .aluoutE(),
            .srcaE(),
            .srcbE(),
            .alucontrolE(),
            .forwardAE(),
            .forwardBE(),
            .resultW(),
            .stallD(),
            .stallF(),
            .flushE(),
            .memtoregE(),
            .instrD());
            
            
            
    // ----------------------------------
    // Clock generatiom
    //
    // 10 ns period
    // ----------------------------------
    
    always begin
        clk = 1'b0;
        
        forever #5 clk = ~clk;
    end
   
   // ----------------------------------
   // Reset
   // ----------------------------------
       
   
   initial begin
            reset = 1'b1;
            
            cycle_count = 0;
            error_count = 0;
            store_count = 0;
            
            repeat(3) @(posedge clk);
            
            reset = 1'b0;
        end
        
    // ------------------------------------
    // Cycle counter + timeout
    // -----------------------------------
    
    always @(posedge clk) begin
        if(reset) begin
            cycle_count <= 0;
        end
        else begin
            cycle_count <= cycle_count + 1;
            
            if(cycle_count >= MAX_CYCLES) begin 
                $display("");
                $display("========================================");
                $display(" TEST FAILED: TIMEOUT");
                $display(" Processor did not finish in %0d cycles.",
                         MAX_CYCLES);
                $display("========================================");
                $display("");

                $finish;
            end
            
        end
    end

  // ---------------------------------------------------------
  // Self-checking memory-write monitor
  // ---------------------------------------------------------
  
  always @(negedge clk) begin
    if(!reset && memwrite) begin
        $display(
            "[cycle %d] STORE address=0x%08h data=0x%08h",
                cycle_count,
                dataadr,
                writedata);
        store_count = store_count +  1;
        
        if(store_count ===  1) begin  
           if(dataadr == FIRSTSTORE_ADDR) begin
            if(writedata == FIRSTSTORE_DATA) begin
                $display("");
                $display("========================================");
                $display("FIRST STORE OK");
                $display("Expected store observed");
                $display("Address: 0x%08h", dataadr);
                $display("Data: 0x%08h", writedata);
                $display("Cycles: 0x%0d", cycle_count);
                $display("========================================");
           end
           else begin
                $display("");
                $display("===========================================");
                $display("FIRST STORE FAILED");
                $display("Correst address, incorect data");
                $display("Data: %h08", writedata);
                $display("Cycles: 0x%0d", cycle_count);
                $display("===========================================");
                
           end
          end
         end
         
                 
        // Final store form the Harris test program
        if(store_count ===  2) begin  
           if(dataadr == EXPECTED_ADDR) begin
            if(writedata == EXPECTED_DATA) begin
                $display("");
                $display("========================================");
                $display("TEST PASSED");
                $display("Expected store observed");
                $display("Address: 0x%08h", dataadr);
                $display("Data: 0x%08h", writedata);
                $display("Cycles: 0x%0d", cycle_count);
                $display("========================================");
                
                $finish;
            end 
            else begin
                $display("");
                $display("===========================================");
                $display("TEST FAILED");
                $display("Correst address, incorect data");
                $display("Data: %h08", writedata);
                $display("Cycles: 0x%0d", cycle_count);
                $display("===========================================");
                
                $finish;
            end
        end 
       end
       
        
    end
  end
  
  
 // ---------------------------------------------
 // unknow-state detection
 // -------------------------------------------- 
 
 always @(negedge clk) begin
    if(!reset) begin
        if(dataadr === 1'bx && memwrite === 1'b1) begin
            $display("WARNING: unknow address during memory write at cycle %0d", cycle_count);
        end
        
        if(writedata === 1'bx && memwrite === 1'b1) begin
            $display("WARNING: unknow write data  during memory write at cycle %0d", cycle_count);
        end  
    end
 end
 

endmodule















`default_nettype wire