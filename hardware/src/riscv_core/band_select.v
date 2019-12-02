module band_select (
    input clk,
    input rst,
    input en_in,
    input [1:0] select,
    input [11:0] yh,
    input [11:0] yb,
    input [11:0] yl,
    input [11:0] yn,
    output reg [11:0] wave_out,
    output reg en_out
);

    always @ (posedge clk) begin
        if (rst) begin
            en_out <= 1'b0;
            wave_out <= 12'b0;
        end else begin
            en_out <= en_in;
            if (en_in)
                case (select)
                    2'b00:
                        wave_out <= yl;
                    2'b01:
                        wave_out <= yb;
                    2'b10:
                        wave_out <= yh;
                    2'b11:
                        wave_out <= yn;
                endcase
        end 
    end

endmodule