`timescale 1ns/10ps

module wave_generator_testbench ();
    
    reg clk;
    reg rst;
    reg global_reset;
    reg [4:0] sine_shift;
    reg [4:0] square_shift;
    reg [4:0] triangle_shift;
    reg [4:0] sawtooth_shift;
    reg [4:0] global_shift;
    reg [23:0] increment_1;
    reg note_start_1;
    reg note_release_1;
    reg note_reset_1;
    wire note_finished_1;
    reg [23:0] increment_2;
    reg note_start_2;
    reg note_release_2;
    reg note_reset_2;
    wire note_finished_2;
    reg [23:0] increment_3;
    reg note_start_3;
    reg note_release_3;
    reg note_reset_3;
    wire note_finished_3;
    reg [23:0] increment_4;
    reg note_start_4;
    reg note_release_4;
    reg note_reset_4;
    wire note_finished_4;
    wire [11:0] wave;
    wire valid;
    
    wave_generator #(
        .CPU_CLOCK_FREQ(50_000_000)
    ) dut (
        .clk(clk),
        .rst(rst),
        .global_reset(global_reset),
        .sine_shift(sine_shift),
        .square_shift(square_shift),
        .triangle_shift(triangle_shift),
        .sawtooth_shift(sawtooth_shift),
        .global_shift(global_shift),
        .increment_1(increment_1),
        .note_start_1(note_start_1),
        .note_release_1(note_release_1),
        .note_reset_1(note_reset_1),
        .note_finished_1(note_finished_1),
        .increment_2(increment_2),
        .note_start_2(note_start_2),
        .note_release_2(note_release_2),
        .note_reset_2(note_reset_2),
        .note_finished_2(note_finished_2),
        .increment_3(increment_3),
        .note_start_3(note_start_3),
        .note_release_3(note_release_3),
        .note_reset_3(note_reset_3),
        .note_finished_3(note_finished_3),
        .increment_4(increment_4),
        .note_start_4(note_start_4),
        .note_release_4(note_release_4),
        .note_reset_4(note_reset_4),
        .note_finished_4(note_finished_4),
        .wave(wave),
        .valid(valid)
    );
    
    initial clk = 0;
    always #10 clk = ~clk;
    
    initial begin
        `ifndef IVERILOG
            $vcdpluson;
        `endif
        `ifdef IVERILOG
            $dumpfile("wave_generator_testbench.fst");
            $dumpvars(0, wave_generator_testbench);
        `endif
        
        global_reset = 1'b0;
        sine_shift = 5'd0;
        square_shift = 5'd31;
        triangle_shift = 5'd31;
        sawtooth_shift = 5'd31;
        global_shift = 5'd1;
        increment_1 = 24'd225280;
        note_start_1 = 1'b1;
        note_release_1 = 1'b0;
        note_reset_1 = 1'b0;
        increment_2 = 24'd450560;
        note_start_2 = 1'b1;
        note_release_2 = 1'b0;
        note_reset_2 = 1'b0;
        increment_3 = 24'd0;
        note_start_3 = 1'b0;
        note_release_3 = 1'b0;
        note_reset_3 = 1'b0;
        increment_4 = 24'd0;
        note_start_4 = 1'b0;
        note_release_4 = 1'b0;
        note_reset_4 = 1'b0;
        rst = 1;
        repeat (5) @(posedge clk);
        rst = 0;
        repeat (1000000) @(posedge clk);
        note_release_1 = 1'b1;
        repeat (1000000) @(posedge clk);
        $finish();
    end

endmodule
