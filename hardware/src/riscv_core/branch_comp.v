module branch_comp (
    input [31:0] rs1_data,
    input [31:0] rs2_data,
    input brun,
    output brlt,
    output breq
);

    assign breq = rs1_data == rs2_data;
    assign brlt = brun ? ($signed(rs1_data) < $signed(rs2_data)) : (rs1_data < rs2_data);

endmodule