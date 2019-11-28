module handshake_rx(
	input rst;
	input clk;
	input Req;
	input [11:0]din;
	output reg [11:0] dout,
	output reg Ack
);

	localparam STATE_Idle = 2'b00;
	localparam STATE_Recv_Data = 2'b01;
	localparam STATE_Ack_Release = 2'b01;
	
	reg[1:0] current_state, next_state;
	reg Req_1, Req_2;
	
	always @(posedge clk)begin
		if(rst) begin
			Req_1 <= 1'b0;
			Req_2 <= 1'b0;
			current_state <= STATE_Idle;
		end
		else begin
			Req_1 <= Ack;
			Req_2 <= Ack;
			current_state <= next_state;
		end
	end
	
	always @(posedge clk)begin
		case(current_state)
			STATE_Idle:begin
				Ack <= 1'b0;
				dout <= 12'b0;
				next_state <= STATE_Recv_Data;
			end
			
			STATE_Recv_Data:begin
				if (Req_2 == 1'b1)begin
					Ack <= 1'b1;
					dout <= din;
					next_state <= STATE_Ack_Release; 
				end
				else 
					next_state <= STATE_Recv_Data;
			end
			
			STATE_Ack_Release:begin
				if(Req_2 == 1'b0)begin
					Ack <= 1'b0;
					next_state <= STATE_Idle;
				end
				else 
					next_state <= STATE_Ack_Release;
			end
			
			default next_state <= STATE_Idle;
		endcase
	end
endmodule
