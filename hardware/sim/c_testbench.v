`timescale 1ns/10ps

/* MODIFY THIS LINE WITH THE HIERARCHICAL PATH TO YOUR REGFILE ARRAY INDEXED WITH reg_number */
`define REGFILE_ARRAY_PATH CPU.rf.registers[reg_number]

module c_testbench();
    reg clk, rst;
    parameter CPU_CLOCK_PERIOD = 20;
    parameter CPU_CLOCK_FREQ = 50_000_000;

    initial clk = 0;
    always #(CPU_CLOCK_PERIOD/2) clk <= ~clk;

    Riscv151 # (
        .CPU_CLOCK_FREQ(CPU_CLOCK_FREQ)
    ) CPU(
        .clk(clk),
        .rst(rst),
        .FPGA_SERIAL_RX(),
        .FPGA_SERIAL_TX()
    );

    // A task to check if the value contained in a register equals an expected value
    task check_reg;
        input [4:0] reg_number;
        input [31:0] expected_value;
        input [10:0] test_num;
        if (expected_value !== `REGFILE_ARRAY_PATH) begin
            $display("FAIL - test %d, got: %d, expected: %d for reg %d", test_num, `REGFILE_ARRAY_PATH, expected_value, reg_number);
            $finish();
        end
        else begin
            $display("PASS - test %d, got: %d for reg %d", test_num, expected_value, reg_number);
        end
    endtask

    // A task that runs the simulation until a register contains some value
    task wait_for_reg_to_equal;
        input [4:0] reg_number;
        input [31:0] expected_value;
        while (`REGFILE_ARRAY_PATH !== expected_value) @(posedge clk);
    endtask

    reg done = 0;
    `define STRINGIFY_ASM(x) `"x/../software/assembly_tests/assembly_tests.hex`"
    initial begin
        $readmemh("../../software/bios151v3/bios151v3.hex", CPU.bios_mem.mem);

        `ifndef IVERILOG
            $vcdpluson;
        `endif
        `ifdef IVERILOG
            $dumpfile("c_testbench.fst");
            $dumpvars(0,c_testbench);
            $dumpvars(0,CPU.rf.registers[1]);
            $dumpvars(0,CPU.rf.registers[2]);
            $dumpvars(0,CPU.rf.registers[14]);
            $dumpvars(0,CPU.rf.registers[15]);
        `endif

        rst = 0;

        // Reset the CPU
        rst = 1;
        repeat (30) @(posedge clk);             // Hold reset for 30 cycles
        rst = 0;

        repeat(100000) @ (posedge clk);
        $finish;

        `ifndef IVERILOG
            $vcdplusoff;
        `endif
        $finish();
    end
endmodule
