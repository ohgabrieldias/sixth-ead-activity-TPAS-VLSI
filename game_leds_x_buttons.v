// # MIT License
// # Copyright (c) [2023] [Gabriel Rosa Dias] [Pedro Antonio]
// # See LICENSE file for full license text.


module game_leds_x_buttons #(parameter WIDTH = 3)(
    input osc_clk,           // Sinal de clock
    input reset_n,           // Sinal de reset
    input [WIDTH:0] button,      // Botões€ (um para cada LED)
    output reg [WIDTH:0] led   // LEDs (um para cada botão€)
  );

integer i = 0;


reg [15:0] entrada_usuario; // Entrada do usuário
reg [3:0] qtd_digitos_corretos;  // Quantidade de digitos corretos
reg [3:0] subconjunto;
reg [3:0] tmp;
reg [2:0] rnd_sel;          // Seleção de LEDs
reg [2:0] count_round;      // Contador de rodadas
reg [15:0] padrao;

// Quantidade de ciclos para 1s: 1/20 6 ciclos
reg [25:0] count;           // Contador de tempo para contar a 50000000
reg [15:0] lfsr;            // Linear Feedback Shift Register for random number generation
//wire resetBSN = 1'b1;

wire resetInv;
assign resetInv = ~reset_n;

always @(posedge osc_clk)
    begin
        if (resetInv)
            begin
                padrao <= 16'b1;
                subconjunto <= 4'b1111;
                count_round <= 3'b0;
                count <= 26'd0;
                lfsr <= 16'b0101010101010101; // Initial value for LFSR
                led <= 4'b1111;     // LEDs apagados
                i <= 0;
            end
        else
            if (count_round == 3'b0) 
                begin
                    if (count == 50000000 && i < 4)      // round 0 (gera padrão e mostra na placa, um padrão a cada 1 s)
                        begin
                            lfsr <= (lfsr ^ (lfsr << 5) ^ (lfsr >> 10))*13;
                            if(lfsr < 22000) begin
                                subconjunto <= 4'b1110;
                            end 
                            else if(lfsr > 22000 && lfsr < 34000)begin
                                subconjunto <= 4'b1101;
                            end
                            else if(lfsr > 34000 && lfsr < 45000) begin
                                subconjunto <= 4'b1011;
                            end
                            else begin
                                subconjunto <= 4'b0111;
                            end

                            // led = subconjunto;    // testar
                            padrao[i*4 +: 4] = subconjunto; // Atualiza a matriz de saÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â­da com o subconjunto
                            tmp =  padrao[i*4 +: 4];
                            led = tmp;
                            count <= 26'd0;     // Reset counter for 1s
                            i = i + 1;
                        end
                    else
                        count <= count + 1;
                        if (i == 4)
                            begin
                                count_round <= 3'b1;
                                count <= 26'd0;     // Reset counter for 1s
                            end
                end
            else if (count_round == 3'b1)
             begin
             led <= 4'b0000;
             i = 0;
        if (count == 50000000 && i < 4)  // round 1 (usuário tenta repetir o padrão, um padrão a cada 1 s)
            begin
                count <= 26'd0;  // Reset counter for 1s
                entrada_usuario[i*4 +: 4] <= button;
                // Blink the LED associated with the pressed button
                led[button] <= ~led[button];

                if (entrada_usuario[i*4 +: 4] == padrao[i*4 +: 4]) begin
                    qtd_digitos_corretos <= qtd_digitos_corretos + 1;
                end

                i = i + 1;
            end
        else
            begin
                count <= count + 1;
                count_round <= 3'b10;
                i = 0;
            end
      end

end
endmodule 
