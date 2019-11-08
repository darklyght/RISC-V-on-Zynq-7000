`include "Opcode.vh"

module load_extend (
    input [31:0] din,
    input [1:0] addr,
    input [2:0] funct3,
    output reg [31:0] dout
);

    always @ (*) begin
        case (funct3)
            FNC_LB:
                case (addr)
                    2'b00:
                        dout = {{24{din[7]}}, din[7:0]};
                    2'b01:
                        dout = {{24{din[15]}}, din[15:8]};
                    2'b10:
                        dout = {{24{din[23]}}, din[23:16]};
                    2'b11:
                        dout = {{24{din[31]}}, din[31:24]};
                endcase
            FNC_LH:
                case (addr[1])
                    1'b0:
                        dout = {{16{din[15]}}, din[15:0]};
                    1'b1:
                        dout = {{16{din[31]}}, din[31:16]};
                endcase
            FNC_LBU:
                case (addr)
                    2'b00:
                        dout = {24'b0, din[7:0]};
                    2'b01:
                        dout = {24'b0, din[15:8]};
                    2'b10:
                        dout = {24'b0, din[23:16]};
                    2'b11:
                        dout = {24'b0, din[31:24]};
                endcase
            FNC_LHU:
                case (addr[1])
                    2'b0:
                        dout = {16'b0, din[15:0]};
                    2'b1:
                        dout = {16'b0, din[31:16]};
                endcase
            default: //FNC_LW
                dout = din;
        endcase
    end
    
endmodule