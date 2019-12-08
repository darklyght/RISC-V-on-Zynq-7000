module nco #(
    parameter CPU_CLOCK_FREQ = 50_000_000
) (
    input clk,
    input rst,
    input [23:0] increment_1,
    input [23:0] increment_2,
    input [23:0] increment_3,
    input [23:0] increment_4,
    input [4:0] sine_shift,
    input [4:0] square_shift,
    input [4:0] triangle_shift,
    input [4:0] sawtooth_shift,
    output reg [20:0] wave_1,
    output reg [20:0] wave_2,
    output reg [20:0] wave_3,
    output reg [20:0] wave_4,
    output reg valid
);
    
    wire [23:0] phase_1;
    wire [23:0] phase_2;
    wire [23:0] phase_3;
    wire [23:0] phase_4;
    wire pa_1_valid;
    wire pa_2_valid;
    wire pa_3_valid;
    wire pa_4_valid;
    wire [20:0] sine_out_1;
    wire [20:0] sine_out_2;    
    wire [20:0] sine_out_3;    
    wire [20:0] sine_out_4;
    wire [20:0] square_out_1;
    wire [20:0] square_out_2;
    wire [20:0] square_out_3;
    wire [20:0] square_out_4;
    wire [20:0] triangle_out_1;
    wire [20:0] triangle_out_2;
    wire [20:0] triangle_out_3;
    wire [20:0] triangle_out_4;
    wire [20:0] sawtooth_out_1;
    wire [20:0] sawtooth_out_2;
    wire [20:0] sawtooth_out_3;
    wire [20:0] sawtooth_out_4;
    
    wire sine_valid;
    wire triangle_valid;
    wire sawtooth_valid;
    wire square_valid;
    wire [20:0] wave_out_1;
    wire [20:0] wave_out_2;
    wire [20:0] wave_out_3;
    wire [20:0] wave_out_4;
    
    assign wave_out_1 = ($signed(sine_out_1) >>> sine_shift) + ($signed(square_out_1) >>> square_shift) + ($signed(triangle_out_1) >>> triangle_shift) + ($signed(sawtooth_out_1) >>> sawtooth_shift);
    assign wave_out_2 = ($signed(sine_out_2) >>> sine_shift) + ($signed(square_out_2) >>> square_shift) + ($signed(triangle_out_2) >>> triangle_shift) + ($signed(sawtooth_out_2) >>> sawtooth_shift);
    assign wave_out_3 = ($signed(sine_out_3) >>> sine_shift) + ($signed(square_out_3) >>> square_shift) + ($signed(triangle_out_3) >>> triangle_shift) + ($signed(sawtooth_out_3) >>> sawtooth_shift);
    assign wave_out_4 = ($signed(sine_out_4) >>> sine_shift) + ($signed(square_out_4) >>> square_shift) + ($signed(triangle_out_4) >>> triangle_shift) + ($signed(sawtooth_out_4) >>> sawtooth_shift);

    phase_accumulator #(
        .CPU_CLOCK_FREQ(CPU_CLOCK_FREQ)
    ) pa_1 (
        .clk(clk),
        .rst(rst),
        .increment(increment_1),
        .phase(phase_1),
        .valid(pa_1_valid)
    );

    phase_accumulator #(
        .CPU_CLOCK_FREQ(CPU_CLOCK_FREQ)
    ) pa_2 (
        .clk(clk),
        .rst(rst),
        .increment(increment_2),
        .phase(phase_2),
        .valid(pa_2_valid)
    );

    phase_accumulator #(
        .CPU_CLOCK_FREQ(CPU_CLOCK_FREQ)
    ) pa_3 (
        .clk(clk),
        .rst(rst),
        .increment(increment_3),
        .phase(phase_3),
        .valid(pa_3_valid)
    );

    phase_accumulator #(
        .CPU_CLOCK_FREQ(CPU_CLOCK_FREQ)
    ) pa_4 (
        .clk(clk),
        .rst(rst),
        .increment(increment_4),
        .phase(phase_4),
        .valid(pa_4_valid)
    );
    
    sine_wave sine_wave (
        .clk(clk),
        .rst(rst),
        .in_valid(pa_1_valid | pa_2_valid | pa_3_valid | pa_4_valid),
        .phase_1(phase_1),
        .phase_2(phase_2),
        .phase_3(phase_3),
        .phase_4(phase_4),
        .wave_1(sine_out_1),
        .wave_2(sine_out_2),
        .wave_3(sine_out_3),
        .wave_4(sine_out_4),
        .out_valid(sine_valid)
    );

    square_wave square_wave (
        .clk(clk),
        .rst(rst),
        .in_valid(pa_1_valid | pa_2_valid | pa_3_valid | pa_4_valid),
        .phase_1(phase_1),
        .phase_2(phase_2),
        .phase_3(phase_3),
        .phase_4(phase_4),
        .wave_1(square_out_1),
        .wave_2(square_out_2),
        .wave_3(square_out_3),
        .wave_4(square_out_4),
        .out_valid(square_valid)
    );
    
    triangle_wave triangle_wave (
        .clk(clk),
        .rst(rst),
        .in_valid(pa_1_valid | pa_2_valid | pa_3_valid | pa_4_valid),
        .phase_1(phase_1),
        .phase_2(phase_2),
        .phase_3(phase_3),
        .phase_4(phase_4),
        .wave_1(triangle_out_1),
        .wave_2(triangle_out_2),
        .wave_3(triangle_out_3),
        .wave_4(triangle_out_4),
        .out_valid(triangle_valid)
    );
    
    sawtooth_wave sawtooth_wave (
        .clk(clk),
        .rst(rst),
        .in_valid(pa_1_valid | pa_2_valid | pa_3_valid | pa_4_valid),
        .phase_1(phase_1),
        .phase_2(phase_2),
        .phase_3(phase_3),
        .phase_4(phase_4),
        .wave_1(sawtooth_out_1),
        .wave_2(sawtooth_out_2),
        .wave_3(sawtooth_out_3),
        .wave_4(sawtooth_out_4),
        .out_valid(sawtooth_valid)
    );
    
    always @ (posedge clk) begin
        if (rst) begin
            valid <= 1'b0;
            wave_1 <= 21'b0;
            wave_2 <= 21'b0;
            wave_3 <= 21'b0;
            wave_4 <= 21'b0;
        end else begin
            valid <= sine_valid & square_valid & triangle_valid & sawtooth_valid;
            if (sine_valid & square_valid & triangle_valid & sawtooth_valid) begin
                wave_1 <= wave_out_1;
                wave_2 <= wave_out_2;
                wave_3 <= wave_out_3;
                wave_4 <= wave_out_4;
            end
        end
    end
    
endmodule
