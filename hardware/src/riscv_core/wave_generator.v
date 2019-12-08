module wave_generator #(
    parameter CPU_CLOCK_FREQ = 50_000_000
) (
    input clk,
    input rst,
    input global_reset,
    input [4:0] global_shift,
    input [4:0] sine_shift,
    input [4:0] square_shift,
    input [4:0] triangle_shift,
    input [4:0] sawtooth_shift,
    // Voice 1
    input [23:0] increment_1,
    input note_start_1,
    input note_release_1,
    input note_reset_1,
    output note_finished_1,
    // Voice 2
    input [23:0] increment_2,
    input note_start_2,
    input note_release_2,
    input note_reset_2,
    output note_finished_2,
    // Voice 3
    input [23:0] increment_3,
    input note_start_3,
    input note_release_3,
    input note_reset_3,
    output note_finished_3,
    // Voice 4
    input [23:0] increment_4,
    input note_start_4,
    input note_release_4,
    input note_reset_4,
    output note_finished_4,
    // Outputs
    output [11:0] wave,
    output valid
);
    wire nco_valid;
    wire [20:0] nco_1_wave;
    wire [20:0] adsr_1_wave;
    wire adsr_1_valid;
    wire [20:0] nco_2_wave;
    wire nco_2_valid;
    wire [20:0] adsr_2_wave;
    wire adsr_2_valid;
    wire [20:0] nco_3_wave;
    wire nco_3_valid;
    wire [20:0] adsr_3_wave;
    wire adsr_3_valid;
    wire [20:0] nco_4_wave;
    wire nco_4_valid;
    wire [20:0] adsr_4_wave;
    wire adsr_4_valid;
    reg [20:0] wave_sum;
    reg valid_sum;

    nco #(
        .CPU_CLOCK_FREQ(CPU_CLOCK_FREQ)
    ) nco (
        .clk(clk),
        .rst(rst),
        .increment_1(increment_1),
        .increment_2(increment_2),
        .increment_3(increment_3),
        .increment_4(increment_4),
        .sine_shift(sine_shift),
        .square_shift(square_shift),
        .triangle_shift(triangle_shift),
        .sawtooth_shift(sawtooth_shift),
        .wave_1(nco_1_wave),
        .wave_2(nco_2_wave),
        .wave_3(nco_3_wave),
        .wave_4(nco_4_wave),
        .valid(nco_valid)
    );

    adsr adsr_1 (
        .clk(clk),
        .rst(rst),
        .global_reset(global_reset),
        .in_valid(nco_valid),
        .wave_in(nco_1_wave),
        .note_start(note_start_1),
        .note_release(note_release_1),
        .note_reset(note_reset_1),
        .wave_out(adsr_1_wave),
        .note_finished(note_finished_1),
        .out_valid(adsr_1_valid)
    );

    adsr adsr_2 (
        .clk(clk),
        .rst(rst),
        .global_reset(global_reset),
        .in_valid(nco_valid),
        .wave_in(nco_2_wave),
        .note_start(note_start_2),
        .note_release(note_release_2),
        .note_reset(note_reset_2),
        .wave_out(adsr_2_wave),
        .note_finished(note_finished_2),
        .out_valid(adsr_2_valid)
    );

    adsr adsr_3 (
        .clk(clk),
        .rst(rst),
        .global_reset(global_reset),
        .in_valid(nco_valid),
        .wave_in(nco_3_wave),
        .note_start(note_start_3),
        .note_release(note_release_3),
        .note_reset(note_reset_3),
        .wave_out(adsr_3_wave),
        .note_finished(note_finished_3),
        .out_valid(adsr_3_valid)
    );

    adsr adsr_4 (
        .clk(clk),
        .rst(rst),
        .global_reset(global_reset),
        .in_valid(nco_valid),
        .wave_in(nco_4_wave),
        .note_start(note_start_4),
        .note_release(note_release_4),
        .note_reset(note_reset_4),
        .wave_out(adsr_4_wave),
        .note_finished(note_finished_4),
        .out_valid(adsr_4_valid)
    );

    always @ (posedge clk) begin
        if (rst) begin
            valid_sum <= 1'b0;
            wave_sum <= 21'b0;
        end else begin
            valid_sum <= adsr_1_valid | adsr_2_valid | adsr_3_valid | adsr_4_valid;
            if (adsr_1_valid | adsr_2_valid | adsr_3_valid | adsr_4_valid)
                wave_sum <= adsr_1_wave + adsr_2_wave + adsr_3_wave + adsr_4_wave;
        end
    end

    gain_and_truncate gain_and_truncate (
        .clk(clk),
        .rst(rst),
        .in_valid(valid_sum),
        .global_gain(global_shift),
        .wave_in(wave_sum),
        .wave_out(wave),
        .out_valid(valid)
    );
            
endmodule
