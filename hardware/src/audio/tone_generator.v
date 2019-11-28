`timescale 1ns/1ns
module tone_generator (
    input clk,
    input rst,
    input output_enable,
    input [23:0] tone_switch_period,
    input volume,
    output square_wave_out
);
    // TODO: copy your solution from lab3 here
   reg [23:0] counter = 0;
    
    reg square_wave_out_reg = 0;
	reg square_wave_out_final = 0;
	
	assign square_wave_out = square_wave_out_final;

	always @(*) begin
		if(output_enable == 0 | tone_switch_period == 0)
			square_wave_out_final = 1'b0;
		else
			square_wave_out_final = square_wave_out_reg;
	end

	always @(posedge clk) begin
		if (rst) 
			counter <= 0;
		
		else if(counter > tone_switch_period)
			counter <= 0;
		else
			counter <= counter + 1'b1;

        
		
		if(counter < tone_switch_period / 2)begin
			if(volume == 1'b1) 
				square_wave_out_reg <= (counter % 2 == 1) ? 1'b1 : 1'b0;
			else
				square_wave_out_reg <= (counter % 4 == 1) ? 1'b1 : 1'b0;
		end
		else 
			square_wave_out_reg <= 1'b0;
		
		
	end
		
endmodule
