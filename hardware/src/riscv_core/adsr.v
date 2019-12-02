module adsr (
    input clk,
    input rst,
    input en_in,
    input press,
    input [11:0] rise_time,
    input [11:0] fall_time,
    input [11:0] wave_in,
    output reg [11:0] wave_out,
    output reg en_out
);

    localparam IDLE = 5'b00001, RISE = 5'b00010, SUSTAIN = 5'b00100, FALL = 5'b01000, DONE = 5'b10000;
    
    reg en_sync;
    reg [4:0] state;
    reg [4:0] next_state;
    reg [11:0] counter;
    reg [12:0] rise_increment;
    reg [12:0] fall_decrement;
    reg [12:0] multiplier;
    wire [11:0] wave_u;
    wire [23:0] wave_out_mult;
    
    assign wave_out_mult = $signed(wave_in) * $signed(multiplier);
    
    always @ (posedge clk) begin
        en_sync <= en;
    end
    
    always @ (posedge clk) begin
        en_out <= en_sync;
    end
    
    always @ (*) begin
        case (state)
            IDLE:
                if (press)
                    next_state = RISE;
                else
                    next_state = IDLE;
            RISE:
                if (counter == 12'b0)
                    next_state = SUSTAIN;
                else
                    next_state = RISE;
            SUSTAIN:
                if (!press)
                    next_state = FALL;
                else
                    next_state = SUSTAIN;
            FALL:
                if (counter == 12'b0)
                    next_state = DONE;
                else
                    next_state = FALL;
            DONE:
                next_state = IDLE;
            default:
                next_state = IDLE;
        endcase
    end
    
    always @ (posedge clk) begin
        if (rst) begin
            counter <= 12'b0;
            rise_increment <= 12'b0;
            fall_decrement <= 12'b0;
            multiplier <= 12'b0;
        end else begin
            if (en)
                case (state)
                    IDLE: begin
                        if (press) begin
                            counter <= rise_time;
                            rise_increment <= 13'd4095 / rise_time;
                        end else begin
                            counter <= 12'b0;
                        end
                        multiplier <= 13'b0;
                    end
                    RISE: begin
                        counter <= counter - 1'b1;
                        multiplier <= multiplier + rise_increment;
                    end
                    SUSTAIN: begin
                        if (!press) begin
                            counter <= fall_time;
                            fall_decrement <= 13'd4095 / fall_time;
                        end else begin
                            counter <= 12'b0;
                        end
                        multiplier <= 13'hFFF;
                    end
                    FALL: begin
                        counter <= counter - 1'b1;
                        multiplier <= multiplier - fall_decrement;
                    end
                    DONE: begin
                        counter <= 12'b0;
                        rise_increment <= 13'b0;
                        fall_decrement <= 13'b0;
                        multiplier <= 13'b0;
                    end
                    default: begin
                        counter <= 12'b0;
                        rise_increment <= 13'b0;
                        fall_decrement <= 13'b0;
                        multiplier <= 13'b0;
                    end
                endcase
        end
    end
    
    always @ (posedge clk) begin
        if (rst)
            wave_out <= 12'b0;
        else
            if (en_sync)
                wave_out <= wave_out_mult[23:12] + 2048;
    end

    always @ (posedge clk) begin
        if (rst)
            state <= IDLE;
        else
            if (en)
                state <= next_state;
    end
    
endmodule