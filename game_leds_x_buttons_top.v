module game_leds_x_buttons_top #(parameter WIDTH = 3)(
    input osc_clk,    // Clock input
    input reset_n,    // Reset input
    input [WIDTH:0] button, // Button input
    output reg [WIDTH:0] led // LED output
);

// Instantiate the game module
game_leds_x_buttons #(WIDTH) game_inst (
    .osc_clk(osc_clk),
    .reset_n(reset_n),
    .button(button),
    .led(led)
);

endmodule
