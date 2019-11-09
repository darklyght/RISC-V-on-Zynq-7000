module control (
    input clk,
    input rst,
    input [31:0] decode_inst,
    input [31:0] execute_inst,
    input [31:0] writeback_inst,
    output pc_sel,
    output decode_rs1_sel,
    output decode_rs2_sel,
    output execute_rs1_sel,
    output execute_rs2_sel,
    output alu1_sel,
    output alu2_sel,
    output brun,
    input breq,
    input brlt,
    output dmem_we,
    output reg [1:0] wb_sel,
    output we
);
    
    reg decode_valid;
    reg execute_valid;
    reg writeback_valid;
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

    assign branch = execute_valid == 1'b1 && (execute_inst[6:2] == `OPC_JAL_5 || execute_inst[6:2] == `OPC_JALR_5 || execute_inst[6:2] == `OPC_BRANCH_5) && branch_comp == 1'b1;
    
    assign pc_sel = branch;
    
    assign decode_rs1_sel = writeback_valid == 1'b1 && writeback_inst[11:7] != 5'b0 && decode_inst[19:15] == writeback_inst[11:7] ? 1'b1 : 1'b0;
    assign decode_rs2_sel = writeback_valid == 1'b1 && writeback_inst[11:7] != 5'b0 && decode_inst[24:20] == writeback_inst[11:7] ? 1'b1 : 1'b0;
    
    assign execute_rs1_sel = writeback_valid == 1'b1 && execute_valid == 1'b1 && writeback_inst[11:7] != 5'b0 && execute_inst[19:15] == writeback_inst[11:7] ? 1'b1 : 1'b0;
    assign execute_rs2_sel = writeback_valid == 1'b1 && execute_valid == 1'b1 && writeback_inst[11:7] != 5'b0 && execute_inst[24:20] == writeback_inst[11:7] ? 1'b1 : 1'b0;
    
    assign alu1_sel = execute_inst[6:2] == `OPC_AUIPC_5 || execute_inst[6:2] == `OPC_JAL_5 || execute_inst[6:2] == `OPC_BRANCH_5;
    assign alu2_sel = ~(execute_inst[6:2] == `OPC_ARI_RTYPE_5);
    
    assign brun = execute_inst[14:12] == `FNC_BLT || execute_inst[14:12] == `FNC_BGE;
    
    assign dmem_we = execute_valid == 1'b1 && execute_inst[6:2] == `OPC_STORE_5;
    
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
            if (branch)
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
