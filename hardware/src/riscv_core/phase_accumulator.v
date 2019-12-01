module phase_accumulator #(
    parameter CPU_CLOCK_FREQ = 50_000_000,
    parameter SAMPLING_RATE = 44_100,
    parameter MAX_COUNT = CPU_CLOCK_FREQ / SAMPLING_RATE
) (
    input clk,
    input rst,
    input [14:0] frequency,
    output reg [17:0] phase,
    output en
);
    
    reg [11:0] counter;
    wire [17:0] increment;
    
    assign increment = (frequency << 18) / SAMPLING_RATE;
    
    always @ (posedge clk) begin
        if (rst)
            counter <= 12'b0;
        else
            if (counter >= MAX_COUNT) 
                counter <= 12'b0;
            else
                counter <= counter + 1'b1;
    end
    
    assign en = (counter >= MAX_COUNT);
    
    always @ (posedge clk) begin
        if (rst)
            phase <= 12'b0;
        else
            if (counter >= MAX_COUNT)
                phase <= phase + increment;
    end
    
endmodule