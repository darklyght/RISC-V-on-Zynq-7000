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
	input note_finished
);

    always @ (*) begin
        case (addr[31:30])
            2'b01:
                dout = bios_doutb;
            2'b10:
                case (addr[6:4])
                    3'b000:
                        dout = addr[2] ? {24'b0, recv_data} : {30'b0, ~recv_empty, ~trmt_full};   // uart_data: 32'h80000004, uart_control: 32'h80000000
                    3'b001:
						dout = addr[2] ? counter_inst : counter_cycle;   // cycle: 32'h80000010, inst: 32'h80000014
					3'b010:
                        dout = addr[3] ? {30'b0, switches} : addr[2] ? {29'b0, buttons} : {31'b0, buttons_empty}; //button_empty: 32'h80000020, button: 32'h80000024
                    3'b100:																							// switches: 32'h80000028
                        dout = {31'b0, tx_ack};							//ack: 32'h80000040
                    default:
                        dout = {31'b0, note_finished};						    // note_finished: 32'h8000100c
                endcase
            default:
                dout = dmem_douta;
        endcase
    end

endmodule
