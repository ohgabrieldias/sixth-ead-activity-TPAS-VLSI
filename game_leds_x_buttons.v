// # MIT License
// # Copyright (c) [2023] [Gabriel Rosa Dias] [Pedro Antônio]
// # See LICENSE file for full license text.


module game_leds_x_buttons (
    input osc_clk,           // Sinal de clock
    input reset_n,           // Sinal de reset
    input [3:0] button,      // Botões (um para cada LED)
    output reg [3:0] led    // LEDs (um para cada botÃ£o)
);

integer i;

reg [15:0] padrao;
reg [3:0] entrada_usuario[15:0]; // Entrada do usuário
reg [3:0] qtd_digitos_corretos;  // Quantidade de dígitos corretos
reg [3:0] subconjunto;
reg [2:0] rnd_sel;          // Seleção aleatória de LEDs
reg [2:0] count_round;      // Contador de rodadas

// Clock com uma frequência de 1/50 MHz=T  T=20×10 −9s
// Quantidade de ciclos para 1s: 1/20×10 −9s=50×10 6 ciclos
reg [25:0] count;           // Contador de tempo para contar até 50000000
reg [15:0] lfsr;            // Linear Feedback Shift Register for random number generation


always @(posedge osc_clk or posedge reset_n)
    begin
        if (reset_n)
            begin
                padrao <= 4'b0;
                subconjunto <= 4'b0;
                count_round <= 3'b0;
                count <= 25'd0;
                lfsr <= 16'hACE1; // Initial value for LFSR
            end
        else
            if (count_round == 3'b0)        // Round 0
                begin
                    for (i = 0; i < 4; i = i + 1)
                        begin
                            rnd_sel = lfsr[1:0]; // Select a random LED based on 2 LSBs of LFSR
                            subconjunto[rnd_sel] = 1; // Seleciona um LED aleatoriamente
                            padrao[i*4 +: 4] = subconjunto; // Atualiza a matriz de saída com o subconjunto
                            subconjunto = 4'b0; // Reset subset for the next iteration
                            lfsr = lfsr ^ (lfsr << 1) ^ (lfsr << 2) ^ (lfsr << 3); // Update LFSR
                        end
                    count_round <= count_round + 1;     // Go to next round
                end
            else                            // Round 1, 2, 3
                begin
                    if (count == 25'd50000000 && count_round == 1)      // 1s
                        begin
                            for (i = 0; i < 4; i = i + 1)   // Update LEDs based on previous round
                                begin
                                    subconjunto = padrao[i*4 +: 4]; // Get subset from previous round
                                    led = subconjunto; // Atualiza a matriz de saída com o subconjunto
                                    subconjunto = 4'b0; // Reset subset for the next iteration
                                end
                            count_round <= count_round + 1;     // Go to next round
                            count <= 26'd0;     // Reset counter for 1s
                        end
                end
            count <= count + 1;     // Increment counter for 1s            
    end
endmodule