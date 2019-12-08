`timescale 1ns/10ps

module nco_testbench ();
    
    reg clk;
    reg rst;
    reg [23:0] increment_1;
    reg [23:0] increment_2;
    reg [23:0] increment_3;
    reg [23:0] increment_4;
    reg [4:0] sine_shift;
    reg [4:0] triangle_shift;
    reg [4:0] sawtooth_shift;
    reg [4:0] square_shift;
    wire [20:0] wave_1;
    wire [20:0] wave_2;
    wire [20:0] wave_3;
    wire [20:0] wave_4;    
    wire valid;
    
    nco #(
        .CPU_CLOCK_FREQ(50_000_000)
    ) dut (
        .clk(clk),
        .rst(rst),
        .increment_1(increment_1),
        .increment_2(increment_2),
        .increment_3(increment_3),
        .increment_4(increment_4),
        .sine_shift(sine_shift),
        .triangle_shift(triangle_shift),
        .sawtooth_shift(sawtooth_shift),
        .square_shift(square_shift),
        .wave_1(wave_1),
        .wave_2(wave_2),
        .wave_3(wave_3),
        .wave_4(wave_4),
        .valid(valid)
    );
    
    initial clk = 0;
    always #10 clk = ~clk;
    
    initial begin
        `ifndef IVERILOG
            $vcdpluson;
        `endif
        `ifdef IVERILOG
            $dumpfile("nco_testbench.fst");
            $dumpvars(0, nco_testbench);
        `endif
        
        sine_shift = 5'd31;
        triangle_shift = 5'd0;
        sawtooth_shift = 5'd31;
        square_shift = 5'd31;
        
        increment_1 = 23'd492_132;
        increment_2 = 23'd246_066;
        increment_3 = 23'd492_132;
        increment_4 = 23'd492_132;
        rst = 1;
        repeat (5) @(posedge clk);
        rst = 0;
        repeat (500000) @(posedge clk);
        $finish();
    end

endmodule
