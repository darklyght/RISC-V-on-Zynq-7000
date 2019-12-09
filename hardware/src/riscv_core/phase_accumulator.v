module phase_accumulator #(
    parameter CPU_CLOCK_FREQ = 50_000_000,
    parameter SAMPLING_RATE = 100_000,
    parameter MAX_COUNT = CPU_CLOCK_FREQ / SAMPLING_RATE
) (
    input clk,
    input rst,
    input [23:0] increment,
    output [23:0] phase,
    output reg valid
);
    
    reg [11:0] counter;
    reg [23:0] phase_int;
    
    always @ (posedge clk) begin
        if (rst)
            counter <= 12'b0;
        else
            /* verilator lint_off WIDTH */
            if (counter >= MAX_COUNT)
            /* verilator lint_on WIDTH */
                counter <= 12'b0;
            else
                counter <= counter + 1'b1;
    end
    
    always @ (posedge clk) begin
        if (rst) begin
            valid <= 1'b0;
            phase_int <= 24'b0;
        end else begin
            /* verilator lint_off WIDTH */
            if (counter >= MAX_COUNT) begin
            /* verilator lint_on WIDTH */
                valid <= 1'b1;
                phase_int <= phase_int + increment;
            end else begin
                valid <= 1'b0;
                phase_int <= phase_int;
            end
        end
    end

    assign phase = phase_int[23:0];
    
endmodule
