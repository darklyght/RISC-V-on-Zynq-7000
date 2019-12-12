module svf (
    input clk,
    input rst,
    input in_valid,
    input [20:0] F, // F
    input [20:0] Q, // Q
    input [20:0] F_Q, // F + Q
    input [20:0] F_F_Q, // F(F + Q)
    input [20:0] x,
    input [1:0] sel,
    output reg [20:0] y,
    output out_valid
);

    reg phase;

    wire [41:0] F_yb;
    wire [41:0] F_Q_yb;
    wire [41:0] F_F_Q_yb;
    wire [41:0] F_x;
    wire [41:0] F_yl;
    wire [41:0] Q_yb;
    
    reg [20:0] yh_t;
    reg [20:0] yb_t;
    reg [20:0] yl_t;
    reg [20:0] yn_t;

    wire [20:0] yh_n;
    wire [20:0] yb_n;
    wire [20:0] yl_n;
    wire [20:0] yn_n;

    assign F_yb = $signed(F) * $signed(yb_t);
    assign F_Q_yb = $signed(F_Q) * $signed(yb_t);
    assign F_F_Q_yb = $signed(F_F_Q) * $signed(yb_t);
    assign F_x = $signed(F) * $signed(x);
    assign F_yl = $signed(F) * $signed(yl_t);
    assign Q_yb = $signed(Q) * $signed(yb_t);

    assign yh_n = x - F_Q_yb[36:16] - yl_t;
    assign yb_n = F_x[36:16] - F_F_Q_yb[36:16] - F_yl[36:16];
    assign yl_n = F_yb[36:16] + yl_t;
    assign yn_n = x - F_Q_yb[36:16] + F_yb[36:16];

    always @ (posedge clk) begin
        if (rst)
            phase <= 1'b0;
        else
            phase <= in_valid;
    end

    always @ (posedge clk) begin
        if (rst) begin
            yh_t <= 21'b0;
            yb_t <= 21'b0;
            yl_t <= 21'b0;
            yn_t <= 21'b0;
        end else begin
            if (in_valid) begin
                yh_t <= yh_n;
                yb_t <= yb_n;
                yl_t <= yl_n;
                yn_t <= yn_n;
            end
        end
    end

    always @ (posedge clk) begin
        if (rst) begin
            y <= 21'b0;
        end else begin
            if (in_valid) begin
                case (sel)
                    2'b00:
                        y <= yl_n;
                    2'b01:
                        y <= yb_n;
                    2'b10:
                        y <= yh_n;
                    2'b11:
                        y <= yn_n;
                endcase
            end
        end
    end

    assign out_valid = phase;

endmodule
