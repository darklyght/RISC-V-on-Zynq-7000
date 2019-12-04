module square_wave (
    input clk,
    input rst,
    input in_valid,
    input [11:0] phase,
    output reg [20:0] wave,
    output reg out_valid
);
    
    reg [20:0] out;
    reg valid_reg;
    
    always @ (posedge clk) begin
        if (rst) begin
            valid_reg <= 1'b0;
            out <= 21'b0;
        end else begin
            valid_reg <= in_valid;
            if (in_valid) begin
                if (phase <= 12'd2048)
                    out <= 21'b0_0001_0000_0000_0000_0000;
                else
                    out <= 21'b1_1111_0000_0000_0000_0000;
            end
        end
    end
    
    always @ (posedge clk) begin
        if (rst) begin
            out_valid <= 1'b0;
            wave <= 21'b0;
        end else begin
            out_valid <= valid_reg;
            if (valid_reg)
                wave <= out;
        end
    end
    
endmodule
