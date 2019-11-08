module fwd_ctrl (
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    output rs1_sel,
    output rs2_sel
);

    assign rs1_sel = (rd != 5'b0) && (rs1 == rd);
    assign rs2_sel = (rd != 5'b0) && (rs2 == rd);  

endmodule