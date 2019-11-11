module pc_sel (
    input [1:0] pc_sel,
    input [31:0] alu,
    input [31:0] predict,
    input [31:0] revert,
    input [31:0] pc,
    output [31:0] pc_next  
);

    assign pc_next = pc_sel[1] ? (pc_sel[0] ? revert : alu) : (pc_sel[0] ? predict : pc + 32'd4);

endmodule
