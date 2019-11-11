`include "Opcode.vh"

module alu (
    input [31:0] alu1_data,
    input [31:0] alu2_data,
    input [2:0] funct3,
    input [4:0] funct5,
    input bit30,
    output reg [31:0] alu_out
);

    always @(*)begin
        if(funct5 == `OPC_ARI_RTYPE_5 || funct5 == `OPC_ARI_ITYPE_5)
            case(funct3)
                `FNC_ADD_SUB:
                if (funct5 == `OPC_ARI_RTYPE_5 && bit30 == ~`FNC2_ADD)
                    alu_out = alu1_data - alu2_data;
                else
                    alu_out = alu1_data + alu2_data;
                `FNC_SLL:
                alu_out = alu1_data << alu2_data[4:0];
                `FNC_SLT:
                alu_out = {31'b0, $signed(alu1_data) < $signed(alu2_data)};
                `FNC_SLTU:
                alu_out = {31'b0, alu1_data < alu2_data};
                `FNC_XOR:
                alu_out = alu1_data ^ alu2_data;
                `FNC_OR:
                alu_out = alu1_data | alu2_data;
                `FNC_AND:
                alu_out = alu1_data & alu2_data;
                `FNC_SRL_SRA:
                if (bit30 == `FNC2_SRL)
                    alu_out = alu1_data >> alu2_data[4:0];
                else
                    alu_out = alu1_data >>> alu2_data[4:0];
                default:
                    alu_out = alu1_data + alu2_data;
            endcase
        else
            alu_out = alu1_data + alu2_data;
    end

endmodule
