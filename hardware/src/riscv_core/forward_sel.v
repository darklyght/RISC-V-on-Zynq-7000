module forward_sel (
    input rs1_sel,
    input rs2_sel,
    input [31:0] wb_data,
    input [31:0] reg_rs1,
    input [31:0] reg_rs2,
    output [31:0] rs1_data,
    output [31:0] rs2_data
);

    assign rs1_data = rs1_sel ? wb_data : reg_rs1;
    assign rs2_data = rs2_sel ? wb_data : reg_rs2;

endmodule