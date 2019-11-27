module handshake_rx (
    input clk,
    input rst,
    input req,
    input [11:0] din,
    output reg [11:0] dout,
    output ack
);

    localparam IDLE = 3'b001, RECV = 3'b010, DONE = 3'b100;

    reg [2:0] state;
    reg [2:0] next_state;
    reg [1:0] req_sync;
    
    always @ (*) begin
        case (state)
            IDLE:
                if (req_sync[1])
                    next_state = RECV;
            RECV:
                next_state = DONE;
            DONE:
                if (!req_sync[1])
                    next_state = IDLE;
        endcase
    end
    
    always @ (posedge clk) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end
    
    always @ (posedge clk) begin
        if (rst)
            req_sync <= 2'b0;
        else
            req_sync <= {req_sync[0], req};
    end
    
    always @ (posedge clk) begin
        if (rst)
            dout <= 12'b0;
        else if (state == RECV)
            dout <= din;
    end
    
    assign ack = state == DONE;

endmodule