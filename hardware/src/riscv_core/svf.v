module svf (
    input clk,
    input rst,
    input en_in,
    input [11:0] F,
    input [11:0] Q,
    input [11:0] x,
    output [11:0] yh,
    output [11:0] yb,
    output [11:0] yl,
    output [11:0] yn,
    output reg en_out
);

    wire [15:0] x_e;
    wire [15:0] F_e;
    wire [15:0] Q_e;
    reg [15:0] yh_e;
    reg [15:0] yb_e;
    reg [15:0] yl_e;
    wire [32:0] Q_bp;
    wire [15:0] Q_bp_r;
    wire [15:0] yh_int;
    wire [32:0] F_yh;
    wire [15:0] F_yh_r;
    wire [15:0] yb_int;
    wire [32:0] F_yb;
    wire [15:0] F_yb_r;
    wire [15:0] yl_int;
    wire [15:0] yn_int;
    
    
    assign x_e = {{4{x[11]}}, x[11:0]};
    assign F_e = {{4{F[11]}}, F[11:0]};
    assign Q_e = {{4{Q[11]}}, Q[11:0]};
    assign Q_bp = $signed(Q_e) * $signed(yb_e);
    assign Q_bp_r = ($signed(Q_bp) > -32768 << 9 && $signed(Q_bp) < 32767 << 9) ? Q_bp[25:10] : ($signed(Q_bp) <= -32768 << 9) ? -32768 : 32767;
    assign yh_int = x_e - yl_e - Q_bp_r;
    assign F_yh = $signed(F_e) * $signed(yh_int);
    assign F_yh_r = ($signed(F_yh) > -32768 << 9 && $signed(F_yh) < 32767 << 9) ? F_yh[25:10] : ($signed(F_yh) <= -32768 << 9) ? -32768 : 32767;
    assign yb_int = F_yh_r + yb_e;
    assign F_yb = $signed(F_e) * $signed(yb_int);
    assign F_yb_r = ($signed(F_yb) > -32768 << 9 && $signed(F_yb) < 32767 << 9) ? F_yb[25:10] : ($signed(F_yb) <= -32768 << 9) ? -32768 : 32767;
    assign yl_int = F_yb_r + yl_e;
    assign yn_int = yh_int + yl_int;
    
    always @ (posedge clk) begin
        if (rst) begin
            en_out <= 1'b0;
            yh_e <= 16'b0;
            yb_e <= 16'b0;
            yl_e <= 16'b0;
        end else begin
            en_out <= en_in;
            if (en_in) begin
                yh_e <= yh_int;
                yb_e <= yb_int;
                yl_e <= yl_int;
            end
        end
    end
    
    assign yh = ($signed(yh_e) > -2048 && $signed(yh_e) < 2047) ? yh_e[11:0] : ($signed(yh_e) <= -2048) ? -2048 : 2047;
    assign yb = ($signed(yb_e) > -2048 && $signed(yb_e) < 2047) ? yb_e[11:0] : ($signed(yb_e) <= -2048) ? -2048 : 2047;
    assign yl = ($signed(yl_e) > -2048 && $signed(yl_e) < 2047) ? yl_e[11:0] : ($signed(yl_e) <= -2048) ? -2048 : 2047;
    assign yn = ($signed(yn_int) > -2048 && $signed(yn_int) < 2047) ? yn_int[11:0] : ($signed(yn_int) <= -2048) ? -2048 : 2047;

endmodule