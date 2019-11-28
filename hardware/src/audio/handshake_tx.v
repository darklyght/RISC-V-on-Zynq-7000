module handshake_tx(
	input rst,
	input clk,
	input Ack,
	input [11:0] data,
	output reg [11:0] dout,
	output reg Req

);
	localparam STATE_Idle = 2'b00;
    localparam STATE_Send_Data= 2'b10;
	localparam STATE_Req_Release = 2'b01;
	localparam STATE_End = 2'b11;
	
	reg[1:0] current_state, next_state;
	reg Ack_1, Ack_2;
	
	always @(posedge clk)begin
		if(rst) begin
			Ack_1 <= 1'b0;
			Ack_2 <= 1'b0;
			current_state <= STATE_Idle;
		end
		else begin
			Ack_1 <= Ack;
			Ack_2 <= Ack_1;
			current_state <= next_state;
		end
	end
	
	always @ (posedge clk)begin
		case(current_state)
			STATE_Idle: begin
				Req <= 1'b0;
				dout <= 12'b0;
				next_state <= STATE_Send_Data;
			end
			
			STATE_Send_Data: begin
				dout <= data;
				Req <= 1'b1;
				next_state <= STATE_Req_Release;
			end
			
			STATE_Req_Release:begin
				if(Ack_2 == 1'b1) begin
					Req <= 1'b0;
					next_state <= STATE_End;
				end
				else 
					next_state <= STATE_Req_Release;
			end
			
			STATE_End: begin
				if(Ack_2 == 1'b0) 
					next_state <= STATE_Idle;
				else
					next_state <= STATE_End;
			end
			default next_state<= STATE_Idle;
		endcase
	end
endmodule