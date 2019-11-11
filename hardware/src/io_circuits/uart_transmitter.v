module uart_transmitter #(
    parameter CLOCK_FREQ = 125_000_000,
    parameter BAUD_RATE = 115_200)
(
    input clk,
    input reset,

    input [7:0] data_in,
    input data_in_valid,
    output data_in_ready,

    output serial_out
);
    // See diagram in the lab guide
    localparam  SYMBOL_EDGE_TIME    =   CLOCK_FREQ / BAUD_RATE;
    localparam  CLOCK_COUNTER_WIDTH =   $clog2(SYMBOL_EDGE_TIME);

    localparam IDLE = 3'b001,
               LATCH = 3'b010,
               SENDING = 3'b100;

    reg [9:0] tx_shift;
    reg [3:0] bit_counter;
    reg [CLOCK_COUNTER_WIDTH-1:0] clock_counter;
    reg [2:0] state;
    reg [2:0] next_state;
    
    always @ (posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end
    
    always @ (*) begin
        case (state)
            IDLE: begin
                if (data_in_valid)
                    next_state = LATCH;
            end
            LATCH: begin
                next_state = SENDING;
            end
            SENDING: begin
                /* verilator lint_off WIDTH */
                if (bit_counter == 4'd9 && clock_counter >= SYMBOL_EDGE_TIME - 'b1)
                /* verilator lint_on WIDTH */
                    next_state = IDLE;
                else
                    next_state = SENDING;
            end
            default:
                next_state = IDLE;
        endcase
    end
    
    always @ (posedge clk) begin
        case (state)
            IDLE: begin
                tx_shift <= 10'h3FF;
                bit_counter <= 4'b0;
                clock_counter <= 'b0;
            end
            LATCH: begin
                tx_shift <= {1'b0, data_in[0], data_in[1], data_in[2], data_in[3], data_in[4], data_in[5], data_in[6], data_in[7], 1'b1};
                bit_counter <= 4'b0;
                clock_counter <= 'b1;
            end
            SENDING: begin
                /* verilator lint_off WIDTH */
                if (clock_counter >= SYMBOL_EDGE_TIME) begin
                /* verilator lint_on WIDTH */
                    tx_shift <= {tx_shift[8:0], 1'b0};
                    bit_counter <= bit_counter + 4'b1;
                    clock_counter <= 'b0;
                end else
                    clock_counter <= clock_counter + 'b1;
            end
            default: begin
                tx_shift <= 10'h3FF;
                bit_counter <= 4'b0;
                clock_counter <= 'b0;
            end
        endcase
    end
    
    assign data_in_ready = (state == IDLE);
    assign serial_out = tx_shift[9];
    
endmodule
