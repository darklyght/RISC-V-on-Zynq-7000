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
    output pwm_we,
    output pwm_tone_we
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
    assign uart_we = addr[31] == 1'b1 && addr[5:3] == 3'b001 ? wea[0] : 1'b0;
    assign counter_reset = addr[31] == 1'b1 && addr[5:3] == 3'b011 ? 1'b1 : 1'b0;
    assign leds_we = addr[31] == 1'b1 && addr[5:3] == 3'b110 ? 1'b1 : 1'b0;
    assign pwm_we = addr[31] == 1'b1 && addr[5:4] == 2'b11 ? 1'b1 : 1'b0;    
    assign pwm_tone_we = addr[3];
endmodule
