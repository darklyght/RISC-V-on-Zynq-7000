module bios_mem (
    input clk,
    input ena,
    input [11:0] addra,
    output reg [31:0] douta,
    input enb,
    input [11:0] addrb,
    output reg [31:0] doutb
);
    reg [31:0] mem [4096-1:0];
    always @(posedge clk) begin
        if (ena) begin
            douta <= mem[addra];
        end
    end

    always @(posedge clk) begin
        if (enb) begin
            doutb <= mem[addrb];
        end
    end

    `define STRINGIFY_BIOS(x) `"x/../software/bios151v3/bios151v3.hex`"
    `ifdef SYNTHESIS
        initial begin
            $readmemh("../../../software/bios151v3/bios151v3.hex", mem);
        end
    `endif
endmodule
