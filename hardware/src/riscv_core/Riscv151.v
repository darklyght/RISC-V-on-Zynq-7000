module Riscv151 #(
    parameter CPU_CLOCK_FREQ = 50_000_000,
    parameter RESET_PC = 32'h4000_0000
)(
    input clk,
    input rst,
    input [2:0] buttons,
    input [1:0] switches,
    output [5:0] leds,
    output pwm,
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

    wire [1:0] pc_sel_pc_sel;
    wire [31:0] pc_sel_alu;
    wire [31:0] pc_sel_predict;
    wire [31:0] pc_sel_revert;
    wire [31:0] pc_sel_pc;
    wire [31:0] pc_sel_pc_next;
    
    wire [31:0] decode_pc_next;
    wire [31:0] decode_pc;
    
    wire imem_sel_pc30;
    wire [31:0] imem_sel_inst;
    wire [31:0] imem_sel_bios_douta;
    wire [31:0] imem_sel_imem_doutb;
    
    wire [31:2] imm_gen_inst;
    wire [31:0] imm_gen_imm;
    
    wire [31:0] branch_pred_pc;
    wire [31:0] branch_pred_imm;
    wire [6:2] branch_pred_inst;
    wire branch_pred_branch;
    wire branch_pred_result;
    wire branch_pred_predict;
    wire [31:0] branch_pred_next_pc;
    
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
    
    wire csr_csr_we;
    wire csr_csr_sel;
    wire [31:0] csr_reg_rs1;
    wire [31:0] csr_imm;
    
    wire [31:0] alu_alu1_data;
    wire [31:0] alu_alu2_data;
    wire [2:0] alu_funct3;
    wire [4:0] alu_funct5;
    wire alu_bit30;
    wire [31:0] alu_alu_out;
    
    wire [31:0] dmem_wsel_addr;
    wire [31:0] dmem_wsel_reg_rs2;
    wire dmem_wsel_we;
    wire [4:0] dmem_wsel_funct5;
    wire [2:0] dmem_wsel_funct3;
    wire dmem_wsel_pc30;
    wire [31:0] dmem_wsel_data;
    wire [3:0] dmem_wsel_dmem_wea;
    wire [3:0] dmem_wsel_imem_wea;
    wire dmem_wsel_uart_we;
    wire dmem_wsel_counter_reset;
    wire dmem_wsel_leds_we;
    wire dmem_wsel_pwm_we;
    wire dmem_wsel_pwm_tone_we;
    
    wire [31:0] pc4_gen_pc;
    wire [31:0] pc4_gen_pc4;
    
    localparam fifo_depth = 32;
    wire trmt_fifo_wr_en;
    wire [7:0] trmt_fifo_din;
    wire trmt_fifo_full;
    wire trmt_fifo_rd_en;
    wire [7:0] trmt_fifo_dout;
    wire trmt_fifo_empty;
    
    wire recv_fifo_wr_en;
    wire [7:0] recv_fifo_din;
    wire recv_fifo_full;
    wire recv_fifo_rd_en;
    wire [7:0] recv_fifo_dout;
    wire recv_fifo_empty;
    
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
    wire dmem_rsel_trmt_full;
    wire dmem_rsel_recv_empty;
    wire [7:0] dmem_rsel_recv_data;
    wire [31:0] dmem_rsel_counter_cycle;
    wire [31:0] dmem_rsel_counter_inst;
    wire dmem_rsel_buttons_empty;
    wire [2:0] dmem_rsel_buttons;
    wire [1:0] dmem_rsel_switches;
    
    wire [31:0] load_extend_din;
    wire [1:0] load_extend_addr;
    wire [2:0] load_extend_funct3;
    wire [31:0] load_extend_dout;
        
    wire [1:0] wb_sel_wb_sel;
    wire [31:0] wb_sel_pc4;
    wire [31:0] wb_sel_alu_out;
    wire [31:0] wb_sel_dmem_out;
    wire [31:0] wb_sel_wb_out;
    
    wire [31:0] control_decode_inst;
    wire [31:0] control_execute_inst;
    wire [31:0] control_writeback_inst;
    wire [1:0] control_pc_sel;
    wire control_predict;
    wire control_pred_en;
    wire control_result;
    wire control_decode_rs1_sel;
    wire control_decode_rs2_sel;
    wire control_execute_rs1_sel;
    wire control_execute_rs2_sel;
    wire control_alu1_sel;
    wire control_alu2_sel;
    wire control_brun;
    wire control_breq;
    wire control_brlt;
    wire control_csr_we;
    wire control_csr_sel;
    wire control_dmem_we;
    wire [31:0] control_alu;
    wire control_uart_re;
    wire control_buttons_re;
    wire control_counter_cycle_valid;
    wire control_counter_inst_valid;
    wire [1:0] control_wb_sel;
    wire control_we;
    
    wire [7:0] uart_data_in;
    wire uart_data_in_valid;
    wire uart_data_in_ready;
    wire [7:0] uart_data_out;
    wire uart_data_out_valid;
    wire uart_data_out_ready;
    
    wire counter_reset;
    wire counter_decode_valid;
    wire counter_writeback_valid;
    wire [31:0] counter_cycle_count;
    wire [31:0] counter_inst_count;
    
    wire buttons_fifo_wr_en;
    wire [2:0] buttons_fifo_din;
    wire buttons_fifo_full;
    wire buttons_fifo_rd_en;
    wire [2:0] buttons_fifo_dout;
    wire buttons_fifo_empty;
    
    wire [2:0] buttons_buttons;
    wire buttons_wr_en;
    wire [2:0] buttons_din;
    wire buttons_full;
    
    wire leds_we;
    wire [5:0] leds_leds_in;
    wire [5:0] leds_leds_out;

    wire pwm_we;
    wire pwm_tone_we;
    wire [31:0] pwm_wdata;
    wire pwm_tone_enable;
    wire [23:0] pwm_tone_input;

    wire tone_generator_output_enable;
    wire [23:0] tone_generator_tone_switch_period;
    wire tone_generator_volume;
    wire tone_generator_square_wave_out;    

    pc_sel pc_sel (
        .pc_sel(pc_sel_pc_sel), // From control
        .alu(pc_sel_alu), // From alu
        .predict(pc_sel_predict), // From branch_pred
        .revert(pc_sel_revert), // From pc4_gen
        .pc(pc_sel_pc), // From decode
        .pc_next(pc_sel_pc_next) // To decode, bios_mem, imem
    );
    
    assign pc_sel_pc_sel = control_pc_sel;
    assign pc_sel_alu = alu_alu_out;
    assign pc_sel_predict = branch_pred_next_pc;
    assign pc_sel_revert = pc4_gen_pc4;
    assign pc_sel_pc = decode_pc;
    assign bios_addra = pc_sel_pc_next[13:2];
    assign imem_addrb = pc_sel_pc_next[15:2];
    
    decode #(
        .RESET_PC(RESET_PC)
    ) decode (
        .clk(clk),
        .rst(rst),
        .pc_next(decode_pc_next), // From pc_sel
        .pc(decode_pc) // To execute, branch_pred
    );
    
    assign decode_pc_next = pc_sel_pc_next;
    
    imem_sel imem_sel (
        .pc30(imem_sel_pc30), // From decode
        .inst(imem_sel_inst), // To reg_file, imm_gen, execute, decode_fwd_ctrl, branch_pred
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
       .imm(imm_gen_imm) // To execute, branch_pred
    );
    
    assign imm_gen_inst = imem_sel_inst[31:2];
    
    branch_pred branch_pred (
        .clk(clk),
        .rst(rst),
        .pc(branch_pred_pc), //From decode
        .imm(branch_pred_imm), // From imm_gen
        .inst(branch_pred_inst), // From imem_sel
        .branch(branch_pred_branch), // From control
        .result(branch_pred_result), // From control
        .predict(branch_pred_predict), // To pc_sel
        .next_pc(branch_pred_next_pc) // To pc_sel
    );
    
    assign branch_pred_pc = decode_pc;
    assign branch_pred_imm = imm_gen_imm;
    assign branch_pred_inst = imem_sel_inst[6:2];
    assign branch_pred_branch = control_pred_en;
    assign branch_pred_result = control_result;
    
    forward_sel decode_forward (
        .rs1_sel(decode_forward_rs1_sel), // From control
        .rs2_sel(decode_forward_rs2_sel), // From control
        .wb_data(decode_forward_wb_data), // From wb_sel
        .reg_rs1(decode_forward_reg_rs1), // From reg_file
        .reg_rs2(decode_forward_reg_rs2), // From reg_file
        .rs1_data(decode_forward_rs1_data), // To execute
        .rs2_data(decode_forward_rs2_data) // To execute
    );
    
    assign decode_forward_rs1_sel = control_decode_rs1_sel;
    assign decode_forward_rs2_sel = control_decode_rs2_sel;
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
        .imm(execute_imm) // To alu_sel, csr
    );
    
    assign execute_pc_next = decode_pc;
    assign execute_inst_next = imem_sel_inst;
    assign execute_reg_rs1_next = decode_forward_rs1_data;
    assign execute_reg_rs2_next = decode_forward_rs2_data;
    assign execute_imm_next = imm_gen_imm;
    
    forward_sel execute_forward (
        .rs1_sel(execute_forward_rs1_sel), // From control
        .rs2_sel(execute_forward_rs2_sel), // From control
        .wb_data(execute_forward_wb_data), // From wb_sel
        .reg_rs1(execute_forward_reg_rs1), // From execute
        .reg_rs2(execute_forward_reg_rs2), // From execute
        .rs1_data(execute_forward_rs1_data), // To alu_sel, branch_comp, csr
        .rs2_data(execute_forward_rs2_data) // To alu_sel, branch_comp, dmem_wsel, trmt_fifo, leds
    );
    
    assign execute_forward_rs1_sel = control_execute_rs1_sel;
    assign execute_forward_rs2_sel = control_execute_rs2_sel;
    assign execute_forward_wb_data = wb_sel_wb_out;
    assign execute_forward_reg_rs1 = execute_reg_rs1;
    assign execute_forward_reg_rs2 = execute_reg_rs2;
    
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
    
    csr csr (
        .clk(clk),
        .rst(rst),
        .csr_we(csr_csr_we), // From control
        .csr_sel(csr_csr_sel), // From control
        .reg_rs1(csr_reg_rs1), // From execute_forward
        .imm(csr_imm) // From execute
    );
    
    assign csr_csr_we = control_csr_we;
    assign csr_csr_sel = control_csr_sel;
    assign csr_reg_rs1 = execute_forward_rs1_data;
    assign csr_imm = execute_imm;
    
    alu alu (
        .alu1_data(alu_alu1_data), // From alu_sel
        .alu2_data(alu_alu2_data), // From alu_sel
        .funct3(alu_funct3), // From execute
        .funct5(alu_funct5), // From execute
        .bit30(alu_bit30), // From execute
        .alu_out(alu_alu_out) // To writeback, dmem_wsel, bios_mem, dmem, imem, control
    );
    
    assign alu_alu1_data = alu_sel_alu1_data;
    assign alu_alu2_data = alu_sel_alu2_data;
    assign alu_funct3 = execute_inst[14:12];
    assign alu_funct5 = execute_inst[6:2];
    assign alu_bit30 = execute_inst[30];
    assign bios_addrb = alu_alu_out[13:2];
    assign dmem_addr = alu_alu_out[15:2];
    assign imem_addra = alu_alu_out[15:2];
    
    dmem_wsel dmem_wsel (
        .addr(dmem_wsel_addr), // From alu
        .reg_rs2(dmem_wsel_reg_rs2), // From execute_forward
        .we(dmem_wsel_we), // From control
        .funct5(dmem_wsel_funct5), // From execute
        .funct3(dmem_wsel_funct3), // From execute
        .pc30(dmem_wsel_pc30), // From execute
        .data(dmem_wsel_data), // To imem, dmem, trmt_fifo
        .dmem_wea(dmem_wsel_dmem_wea), // To dmem
        .imem_wea(dmem_wsel_imem_wea), // To imem
        .uart_we(dmem_wsel_uart_we), // To trmt_fifo
        .counter_reset(dmem_wsel_counter_reset), // To counter
        .leds_we(dmem_wsel_leds_we), // To leds
        .pwm_we(dmem_wsel_pwm_we), // To pwm
        .pwm_tone_we(dmem_wsel_pwm_tone_we) // To pwm
    );
    
    assign dmem_wsel_addr = alu_alu_out;
    assign dmem_wsel_reg_rs2 = execute_forward_rs2_data;
    assign dmem_wsel_we = control_dmem_we;
    assign dmem_wsel_funct5 = execute_inst[6:2];
    assign dmem_wsel_funct3 = execute_inst[14:12];
    assign dmem_wsel_pc30 = execute_pc[30];
    assign dmem_we = dmem_wsel_dmem_wea;
    assign imem_wea = dmem_wsel_imem_wea;
    assign dmem_din = dmem_wsel_data;
    assign imem_dina = dmem_wsel_data;
    
    pc4_gen pc4_gen (
        .pc(pc4_gen_pc), // From execute
        .pc4(pc4_gen_pc4) // To writeback, pc_sel
    );
    
    assign pc4_gen_pc = execute_pc;
    
    fifo #(
        .fifo_depth(fifo_depth)
    ) trmt_fifo (
        .clk(clk),
        .rst(rst),
        .wr_en(trmt_fifo_wr_en), // From dmem_wsel
        .din(trmt_fifo_din), // From execute_forward
        .full(trmt_fifo_full), // To dmem_rsel
        .rd_en(trmt_fifo_rd_en), // From uart
        .dout(trmt_fifo_dout), // To uart
        .empty(trmt_fifo_empty) // To uart
    );
    
    assign trmt_fifo_wr_en = dmem_wsel_uart_we;
    assign trmt_fifo_din = dmem_wsel_data[7:0];
    assign trmt_fifo_rd_en = ~trmt_fifo_empty & uart_data_in_ready;
    
    fifo #(
        .fifo_depth(fifo_depth)
    ) recv_fifo (
        .clk(clk),
        .rst(rst),
        .wr_en(recv_fifo_wr_en), // From uart
        .din(recv_fifo_din), // From uart
        .full(recv_fifo_full), // To uart
        .rd_en(recv_fifo_rd_en), // From control
        .dout(recv_fifo_dout), // To dmem_rsel
        .empty(recv_fifo_empty) // To dmem_rsel
    );
    
    assign recv_fifo_wr_en = ~recv_fifo_full & uart_data_out_valid;
    assign recv_fifo_din = uart_data_out;
    assign recv_fifo_rd_en = control_uart_re;
    
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
        .dmem_douta(dmem_rsel_dmem_douta), // From dmem
        .trmt_full(dmem_rsel_trmt_full), // From trmt_fifo
        .recv_empty(dmem_rsel_recv_empty), // From recv_fifo
        .recv_data(dmem_rsel_recv_data), // From recv_fifo
        .counter_cycle(dmem_rsel_counter_cycle), // From counter
        .counter_inst(dmem_rsel_counter_inst), // From counter
        .buttons_empty(dmem_rsel_buttons_empty), // From buttons_fifo
        .buttons(dmem_rsel_buttons), // From buttons_fifo
        .switches(dmem_rsel_switches) // From external
    );
    
    assign dmem_rsel_addr = writeback_alu;
    assign dmem_rsel_bios_doutb = bios_doutb;
    assign dmem_rsel_dmem_douta = dmem_dout;
    assign dmem_rsel_trmt_full = trmt_fifo_full;
    assign dmem_rsel_recv_empty = recv_fifo_empty;
    assign dmem_rsel_recv_data = recv_fifo_dout;
    assign dmem_rsel_counter_cycle = counter_cycle_count;
    assign dmem_rsel_counter_inst = counter_inst_count;
    assign dmem_rsel_buttons_empty = buttons_fifo_empty;
    assign dmem_rsel_buttons = buttons_fifo_dout;
    assign dmem_rsel_switches = switches;
    
    load_extend load_extend (
        .din(load_extend_din), // From dmem_rsel
        .addr(load_extend_addr), // From writeback
        .funct3(load_extend_funct3), // From writeback
        .dout(load_extend_dout) // To wb_sel
    );
    
    assign load_extend_din = dmem_rsel_dout;
    assign load_extend_addr = writeback_alu[1:0];
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
    
    control control (
        .clk(clk),
        .rst(rst),
        .decode_inst(control_decode_inst), // From imem_sel
        .execute_inst(control_execute_inst), // From execute
        .writeback_inst(control_writeback_inst), // From writeback
        .pc_sel(control_pc_sel), // To pc_sel
        .predict(control_predict), // From branch_pred
        .pred_en(control_pred_en), // To branch_pred
        .result(control_result), // To branch_pred
        .decode_rs1_sel(control_decode_rs1_sel), // To decode_forward
        .decode_rs2_sel(control_decode_rs2_sel), // To decode_forward
        .execute_rs1_sel(control_execute_rs1_sel), // To execute_forward
        .execute_rs2_sel(control_execute_rs2_sel), // To execute_forward 
        .alu1_sel(control_alu1_sel), // To alu_sel
        .alu2_sel(control_alu2_sel), // To alu_sel
        .brun(control_brun), // To branch_comp
        .breq(control_breq), // From branch_comp
        .brlt(control_brlt), // From branch_comp
        .csr_we(control_csr_we), // To csr
        .csr_sel(control_csr_sel), // To csr
        .dmem_we(control_dmem_we), // To dmem_wsel
        .alu(control_alu), // From alu
        .uart_re(control_uart_re), // To recv_fifo
        .buttons_re(control_buttons_re), // To buttons_fifo
        .counter_cycle_valid(control_counter_cycle_valid), // To counter
        .counter_inst_valid(control_counter_inst_valid), // To counter
        .wb_sel(control_wb_sel), // To wb_sel
        .we(control_we) // To reg_file
    );
    
    assign control_decode_inst = imem_sel_inst;
    assign control_execute_inst = execute_inst;
    assign control_writeback_inst = writeback_inst;
    assign control_predict = branch_pred_predict;
    assign control_breq = branch_comp_breq;
    assign control_brlt = branch_comp_brlt;
    assign control_alu = alu_alu_out;
    assign we = control_we;
    
    // On-chip UART
    uart #(
        .CLOCK_FREQ(CPU_CLOCK_FREQ)
    ) on_chip_uart (
        .clk(clk),
        .reset(rst),
        .data_in(uart_data_in), // From trmt_fifo
        .data_in_valid(uart_data_in_valid), // From trmt_fifo
        .data_out_ready(uart_data_out_ready), // From recv_fifo
        .serial_in(FPGA_SERIAL_RX),

        .data_in_ready(uart_data_in_ready), // To trmt_fifo
        .data_out(uart_data_out), // To recv_fifo
        .data_out_valid(uart_data_out_valid), // To recv_fifo
        .serial_out(FPGA_SERIAL_TX)
    );
    
    assign uart_data_in = trmt_fifo_dout;
    assign uart_data_in_valid = ~trmt_fifo_empty;
    assign uart_data_out_ready = ~recv_fifo_full;
    
    counter counter (
        .clk(clk),
        .rst(rst),
        .reset(counter_reset), // From dmem_wsel
        .decode_valid(counter_decode_valid), // From control
        .writeback_valid(counter_writeback_valid), // From control
        .cycle_count(counter_cycle_count), // To dmem_rsel
        .inst_count(counter_inst_count) // To dmem_rsel
    );
    
    assign counter_reset = dmem_wsel_counter_reset;
    assign counter_decode_valid = control_counter_cycle_valid;
    assign counter_writeback_valid = control_counter_inst_valid;
    
    fifo #(
        .data_width(3),
        .fifo_depth(fifo_depth)
    ) buttons_fifo (
        .clk(clk),
        .rst(rst),
        .wr_en(buttons_fifo_wr_en), // From buttons
        .din(buttons_fifo_din), // From buttons
        .full(buttons_fifo_full), // To buttons
        .rd_en(buttons_fifo_rd_en), // From control
        .dout(buttons_fifo_dout), // To dmem_rsel
        .empty(buttons_fifo_empty) // To dmem_rsel
    );
    
    assign buttons_fifo_wr_en = buttons_wr_en;
    assign buttons_fifo_din = buttons_din;
    assign buttons_fifo_rd_en = control_buttons_re;
    
    buttons gpio_buttons (
        .clk(clk),
        .rst(rst),
        .buttons(buttons_buttons), // From external
        .wr_en(buttons_wr_en), // To buttons_fifo
        .din(buttons_din), // To buttons_fifo
        .full(buttons_full) // From buttons_fifo
    );
    
    assign buttons_buttons = buttons;
    assign buttons_full = buttons_fifo_full;
    
    leds gpio_leds (
        .clk(clk),
        .rst(rst),
        .we(leds_we), // From dmem_wsel
        .leds_in(leds_leds_in), // From dmem_wsel
        .leds_out(leds_leds_out) // To external
    );
    
    assign leds_we = dmem_wsel_leds_we;
    assign leds_leds_in = dmem_wsel_data[5:0];
    assign leds = leds_leds_out;

    pwm audio_pwm (
        .clk(clk),
        .rst(rst),
        .we(pwm_we), // From dmem_wsel
        .tone_we(pwm_tone_we), // From dmem_wsel
        .wdata(pwm_wdata), // From dmem_wsel
        .tone_enable(pwm_tone_enable), // To tone_generator
        .tone_input(pwm_tone_input) // To tone_generator
    );

    assign pwm_we = dmem_wsel_pwm_we;
    assign pwm_tone_we = dmem_wsel_pwm_tone_we;
    assign pwm_wdata = dmem_wsel_data;

    tone_generator tone_generator (
        .clk(clk),
        .rst(rst),
        .output_enable(tone_generator_output_enable), // From pwm
        .tone_switch_period(tone_generator_tone_switch_period), // From pwm
        .volume(tone_generator_volume), // Set to '1'
        .square_wave_out(tone_generator_square_wave_out) // To external
    );

    assign tone_generator_output_enable = pwm_tone_enable;
    assign tone_generator_tone_switch_period = pwm_tone_input;
    assign tone_generator_volume = 1'b1;
    assign pwm = tone_generator_square_wave_out;
    
endmodule
