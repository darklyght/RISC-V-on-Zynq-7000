module sawtooth_wave (
    input clk,
    input rst,
    input [14:0] phase,
    output reg [11:0] wave
);
    
    wire [11:0] out;
    
    sawtooth_lut sawtooth_lut (
        .clk(clk),
        .addr(phase),
        .dout(out)
    );
    
    always @ (posedge clk) begin
        if (rst)
            wave <= 12'b0;
        else
            wave <= out;
    end
    
endmodule