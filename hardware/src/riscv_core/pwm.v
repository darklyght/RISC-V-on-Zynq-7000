module pwm (
    input clk,
    input rst,
    input we,
    input tone_we,
    input [31:0] wdata,
    output reg tone_enable,
    output reg [23:0] tone_input
);

    always @ (posedge clk) begin
        if (rst) begin
            tone_enable <= 1'b0;
            tone_input <= 24'b0;
        end else begin
            if (we) begin
                if (!tone_we)
                    tone_enable <= wdata[0];
                if (tone_we)
                    tone_input <= wdata[23:0];
            end
        end
    end

endmodule
