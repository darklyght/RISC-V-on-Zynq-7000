`timescale 1ns/10ps

module wave_generator_testbench ();
    
    reg clk;
    reg rst;
    reg [14:0] frequency;
    reg [2:0] sine_weight;
    reg [2:0] triangle_weight;
    reg [2:0] sawtooth_weight;
    reg [2:0] square_weight;
    reg [11:0] F;
    reg [11:0] Q;
    reg [1:0] select;
    reg press;
    reg [11:0] rise_time;
    reg [11:0] fall_time;
    wire [11:0] wave;
    
    wave_generator #(
        .CPU_CLOCK_FREQ(100_000_000)
    ) dut (
        .clk(clk),
        .rst(rst),
        .frequency(frequency),
        .sine_weight(sine_weight),
        .triangle_weight(triangle_weight),
        .sawtooth_weight(sawtooth_weight),
        .square_weight(square_weight),
        .F(F),
        .Q(Q),
        .select(select),
        .press(press),
        .rise_time(rise_time),
        .fall_time(fall_time),
        .wave(wave)  
    );
    
    initial clk = 0;
    always #5 clk = ~clk;
    
    initial begin
        `ifndef IVERILOG
            $vcdpluson;
        `endif
        `ifdef IVERILOG
            $dumpfile("wave_generator_testbench.fst");
            $dumpvars(0, wave_generator_testbench);
        `endif
        
        sine_weight = 3'd0;
        triangle_weight = 3'd0;
        sawtooth_weight = 3'd0;
        square_weight = 3'd4;
        F = 12'b0010_0000_0000;
        Q = 12'b0100_0000_0000;
        select = 2'b00;
        press = 1'b1;
        rise_time = 12'd200;
        fall_time = 12'd200;
        
        frequency = 15'd2000;
        rst = 1;
        repeat (5) @(posedge clk);
        rst = 0;
        repeat (1000000) @(posedge clk);
        $finish();
    end

endmodule