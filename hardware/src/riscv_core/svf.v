module svf (
    input clk,
    input rst,
    input in_valid,
    input [20:0] F,
    input [20:0] Q,
    input [20:0] x,
    output [1:0] sel,
    output reg [20:0] y,
    output out_valid
);

    reg [1:0] phase;

    reg [20:0] yh_t;
    reg [20:0] yb_t;
    reg [20:0] yl_t;
    wire [20:0] yh_n;
    wire [20:0] yb_n;
    wire [20:0] yl_n;

    wire [41:0] Q_yb;
    wire [20:0] Q_yb_q;
    wire [41:0] F_yh;
    wire [20:0] F_yh_q;
    wire [41:0] F_yl;
    wire [20:0] F_yl_q;

    assign Q_yb = $signed(Q) * $signed(yb_t);
    assign Q_yb_q = Q_yb[36:16];
    assign F_yh = $signed(F) * $signed(yh_n);
    assign F_yh_q = F_yh[36:16];
    assign F_yl = $signed(F) * $signed(yl_t);
    assign F_yl_q = F_yl[36:16];
    assign yh_n = x - yl_t - Q_yb_q;
    assign yb_n = F_yh_q + yb_t;
    assign yl_n = yb_n + F_yl_q;

    always @ (posedge clk) begin
        if (rst)
            phase <= 2'b0;
        else
            phase <= {phase[0], in_valid};
    end

    always @ (posedge clk) begin
        if (rst) begin
            yh_t <= 21'b0;
            yb_t <= 21'b0;
            yl_t <= 21'b0;
        end else begin
            if (in_valid) begin
                yh_t <= yh_n;
                yb_t <= yb_n;
                yl_t <= yl_n;
            end
        end            
    end

    always @ (posedge clk) begin
        if (rst) begin
            y <= 21'b0;
        end else begin
            if (phase[0]) begin
                case (sel)
                    2'b00:
                        y <= yl_t;
                    2'b01:
                        y <= yb_t;
                    2'b10:
                        y <= yh_t;
                    2'b11:
                        y <= yl_t + yh_t;
                endcase
            end
        end
    end

    assign out_valid = phase[1];

endmodule
