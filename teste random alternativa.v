module RandomSimulator(
  input wire clk,
  output wire [3:0] random_value
);
  reg [2:0] count;
  reg [3:0] shift_register;

  always @(posedge clk) begin
    // Pode ajustar o valor 2 para obter uma sequência de bits diferente
    count <= count + 1;
    
    // Desloca o registrador para a esquerda
    shift_register <= {shift_register[2:0], count[0]};
    
    // Atribui o valor atual do registrador como saída
    random_value <= shift_register;
  end

endmodule
