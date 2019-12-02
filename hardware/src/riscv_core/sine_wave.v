module sine_wave (
    input clk,
    input rst,
    input [17:0] phase,
    output [11:0] wave
);
    
    wire [11:0] out;
    wire [11:0] out_d;
    wire [3:0] p;
    wire [3:0] n;
    reg [2:0] residue;
    reg [15:0] wave_reg;
    
    sine_lut sine_lut (
        .clk(clk),
        .addr(phase[17:3]),
        .dout(out)
    );
    
    sine_lut sine_lut_d (
        .clk(clk),
        .addr(phase[17:3] + 14'b1),
        .dout(out_d)
    );

    always @ (posedge clk) begin
        if (rst)
            residue <= 3'b0;
        else
            residue <= phase[2:0];
    end
    
    assign p = {1'b0, residue};
    assign n = 4'b1000 - residue;
    
    always @ (posedge clk) begin
        if (rst)
            wave_reg <= 16'b0;
        else
            wave_reg <= out * n + out_d * p;
    end
    
    assign wave = wave_reg[14:3];
    
endmodule