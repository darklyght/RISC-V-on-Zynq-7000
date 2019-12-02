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
    output reg [11:0] wave,
    output reg en
);
    
    wire [17:0] phase;
    wire pa_en;
    reg [1:0] pa_en_sync;
    wire [11:0] sine_out;
    wire [11:0] triangle_out;
    wire [11:0] sawtooth_out;
    wire [11:0] square_out;
    wire [15:0] wave_out;
    wire [3:0] sine_weight_e;
    wire [3:0] triangle_weight_e;
    wire [3:0] sawtooth_weight_e;
    wire [3:0] square_weight_e;
    
    assign sine_weight_e = {1'b0, sine_weight};
    assign triangle_weight_e = {1'b0, triangle_weight};
    assign sawtooth_weight_e = {1'b0, sawtooth_weight};
    assign square_weight_e = {1'b0, square_weight};
    assign wave_out = $signed(sine_weight_e) * $signed(sine_out) + $signed(triangle_weight_e) * $signed(triangle_out) + $signed(sawtooth_weight_e) * $signed(sawtooth_out) + $signed(square_weight_e) * $signed(square_out);
    
    always @ (posedge clk) begin
        pa_en_sync <= {pa_en_sync[0], pa_en};
    end
    
    always @ (posedge clk) begin
        en <= pa_en_sync[1];
    end
    
    phase_accumulator #(
        .CPU_CLOCK_FREQ(CPU_CLOCK_FREQ)
    ) pa (
        .clk(clk),
        .rst(rst),
        .frequency(frequency),
        .phase(phase),
        .en(pa_en)
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
            if (pa_en_sync[1])
                wave <= wave_out[13:2];
    end
    
endmodule