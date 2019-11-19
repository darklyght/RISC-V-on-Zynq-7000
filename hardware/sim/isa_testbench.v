`timescale 1ns/10ps

/* MODIFY THIS LINE WITH THE HIERARCHICAL PATH TO YOUR tohost (0x51e) CSR */
`define CSR_PATH CPU.wd

module isa_testbench();
    reg clk, rst;
    parameter CPU_CLOCK_PERIOD = 20;
    parameter CPU_CLOCK_FREQ = 50_000_000;

    initial clk = 0;
    always #(CPU_CLOCK_PERIOD/2) clk <= ~clk;

    Riscv151 # (
        .CPU_CLOCK_FREQ(CPU_CLOCK_FREQ),
        .RESET_PC(32'h1000_0000)
    ) CPU(
        .clk(clk),
        .rst(rst),
        .FPGA_SERIAL_RX(),
        .FPGA_SERIAL_TX()
    );

    reg done = 0;
    reg [31:0] cycle = 0;
    string hex_file;
    string test_name;
    initial begin
        $value$plusargs("hex_file=%s", hex_file);
        $value$plusargs("test_name=%s", test_name);
        $readmemh(hex_file, CPU.dmem.mem);
        $readmemh(hex_file, CPU.imem.mem);

        `ifndef IVERILOG
            $vcdpluson;
        `endif
        `ifdef IVERILOG
            $dumpfile({test_name, ".fst"});
            $dumpvars(0,isa_testbench);
        `endif

        rst = 0;

        // Reset the CPU
        rst = 1;
        repeat (30) @(posedge clk); #1;             // Hold reset for 30 cycles
        rst = 0;

        fork
            begin
                while (`CSR_PATH[0] !== 1'b1) begin
                    @(posedge clk);
                end
                done = 1;
            end
            begin
                for (cycle = 0; cycle < 10000; cycle = cycle + 1) begin
                    if (!done) @(posedge clk);
                end
                if (!done) begin
                    $display("FAIL - %s. Timing out", test_name);
                    $finish();
                end
            end
        join
        if (`CSR_PATH[0] === 1'b1 && `CSR_PATH[31:1] === 31'd0) begin
            $display("PASS - %s", test_name);
        end else begin
            $display("FAIL - %s. Failed test: %d", test_name, `CSR_PATH[31:1]);
        end

        `ifndef IVERILOG
            $vcdplusoff;
        `endif
        $finish();
    end
endmodule
