module pc_sel (
    input pc_sel,
    input [31:0] alu,
    input [31:0] pc,
    output [31:0] pc_next  
);

    assign pc_next = pc_sel ? alu : pc + 32'd4;

endmodule