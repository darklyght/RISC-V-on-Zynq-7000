`timescale 1ns/10ps

module echo_integration_testbench ();
    parameter SYSTEM_CLK_PERIOD = 8;
    parameter SYSTEM_CLK_FREQ = 125_000_000;

    reg sys_clk = 0;
    reg sys_rst = 0;
    always #(SYSTEM_CLK_PERIOD/2) sys_clk <= ~sys_clk;

    // UART Signals between the on-chip and off-chip UART
    wire FPGA_SERIAL_RX, FPGA_SERIAL_TX;

    // Off-chip UART Ready/Valid interface
    reg   [7:0] data_in;
    reg         data_in_valid;
    wire        data_in_ready;
    wire  [7:0] data_out;
    wire        data_out_valid;
    reg         data_out_ready;

    z1top #(
        .SYSTEM_CLOCK_FREQ(SYSTEM_CLK_FREQ),
        .B_SAMPLE_COUNT_MAX(5),
        .B_PULSE_COUNT_MAX(5)
    ) top (
        .CLK_125MHZ_FPGA(sys_clk),
        .BUTTONS({3'b0, sys_rst}),
        .SWITCHES(2'b0),
        .LEDS(),
        .FPGA_SERIAL_RX(FPGA_SERIAL_RX),
        .FPGA_SERIAL_TX(FPGA_SERIAL_TX)
    );

    // Instantiate the off-chip UART
    uart # (
        .CLOCK_FREQ(SYSTEM_CLK_FREQ)
    ) off_chip_uart (
        .clk(sys_clk),
        .reset(sys_rst),
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
    reg [31:0] cycle = 0;
    initial begin
        $readmemh("../../software/echo/echo.hex", top.cpu.bios_mem.mem, 0, 4095);

        `ifndef IVERILOG
            $vcdpluson;
        `endif
        `ifdef IVERILOG
            $dumpfile("echo_integration_testbench.fst");
            $dumpvars(0,echo_integration_testbench);
        `endif

        // Reset all parts
        sys_rst = 1'b0;
        data_in = 8'h7a;
        data_in_valid = 1'b0;
        data_out_ready = 1'b0;

        repeat (20) @(posedge sys_clk); #1;

        sys_rst = 1'b1;
        repeat (50) @(posedge sys_clk); #1;
        sys_rst = 1'b0;

        fork
            begin
                // Wait until off-chip UART's transmit is ready
                while (!data_in_ready) @(posedge sys_clk); #1;

                // Send a UART packet to the CPU from the off-chip UART
                data_in_valid = 1'b1;
                @(posedge sys_clk); #1;
                data_in_valid = 1'b0;

                // Watch data_in (7A) be sent over FPGA_SERIAL_RX to the CPU's on-chip UART

                // The echo program running on the CPU is polling the memory mapped register (0x80000000)
                // and waiting for data_out_valid of the on-chip UART to become 1. Once it does, the echo program
                // performs a load from memory mapped register (0x80000004) to fetch the data that the on-chip UART
                // received from the off-chip UART. Then, the same data is stored to memory mapped register (0x80000008),
                // which should command the on-chip UART's transmitter to send the same data back to the off-chip UART.

                // Wait for the off-chip UART to receive the echoed data
                while (!data_out_valid) @(posedge sys_clk); #1;
                $display("Got %h", data_out);

                // Clear the off-chip UART's receiver for another UART packet
                data_out_ready = 1'b1;
                @(posedge sys_clk); #1;
                data_out_ready = 1'b0;
                done = 1;
            end
            begin
                for (cycle = 0; cycle < 100000; cycle = cycle + 1) begin
                    if (done) $finish();
                    @(posedge sys_clk);
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
