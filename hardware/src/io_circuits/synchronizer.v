module synchronizer #(parameter width = 1) (
    input [width-1:0] async_signal,
    input clk,
    output [width-1:0] sync_signal
);
    // Create your 2 flip-flop synchronizer here
    // This module takes in a vector of 1-bit asynchronous (from different clock domain or not clocked) signals
    // and should output a vector of 1-bit synchronous signals that are synchronized to the input clk

    // Remove this line once you create your synchronizer
    
    genvar i;
    
    reg [1:0] sync_reg [width-1:0];
    
    generate
        for (i = 0; i < width; i = i + 1) begin
            always @ (posedge clk) begin
                sync_reg[i] <= {async_signal[i], sync_reg[i][1]};
            end
            assign sync_signal[i] = sync_reg[i][0];
        end
    endgenerate
    
endmodule