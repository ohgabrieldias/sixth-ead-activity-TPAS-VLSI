// # MIT License
// # Copyright (c) [2023] [Gabriel Rosa Dias][Pedro Antonio]
// # See LICENSE file for full license text.
module game_leds_x_buttons (
    input osc_clk,           // Sinal de clock
    input reset_n,           // Sinal de reset
    input [3:0] btn,      // Botões (um para cada LED)
    output  [3:0] led    // LEDs (um para cada botão)
);

reg [3:0] pattern;          // Padrão gerado pela arquitetura
reg [3:0] user_input;       // Padrão inserido pelo usuário
reg [2:0] pattern_pos;      // Posição atual no padrão
reg [2:0] correct_pos;      // Posição correta no padrão

reg [2:0] rnd_sel;          // Seleção aleatória de LEDs
      

reg game_active;            // Indica se o jogo está ativo

// Contadores
reg [3:0] round_count;      // Conta as rodadas
reg [3:0] correct_count;    // Conta os acertos consecutivos

// Lógica do jogo
always @(posedge osc_clk or posedge reset_n)
    begin
        if (reset_n)
            begin
                pattern <= 3'b0;
                user_input <= 3'b0;
                pattern_pos <= 2'b0;
                correct_pos <= 2'b0;
                rnd_sel <= 2'b0;
            end
        else 
            begin
            // Lógica principal do jogo
            if (game_active)
                begin
                    // Geração do padrão na primeira rodada
                    if (round_count == 0) begin
                        rnd_sel <= $random % 4;
                        pattern <= 4'b0;
                        pattern[rnd_sel] <= 1;
                        pattern_pos <= 0;
                    end // if
                end // if2
        end // else
    end // always
endmodule