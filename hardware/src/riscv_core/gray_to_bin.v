module gray_to_bin #(
    parameter fifo_depth = 8,
    parameter addr_width = $clog2(fifo_depth)
) (
    input [addr_width:0] gray,
    output [addr_width:0] bin
);

    genvar i;

    assign bin[addr_width] = gray[addr_width];
    generate
        for (i = addr_width-1; i >= 0; i = i-1) begin
            assign bin[i] = ^gray[addr_width:i];
        end
    endgenerate

endmodule
