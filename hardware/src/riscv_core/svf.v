module svf (
    input clk,
    input rst,
    input [11:0] F,
    input [11:0] Q,
    input [11:0] x,
    output reg [11:0] yh,
    output reg [11:0] yb,
    output reg [11:0] yl,
    output [11:0] yn
);

    wire [23:0] Q_bp;
    wire [11:0] Q_bp_r;
    wire [11:0] yh_int;
    wire [23:0] F_yh;
    wire [11:0] F_yh_r;
    wire [11:0] yb_int;
    wire [23:0] F_yb;
    wire [11:0] F_yb_r;
    
    assign Q_bp = $signed(Q) * $signed(yb);
    assign Q_bp_r = Q_bp[23:12];
    assign yh_int = x - yl - Q_bp_r;
    assign F_yh = $signed(F) * $signed(yh_int);
    assign F_yh_r = F_yh[23:12];
    assign yb_int = F_yh_r + yb;
    assign F_yb = $signed(F) * $signed(yb_int);
    assign F_yb_r = F_yb[23:12];
    
    always @ (posedge clk) begin
        if (rst) begin
            yh <= 12'b0;
            yb <= 12'b0;
            yl <= 12'b0;
        end else begin
            yh <= yh_int;
            yb <= yb_int;
            yl <= F_yb_r + yl;
        end
    end
    
    assign yn = yh + yl;

endmodule