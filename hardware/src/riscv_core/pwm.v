module pwm (
    input clk,
    input rst,
    input reset,
    input [11:0] duty_cycle,
    output pwm  
);

    reg [11:0] counter;
    
    always @ (posedge clk) begin
        if (rst)
            counter <= 12'b0;
        else
            if (reset)
                counter <= 12'b0;
            else
                counter <= counter + 12'b1;
    end
    
    assign pwm = counter < duty_cycle;

endmodule
