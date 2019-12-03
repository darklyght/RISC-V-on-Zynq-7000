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
    output dac_source_we,
    output gsr_we,
    output global_shift_we,
	output sine_shift_we,
	output square_shift_we,
	output triangle_shift_we,
	output sawtooth_shift_we,
    output voice_1_we,
    output voice_2_we,
    output voice_3_we,
    output voice_4_we,
    output fcw_we,
    output note_start_we,
    output note_release_we,
    output reset_we
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
    assign uart_we = addr[31] == 1'b1 && addr[12] == 1'b0 && addr[9] == 1'b0 && addr[4] == 1'b0 && addr[3] == 1'b1 ? wea[0] : 1'b0; // 32'h80000008 
    assign counter_reset = addr[31] == 1'b1 && addr[7:0] == 8'h18 ? |wea : 1'b0; // 32'h80000018 
    assign leds_we = addr[31] == 1'b1 && addr[5:4] == 2'b11 && addr[3:2] == 2'b00 ? wea[0] : 1'b0; // 32'h80000030
    assign tx_duty_we = addr[2]; // 32'h80000034
    assign tx_we = addr[31] == 1'b1 && addr[5:3] == 3'b111 ? wea[0] : 1'b0; // 32'h80000038
    assign dac_source_we = addr[31] == 1'b1 && addr[6] == 1'b1 ? wea[0] : 1'b0; // 32'h80000044
    assign gsr_we = addr[31] == 1'b1 && addr[8] == 1'b1 && addr[2] == 1'b0 ? |wea : 1'b0; // 32'h80000100
    assign global_shift_we = addr[31] == 1'b1 && addr[8] == 1'b1 && addr[2] == 1'b1 ? wea[0] : 1'b0; // 32'h80000104
	assign sine_shift_we = addr[31] == 1'b1 && addr[9] == 1'b1 && addr[3:2] == 2'b00  ? wea[0] : 1'b0; // 32'h80000200
	assign square_shift_we = addr[31] == 1'b1 && addr[9] == 1'b1 && addr[3:2] == 2'b01 ? wea[0] : 1'b0; // 32'h80000204
	assign triangle_shift_we = addr[31] == 1'b1 && addr[9] == 1'b1 && addr[3:2] == 2'b10 ? wea[0] : 1'b0; // 32'h80000208
	assign sawtooth_shift_we = addr[31] == 1'b1 && addr[9] == 1'b1 && addr[3:2] == 2'b11 ? wea[0] : 1'b0; // 32'h8000020c
    assign voice_1_we = addr[12] == 1'b1; // 32'h80001xxx
    assign voice_2_we = addr[13] == 1'b1; // 32'h80002xxx
    assign voice_3_we = addr[14] == 1'b1; // 32'h80004xxx
    assign voice_4_we = addr[15] == 1'b1; // 32'h80008xxx
	assign fcw_we = addr[31] == 1'b1 && addr[4:2] == 3'b000 ? |wea : 1'b0; //32'h80001000
	assign note_start_we = addr[31] == 1'b1 && addr[4:2] == 3'b001 ? |wea : 1'b0; //32'h80001004
	assign note_release_we = addr[31] == 1'b1 && addr[4:2] == 3'b010 ? |wea : 1'b0; //32'h80001008
    assign reset_we = addr[31] == 1'b1 && addr[4:2] == 3'b100 ? |wea : 1'b0; // 32'h80001010
endmodule
