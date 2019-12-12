module addr_gen (
    input [31:0] alu1_data,
    input [31:0] alu2_data,
    output [31:0] addr
);

    assign addr = alu1_data + alu2_data;

endmodule
