module game_leds_x_buttons (
    input osc_clk,           // Sinal de clock
    input reset_n,           // Sinal de reset
    input [3:0] button,      // BotÃµes (um para cada LED)
    output reg [3:0] led    // LEDs (um para cada botÃ£o)
);

reg [3:0] pattern;          // PadrÃ£o gerado pela arquitetura
reg [3:0] user_input;       // PadrÃ£o inserido pelo usuÃ¡rio
reg [2:0] pattern_pos;      // PosiÃ§Ã£o atual no padrÃ£o
reg [2:0] correct_pos;      // PosiÃ§Ã£o correta no padrÃ£o

reg [2:0] rnd_sel;          // SeleÃ§Ã£o aleatÃ³ria de LEDs
reg [2:0] rnd_sel_count; // Contador para simular aleatoriedade
      
reg game_active;            // Indica se o jogo estÃ¡ ativo

// Contadores
reg [3:0] round_count;      // Conta as rodadas
reg [3:0] correct_count;    // Conta os acertos consecutivos

reg [26:0] count;           // Contador de tempo

always @(posedge osc_clk or posedge reset_n)
    begin
        if (reset_n)
            begin
                pattern <= 4'b0;
                user_input <= 4'b0;
                pattern_pos <= 3'b0;
                correct_pos <= 3'b0;
                rnd_sel <= 3'b0;
                count <= 0;
            end
        else 
            begin
                if (game_active)
                    begin
                        // Passo 1: Piscar cada LED do padrÃ£o
                        if (count == 26'd500000000 && round_count > 0) 
                            begin
                                count <= 0;
                                // LÃ³gica para fazer piscar cada LED do padrÃ£o
                                led <= pattern; // Acende todos os LEDs de acordo com o padrÃ£o
                                led <= 4'b0; // Desliga todos os LEDs
                                // Repete o processo para cada LED do padrÃ£o
                            end
                        count <= count + 1;
                        // Passo 2: Seleciona aleatoriamente e faz piscar um dos LEDs
                        if (round_count == 0) // Apenas na primeira rodada
                            begin
                                // Inicializa o contador limite
                                reg [1:0] loop_limit;
                                loop_limit = 4;

                                // Seleciona um LED com base no contador
                                rnd_sel = rnd_sel_count % 4;

                                // Limite de iterações para garantir a terminação do loop
                                while (pattern[rnd_sel] == 1 && loop_limit < 4)
                                begin
                                    rnd_sel_count <= rnd_sel_count + 1;
                                    rnd_sel = rnd_sel_count % 4;
                                    loop_limit = loop_limit - 1;
                                end

                                pattern[rnd_sel] <= 1; // Adiciona o LED ao padrão
                                pattern_pos <= 3'b0;
                            end
                    end
            end
    end
endmodule
