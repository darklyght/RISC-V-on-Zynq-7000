`timescale 1ns/1ns
module svf_testbench ();
    
    reg clk;
    reg rst;
    reg [11:0] F;
    reg [11:0] Q;
    reg [11:0] x;
    wire [11:0] yh;
    wire [11:0] yb;
    wire [11:0] yl;
    wire [11:0] yn;
    
    integer inputs;
    
    svf dut (
        .clk(clk),
        .rst(rst),
        .F(F),
        .Q(Q),
        .x(x),
        .yh(yh),
        .yb(yb),
        .yl(yl),
        .yn(yn)
    );
    
    initial clk = 0;
    always #5 clk = ~clk;
        
    initial begin
        `ifndef IVERILOG
            $vcdpluson;
        `endif
        `ifdef IVERILOG
            $dumpfile("svf_testbench.fst");
            $dumpvars(0, svf_testbench);
        `endif
        
        inputs = $fopen("../../scripts/waves.bin","r");
        
        rst = 1;
        F = 12'b0111_1111_1111;
        Q = 12'b0111_1111_1111;
        x = 12'b0;
        repeat(5) @(posedge clk);
        rst = 0;
        while (!$feof(inputs)) begin
            $fscanf(inputs,"%b\n", x);
            @(posedge clk);
        end
        $finish();
    end
    
endmodule