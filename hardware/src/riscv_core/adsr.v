module adsr (
    input clk,
    input rst,
    input global_reset,
    input in_valid,
    input [20:0] wave_in,
    input note_start,
    input note_release,
    input note_reset,
    input [11:0] increment,
    input [11:0] decrement,
    output reg [20:0] wave_out,
    output note_finished,
    output reg out_valid
);

    localparam IDLE = 5'b00001, RISE = 5'b00010, PLAY = 5'b00100, FALL = 5'b01000, STOP = 5'b10000;
    
    reg [12:0] mult;
    wire [12:0] mult_n;
    reg [4:0] state;
    reg [4:0] next_state;
    
    wire [33:0] result;
    wire [20:0] result_q;

    assign mult_n = (state == RISE) ? mult + {1'b0, increment} : (state == FALL) ? mult - {1'b0, decrement} : 13'b0;

    always @ (*) begin
        case (state)
            IDLE:
                next_state = global_reset ? IDLE : note_start ? RISE : IDLE;
            RISE:
                next_state = global_reset ? IDLE : mult_n[12] ? PLAY : RISE;
            PLAY:
                next_state = global_reset ? IDLE : note_release ? FALL : PLAY;
            FALL:
                next_state = global_reset ? IDLE : mult_n[12] ? STOP : FALL;
            STOP:
                next_state = note_reset | global_reset ? IDLE : STOP;
            default:
                next_state = IDLE;
        endcase
    end

    always @ (posedge clk) begin
        if (rst)
            mult <= 13'b0;
        else
            if (in_valid)
                case (state)
                    IDLE:
                        mult <= 13'b0;
                    RISE:
                        mult <= (mult_n > 13'd4095) ? 13'd4095 : mult_n;
                    PLAY:
                        mult <= 13'd4095;
                    FALL:
                        mult <= (mult_n > 13'd4095) ? 13'd0 : mult_n;
                    STOP:
                        mult <= 13'b0;
                    default:
                        mult <= 13'b0;
                endcase
    end

    always @ (posedge clk) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    assign result = $signed(wave_in) * $signed(mult);
    assign result_q = result[32:12];

    always @ (posedge clk) begin
        if (rst) begin
            wave_out <= 21'b0;
            out_valid <= 1'b0;
        end else begin
            out_valid <= in_valid;
            if (in_valid)
                wave_out <= result_q;
        end
    end

    assign note_finished = (state == STOP);

endmodule
