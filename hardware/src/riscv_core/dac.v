module dac (
    input clk,
    input rst,
    input [11:0] rv_duty_cycle,
    input req,
    output ack,
    output pwm
);

    wire handshake_rx_req;
    wire [11:0] handshake_rx_din;
    wire [11:0] handshake_rx_dout;
    wire handshake_rx_ack;
    
    wire [11:0] pwm_duty_cycle;
    wire pwm_pwm;
    
    handshake_rx handshake_rx (
        .clk(clk),
        .rst(rst),
        .req(handshake_rx_req), // From external
        .din(handshake_rx_din), // From external
        .dout(handshake_rx_dout), // To pwm
        .ack(handshake_rx_ack) // To external
    );
    
    assign handshake_rx_req = req;
    assign handshake_rx_din = rv_duty_cycle;
    assign ack = handshake_rx_ack;
    
    pwm aud_pwm (
        .clk(clk),
        .rst(rst),
        .duty_cycle(pwm_duty_cycle), // From handshake_rx
        .pwm(pwm_pwm) // To external
    );
    
    assign pwm_duty_cycle = handshake_rx_dout;
    assign pwm = pwm_pwm;

endmodule
