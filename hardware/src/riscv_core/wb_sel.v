module wb_sel (
    input [1:0] wb_sel,
    input [31:0] pc_4,
    input [31:0] alu_out,
    input [31:0] dmem_out,
    output [31:0] wb_out
);

    assign wb_out = wb_sel[1] ? alu_out : wb_sel[0] ? dmem_out : pc_4;
    
endmodule