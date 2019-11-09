module counter (
    input clk,
    input rst,
    input reset,
    input decode_valid,
    input writeback_valid,
    output reg [31:0] cycle_count,
    output reg [31:0] inst_count
);

    always @ (posedge clk) begin
        if (rst) begin
            cycle_count <= 32'b0;
            inst_count <= 32'b0;
        end else begin
            if (reset) begin
                cycle_count <= 32'b0;
                inst_count <= 32'b0;
            end else begin
                if (decode_valid)
                    cycle_count <= cycle_count + 1'b1;
                if (writeback_valid)
                    inst_count <= inst_count + 1'b1;
            end
        end
    end

endmodule