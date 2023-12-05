module game_leds_x_buttons (
    input osc_clk,           // Sinal de clock
    input reset_n,           // Sinal de reset
    input [3:0] button,      // BotÃµes (um para cada LED)
    output reg [3:0] led    // LEDs (um para cada botÃ£o)
);

reg [15:0] pattern;
reg [3:0] subconjunto;
reg [2:0] rnd_sel;          // Seleção aleatória de LEDs

// Clock com uma frequência de 1/50 MHz=T  T=20×10 −9s
// Quantidade de ciclos para 1s: 1/20×10 −9s=50×10 6 ciclos
reg [25:0] count;           // Contador de tempo para contar até 50000000

always @(posedge osc_clk or posedge reset_n)
    begin
        if (reset_n)
            begin
                pattern <= 4'b0;
                subconjunto <= 4'b0;
            end
        else
            for (int i = 0; i < 4; i = i + 1)
                begin
                    rnd_sel = $urandom_range(0, 3);; // Seleciona um LED aleatoriamente
                    subconjunto[rnd_sel] = 1; // Seleciona um LED aleatoriamente
                    // Faça algo com o subconjunto de 4 bits aqui
                    pattern[i*4 +: 4] = subconjunto; // Atualiza a matriz de saída com o subconjunto
                end
    end

endmodule