module fcw_register (
    input clk,
    input rst,
    input we,
    input [23:0] fcw_in,
    output reg [23:0] fcw_out
);

    always @ (posedge clk) begin
        if (rst)
            fcw_out <= 24'b0;
        else
            if (we)
                fcw_out <= fcw_in;
    end

endmodule
