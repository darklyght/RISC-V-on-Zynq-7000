module nco #(
    parameter CPU_CLOCK_FREQ = 50_000_000
) (
    input clk,
    input rst,
    input [23:0] increment,
    input [4:0] sine_shift,
    input [4:0] square_shift,
    input [4:0] triangle_shift,
    input [4:0] sawtooth_shift,
    output reg [20:0] wave,
    output reg valid
);
    
    wire [11:0] phase;
    wire pa_valid;
    reg [1:0] pa_en_sync;
    wire [20:0] sine_out;
    wire sine_valid;
    wire [20:0] triangle_out;
    wire triangle_valid;
    wire [20:0] sawtooth_out;
    wire sawtooth_valid;
    wire [20:0] square_out;
    wire square_valid;
    wire [20:0] wave_out;
    
    assign wave_out = ($signed(sine_out) >>> sine_shift) + ($signed(square_out) >>> square_shift) + ($signed(triangle_out) >>> triangle_shift) + ($signed(sawtooth_out) >>> sawtooth_shift);

    phase_accumulator #(
        .CPU_CLOCK_FREQ(CPU_CLOCK_FREQ)
    ) pa (
        .clk(clk),
        .rst(rst),
        .increment(increment),
        .phase(phase),
        .valid(pa_valid)
    );
    
    sine_wave sine_wave (
        .clk(clk),
        .rst(rst),
        .in_valid(pa_valid),
        .phase(phase),
        .wave(sine_out),
        .out_valid(sine_valid)
    );

    square_wave square_wave (
        .clk(clk),
        .rst(rst),
        .in_valid(pa_valid),
        .phase(phase),
        .wave(square_out),
        .out_valid(square_valid)
    );
    
    triangle_wave triangle_wave (
        .clk(clk),
        .rst(rst),
        .in_valid(pa_valid),
        .phase(phase),
        .wave(triangle_out),
        .out_valid(triangle_valid)
    );
    
    sawtooth_wave sawtooth_wave (
        .clk(clk),
        .rst(rst),
        .in_valid(pa_valid),
        .phase(phase),
        .wave(sawtooth_out),
        .out_valid(sawtooth_valid)
    );
    
    always @ (posedge clk) begin
        if (rst) begin
            valid <= 1'b0;
            wave <= 21'b0;
        end else begin
            valid <= sine_valid & square_valid & triangle_valid & sawtooth_valid;
            if (sine_valid & square_valid & triangle_valid & sawtooth_valid)
                wave <= wave_out;
        end
    end
    
endmodule
