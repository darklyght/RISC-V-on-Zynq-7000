module edge_detector #(
    parameter width = 1
)(
    input clk,
    input [width-1:0] signal_in,
    output [width-1:0] edge_detect_pulse
);
    // The edge detector takes a bus of 1-bit signals and looks for a low to high (0 -> 1)
    // logic transition. It outputs a 1 clock cycle wide pulse if a transition is detected.
    // Remove this line once you have implemented this module.
    
    reg [width-1:0] signal_reg;
    
    always @ (posedge clk) begin
        signal_reg <= signal_in;
    end
    
    assign edge_detect_pulse = ~signal_reg & signal_in;
    
endmodule
