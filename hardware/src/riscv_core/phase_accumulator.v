module phase_accumulator #(
    parameter CPU_CLOCK_FREQ = 50_000_000
) (
    input clk,
    input rst,
    input [14:0] frequency,
    output [17:0] phase
);
    
    reg [47:0] counter;
    wire [63:0] total;
    wire [63:0] increment;
    
    assign total = frequency << 48;
    assign increment = total / CPU_CLOCK_FREQ;

    always @ (posedge clk) begin
        if (rst)
            counter <= 48'b0;
        else
            counter <= counter + increment[47:0];
    end
    
    assign phase = counter[47:30];
    
endmodule