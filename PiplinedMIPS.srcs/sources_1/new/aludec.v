`timescale 1ns / 1ps
`default_nettype none

module aludec(
    input  wire [5:0] funct,
    input  wire [1:0] aluop,
    output reg [2:0] alucontrol,
    output reg [1:0] shiftercontrol,
    output reg       shiftenable
);

    always @(*)
    begin
        // Wartości domyślne:
        // ALU wykonuje ADD, shifter jest wyłączony.
        // Zapobiega to inferowaniu latchy dla sygnałów sterujących.
        alucontrol     = 3'b010;
        shiftercontrol = 2'b00;
        shiftenable    = 1'b0;

        case (aluop)

            // Operacje wymagające dodawania, np. ADDI, LW, SW
            2'b00:
                alucontrol = 3'b010; // ADD

            // Operacja odejmowania, używana m.in. przez BEQ
            2'b01:
                alucontrol = 3'b110; // SUB

            // Instrukcje R-type:
            // właściwa operacja jest wybierana na podstawie pola funct.
            default:
                case (funct)

                    // SLL - Shift Left Logical
                    // ALU przekazuje operand do shiftera,
                    // który wykonuje logiczne przesunięcie w lewo.
                    6'b000000:
                    begin
                        alucontrol     = 3'b010;
                        shiftercontrol = 2'b01; // SLL
                        shiftenable    = 1'b1;
                    end

                    // SRL - Shift Right Logical
                    // Shifter wykonuje logiczne przesunięcie w prawo.
                    6'b000010:
                    begin
                        alucontrol     = 3'b010;
                        shiftercontrol = 2'b10; // SRL
                        shiftenable    = 1'b1;
                    end

                    // SRA - Shift Right Arithmetic
                    // Shifter wykonuje arytmetyczne przesunięcie w prawo.
                    6'b000011:
                    begin
                        alucontrol     = 3'b010;
                        shiftercontrol = 2'b11; // SRA
                        shiftenable    = 1'b1;
                    end

                    // ADD - dodawanie dwóch operandów rejestrowych
                    6'b100000:
                    begin
                        alucontrol     = 3'b010; // ADD
                        shiftercontrol = 2'b00;
                        shiftenable    = 1'b0;
                    end

                    // SUB - odejmowanie dwóch operandów rejestrowych
                    6'b100010:
                    begin
                        alucontrol     = 3'b110; // SUB
                        shiftercontrol = 2'b00;
                        shiftenable    = 1'b0;
                    end

                    // AND - bitowe AND
                    6'b100100:
                    begin
                        alucontrol     = 3'b000; // AND
                        shiftercontrol = 2'b00;
                        shiftenable    = 1'b0;
                    end

                    // OR - bitowe OR
                    6'b100101:
                    begin
                        alucontrol     = 3'b001; // OR
                        shiftercontrol = 2'b00;
                        shiftenable    = 1'b0;
                    end

                    // SLT - Set Less Than
                    // Wynik = 1, gdy pierwszy operand jest mniejszy od drugiego,
                    // w przeciwnym przypadku wynik = 0.
                    6'b101010:
                    begin
                        alucontrol     = 3'b111; // SLT
                        shiftercontrol = 2'b00;
                        shiftenable    = 1'b0;
                    end

                    // Nieobsługiwana wartość pola funct.
                    // X ułatwia wykrywanie nieprawidłowych instrukcji w symulacji.
                    default:
                    begin
                        alucontrol     = 3'bxxx;
                        shiftercontrol = 2'bxx;
                        shiftenable    = 1'b0;
                    end

                endcase
        endcase
    end

endmodule

`default_nettype wire