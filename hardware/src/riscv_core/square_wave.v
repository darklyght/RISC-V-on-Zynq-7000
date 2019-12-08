module square_wave (
    input clk,
    input rst,
    input in_valid,
    input [23:0] phase_1,
    input [23:0] phase_2,
    input [23:0] phase_3,
    input [23:0] phase_4,
    output reg [20:0] wave_1,
    output reg [20:0] wave_2,
    output reg [20:0] wave_3,
    output reg [20:0] wave_4,
    output out_valid
);
    
    reg [6:0] phase;
    reg [23:0] phase_reg_1;
    reg [23:0] phase_reg_2;
    reg [23:0] phase_reg_3;
    reg [23:0] phase_reg_4;

    always @ (posedge clk) begin
        if (rst)
            phase <= 7'b0;
        else
            phase <= {phase[5:0], in_valid};
    end

    always @ (posedge clk) begin
        if (rst) begin
            phase_reg_1 <= 24'b0;
            phase_reg_2 <= 24'b0;
            phase_reg_3 <= 24'b0;
            phase_reg_4 <= 24'b0;
        end else begin
            if (in_valid) begin
                phase_reg_1 <= phase_1;
                phase_reg_2 <= phase_2;
                phase_reg_3 <= phase_3;
                phase_reg_4 <= phase_4;
            end
        end
    end
    
    always @ (posedge clk) begin
        if (rst) begin
            wave_1 <= 21'b0;
            wave_2 <= 21'b0;
            wave_3 <= 21'b0;
            wave_4 <= 21'b0;
        end else begin
            if (phase[5]) begin
                wave_1 <= phase_reg_1 <= 24'd8388608 ? 21'b0_0001_0000_0000_0000_0000 : 21'b1_1111_0000_0000_0000_0000;
                wave_2 <= phase_reg_2 <= 24'd8388608 ? 21'b0_0001_0000_0000_0000_0000 : 21'b1_1111_0000_0000_0000_0000;
                wave_3 <= phase_reg_3 <= 24'd8388608 ? 21'b0_0001_0000_0000_0000_0000 : 21'b1_1111_0000_0000_0000_0000;
                wave_4 <= phase_reg_4 <= 24'd8388608 ? 21'b0_0001_0000_0000_0000_0000 : 21'b1_1111_0000_0000_0000_0000;
            end
        end
    end
    
    assign out_valid = phase[6];
    
endmodule
