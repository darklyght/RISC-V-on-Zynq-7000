module tone_generator (
    input clk,
    input rst,
    input output_enable,
    input [23:0] tone_switch_period,
    input volume,
    output square_wave_out
);
<<<<<<< HEAD
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
		
=======
    reg square_wave_reg = 1'b0;
    reg [1:0] volume_reg = 2'b0;
    reg [23:0] count_reg = 24'b0;
    
    wire duty_cycle;
    
    always @ (posedge clk) begin
        if (rst == 1'b1) begin
            square_wave_reg <= 1'b0;
            volume_reg <= 2'b0;
            count_reg <= 24'b0;
        // Controls period
        end else if (output_enable == 1'b1) begin
            if (tone_switch_period == 0) begin
                square_wave_reg <= 1'b0;
                count_reg <= 24'b0;
            end else if (count_reg >= tone_switch_period >> 1) begin
                square_wave_reg <= ~square_wave_reg;
                count_reg <= 24'b0;
            end else begin
                count_reg <= count_reg + 1;
            end
        end else begin
            square_wave_reg <= 1'b0;
            count_reg <= 24'b0;
        end
        
        // Controls volume
        volume_reg <= volume_reg + 1;
    end
    
    assign duty_cycle = volume ? volume_reg == 2'b00 || volume_reg == 2'b01 : volume_reg == 2'b00;
    assign square_wave_out = output_enable ? duty_cycle && (square_wave_reg == 1'b1) : 1'b0;
>>>>>>> 89fcf9b15ad10c002ef3150d3bb3b63b1344bea8
endmodule
