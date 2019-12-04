module shift_register (
    input clk,
    input rst,
    input we,
    input [4:0] shift_in,
    output reg [4:0] shift_out
);

    always @ (posedge clk) begin
        if (rst)
            shift_out <= 5'b0;
        else
            if (we)
                shift_out <= shift_in;
    end

endmodule
