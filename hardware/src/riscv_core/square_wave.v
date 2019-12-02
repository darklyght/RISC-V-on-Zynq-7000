module square_wave (
    input clk,
    input rst,
    input [14:0] phase,
    output reg [11:0] wave
);
    
    reg [11:0] out;
    
    always @ (posedge clk) begin
        if (phase <= 15'd16384)
            out <= 12'h7FC;
        else
            out <= 12'h804;
    end
    
    always @ (posedge clk) begin
        if (rst)
            wave <= 12'b0;
        else
            wave <= out;
    end
    
endmodule