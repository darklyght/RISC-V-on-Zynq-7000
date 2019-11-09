module csr (
    input clk,
    input rst,
    input csr_we,
    input csr_sel,
    input [31:0] reg_rs1,
    input [31:0] imm    
);
    
    reg [31:0] tohost;
    
    always @ (posedge clk) begin
        if (rst)
            tohost <= 32'b0;
        else
            if (csr_we)
                tohost <= csr_sel ? imm : reg_rs1;
    end

endmodule