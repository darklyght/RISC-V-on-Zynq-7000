`include "Opcode.vh"

module dmem_wsel (
    input [31:0] addr,
    input [31:0] reg_rs2,
    input we,
    input [4:0] funct5,
    input [2:0] funct3,
    input pc30,
    output reg [31:0] data,
    output [3:0] dmem_wea,
    output [3:0] imem_wea,
    output uart_we,
    output counter_reset,
    output leds_we,
    output tx_we,
    output tx_duty_we,
	output sine_scale_we,
	output square_scale_we,
	output triangle_scale_we,
	output sawtooth_scale_we,
	output fcw_we,
	output dac_source,
	output gsr,
	output note_start,
	output note_release,
	
	
);

    reg [3:0] wea;
    
    always @ (*) begin
        if (we == 1'b1 && funct5 == `OPC_STORE_5)
            case (funct3)
                `FNC_SB:
                    case (addr[1:0])
                        2'b00: begin
                            wea = 4'b0001;
                            data = {24'b0, reg_rs2[7:0]};
                        end
                        2'b01: begin
                            wea = 4'b0010;
                            data = {16'b0, reg_rs2[7:0], 8'b0};
                        end
                        2'b10: begin
                            wea = 4'b0100;
                            data = {8'b0, reg_rs2[7:0], 16'b0};
                        end
                        2'b11: begin
                            wea = 4'b1000;
                            data = {reg_rs2[7:0], 24'b0};
                        end
                    endcase
                `FNC_SH:
                    case (addr[1])
                        1'b0: begin
                            wea = 4'b0011;
                            data = {16'b0, reg_rs2[15:0]};
                        end
                        1'b1: begin
                            wea = 4'b1100;
                            data = {reg_rs2[15:0], 16'b0};
                        end
                    endcase
                `FNC_SW: begin
                    wea = 4'b1111;
                    data = reg_rs2;
                end
                default: begin
                    wea = 4'b0000;
                    data = reg_rs2;
                end
            endcase
        else begin
            wea = 4'b0000;
            data = reg_rs2;
        end
    end

    assign dmem_wea = addr[28] == 1'b1 ? wea : 4'b0000;
    assign imem_wea = addr[29] == 1'b1 && pc30 == 1'b1 ? wea : 4'b0000;
    assign uart_we = addr[31] == 1'b1 && addr[9] == 1'b0 && addr[3] == 1'b1 ? wea[0] : 1'b0;    //32'h80000008 
    assign counter_reset = addr[31] == 1'b1 && addr[7:0] == 8'h18 ? |wea : 1'b0;    //32'h80000018 
    assign leds_we = addr[31] == 1'b1 && addr[5:4] == 2'b11 && addr[3:2] == 2'b00? wea : 1'b0;   //32'h80000030
    assign tx_duty_we = addr[31] == 1'b1 && addr[5:4] == 2'b11 && addr[2] == 1'b1 ? wea : 1'b0;   //32'h80000034
    assign tx_we = addr[31] == 1'b1 && addr[5:3] == 3'b111 ? wea: 1'b0;   //32'h80000038
	assign sine_scale_we = addr[31] == 1'b1 && addr[9] == 1'b1 && addr[3] == 1'b0 && addr[2] == 1'b0  ? wea: 1'b0;   //32'h80000200
	assign square_scale_we = addr[31] == 1'b1 && addr[9] == 1'b1 && addr[2] == 1'b1 ? wea: 1'b0;   //32'h80000204
	assign triangle_scale_we = addr[31] == 1'b1 && addr[9] == 1'b1 && addr[3] == 1'b1 ? wea: 1'b0;   //32'h80000208
	assign sawtooth_scale_we = addr[31] == 1'b1 && addr[3:0] == 4'hc ? wea: 1'b0;   //32'h8000020c
	assign fcw_we = addr[31] == 1'b1 && addr[12] == 1'b1 && addr[3] == 1'b0 && addr[2] == 1'b0 ? wea: 1'b0;   //32'h80001000
	assign dac_source = addr[31] == 1'b1 && addr[6] == 1'b1 ? wea: 1'b0;   //32'h80000040
	assign gsr = addr[31] == 1'b1 && addr[8] == 1'b1 ? |wea : 1'b0;   //32'h80000100
	assign note_start = addr[31] == 1'b1 && addr[12] == 1'b1 && addr[2] == 1'b1 ? |wea: 1'b0;  //32'h80001004
	assign note_release = addr[31] == 1'b1 && addr[12] == 1'b1 && addr[3] == 1'b1 ? |wea: 1'b0;  //32'h80001008
endmodule
