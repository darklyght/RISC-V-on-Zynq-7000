module decode #(
    parameter RESET_PC = 32'h4000_0000
)(
    input clk,
    input rst,
    input [31:0] pc_next,
    output reg [31:0] pc
);

    always @ (posedge clk) begin
        if (rst)
            pc <= RESET_PC - 32'd4;
        else
            pc <= pc_next;
    end

endmodule
