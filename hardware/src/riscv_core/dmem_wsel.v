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
    output uart_we
);

    reg [3:0] wea;
    
    always @ (*) begin
        if (funct5 == `OPC_STORE_5)
            case (funct3)
                `FNC_SB:
                    case (addr[1:0])
                        2'b00: begin
                            wea = 4'b0001;
                            data = reg_rs2;
                        end
                        2'b01: begin
                            wea = 4'b0010;
                            data = reg_rs2 << 8;
                        end
                        2'b10: begin
                            wea = 4'b0100;
                            data = reg_rs2 << 16;
                        end
                        2'b11: begin
                            wea = 4'b1000;
                            data = reg_rs2 << 24;
                        end
                    endcase
                `FNC_SH:
                    case (addr[1])
                        1'b0: begin
                            wea = 4'b0011;
                            data = reg_rs2;
                        end
                        1'b1: begin
                            wea = 4'b1100;
                            data = reg_rs2 << 16;
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
    assign uart_we = addr[31] == 1'b1 && addr[7:0] == 8'h08 ? wea[0] : 1'b0;

endmodule