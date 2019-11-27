`timescale 1ns/10ps

module nco_testbench ();
    
    reg clk;
    reg rst;
    reg [14:0] frequency;
    wire [11:0] wave;
    
    nco dut (
        .clk(clk),
        .rst(rst),
        .frequency(frequency),
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
        
        $readmemh("../../scripts/sine_lut.hex", dut.sine_lut.mem);
        $readmemh("../../scripts/sine_lut.hex", dut.sine_lut_d.mem);
        
        frequency = 15'd20000;
        rst = 1;
        repeat (5) @(posedge clk);
        rst = 0;
        repeat (10000) @(posedge clk);
        $finish();
    end

endmodule