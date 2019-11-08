module Riscv151 #(
    parameter CPU_CLOCK_FREQ = 50_000_000,
    parameter RESET_PC = 32'h4000_0000
)(
    input clk,
    input rst,
    input FPGA_SERIAL_RX,
    output FPGA_SERIAL_TX
);
    // Memories
    wire [11:0] bios_addra, bios_addrb;
    wire [31:0] bios_douta, bios_doutb;
    wire bios_ena, bios_enb;
    bios_mem bios_mem (
      .clk(clk),
      .ena(bios_ena),
      .addra(bios_addra),
      .douta(bios_douta),
      .enb(bios_enb),
      .addrb(bios_addrb),
      .doutb(bios_doutb)
    );
    
    assign bios_ena = 1'b1;
    assign bios_enb = 1'b1;

    wire [13:0] dmem_addr;
    wire [31:0] dmem_din, dmem_dout;
    wire [3:0] dmem_we;
    wire dmem_en;
    dmem dmem (
      .clk(clk),
      .en(dmem_en),
      .we(dmem_we),
      .addr(dmem_addr),
      .din(dmem_din),
      .dout(dmem_dout)
    );
    
    assign dmem_en = 1'b1;

    wire [31:0] imem_dina, imem_doutb;
    wire [13:0] imem_addra, imem_addrb;
    wire [3:0] imem_wea;
    wire imem_ena;
    imem imem (
      .clk(clk),
      .ena(imem_ena),
      .wea(imem_wea),
      .addra(imem_addra),
      .dina(imem_dina),
      .addrb(imem_addrb),
      .doutb(imem_doutb)
    );
    
    assign imem_ena = 1'b1;

    // Register file
    wire we;
    wire [4:0] ra1, ra2, wa;
    wire [31:0] wd;
    wire [31:0] rd1, rd2;
    reg_file rf (
        .clk(clk),
        .we(we),
        .ra1(ra1), .ra2(ra2), .wa(wa),
        .wd(wd),
        .rd1(rd1), .rd2(rd2)
    );

    wire pc_sel_pc_sel;
    wire [31:0] pc_sel_alu;
    wire [31:0] pc_sel_pc;
    wire [31:0] pc_sel_pc_next;
    
    wire imem_sel_pc30;
    wire [31:0] imem_sel_inst;
    wire [31:0] imem_sel_bios_douta;
    wire [31:0] imem_sel_imem_doutb;
    
    wire [31:0] decode_pc_next;
    wire [31:0] decode_pc;
    
    wire [31:2] imm_gen_inst;
    wire [31:0] imm_gen_imm;
    
    wire decode_forward_rs1_sel;
    wire decode_forward_rs2_sel;
    wire [31:0] decode_forward_wb_data;
    wire [31:0] decode_forward_reg_rs1;
    wire [31:0] decode_forward_reg_rs2;
    wire [31:0] decode_forward_rs1_data;
    wire [31:0] decode_forward_rs2_data;
    
    wire [31:0] execute_pc_next;
    wire [31:0] execute_inst_next;
    wire [31:0] execute_reg_rs1_next;
    wire [31:0] execute_reg_rs2_next;
    wire [31:0] execute_imm_next;
    wire [31:0] execute_pc;
    wire [31:0] execute_inst;
    wire [31:0] execute_reg_rs1;
    wire [31:0] execute_reg_rs2;
    wire [31:0] execute_imm;
    
    wire execute_forward_rs1_sel;
    wire execute_forward_rs2_sel;
    wire [31:0] execute_forward_wb_data;
    wire [31:0] execute_forward_reg_rs1;
    wire [31:0] execute_forward_reg_rs2;
    wire [31:0] execute_forward_rs1_data;
    wire [31:0] execute_forward_rs2_data;
    
    wire alu_sel_alu1_sel;
    wire alu_sel_alu2_sel;
    wire [31:0] alu_sel_rs1_data;
    wire [31:0] alu_sel_rs2_data;
    wire [31:0] alu_sel_pc;
    wire [31:0] alu_sel_imm;
    wire [31:0] alu_sel_alu1_data;
    wire [31:0] alu_sel_alu2_data;
    
    wire [31:0] branch_comp_rs1_data;
    wire [31:0] branch_comp_rs2_data;
    wire branch_comp_brun;
    wire branch_comp_brlt;
    wire branch_comp_breq;
    
    wire [31:0] alu_alu1_data;
    wire [31:0] alu_alu2_data;
    wire [2:0] alu_funct3;
    wire [4:0] alu_funct5;
    wire alu_bit30;
    wire [31:0] alu_alu_out;
    
    wire [31:0] dmem_wsel_addr;
    wire dmem_wsel_we;
    wire [4:0] dmem_wsel_funct5;
    wire [2:0] dmem_wsel_funct3;
    wire dmem_wsel_pc30;
    wire [3:0] dmem_wsel_dmem_wea;
    wire [3:0] dmem_wsel_imem_wea;
    
    wire [31:0] pc4_gen_pc;
    wire [31:0] pc4_gen_pc4;
    
    wire [31:0] writeback_pc4_next;
    wire [31:0] writeback_inst_next;
    wire [31:0] writeback_alu_next;
    wire [31:0] writeback_pc4;
    wire [31:0] writeback_inst;
    wire [31:0] writeback_alu;
    
    wire [31:0] dmem_rsel_addr;
    wire [31:0] dmem_rsel_dout;
    wire [31:0] dmem_rsel_bios_doutb;
    wire [31:0] dmem_rsel_dmem_douta;
    
    wire [31:0] load_extend_din;
    wire [1:0] load_extend_addr;
    wire [2:0] load_extend_funct3;
    wire [31:0] load_extend_dout;
        
    wire [1:0] wb_sel_wb_sel;
    wire [31:0] wb_sel_pc4;
    wire [31:0] wb_sel_alu_out;
    wire [31:0] wb_sel_dmem_out;
    wire [31:0] wb_sel_wb_out;
    
    wire [4:0] decode_fwd_ctrl_rs1;
    wire [4:0] decode_fwd_ctrl_rs2;
    wire [4:0] decode_fwd_ctrl_rd;
    wire decode_fwd_ctrl_rs1_sel;
    wire decode_fwd_ctrl_rs2_sel;
    
    wire [4:0] execute_fwd_ctrl_rs1;
    wire [4:0] execute_fwd_ctrl_rs2;
    wire [4:0] execute_fwd_ctrl_rd;
    wire execute_fwd_ctrl_rs1_sel;
    wire execute_fwd_ctrl_rs2_sel;
    
    wire [31:0] control_decode_inst;
    wire [31:0] control_execute_inst;
    wire [31:0] control_writeback_inst;
    wire control_pc_sel;
    wire control_alu1_sel;
    wire control_alu2_sel;
    wire control_brun;
    wire control_breq;
    wire control_brlt;
    wire control_dmem_we;
    wire [1:0] control_wb_sel;
    wire control_we;
    
    pc_sel pc_sel (
        .pc_sel(pc_sel_pc_sel), // From control
        .alu(pc_sel_alu), // From alu
        .pc(pc_sel_pc), // From decode
        .pc_next(pc_sel_pc_next) // To decode, bios_mem, imem
    );
    
    assign pc_sel_pc_sel = control_pc_sel;
    assign pc_sel_alu = alu_alu_out;
    assign pc_sel_pc = decode_pc;
    assign bios_addra = pc_sel_pc_next;
    assign imem_addrb = pc_sel_pc_next;
    
    decode decode (
        .clk(clk),
        .rst(rst),
        .pc_next(decode_pc_next), // From pc_sel
        .pc(decode_pc) // To execute
    );
    
    assign decode_pc_next = pc_sel_pc_next;
    
    imem_sel imem_sel (
        .pc30(imem_sel_pc30), // From decode
        .inst(imem_sel_inst), // To reg_file, imm_gen, execute, decode_fwd_ctrl
        .bios_douta(imem_sel_bios_douta), // From bios_mem
        .imem_doutb(imem_sel_imem_doutb) // From imem
    );
    
    assign imem_sel_pc30 = decode_pc[30];
    assign ra1 = imem_sel_inst[19:15];
    assign ra2 = imem_sel_inst[24:20];
    assign imem_sel_bios_douta = bios_douta;
    assign imem_sel_imem_doutb = imem_doutb;
    
    imm_gen imm_gen (
       .inst(imm_gen_inst), // From imem_sel
       .imm(imm_gen_imm) // To execute
    );
    
    assign imem_gen_inst = imem_sel_inst;
    
    forward_sel decode_forward (
        .rs1_sel(decode_forward_rs1_sel), // From decode_fwd_ctrl
        .rs2_sel(decode_forward_rs2_sel), // From decode_fwd_ctrl
        .wb_data(decode_forward_wb_data), // From wb_sel
        .reg_rs1(decode_forward_reg_rs1), // From reg_file
        .reg_rs2(decode_forward_reg_rs2), // From reg_file
        .rs1_data(decode_forward_rs1_data), // To execute
        .rs2_data(decode_forward_rs2_data) // To execute
    );
    
    assign decode_forward_rs1_sel = decode_fwd_ctrl_rs1_sel;
    assign decode_forward_rs2_sel = decode_fwd_ctrl_rs2_sel;
    assign decode_forward_wb_data = wb_sel_wb_out;
    assign decode_forward_reg_rs1 = rd1;
    assign decode_forward_reg_rs2 = rd2;
    
    execute execute (
        .clk(clk),
        .rst(rst),
        .pc_next(execute_pc_next), // From decode
        .inst_next(execute_inst_next), // From imem_sel
        .reg_rs1_next(execute_reg_rs1_next), // From decode_forward
        .reg_rs2_next(execute_reg_rs2_next), // From decode_forward
        .imm_next(execute_imm_next), // From imm_gen
        .pc(execute_pc), // To pc4_gen, alu_sel, dmem_wsel
        .inst(execute_inst), // To writeback, alu, dmem_wsel, execute_fwd_ctrl
        .reg_rs1(execute_reg_rs1), // To execute_forward
        .reg_rs2(execute_reg_rs2), // To execute_forward
        .imm(execute_imm)
    );
    
    assign execute_pc_next = decode_pc;
    assign execute_inst_next = imem_sel_inst;
    assign execute_reg_rs1_next = decode_forward_rs1_data;
    assign execute_reg_rs2_next = decode_forward_rs2_data;
    assign execute_imm_next = imm_gen_imm;
    
    forward_sel execute_forward (
        .rs1_sel(execute_forward_rs1_sel), // From execute_fwd_ctrl
        .rs2_sel(execute_forward_rs2_sel), // From execute_fwd_ctrl
        .wb_data(execute_forward_wb_data), // From wb_sel
        .reg_rs1(execute_forward_reg_rs1), // From execute
        .reg_rs2(execute_forward_reg_rs2), // From execute
        .rs1_data(execute_forward_rs1_data), // To alu_sel, branch_comp
        .rs2_data(execute_forward_rs2_data) // To alu_sel, branch_comp, dmem, imem
    );
    
    assign execute_forward_rs1_sel = execute_fwd_ctrl_rs1_sel;
    assign execute_forward_rs2_sel = execute_fwd_ctrl_rs2_sel;
    assign execute_forward_wb_data = wb_sel_wb_out;
    assign execute_forward_reg_rs1 = execute_reg_rs1;
    assign execute_forward_reg_rs2 = execute_reg_rs2;
    assign dmem_din = execute_forward_rs2_data;
    assign imem_dina = execute_forward_rs2_data;
    
    alu_sel alu_sel (
        .alu1_sel(alu_sel_alu1_sel), // From control
        .alu2_sel(alu_sel_alu2_sel), // From control
        .rs1_data(alu_sel_rs1_data), // From execute_forward
        .rs2_data(alu_sel_rs2_data), // From execute_forward
        .pc(alu_sel_pc), // From execute
        .imm(alu_sel_imm), // From execute
        .alu1_data(alu_sel_alu1_data), // To alu
        .alu2_data(alu_sel_alu2_data) // To alu
    );
    
    assign alu_sel_alu1_sel = control_alu1_sel;
    assign alu_sel_alu2_sel = control_alu2_sel;
    assign alu_sel_rs1_data = execute_forward_rs1_data;
    assign alu_sel_rs2_data = execute_forward_rs2_data;
    assign alu_sel_pc = execute_pc;
    assign alu_sel_imm = execute_imm;
    
    branch_comp branch_comp (
        .rs1_data(branch_comp_rs1_data), // From execute_forward
        .rs2_data(branch_comp_rs2_data), // From execute_forward
        .brun(branch_comp_brun), // From control
        .brlt(branch_comp_brlt), // To control
        .breq(branch_comp_breq) // To control
    );
    
    assign branch_comp_rs1_data = execute_forward_rs1_data;
    assign branch_comp_rs2_data = execute_forward_rs2_data;
    assign branch_comp_brun = control_brun;
    
    alu alu (
        .alu1_data(alu_alu1_data), // From alu_sel
        .alu2_data(alu_alu2_data), // From alu_sel
        .funct3(alu_funct3), // From execute
        .funct5(alu_funct5), // From execute
        .bit30(alu_bit30), // From execute
        .alu_out(alu_alu_out) // To writeback, dmem_wsel, bios_mem, dmem, imem
    );
    
    assign alu_alu1_data = alu_sel_alu1_data;
    assign alu_alu2_data = alu_sel_alu2_data;
    assign alu_funct3 = execute_inst[14:12];
    assign alu_funct5 = execute_inst[6:2];
    assign bios_addrb = alu_alu_out;
    assign dmem_addr = alu_alu_out;
    assign imem_addra = alu_alu_out;
    
    dmem_wsel dmem_wsel (
        .addr(dmem_wsel_addr), // From alu
        .we(dmem_wsel_we), // From control
        .funct5(dmem_wsel_funct5), // From execute
        .funct3(dmem_wsel_funct3), // From execute
        .pc30(dmem_wsel_pc30), // From execute
        .dmem_wea(dmem_wsel_dmem_wea), // To dmem
        .imem_wea(dmem_wsel_imem_wea) // To imem
    );
    
    assign dmem_wsel_addr = alu_alu_out;
    assign dmem_wsel_we = control_dmem_we;
    assign dmem_wsel_funct5 = execute_inst[6:2];
    assign dmem_wsel_funct3 = execute_inst[14:12];
    assign dmem_wsel_pc30 = execute_pc[30];
    assign dmem_we = dmem_wsel_dmem_wea;
    assign imem_wea = dmem_wsel_imem_wea;
    
    pc4_gen pc4_gen (
        .pc(pc4_gen_pc), // From execute
        .pc4(pc4_gen_pc4) // To writeback
    );
    
    assign pc4_gen_pc = execute_pc;
    
    writeback writeback (
        .clk(clk),
        .rst(rst),
        .pc4_next(writeback_pc4_next), // From pc4_gen
        .inst_next(writeback_inst_next), // From execute
        .alu_next(writeback_alu_next), // From alu
        .pc4(writeback_pc4), // To wb_sel
        .inst(writeback_inst), // To reg_file, load_extend, decode_fwd_ctrl, execute_fwd_ctrl
        .alu(writeback_alu) // To wb_sel, dmem_rsel
    );
    
    assign writeback_pc4_next = pc4_gen_pc4;
    assign writeback_inst_next = execute_inst;
    assign writeback_alu_next = alu_alu_out;
    assign wa = writeback_inst[11:7];
    
    dmem_rsel dmem_rsel (
        .addr(dmem_rsel_addr), // From writeback
        .dout(dmem_rsel_dout), // To load_extend
        .bios_doutb(dmem_rsel_bios_doutb), // From bios_mem
        .dmem_douta(dmem_rsel_dmem_douta) // From dmem
    );
    
    assign dmem_rsel_addr = writeback_alu;
    assign dmem_rsel_bios_doutb = bios_doutb;
    assign dmem_rsel_dmem_douta = dmem_dout;
    
    load_extend load_extend (
        .din(load_extend_din), // From dmem_rsel
        .addr(load_extend_addr), // From writeback
        .funct3(load_extend_funct3), // From writeback
        .dout(load_extend_dout) // To wb_sel
    );
    
    assign load_extend_din = dmem_rsel_dout;
    assign load_extend_addr = writeback_alu;
    assign load_extend_funct3 = writeback_inst[14:12];
    
    wb_sel wb_sel (
        .wb_sel(wb_sel_wb_sel), // From control
        .pc4(wb_sel_pc4), // From writeback
        .alu_out(wb_sel_alu_out), // From writeback
        .dmem_out(wb_sel_dmem_out), // From load_extend
        .wb_out(wb_sel_wb_out) // To reg_file, decode_forward, execute_forward
    );
    
    assign wb_sel_wb_sel = control_wb_sel;
    assign wb_sel_pc4 = writeback_pc4;
    assign wb_sel_alu_out = writeback_alu;
    assign wb_sel_dmem_out = load_extend_dout;
    assign wd = wb_sel_wb_out;
    
    fwd_ctrl decode_fwd_ctrl (
        .rs1(decode_fwd_ctrl_rs1), // From imem_sel
        .rs2(decode_fwd_ctrl_rs2), // From imem_sel
        .rd(decode_fwd_ctrl_rd), // From writeback
        .rs1_sel(decode_fwd_ctrl_rs1_sel), // To decode_forward
        .rs2_sel(decode_fwd_ctrl_rs2_sel) // To decode_forward
    );
    
    assign decode_fwd_ctrl_rs1 = imem_sel_inst[19:15];
    assign decode_fwd_ctrl_rs2 = imem_sel_inst[24:20];
    assign decode_fwd_ctrl_rd = writeback_inst[11:7];
    
    fwd_ctrl execute_fwd_ctrl (
        .rs1(execute_fwd_ctrl_rs1), // From execute
        .rs2(execute_fwd_ctrl_rs2), // From execute
        .rd(execute_fwd_ctrl_rd), // From writeback
        .rs1_sel(execute_fwd_ctrl_rs1_sel), // To execute_forward
        .rs2_sel(execute_fwd_ctrl_rs2_sel) // To execute_forward
    );
    
    assign execute_fwd_ctrl_rs1 = execute_inst[19:15];
    assign execute_fwd_ctrl_rs2 = execute_inst[24:20];
    assign execute_fwd_ctrl_rd = writeback_inst[11:7];
    
    control control (
        .clk(clk),
        .rst(rst),
        .decode_inst(control_decode_inst), // From imem_sel
        .execute_inst(control_execute_inst), // From execute
        .writeback_inst(control_writeback_inst), // From writeback
        .pc_sel(control_pc_sel), // To pc_sel
        .alu1_sel(control_alu1_sel), // To alu_sel
        .alu2_sel(control_alu2_sel), // To alu_sel
        .brun(control_brun), // To branch_comp
        .breq(control_breq), // From branch_comp
        .brlt(control_brlt), // From branch_comp
        .dmem_we(control_dmem_we), // To dmem_wsel
        .wb_sel(control_wb_sel), // To wb_sel
        .we(control_we) // To reg_file
    );
    
    assign control_decode_inst = imem_sel_inst;
    assign control_execute_inst = execute_inst;
    assign control_writeback_inst = writeback_inst;
    assign control_breq = branch_comp_breq;
    assign control_brlt = branch_comp_brlt;
    assign we = control_we;
    
    // On-chip UART
    uart #(
        .CLOCK_FREQ(CPU_CLOCK_FREQ)
    ) on_chip_uart (
        .clk(clk),
        .reset(rst),
        .data_in(),
        .data_in_valid(),
        .data_out_ready(),
        .serial_in(FPGA_SERIAL_RX),

        .data_in_ready(),
        .data_out(),
        .data_out_valid(),
        .serial_out(FPGA_SERIAL_TX)
    );
endmodule
