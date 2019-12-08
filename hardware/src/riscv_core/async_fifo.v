module async_fifo #(
    parameter data_width = 12,
    parameter fifo_depth = 8,
    parameter addr_width = $clog2(fifo_depth)
) (
    input rst,
    // Write side
    input w_clk,
    input w_en,
    input [data_width-1:0] w_data,
    output full,
    
    // Read side
    input r_clk,
    input r_en,
    output reg [data_width-1:0] r_data,
    output empty
);
    
    integer i;    
    
    reg [data_width-1:0] fifo [fifo_depth-1:0];
    reg [addr_width:0] w_ptr;
    reg [addr_width:0] r_ptr;
    reg [addr_width:0] w_ptr_gray_reg;
    reg [addr_width:0] r_ptr_gray_reg;
    
    wire [addr_width:0] w_ptr_gray;
    wire [addr_width:0] r_ptr_gray;
    wire [addr_width:0] w_r_ptr_gray;
    wire [addr_width:0] r_w_ptr_gray;
    wire [addr_width:0] w_r_ptr;
    wire [addr_width:0] r_w_ptr;
    wire full_int;
    wire empty_int;


    initial begin
        for (i = 0; i < fifo_depth; i = i + 1)
            fifo[i] = 'b0;
    end

    bin_to_gray #(
        .fifo_depth(fifo_depth)
    ) w_bin_to_gray (
        .bin(w_ptr),
        .gray(w_ptr_gray)
    );

    bin_to_gray #(
        .fifo_depth(fifo_depth)
    ) r_bin_to_gray (
        .bin(r_ptr),
        .gray(r_ptr_gray)
    );

    synchronizer #(
        .width(addr_width+1)
    ) w_r_synchronizer (
        .async_signal(w_ptr_gray_reg),
        .clk(r_clk),
        .sync_signal(w_r_ptr_gray)
    );

    synchronizer #(
        .width(addr_width+1)
    ) r_w_synchronizer (
        .async_signal(r_ptr_gray_reg),
        .clk(w_clk),
        .sync_signal(r_w_ptr_gray)
    );

    gray_to_bin #(
        .fifo_depth(fifo_depth)
    ) w_gray_to_bin (
        .gray(r_w_ptr_gray),
        .bin(r_w_ptr)
    );

    gray_to_bin #(
        .fifo_depth(fifo_depth)
    ) r_gray_to_bin (
        .gray(w_r_ptr_gray),
        .bin(w_r_ptr)
    );

    assign full_int = (w_ptr[addr_width] ^ r_w_ptr[addr_width]) && (w_ptr[addr_width-1:0] == r_w_ptr[addr_width-1:0]);
    assign empty_int = (w_r_ptr == r_ptr);

    always @ (posedge w_clk or posedge rst) begin
        if (rst) begin
            w_ptr <= 'b0;
            w_ptr_gray_reg <= 'b0;
        end else begin
            if (w_en & ~full_int) begin
                fifo[w_ptr[addr_width-1:0]] <= w_data;
                w_ptr <= w_ptr + 'b1;
            end
            w_ptr_gray_reg <= w_ptr_gray;
        end
    end

    always @ (posedge r_clk or posedge rst) begin
        if (rst) begin
            r_data <= 'b0;
            r_ptr <= 'b0;
            r_ptr_gray_reg <= 'b0;
        end else begin
            if (r_en & ~empty_int) begin
                r_data <= fifo[r_ptr[addr_width-1:0]];
                r_ptr <= r_ptr + 'b1;
            end
            r_ptr_gray_reg <= r_ptr_gray;
        end
    end

    assign full = full_int;
    assign empty = empty_int;

endmodule
