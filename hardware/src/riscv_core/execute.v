module execute (
    input clk,
    input rst,
    input [31:0] pc_next,
    input [31:0] inst_next,
    input [31:0] reg_rs1_next,
    input [31:0] reg_rs2_next,
    input [31:0] imm_next,
    output reg [31:0] pc,
    output reg [31:0] inst,
    output reg [31:0] reg_rs1,
    output reg [31:0] reg_rs2,
    output reg [31:0] imm
);

    always @ (posedge clk) begin
        if (rst) begin
            pc <= 32'b0;
            inst <= 32'b0;
            reg_rs1 <= 32'b0;
            reg_rs2 <= 32'b0;
            imm <= 32'b0;
        end else begin
            pc <= pc_next;
            inst <= inst_next;
            reg_rs1 <= reg_rs1_next;
            reg_rs2 <= reg_rs2_next;
            imm <= imm_next;
        end
    end
    
endmodule