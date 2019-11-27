module bin_to_gray #(
    parameter fifo_depth = 8,
    parameter addr_width = $clog2(fifo_depth)
) (
    input [addr_width:0] bin,
    input [addr_width:0] gray
);

    genvar i;
    assign gray[addr_width] = bin[addr_width];
    generate
        for (i = addr_width-1; i >= 0; i = i-1) begin
            assign gray[i] = bin[i+1] ^ bin[i];
        end
    endgenerate

endmodule
