`timescale 1ns/10ps

module z1top #(
    // A 125 MHz clock comes into the FPGA
    // It is declared as a parameter so the testbench can override it if desired
    parameter SYSTEM_CLOCK_FREQ = 125_000_000,
    parameter BAUD_RATE = 115_200,
    // Warning: changing the CPU_CLOCK_FREQ parameter doesn't actually change the clock frequency coming out of the PLL
    parameter CPU_CLOCK_FREQ = 50_000_000,
    /* verilator lint_off REALCVT */
    // Sample the button signal every 500us
    parameter integer B_SAMPLE_COUNT_MAX = 0.0005 * CPU_CLOCK_FREQ,
    // The button is considered 'pressed' after 100ms of continuous pressing
    parameter integer B_PULSE_COUNT_MAX = 0.100 / 0.0005,
    /* lint_on */
    // The PC the RISC-V CPU should start at after reset
    parameter RESET_PC = 32'h4000_0000
) (
    input CLK_125MHZ_FPGA,
    input [3:0] BUTTONS,
    input [1:0] SWITCHES,
    output [5:0] LEDS,
    input FPGA_SERIAL_RX,
    output FPGA_SERIAL_TX,
    output aud_pwm,
    output aud_sd
);
    assign LEDS = 6'b111111;
    wire cpu_clk, cpu_clk_g, cpu_clk_pll_lock;
    wire cpu_clk_pll_fb_out, cpu_clk_pll_fb_in;

    BUFG  cpu_clk_buf     (.I(cpu_clk),               .O(cpu_clk_g));
    BUFG  cpu_clk_f_buf   (.I(cpu_clk_pll_fb_out),    .O (cpu_clk_pll_fb_in));

    // This PLL generates the cpu_clk from the 125 Mhz clock
    /* verilator lint_off PINMISSING */
    PLLE2_ADV #(
        .BANDWIDTH            ("OPTIMIZED"),
        .COMPENSATION         ("BUF_IN"),  // Not "ZHOLD"
        .STARTUP_WAIT         ("FALSE"),
        .DIVCLK_DIVIDE        (5),
        .CLKFBOUT_MULT        (34),
        .CLKFBOUT_PHASE       (0.000),
        .CLKOUT0_DIVIDE       (17),
        .CLKOUT0_PHASE        (0.000),
        .CLKOUT0_DUTY_CYCLE   (0.500),
        .CLKIN1_PERIOD        (8.000)
    ) plle2_cpu_inst (
        .CLKFBOUT            (cpu_clk_pll_fb_out),
        .CLKOUT0             (cpu_clk),
        // Input clock control
        .CLKFBIN             (cpu_clk_pll_fb_in),
        .CLKIN1              (CLK_125MHZ_FPGA),
        .CLKIN2              (1'b0),
        // Tied to always select the primary input clock
        .CLKINSEL            (1'b1),
        // Other control and status signals
        .LOCKED              (cpu_clk_pll_lock),
        .PWRDWN              (1'b0),
        .RST                 (1'b0)
    );
    /* lint_on */

    wire pwm_clk, pwm_clk_g, pwm_clk_pll_lock;
    wire pwm_clk_pll_fb_out, pwm_clk_pll_fb_in;

    BUFG  pwm_clk_buf     (.I(pwm_clk),               .O(pwm_clk_g));
    BUFG  pwm_clk_f_buf   (.I(pwm_clk_pll_fb_out),    .O (pwm_clk_pll_fb_in));

    // This PLL generates the pwm_clk from the 125 Mhz clock
    /* verilator lint_off PINMISSING */
    PLLE2_ADV #(
        .BANDWIDTH            ("OPTIMIZED"),
        .COMPENSATION         ("BUF_IN"),  // Not "ZHOLD"
        .STARTUP_WAIT         ("FALSE"),
        .DIVCLK_DIVIDE        (5),
        .CLKFBOUT_MULT        (36),
        .CLKFBOUT_PHASE       (0.000),
        .CLKOUT0_DIVIDE       (6),
        .CLKOUT0_PHASE        (0.000),
        .CLKOUT0_DUTY_CYCLE   (0.500),
        .CLKIN1_PERIOD        (8.000)
    ) plle2_pwm_inst (
        .CLKFBOUT            (pwm_clk_pll_fb_out),
        .CLKOUT0             (pwm_clk), // 150 Mhz
        // Input clock control
        .CLKFBIN             (pwm_clk_pll_fb_in),
        .CLKIN1              (CLK_125MHZ_FPGA),
        .CLKIN2              (1'b0),
        // Tied to always select the primary input clock
        .CLKINSEL            (1'b1),
        // Other control and status signals
        .LOCKED              (pwm_clk_pll_lock),
        .PWRDWN              (1'b0),
        .RST                 (1'b0)
    );
    /* lint_on */

    // The global system reset is asserted when the RESET button is
    // pressed by the user or when the PLL isn't locked
    wire [2:0] clean_buttons;
    wire reset_button, reset;
    assign reset = reset_button || ~cpu_clk_pll_lock;

    button_parser #(
        .width(4),
        .sample_count_max(B_SAMPLE_COUNT_MAX),
        .pulse_count_max(B_PULSE_COUNT_MAX)
    ) b_parser (
        .clk(cpu_clk_g),
        .in(BUTTONS),
        .out({clean_buttons, reset_button})
    );

    wire cpu_tx, cpu_rx;
    Riscv151 #(
        .CPU_CLOCK_FREQ(CPU_CLOCK_FREQ),
        .RESET_PC(RESET_PC),
        .BAUD_RATE(BAUD_RATE)
    ) cpu (
        .clk(cpu_clk_g),
        .rst(reset),
        .FPGA_SERIAL_RX(cpu_rx),
        .FPGA_SERIAL_TX(cpu_tx)
    );

    (* IOB = "true" *) reg fpga_serial_tx_iob;
    (* IOB = "true" *) reg fpga_serial_rx_iob;
    assign FPGA_SERIAL_TX = fpga_serial_tx_iob;
    assign cpu_rx = fpga_serial_rx_iob;
    always @(posedge cpu_clk_g) begin
        fpga_serial_tx_iob <= cpu_tx;
        fpga_serial_rx_iob <= FPGA_SERIAL_RX;
    end

    // PWM Controller
    (* IOB = "true" *) reg pwm_iob;
    wire pwm_out, pwm_rst, reset_button_sync;
    synchronizer rst_pwm_sync(.async_signal(reset_button), .sync_signal(reset_button_sync), .clk(pwm_clk_g));
    assign aud_pwm = pwm_iob;
    assign aud_sd = 1'b1;
    always @(posedge pwm_clk_g) begin
        pwm_iob <= pwm_out;
    end
    assign pwm_out = 1'b0;
    assign pwm_rst = reset_button_sync || ~pwm_clk_pll_lock;
endmodule
