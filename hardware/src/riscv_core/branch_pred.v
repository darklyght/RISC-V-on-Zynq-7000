module branch_pred (
    input clk,
    input rst,
    input [31:0] pc,
    input [31:0] imm,
    input [6:2] inst,
    input branch,
    input result,
    output predict,
    output [31:0] next_pc
);
    reg [3:0] history;
    reg [1:0] history_table [15:0];
    wire [3:0] new_history;
    
    integer i;
    
    assign next_pc = pc + imm;
    assign predict = inst[6:2] == `OPC_JAL_5 || (inst[6:2] == `OPC_BRANCH_5 && history_table[history][1] == 1'b1);
    assign new_history = {history[2:0], result};
    
    always @ (posedge clk) begin
        if (rst) begin
            history <= 2'b0;
            for (i = 0; i < 16; i = i + 1) begin
                history_table[i] <= i % 4;
            end
        end else begin
            if (branch) begin
                history <= new_history;
                if (result && history_table[history] < 3)
                    history_table[history] <= history_table[history] + 2'b1;
                if (~result && history_table[history] > 0)
                    history_table[history] <= history_table[history] - 2'b1;
            end
        end
    end

endmodule
