module alu_sel (
    input alu1_sel,
    input alu2_sel,
    input [31:0] rs1_data,
    input [31:0] rs2_data,
    input [31:0] pc,
    input [31:0] imm,
    output [31:0] alu1_data,
    output [31:0] alu2_data
);

    assign alu1_data = alu1_sel ? pc : rs1_data;
    assign alu2_data = alu2_sel ? imm : rs2_data;

endmodule