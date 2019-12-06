`timescale 1ns/10ps

module nco_testbench ();
    
    reg clk;
    reg rst;
    reg [23:0] increment;
    reg [4:0] sine_shift;
    reg [4:0] triangle_shift;
    reg [4:0] sawtooth_shift;
    reg [4:0] square_shift;
    wire [20:0] wave;
    wire valid;
    
    nco #(
        .CPU_CLOCK_FREQ(100_000_000)
    ) dut (
        .clk(clk),
        .rst(rst),
        .increment(increment),
        .sine_shift(sine_shift),
        .triangle_shift(triangle_shift),
        .sawtooth_shift(sawtooth_shift),
        .square_shift(square_shift),
        .wave(wave),
        .valid(valid)
    );
    
    initial clk = 0;
    always #5 clk = ~clk;
    
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
        
        increment = 23'd1_024_000;
        rst = 1;
        repeat (5) @(posedge clk);
        rst = 0;
        repeat (5000000) @(posedge clk);
        $finish();
    end

endmodule
