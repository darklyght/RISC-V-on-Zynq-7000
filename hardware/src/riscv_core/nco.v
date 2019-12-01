module nco #(
    parameter CPU_CLOCK_FREQ = 50_000_000
) (
    input clk,
    input rst,
    input [14:0] frequency,
    output [11:0] wave
);
    
    wire [17:0] phase;
    wire [11:0] sine_out;
    wire [11:0] sine_out_d;
    wire [3:0] sine_p;
    wire [3:0] sine_n;
    reg [2:0] sine_residue;
    reg [15:0] sine;
    
    phase_accumulator #(
        .CPU_CLOCK_FREQ(CPU_CLOCK_FREQ)
    ) pa (
        .clk(clk),
        .rst(rst),
        .frequency(frequency),
        .phase(phase)
    );
    
    sine_lut sine_lut (
        .clk(clk),
        .addr(phase[17:3]),
        .dout(sine_out)
    );
    
    sine_lut sine_lut_d (
        .clk(clk),
        .addr(phase[17:3] + 14'b1),
        .dout(sine_out_d)
    );

    always @ (posedge clk) begin
        if (rst)
            sine_residue <= 3'b0;
        else
            sine_residue <= phase[2:0];
    end
    
    assign sine_p = {1'b0, sine_residue};
    assign sine_n = 4'b1000 - sine_residue;
    
    always @ (posedge clk) begin
        if (rst)
            sine <= 16'b0;
        else
            sine <= sine_out * sine_n + sine_out_d * sine_p;
    end
    
    assign wave = sine[14:3];
    
endmodule