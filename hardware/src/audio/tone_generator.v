`timescale 1ns/1ns
module tone_generator (
    input clk,
    input rst,
    input output_enable,
    input [23:0] tone_switch_period,
    input volume,
    output square_wave_out
);
    // TODO: copy your solution from lab3 here
    assign square_wave_out = 1'b0;
endmodule
