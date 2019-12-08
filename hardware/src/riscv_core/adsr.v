module adsr (
    input clk,
    input rst,
    input global_reset,
    input in_valid,
    input [20:0] wave_in,
    input note_start,
    input note_release,
    input note_reset,
    output [20:0] wave_out,
    output note_finished,
    output out_valid
);

    localparam IDLE = 3'b001, PLAY = 3'b010, STOP = 3'b100;

    reg [2:0] state;
    reg [2:0] next_state;

    always @ (*) begin
        case (state)
            IDLE:
                next_state = global_reset ? IDLE : note_start ? PLAY : IDLE;
            PLAY:
                next_state = global_reset ? IDLE : note_release ? STOP : PLAY;
            STOP:
                next_state = note_reset | global_reset ? IDLE : STOP;
            default:
                next_state = IDLE;
        endcase
    end

    always @ (posedge clk) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    assign wave_out = (state == PLAY) ? wave_in : 21'b0;
    assign note_finished = (state == STOP);
    assign out_valid = (state == PLAY) ? in_valid : 1'b0;

endmodule
