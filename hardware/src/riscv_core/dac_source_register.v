module dac_source_register (
    input clk,
    input rst,
    input we,
    input source_in,
    output reg source_out
);

    always @ (posedge clk) begin
        if (rst)
            source_out <= 1'b0;
        else
            if (we)
                source_out <= source_in;
    end

endmodule
