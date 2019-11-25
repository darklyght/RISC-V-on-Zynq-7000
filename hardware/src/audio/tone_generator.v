`timescale 1ns/1ns
module tone_generator (
    input clk,
    input rst,
    input output_enable,
    input [23:0] tone_switch_period,
    input volume,
    output square_wave_out
);
    reg square_wave_reg = 1'b0;
    reg [1:0] volume_reg = 2'b0;
    reg [22:0] count_reg = 23'b0;
    
    wire duty_cycle;
    
    always @ (posedge clk) begin
        if (rst == 1'b1) begin
            square_wave_reg <= 1'b0;
            volume_reg <= 2'b0;
            count_reg <= 23'b0;
        // Controls period
        end else if (output_enable == 1'b1) begin
            if (tone_switch_period == 0) begin
                square_wave_reg <= 1'b0;
                count_reg <= 23'b0;
            end else if (count_reg >= tone_switch_period >> 1) begin
                square_wave_reg <= ~square_wave_reg;
                count_reg <= 23'b0;
            end else begin
                count_reg <= count_reg + 1;
            end
        end else begin
            square_wave_reg <= 1'b0;
            count_reg <= 23'b0;
        end
        
        // Controls volume
        volume_reg <= volume_reg + 1;
    end
    
    assign duty_cycle = volume ? volume_reg == 2'b00 || volume_reg == 2'b01 : volume_reg == 2'b00;
    assign square_wave_out = output_enable ? duty_cycle && (square_wave_reg == 1'b1) : 1'b0;
endmodule
