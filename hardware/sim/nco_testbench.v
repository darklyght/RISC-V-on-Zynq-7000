`timescale 1ns/10ps

module nco_testbench ();
    
    reg clk;
    reg rst;
    reg [14:0] frequency;
    reg [2:0] sine_weight;
    reg [2:0] triangle_weight;
    reg [2:0] sawtooth_weight;
    reg [2:0] square_weight;
    wire [11:0] wave;
    
    nco #(
        .CPU_CLOCK_FREQ(100_000_000)
    ) dut (
        .clk(clk),
        .rst(rst),
        .frequency(frequency),
        .sine_weight(sine_weight),
        .triangle_weight(triangle_weight),
        .sawtooth_weight(sawtooth_weight),
        .square_weight(square_weight),
        .wave(wave)  
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
        
        sine_weight = 3'd0;
        triangle_weight = 3'd0;
        sawtooth_weight = 3'd2;
        square_weight = 3'd2;       
        
        frequency = 15'd20000;
        rst = 1;
        repeat (5) @(posedge clk);
        rst = 0;
        repeat (10000) @(posedge clk);
        $finish();
    end

endmodule