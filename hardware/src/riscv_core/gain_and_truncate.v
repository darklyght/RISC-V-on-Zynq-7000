module gain_and_truncate (
    input clk,
    input rst,
    input in_valid,
    input [4:0] global_gain,
    input [20:0] wave_in,
    output reg [11:0] wave_out,
    output reg out_valid
);

    reg [20:0] wave_int;
    reg int_valid;
    wire [20:0] wave_c;

    assign wave_c = wave_int + 21'd65536;
    
    always @ (posedge clk) begin
        if (rst) begin
            int_valid <= 1'b0;
            wave_int <= 21'b0;
        end else begin
            int_valid <= in_valid;
            if (in_valid)
                wave_int <= $signed(wave_in) >>> global_gain;
        end
    end

    always @ (posedge clk) begin
        if (rst) begin
            out_valid <= 1'b0;
            wave_out <= 12'b0;
        end else begin
            out_valid <= int_valid;
            if (int_valid)
                wave_out <= wave_c[16:5];
        end
    end

endmodule
