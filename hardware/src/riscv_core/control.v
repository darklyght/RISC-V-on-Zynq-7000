module control (
    input clk,
    input rst,
    input [31:0] decode_inst,
    input [31:0] execute_inst,
    input [31:0] writeback_inst,
    output [1:0] pc_sel,
    input predict,
    output pred_en,
    output result,
    output decode_rs1_sel,
    output decode_rs2_sel,
    output execute_rs1_sel,
    output execute_rs2_sel,
    output alu1_sel,
    output alu2_sel,
    output brun,
    input breq,
    input brlt,
    output csr_we,
    output csr_sel,
    output dmem_we,
    input [31:0] alu,
    output uart_re,
    output counter_cycle_valid,
    output counter_inst_valid,
    output reg [1:0] wb_sel,
    output we
);
    
    reg decode_valid;
    reg execute_valid;
    reg writeback_valid;
    reg execute_predict;
    reg branch_comp;
    wire branch;
    always @ (*) begin
        case (execute_inst[14:12])
            `FNC_BEQ: 
                branch_comp = breq;
            `FNC_BNE:
                branch_comp = ~breq;
            `FNC_BLT:
                branch_comp = brlt;
            `FNC_BGE:
                branch_comp = ~brlt;
            `FNC_BLTU:
                branch_comp = brlt;
            `FNC_BGEU:
                branch_comp = ~brlt;
            default:
                branch_comp = 1'b0;
        endcase
    end
    
    always @ (posedge clk) begin
        if (rst)
            execute_predict <= 1'b0;
        else
            execute_predict <= predict;
    end

    assign branch = execute_valid == 1'b1 && (execute_inst[6:2] == `OPC_JAL_5 || execute_inst[6:2] == `OPC_JALR_5 || (execute_inst[6:2] == `OPC_BRANCH_5 && branch_comp == 1'b1));
    
    assign pc_sel = {execute_valid & execute_predict ^ branch, decode_valid & predict};
    
    assign pred_en = execute_valid == 1'b1 && execute_inst[6:2] == `OPC_BRANCH_5;
    assign result = execute_valid == 1'b1 && execute_inst[6:2] == `OPC_BRANCH_5 && branch_comp == 1'b1;
    
    assign decode_rs1_sel = writeback_valid == 1'b1 && writeback_inst[11:7] != 5'b0 && decode_inst[19:15] == writeback_inst[11:7] ? 1'b1 : 1'b0;
    assign decode_rs2_sel = writeback_valid == 1'b1 && writeback_inst[11:7] != 5'b0 && decode_inst[24:20] == writeback_inst[11:7] ? 1'b1 : 1'b0;
    
    assign execute_rs1_sel = writeback_valid == 1'b1 && execute_valid == 1'b1 && writeback_inst[11:7] != 5'b0 && execute_inst[19:15] == writeback_inst[11:7] ? 1'b1 : 1'b0;
    assign execute_rs2_sel = writeback_valid == 1'b1 && execute_valid == 1'b1 && writeback_inst[11:7] != 5'b0 && execute_inst[24:20] == writeback_inst[11:7] ? 1'b1 : 1'b0;
    
    assign alu1_sel = execute_inst[6:2] == `OPC_AUIPC_5 || execute_inst[6:2] == `OPC_JAL_5 || execute_inst[6:2] == `OPC_BRANCH_5;
    assign alu2_sel = ~(execute_inst[6:2] == `OPC_ARI_RTYPE_5);
    
    assign brun = execute_inst[14:12] == `FNC_BLT || execute_inst[14:12] == `FNC_BGE;
    
    assign csr_we = execute_valid == 1'b1 && execute_inst[6:2] == `OPC_CSR_5;
    assign csr_sel = execute_inst[14];
    
    assign dmem_we = execute_valid == 1'b1 && execute_inst[6:2] == `OPC_STORE_5;
    
    assign uart_re = execute_valid == 1'b1 && execute_inst[6:2] == `OPC_LOAD_5 && alu[31] == 1'b1 && alu[7:0] == 8'h04;
    
    assign counter_cycle_valid = decode_valid;
    assign counter_inst_valid = writeback_valid;
    
    always @ (*) begin
        case (writeback_inst[6:2])
            `OPC_JAL_5:
                wb_sel = 2'b00;
            `OPC_JALR_5:
                wb_sel = 2'b00;
            `OPC_LOAD_5:
                wb_sel = 2'b01;
            default: // OPC_LUI_5, OPC_AUIPC_5, OPC_ARI_RTYPE_5, OPC_ARI_ITYPE_5
                wb_sel = 2'b10;
        endcase
    end
    
    assign we = writeback_valid == 1'b1 && (writeback_inst[6:2] == `OPC_JAL_5 || writeback_inst[6:2] == `OPC_JALR_5 || writeback_inst[6:2] == `OPC_LOAD_5 || writeback_inst[6:2] == `OPC_LUI_5 || writeback_inst[6:2] == `OPC_AUIPC_5 || writeback_inst[6:2] == `OPC_ARI_RTYPE_5 || writeback_inst[6:2] == `OPC_ARI_ITYPE_5);
    
    always @ (posedge clk) begin
        if (rst)
            decode_valid <= 1'b0;
        else
            decode_valid <= 1'b1;
    end
    
    always @ (posedge clk) begin
        if (rst) begin
            execute_valid <= 1'b0;
        end else begin
            if (execute_valid & execute_predict ^ branch)
                execute_valid <= 1'b0;
            else
                execute_valid <= decode_valid;
        end
    end
    
    always @ (posedge clk) begin
        if (rst)
            writeback_valid <= 1'b0;
        else
            writeback_valid <= execute_valid;
    end
       
endmodule
