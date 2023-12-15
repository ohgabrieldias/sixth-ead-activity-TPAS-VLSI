`timescale 1ns/1ns

module tb_game_leds_x_buttons;

  parameter WIDTH = 3; // Define WIDTH as a local parameter

  reg osc_clk;
  reg reset_n;
  reg [WIDTH:0] button;
  wire [WIDTH:0] led;

  // Instantiate the module with a name (e.g., uut_inst)
  game_leds_x_buttons #(WIDTH) uut_inst (
    .osc_clk(osc_clk),
    .reset_n(reset_n),
    .button(button),
    .led(led)
  );

  // Clock generation
  initial begin
    osc_clk = 0;
    forever #5 osc_clk = ~osc_clk;
  end

  // Test scenario
  initial begin
    // Apply reset
    reset_n = 0;
    #10 reset_n = 1;

    // Wait for a few clock cycles
    #50;

    // Simulate button presses
    button = 3'b001; // Replace with your desired button sequence
    #100 button = 3'b010;
    #100 button = 3'b100;
    #100 button = 3'b110;

    // Add more test scenarios if needed

    // Run the simulation for a while
    #1000;

    // Print results
    $display("Generated Pattern: %b", uut_inst.padrao);
    $display("User Input Pattern: %b", uut_inst.entrada_usuario);
    $display("Number of Correct Digits: %d", uut_inst.qtd_digitos_corretos);

    $stop; // Stop the simulation
  end

endmodule
