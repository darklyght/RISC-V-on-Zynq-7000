module pdm (
    input clk,
    input rst,
    input [11:0] duty_cycle,
    output pdm  
);
    wire pdm_int;
    reg [11:0] data;
    reg [11:0] error;
    
    always @ (posedge clk) begin
        if (rst)
            data <= 12'b0;
        else
            data <= duty_cycle;
    end

    always @ (posedge clk) begin
        if (rst)
            error <= 12'b0;
        else
            error <= {12{pdm_int}} - duty_cycle + error;
    end

    assign pdm_int = data >= error;
    assign pdm = pdm_int;

endmodule
