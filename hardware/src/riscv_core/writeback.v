module writeback (
    input clk,
    input rst,
    input [31:0] pc4_next,
    input [31:0] inst_next,
    input [31:0] alu_next,
    output reg [31:0] pc4,
    output reg [31:0] inst,
    output reg [31:0] alu
);

    always @ (posedge clk) begin
        if (rst) begin
            pc4 <= 32'b0;
            inst <= 32'b0;
            alu <= 32'b0;
        end else begin
            pc4 <= pc4_next;
            inst <= inst_next;
            alu <= alu_next;
        end
    end

endmodule