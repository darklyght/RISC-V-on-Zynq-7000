`timescale 1ns/10ps
/* CHANGE THIS TO POINT TO YOUR CSR REGISTER (like isa_testbench.v) */
`define CSR_PATH CPU.wd

module c_testbench();
    parameter CPU_CLOCK_PERIOD = 20;
    parameter CPU_CLOCK_FREQ = 50_000_000;
    parameter BAUD_RATE = 10_000_000; // Fast baud rate for simulation

    reg clk, rst;
    wire FPGA_SERIAL_RX, FPGA_SERIAL_TX;

    reg   [7:0] data_in;
    reg         data_in_valid;
    wire        data_in_ready;
    wire  [7:0] data_out;
    wire        data_out_valid;
    reg         data_out_ready;

    initial clk = 0;
    always #(CPU_CLOCK_PERIOD/2) clk <= ~clk;

    // Instantiate your Riscv CPU here and connect the FPGA_SERIAL_TX wires
    // to the off-chip UART we use for testing. The CPU has a UART (on-chip UART) inside it.
    Riscv151 # (
        .CPU_CLOCK_FREQ(CPU_CLOCK_FREQ),
        .RESET_PC(32'h1000_0000),
        .BAUD_RATE(BAUD_RATE)
    ) CPU (
        .clk(clk),
        .rst(rst),
        .FPGA_SERIAL_RX(FPGA_SERIAL_RX),
        .FPGA_SERIAL_TX(FPGA_SERIAL_TX)
    );

    // Instantiate the off-chip UART
    uart # (
        .CLOCK_FREQ(CPU_CLOCK_FREQ),
        .BAUD_RATE(BAUD_RATE)
    ) off_chip_uart (
        .clk(clk),
        .reset(rst),
        .data_in(data_in),
        .data_in_valid(data_in_valid),
        .data_in_ready(data_in_ready),
        .data_out(data_out),
        .data_out_valid(data_out_valid),
        .data_out_ready(data_out_ready),
        .serial_in(FPGA_SERIAL_TX),
        .serial_out(FPGA_SERIAL_RX)
    );

    reg done = 0;
    integer cycle = 0;
    integer idx = 0;
    reg [7:0] str [0:3];
    assign str[0] = "x";
    assign str[1] = "y";
    assign str[2] = "z";
    assign str[3] = 8'h0d;
    integer csr_val = 0;
    initial begin
        $readmemh("../../software/c_test/c_test.hex", CPU.dmem.mem, 0, 16384-1);
        $readmemh("../../software/c_test/c_test.hex", CPU.imem.mem, 0, 16384-1);

        `ifndef IVERILOG
            $vcdpluson;
        `endif
        `ifdef IVERILOG
            $dumpfile("c_testbench.fst");
            $dumpvars(0,c_testbench);
        `endif

        // Reset all parts
        rst = 1'b0;
        data_in_valid = 1'b0;
        data_out_ready = 1'b0;

        repeat (20) @(posedge clk); #1;

        rst = 1'b1;
        repeat (30) @(posedge clk); #1;
        rst = 1'b0;

        fork
            begin
                // Receive the characters '151> ' from the UART
                repeat (5) begin
                    while (!data_out_valid) @(posedge clk); #1;
                    $display("Got %c", data_out);

                    data_out_ready = 1'b1;
                    @(posedge clk); #1;
                    data_out_ready = 1'b0;
                end

                // Send the characters 'x' 'y' 'z' '0d' to the CPU's UART
                repeat (4) begin
                    while (!data_in_ready) @(posedge clk); #1;

                    data_in = str[idx];
                    data_in_valid = 1'b1;
                    @(posedge clk); #1;
                    data_in_valid = 1'b0;
                    idx = idx + 1;

                    repeat (300) @(posedge clk); // Give the CPU time to process each character
                end

                while (`CSR_PATH === 32'd0) begin
                    @(posedge clk);
                end
                csr_val = `CSR_PATH;
                done = 1;
            end
            begin
                for (cycle = 0; cycle < 10000; cycle = cycle + 1) begin
                    if (done) begin
                        $display("Got CSR value: %d", csr_val);
                        $finish();
                    end
                    @(posedge clk);
                end
                if (!done) begin
                    $display("Failed: timing out");
                    $finish();
                end
            end
        join

        `ifndef IVERILOG
            $vcdplusoff;
        `endif
        $finish();
    end
endmodule
