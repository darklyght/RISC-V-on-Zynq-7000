module wave_generator #(
    parameter CPU_CLOCK_FREQ = 50_000_000
) (
    input clk,
    input rst,
    // NCO parameters
    input [14:0] frequency,
    input [2:0] sine_weight,
    input [2:0] triangle_weight,
    input [2:0] sawtooth_weight,
    input [2:0] square_weight,
    // SVF parameters
    input [11:0] F,
    input [11:0] Q,
    // Band select
    input [1:0] select,
    // ADSR parameters
    input press,
    input [11:0] rise_time,
    input [11:0] fall_time,
    // Output wave
    output [11:0] wave
);

    wire [11:0] nco_out;
    wire [11:0] svf_yh;
    wire [11:0] svf_yb;
    wire [11:0] svf_yl;
    wire [11:0] svf_yn;
    wire [11:0] band_select_out;
    wire [11:0] adsr_out;
    wire nco_en;
    wire svf_en;
    wire bs_en;
    
    nco #(
        .CPU_CLOCK_FREQ(CPU_CLOCK_FREQ)
    ) nco (
        .clk(clk),
        .rst(rst),
        .frequency(frequency),
        .sine_weight(sine_weight),
        .triangle_weight(triangle_weight),
        .sawtooth_weight(sawtooth_weight),
        .square_weight(square_weight),
        .wave(nco_out),
        .en(nco_en)
    );
    
    svf svf (  
        .clk(clk),
        .rst(rst),
        .en_in(nco_en),
        .F(F),
        .Q(Q),
        .x(nco_out),
        .yh(svf_yh),
        .yb(svf_yb),
        .yl(svf_yl),
        .yn(svf_yn),
        .en_out(svf_en)
    );
    
    band_select bs (
        .clk(clk),
        .rst(rst),
        .en_in(svf_en),
        .select(select),
        .yh(svf_yh),
        .yb(svf_yb),
        .yl(svf_yl),
        .yn(svf_yn),
        .wave_out(band_select_out),
        .en_out(bs_en)
    );
    
    adsr adsr (
        .clk(clk),
        .rst(rst),
        .en(bs_en),
        .press(press),
        .rise_time(rise_time),
        .fall_time(fall_time),
        .wave_in(band_select_out),
        .wave_out(wave)
    );

endmodule