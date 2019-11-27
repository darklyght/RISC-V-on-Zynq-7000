`timescale 1ns/10ps

module pwm_testbench();
    parameter CPU_CLOCK_PERIOD = 8;
    parameter CPU_CLOCK_FREQ = 125_000_000;

    reg clk, rst;
    reg [3:0] buttons;
    reg [1:0] switches;
    wire FPGA_SERIAL_RX, FPGA_SERIAL_TX;
    wire [5:0] leds;
    wire aud_pwm, aud_sd;

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
    
    z1top (
        .CLK_125MHZ_FPGA(clk),
        .BUTTONS(buttons),
        .SWITCHES(switches),
        .LEDS(leds),
        .FPGA_SERIAL_RX(FPGA_SERIAL_RX),
        .FPGA_SERIAL_TX(FPGA_SERIAL_TX),
        .aud_pwm(aud_pwm),
        .aud_sd(aud_sd)
    );

    // Instantiate the off-chip UART
    uart # (
        .CLOCK_FREQ(CPU_CLOCK_FREQ)
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
    `define STRINGIFY_ECHO(x) `"x/../software/echo/echo.hex`"
    initial begin
        buttons[0] = 1;
        repeat (10000) @(posedge clk); #1;
        buttons[1] = 0;
        $readmemh("../../software/bios151v3/bios151v3.hex", z1top.cpu.bios_mem.mem);

        `ifndef IVERILOG
            $vcdpluson;
        `endif
        `ifdef IVERILOG
            $dumpfile("bios_testbench.fst");
            $dumpvars(0,bios_testbench);
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
                // Wait until off-chip UART's transmit is ready
                while (!data_in_ready) @(posedge clk); #1;
                data_in = 8'h12;
                data_in_valid = 1'b1;
                @(posedge clk); #1;
                data_in_valid = 1'b0;
                while (!data_in_ready) @(posedge clk); #1;
                data_in = 8'h34;
                data_in_valid = 1'b1;
                @(posedge clk); #1;
                data_in_valid = 1'b0;
                while (!data_in_ready) @(posedge clk); #1;
                data_in = 8'h56;
                data_in_valid = 1'b1;
                @(posedge clk); #1;
                data_in_valid = 1'b0;
            end
            begin
                repeat (50000) @(posedge clk);
                $finish();
            end
            begin
                data_out_ready = 1'b1;
                if (data_out_valid)
                    $display("Got %h", data_out);
            end
        join

        `ifndef IVERILOG
            $vcdplusoff;
        `endif
        $finish();
    end
endmodule
