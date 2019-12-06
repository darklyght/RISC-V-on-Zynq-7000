`timescale 1ns/1ns

module tone_generator (
    input clk,
    input rst,
    input output_enable,
    input [11:0] din,
    output wave_out
);
    // TODO: copy your solution from lab3 here
    reg [11:0] counter = 0;
	reg wave_out_reg = 0;
	reg wave_out_final = 0;
	
	assign wave_out = output_enable ? (counter < din): 1'b0 ;

	always @(posedge clk) begin
		if (rst) begin
			counter <= 0;
		end else begin
			counter <= counter + 1'b1;
		end
	end
		
endmodule
