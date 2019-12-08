module async_rx (
    input clk,
    input rst,
    input [11:0] data,
    output r_en,
    input empty,
    output reg [11:0] duty_cycle
);
    
    localparam IDLE = 3'b001, READ = 3'b010, LATCH = 3'b100;
    reg [2:0] state;
    reg [2:0] next_state;

    always @ (*) begin
        case (state)
            IDLE:
                if (!empty)
                    next_state = READ;
                else
                    next_state = IDLE;
            READ:
                next_state = LATCH;
            LATCH:
                next_state = IDLE;
            default:
                next_state = IDLE;
        endcase
    end

    always @ (posedge clk) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    assign r_en = (state == READ);

    always @ (posedge clk) begin
        if (rst)
            duty_cycle <= 12'b0;
        else
            if (state == LATCH)
                duty_cycle <= data;
    end

endmodule
