module dac (
    input clk,
    input rst,
    input dac_source,
    input [11:0] rv_duty_cycle,
    input [11:0] async_duty_cycle,
    output async_r_en,
    input async_empty,
    input req,
    output ack,
    output pwm
);

    wire handshake_rx_req;
    wire [11:0] handshake_rx_din;
    wire [11:0] handshake_rx_dout;
    wire handshake_rx_ack;

    wire [11:0] async_rx_data;
    wire async_rx_r_en;
    wire async_rx_empty;
    wire [11:0] async_rx_duty_cycle;

    wire dac_source_sync_async_signal;
    wire dac_source_sync_sync_signal;

    wire dac_source_sel_select;
    wire [11:0] dac_source_sel_rv;
    wire [11:0] dac_source_sel_wg;
    wire [11:0] dac_source_sel_pwm;
    
    wire [11:0] pwm_duty_cycle;
    wire pwm_reset;
    wire pwm_pwm;
    
    handshake_rx handshake_rx (
        .clk(clk),
        .rst(rst),
        .req(handshake_rx_req), // From external
        .din(handshake_rx_din), // From external
        .dout(handshake_rx_dout), // To dac_source_sel
        .ack(handshake_rx_ack) // To external
    );
    
    assign handshake_rx_req = req;
    assign handshake_rx_din = rv_duty_cycle;
    assign ack = handshake_rx_ack;

    async_rx async_rx (
        .clk(clk),
        .rst(rst),
        .data(async_rx_data), // From external
        .r_en(async_rx_r_en), // To external
        .empty(async_rx_empty), // From external
        .duty_cycle(async_rx_duty_cycle) // To dac_source_sel
    );

    assign async_rx_data = async_duty_cycle;
    assign async_rx_empty = async_empty;
    assign async_r_en = async_rx_r_en;

    synchronizer dac_source_sync (
        .async_signal(dac_source_sync_async_signal), // From external
        .clk(clk),
        .sync_signal(dac_source_sync_sync_signal) // To dac_source_sel
    );

    assign dac_source_sync_async_signal = dac_source;

    dac_source_sel dac_source_sel (
        .select(dac_source_sel_select), // From dac_source_sync
        .rv(dac_source_sel_rv), // From handshake_rx
        .wg(dac_source_sel_wg), // From async_rx
        .pwm(dac_source_sel_pwm) // To pwm
    );

    assign dac_source_sel_select = dac_source_sync_sync_signal;
    assign dac_source_sel_rv = handshake_rx_dout;
    assign dac_source_sel_wg = async_rx_duty_cycle;
    
    pdm aud_pdm (
        .clk(clk),
        .rst(rst),
        .duty_cycle(pwm_duty_cycle), // From handshake_rx
        .pdm(pwm_pwm) // To external
    );
    
    assign pwm_duty_cycle = dac_source_sel_pwm;
    assign pwm = pwm_pwm;

endmodule
