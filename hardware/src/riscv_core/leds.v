module leds (
    input clk,
    input rst,
    input we,
    input [5:0] leds_in,
    output reg [5:0] leds_out
);

    always @ (posedge clk) begin
        if (rst)
            leds_out <= 6'b0;
        else
            if (we)
                leds_out <= leds_in;
    end

endmodule