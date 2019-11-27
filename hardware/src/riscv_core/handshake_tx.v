module handshake_tx (
    input clk,
    input rst,
    input we,
    input duty_we,
    input [11:0] din,
    input ack,
    output reg [11:0] dout,
    output reg req,
    output ack_rv
);
    
    reg [1:0] ack_sync;

    always @ (posedge clk) begin
        if (rst)
            ack_sync <= 2'b0;
        else
            ack_sync <= {ack_sync[0], ack};
    end
    
    assign ack_rv = ack_sync[1];
    
    always @ (posedge clk) begin
        if (rst) begin
            dout <= 12'b0;
            req <= 1'b0;
        end else begin
            if (we) begin
                if (!duty_we)
                    req <= din[0];
                else
                    dout <= din[11:0];
            end
        end
    end

endmodule
