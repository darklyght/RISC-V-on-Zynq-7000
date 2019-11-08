`include "Opcode.vh"

module imm_gen (
    input [31:2] inst,
    output reg [31:0] imm
);

    always @ (*) begin
        case (inst[6:2])
            OPC_LUI_5:
                imm = {inst[31:12], 12'b0};
            OPC_AUIPC_5:
                imm = {inst[31:12], 12'b0};
            OPC_JAL_5:
                imm = {{12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0};
            OPC_JALR_5:
                imm = {{20{inst[31]}}, inst[11:0]};
            OPC_BRANCH_5:
                imm = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};
            OPC_STORE_5:
                imm = {{20{inst[31]}}, inst[31:25], inst[11:7]};
            OPC_CSR_5:
                imm = {27'b0, inst[19:15]};
            default: // OPC_LOAD_5 and OPC_ARI_ITYPE_5
                imm = {{20{inst[31]}}, inst[31:20]};
        endcase
    end
    
endmodule