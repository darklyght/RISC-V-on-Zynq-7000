module triangle_wave (
    input clk,
    input rst,
    input [14:0] phase,
    output reg [11:0] wave
);
    
    wire [11:0] out;
    
    triangle_lut triangle_lut (
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