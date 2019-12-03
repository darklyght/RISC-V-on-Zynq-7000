module dac_source_sel (
    input select,
    input [11:0] rv,
    input [11:0] wg,
    output [11:0] pwm
);

    assign pwm = select ? wg : rv;

endmodule
