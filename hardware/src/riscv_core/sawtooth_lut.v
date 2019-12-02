module sawtooth_lut (
    input clk,
    input en,
    input [14:0] addr,
    output reg [11:0] dout
);
    reg [11:0] mem [32768-1:0];
    
    initial begin
        $readmemh("../../scripts/sawtooth_lut.hex", mem);
    end
    
    always @(posedge clk) begin
        dout <= mem[addr];
    end

endmodule