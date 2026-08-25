`timescale 1ns / 1ps
`default_nettype none



module dmem(input wire clk, we,
            input wire [31:0] a, wd,
            output wire [31:0] rd);
            
            reg [31:0] RAM[63:0];
            // ten zabieg powoduje że mam odczyt pamięci wyrównany do słowa
            // polega to na tym że że każde kolejne słowo zwiększa licznik o 4, czyli
            // dwa ostatnie bity juz można pominąć bo zawsze będą wynosiły 00
            // do tego wtedy otrzymamy offset w słowach. A nie w bajtach co by spowodowało
            // nie poprawny odczyt pamięci
            assign rd = RAM[a[31:2]];
            initial
                begin
                    RAM[64] = 32'd7;
                end
                
            always @(posedge clk)
                if(we)
                    RAM[a[31:2]] <= wd;
endmodule
`default_nettype wire