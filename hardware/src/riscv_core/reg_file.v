module reg_file (
    input clk,
    input we,
    input [4:0] ra1, ra2, wa,
    input [31:0] wd,
    output [31:0] rd1, rd2
);
    reg [31:0] registers [0:31];
    
    integer i;

    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] = 32'b0;
        end
    end

    always @ (posedge clk) begin
        if (we == 1'b1) begin
            if (wa != 5'b0) begin
                registers[wa] <= wd;
            end
        end
    end
    
    assign rd1 = (ra1 == 5'b0) ? 32'b0 : registers[ra1];
    assign rd2 = (ra2 == 5'b0) ? 32'b0 : registers[ra2];
    
endmodule
