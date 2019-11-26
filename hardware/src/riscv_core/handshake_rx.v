module handshake_rx (
    input clk,
    input rst,
    input req,
    input [11:0] din,
    output reg [11:0] dout,
    output ack
);

    localparam IDLE = 4'b0001, RECV1 = 4'b0010, RECV2 = 4'b0100, DONE = 4'b1000;
    
    reg [1:0] req_sync;
    reg [3:0] state;
    reg [3:0] next_state;

    always @ (posedge clk) begin
        if (rst)
            req_sync <= 2'b0;
        else
            req_sync <= {req_sync[0], req};
    end

    always @ (*) begin
        case (state)
            IDLE:
                if (req_sync[1])
                    next_state = RECV1;
                else
                    next_state = IDLE;
            RECV1:
                next_state = RECV2;
            RECV2:
                next_state = DONE;
            DONE:
                if (!req_sync[1])
                    next_state = IDLE;
                else
                    next_state = DONE;
        endcase
    end

endmodule

