module fifo #(
    parameter data_width = 8,
    parameter fifo_depth = 32,
    parameter addr_width = $clog2(fifo_depth)
) (
    input clk, rst,

    // Write side
    input wr_en,
    input [data_width-1:0] din,
    output full,

    // Read side
    input rd_en,
    output reg [data_width-1:0] dout,
    output empty
);
    reg [data_width-1:0] fifo [fifo_depth-1:0];
    reg [addr_width:0] wr_addr;
    reg [addr_width:0] rd_addr;
    
    integer i;
    
    wire full_int;
    wire empty_int;
    
    assign full_int = (wr_addr[addr_width] ^ rd_addr[addr_width]) && (wr_addr[addr_width-1:0] == rd_addr[addr_width-1:0]);
    assign empty_int = (wr_addr == rd_addr);
    
    always @ (posedge clk) begin
        if (rst) begin
            for (i = 0; i < fifo_depth; i = i + 1) begin
                fifo[i] <= 'b0;
            end
            wr_addr <= 'b0;
            rd_addr <= 'b0;
        end else begin
            if (wr_en & ~full_int) begin
                fifo[wr_addr[addr_width-1:0]] <= din;
                wr_addr <= wr_addr + 'b1;
            end
            if (rd_en & ~empty_int) begin
                dout <= fifo[rd_addr[addr_width-1:0]];
                rd_addr <= rd_addr + 'b1;
            end
        end
    end
    
    assign full = full_int;
    assign empty = empty_int;
    
endmodule
