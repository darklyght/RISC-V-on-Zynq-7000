module dmem_rsel (
    input [31:0] addr,
    output reg [31:0] dout,
    input [31:0] bios_doutb,
    input [31:0] dmem_douta,
    input trmt_full,
    input recv_empty,
    input [7:0] recv_data,
    input [31:0] counter_cycle,
    input [31:0] counter_inst,
    input buttons_empty,
    input [2:0] buttons,
    input [1:0] switches,
    input tx_ack,
    input voice_1_finished,
    input voice_2_finished,
    input voice_3_finished,
    input voice_4_finished
);

    always @ (*) begin
        case (addr[31:28])
            4'b0100:
                dout = bios_doutb;
            4'b1000:
                if (~(|addr[15:12]))
                    case (addr[6:4])
                        3'b000:
                            dout = addr[2] ? {24'b0, recv_data} : {30'b0, ~recv_empty, ~trmt_full};
                        3'b010:
                            dout = addr[3] ? {30'b0, switches} : addr[2] ? {29'b0, buttons} : {31'b0, buttons_empty};
                        3'b100:
                            dout = {31'b0, tx_ack};
                        default:
                            dout = addr[2] ? counter_inst : counter_cycle;
                    endcase
                else
                    case (addr[15:12])
                        4'b0001:
                            dout = {31'b0, voice_1_finished};
                        4'b0010:
                            dout = {31'b0, voice_2_finished};
                        4'b0100:
                            dout = {31'b0, voice_3_finished};
                        4'b1000:
                            dout = {31'b0, voice_4_finished};
                        default:
                            dout = 32'b0;
                    endcase
            default:
                dout = dmem_douta;
        endcase
    end

endmodule
