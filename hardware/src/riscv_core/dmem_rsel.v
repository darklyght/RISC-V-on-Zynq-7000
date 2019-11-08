module dmem_rsel (
    input [31:0] addr,
    output [31:0] dout,
    input [31:0] bios_doutb,
    input [31:0] dmem_douta
);

    assign dout = addr[31:28] == 4'b0100 ? bios_doutb : dmem_douta;

endmodule