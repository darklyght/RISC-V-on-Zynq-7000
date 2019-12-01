module sine_lut (
    input clk,
    input [14:0] addr,
    output reg [11:0] dout
);
    reg [11:0] mem [32768-1:0];

    always @(posedge clk) begin
        dout <= mem[addr];
    end

    `ifdef SYNTHESIS
        initial begin
            $readmemh("../../../scripts/sine_lut.hex", mem);
        end
    `endif
endmodule