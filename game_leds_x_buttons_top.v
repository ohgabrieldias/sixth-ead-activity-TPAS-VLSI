// # MIT License
// # Copyright (c) [2023] [Gabriel Rosa Dias] [Pedro Antonio]
// # See LICENSE file for full license text.

`timescale 1ns/1ns

module game_leds_x_buttons_top;

  // Parameters
  parameter WIDTH = 3;

  // Signals
  reg osc_clk;
  reg reset_n;
  reg [WIDTH:0] button;
  wire [WIDTH:0] led;
  

  // Instantiate the module
  game_leds_x_buttons #(WIDTH) uut (
    .osc_clk(osc_clk),
    .reset_n(reset_n),
    .button(button),
    .led(led)
  );

  // Clock generation
  initial begin
    osc_clk = 0;
    forever #10 osc_clk = ~osc_clk;
  end

  // Reset generation
  initial begin
    reset_n = 0;
    #10 reset_n = 1;
  end

  // Test scenario
  initial begin
    // Wait for a few cycles
    #20;

    // Apply some button inputs
    button = 4'b1001; // Change this value as needed
    #10 button = 4'b0010;
    #10 button = 4'b1000;
    #10 button = 4'b1101;

    // Add more test scenarios as needed

    // Finish the simulation after some time
    #1000 $finish;
  end

endmodule
