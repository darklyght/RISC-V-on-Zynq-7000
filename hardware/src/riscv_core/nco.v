module nco #(
    parameter CPU_CLOCK_FREQ = 50_000_000
) (
    input clk,
    input rst,
    input [14:0] frequency,
    input [2:0] sine_weight,
    input [2:0] triangle_weight,
    input [2:0] sawtooth_weight,
    input [2:0] square_weight,
    output reg [11:0] wave
);
    
    wire [17:0] phase;
    wire [11:0] sine_out;
    wire [11:0] triangle_out;
    wire [11:0] sawtooth_out;
    wire [11:0] square_out;
    wire [14:0] wave_out;
    
    assign wave_out = sine_weight * sine_out + triangle_weight * triangle_out + sawtooth_weight * sawtooth_out + square_weight * square_out;
    
    phase_accumulator #(
        .CPU_CLOCK_FREQ(CPU_CLOCK_FREQ)
    ) pa (
        .clk(clk),
        .rst(rst),
        .frequency(frequency),
        .phase(phase)
    );
    
    sine_wave sine_wave (
        .clk(clk),
        .rst(rst),
        .phase(phase),
        .wave(sine_out)
    );
    
    triangle_wave triangle_wave (
        .clk(clk),
        .rst(rst),
        .phase(phase[17:3]),
        .wave(triangle_out)
    );
    
    sawtooth_wave sawtooth_wave (
        .clk(clk),
        .rst(rst),
        .phase(phase[17:3]),
        .wave(sawtooth_out)
    );
    
    square_wave square_wave (
        .clk(clk),
        .rst(rst),
        .phase(phase[17:3]),
        .wave(square_out)
    );
    
    always @ (posedge clk) begin
        if (rst)
            wave <= 12'b0;
        else
            wave <= wave_out[13:2];
    end
    
endmodule