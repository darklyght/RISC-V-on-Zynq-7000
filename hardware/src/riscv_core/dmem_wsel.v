module dmem_wsel (
    input [31:0] addr,
    input we,
    input [4:0] funct5,
    input [2:0] funct3,
    input pc30,
    output [3:0] dmem_wea,
    output [3:0] imem_wea
);

    reg [3:0] wea;
    
    always @ (*) begin
        if (funct5 == OPC_STORE_5)
            case (funct3)
                FNC_SB:
                    case (addr[1:0])
                        2'b00:
                            wea = 4'b0001;
                        2'b01:
                            wea = 4'b0010;
                        2'b10:
                            wea = 4'b0100;
                        2'b11:
                            wea = 4'b1000;
                    endcase
                FNC_SH:
                    case (addr[1])
                        2'b0:
                            wea = 4'b0011;
                        2'b1:
                            wea = 4'b1100;
                    endcase
                FNC_SW:
                    wea = 4'b1111;
                default:
                    wea = 4'b0000;
            endcase
        else
            wea = 4'b0000;
    end

    assign dmem_wea = addr[28] == 1'b1 ? wea : 4'b0000;
    assign imem_wea = addr[29] == 1'b1 && pc30 == 1'b1 ? wea : 4'b0000;

endmodule