module imem_sel (
    input pc30,
    output [31:0] inst,
    input [31:0] bios_douta,
    input [31:0] imem_doutb
);

    assign inst = pc30 ? bios_douta : imem_doutb;

endmodule