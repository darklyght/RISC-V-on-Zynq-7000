module async_rx (
    input clk,
    input rst,
    input [11:0] data,
    output r_en,
    input empty,
    output reg [11:0] duty_cycle
);
    
    reg empty_reg;    

    always @ (posedge clk) begin
        if (rst)
            empty_reg <= 1'b1;
        else
            empty_reg <= empty;
    end

    assign r_en = ~empty_reg;

    always @ (posedge clk) begin
        if (rst)
            duty_cycle <= 12'b0;
        else
            if (~empty_reg)
                duty_cycle <= data;
    end

endmodule
