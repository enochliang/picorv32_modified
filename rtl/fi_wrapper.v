module fi_wrapper;
//=============================
// Tasks
//=============================

task setmask;
  input [31:0] num;
  output [63:0] o_mask;
  begin
    o_mask = 1 << num;
  end
endtask

task cycle2num;
  input [31:0] cyc;
  output [55:0] num;
  begin
    num2char(cyc/1000000,num[55:48]);
    cyc = cyc % 1000000;
    num2char(cyc/100000,num[47:40]);
    cyc = cyc % 100000;
    num2char(cyc/10000,num[39:32]);
    cyc = cyc % 10000;
    num2char(cyc/1000,num[31:24]);
    cyc = cyc % 1000;
    num2char(cyc/100,num[23:16]);
    cyc = cyc % 100;
    num2char(cyc/10,num[15:8]);
    cyc = cyc % 10;

    num2char(cyc,num[7:0]);
  end
endtask

task num2char;
  input [31:0] num;
  output [7:0] ch;
  begin
    case(num)
      'd0:ch=8'd48;
      'd1:ch=8'd49;
      'd2:ch=8'd50;
      'd3:ch=8'd51;
      'd4:ch=8'd52;
      'd5:ch=8'd53;
      'd6:ch=8'd54;
      'd7:ch=8'd55;
      'd8:ch=8'd56;
      'd9:ch=8'd57;
    endcase
  end
endtask

task num2str;
  input [31:0] num;
  output [31:0] str;
  begin
    num2char(cyc/1000,str[31:24]);
    cyc = cyc % 1000;
    num2char(cyc/100,str[23:16]);
    cyc = cyc % 100;
    num2char(cyc/10,str[15:8]);
    cyc = cyc % 10;

    num2char(num,str[7:0]);
  end
endtask
//----------------------------------------------------------------
//  FI_Wrapper Control Signals Declaration
//----------------------------------------------------------------
reg [31:0] cycle
reg [55:0] cycle_str
reg [55:0] cycle_str2
reg [31:0] inj_id;
reg [31:0] inj_id_str;
reg [31:0] bit_pos;
reg [31:0] bit_pos_str;
reg [63:0] mask;
reg inj_flag;
reg input_flag;
//=====================
// input port buffers
//=====================
reg [0:0] tb_in__resetn;
reg [0:0] tb_in2__resetn;
reg [0:0] tb_in__mem_axi_awready;
reg [0:0] tb_in2__mem_axi_awready;
reg [0:0] tb_in__mem_axi_wready;
reg [0:0] tb_in2__mem_axi_wready;
reg [0:0] tb_in__mem_axi_bvalid;
reg [0:0] tb_in2__mem_axi_bvalid;
reg [0:0] tb_in__mem_axi_arready;
reg [0:0] tb_in2__mem_axi_arready;
reg [0:0] tb_in__mem_axi_rvalid;
reg [0:0] tb_in2__mem_axi_rvalid;
reg [31:0] tb_in__mem_axi_rdata;
reg [31:0] tb_in2__mem_axi_rdata;
reg [0:0] tb_in__pcpi_wr;
reg [0:0] tb_in2__pcpi_wr;
reg [31:0] tb_in__pcpi_rd;
reg [31:0] tb_in2__pcpi_rd;
reg [0:0] tb_in__pcpi_wait;
reg [0:0] tb_in2__pcpi_wait;
reg [0:0] tb_in__pcpi_ready;
reg [0:0] tb_in2__pcpi_ready;
reg [31:0] tb_in__irq;
reg [31:0] tb_in2__irq;
//=====================
// output port buffers
//=====================
reg [0:0] tb_out__trap;
reg [0:0] tb_out__mem_axi_awvalid;
reg [31:0] tb_out__mem_axi_awaddr;
reg [0:0] tb_out__mem_axi_wvalid;
reg [31:0] tb_out__mem_axi_wdata;
reg [3:0] tb_out__mem_axi_wstrb;
reg [0:0] tb_out__mem_axi_bready;
reg [0:0] tb_out__mem_axi_arvalid;
reg [31:0] tb_out__mem_axi_araddr;
reg [2:0] tb_out__mem_axi_arprot;
reg [0:0] tb_out__mem_axi_rready;
reg [0:0] tb_out__pcpi_valid;
reg [31:0] tb_out__pcpi_insn;
reg [31:0] tb_out__pcpi_rs1;
reg [31:0] tb_out__pcpi_rs2;
reg [31:0] tb_out__eoi;
reg [0:0] tb_out__trace_valid;
reg [35:0] tb_out__trace_data;
//=====================
// output port wire
//=====================
wire [0:0] trap;
wire [0:0] mem_axi_awvalid;
wire [31:0] mem_axi_awaddr;
wire [0:0] mem_axi_wvalid;
wire [31:0] mem_axi_wdata;
wire [3:0] mem_axi_wstrb;
wire [0:0] mem_axi_bready;
wire [0:0] mem_axi_arvalid;
wire [31:0] mem_axi_araddr;
wire [2:0] mem_axi_arprot;
wire [0:0] mem_axi_rready;
wire [0:0] pcpi_valid;
wire [31:0] pcpi_insn;
wire [31:0] pcpi_rs1;
wire [31:0] pcpi_rs2;
wire [31:0] eoi;
wire [0:0] trace_valid;
wire [35:0] trace_data;
//=============================
// fault free register buffers
//=============================
reg [0:0] ff_buf__picorv32_axi__mem_valid;
reg [31:0] ff_buf__picorv32_axi__mem_addr;
reg [31:0] ff_buf__picorv32_axi__mem_wdata;
reg [3:0] ff_buf__picorv32_axi__mem_wstrb;
reg [0:0] ff_buf__picorv32_axi__mem_instr;
reg [0:0] ff_buf__picorv32_axi__axi_adapter__ack_awvalid;
reg [0:0] ff_buf__picorv32_axi__axi_adapter__ack_arvalid;
reg [0:0] ff_buf__picorv32_axi__axi_adapter__ack_wvalid;
reg [0:0] ff_buf__picorv32_axi__axi_adapter__xfer_done;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__trap_reg;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__pcpi_valid_reg;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__pcpi_insn_reg;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__eoi_reg;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__trace_valid_reg;
reg [35:0] ff_buf__picorv32_axi__picorv32_core__trace_data_reg;
reg [63:0] ff_buf__picorv32_axi__picorv32_core__count_cycle;
reg [63:0] ff_buf__picorv32_axi__picorv32_core__count_instr;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__reg_pc;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__reg_next_pc;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__reg_op1;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__reg_op2;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__reg_out;
reg [4:0] ff_buf__picorv32_axi__picorv32_core__reg_sh;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__next_insn_opcode;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__dbg_insn_addr;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__irq_delay;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__irq_active;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__irq_mask;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__irq_pending;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__timer;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__cpuregs__0;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__cpuregs__1;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__cpuregs__2;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__cpuregs__3;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__cpuregs__4;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__cpuregs__5;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__cpuregs__6;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__cpuregs__7;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__cpuregs__8;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__cpuregs__9;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__cpuregs__10;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__cpuregs__11;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__cpuregs__12;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__cpuregs__13;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__cpuregs__14;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__cpuregs__15;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__cpuregs__16;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__cpuregs__17;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__cpuregs__18;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__cpuregs__19;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__cpuregs__20;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__cpuregs__21;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__cpuregs__22;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__cpuregs__23;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__cpuregs__24;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__cpuregs__25;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__cpuregs__26;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__cpuregs__27;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__cpuregs__28;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__cpuregs__29;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__cpuregs__30;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__cpuregs__31;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__cpuregs__32;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__cpuregs__33;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__cpuregs__34;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__cpuregs__35;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__pcpi_div_wr;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__pcpi_div_rd;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__pcpi_div_wait;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__pcpi_div_ready;
reg [1:0] ff_buf__picorv32_axi__picorv32_core__mem_state;
reg [1:0] ff_buf__picorv32_axi__picorv32_core__mem_wordsize;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__mem_rdata_q;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__mem_do_prefetch;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__mem_do_rinst;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__mem_do_rdata;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__mem_do_wdata;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__mem_la_secondword;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__mem_la_firstword_reg;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__last_mem_valid;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__prefetched_high_word;
reg [15:0] ff_buf__picorv32_axi__picorv32_core__mem_16bit_buffer;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_lui;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_auipc;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_jal;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_jalr;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_beq;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_bne;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_blt;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_bge;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_bltu;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_bgeu;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_lb;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_lh;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_lw;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_lbu;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_lhu;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_sb;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_sh;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_sw;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_addi;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_slti;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_sltiu;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_xori;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_ori;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_andi;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_slli;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_srli;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_srai;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_add;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_sub;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_sll;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_slt;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_sltu;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_xor;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_srl;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_sra;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_or;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_and;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_rdcycle;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_rdcycleh;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_rdinstr;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_rdinstrh;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_ecall_ebreak;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_fence;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_getq;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_setq;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_retirq;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_maskirq;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_waitirq;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__instr_timer;
reg [5:0] ff_buf__picorv32_axi__picorv32_core__decoded_rd;
reg [5:0] ff_buf__picorv32_axi__picorv32_core__decoded_rs1;
reg [4:0] ff_buf__picorv32_axi__picorv32_core__decoded_rs2;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__decoded_imm;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__decoded_imm_j;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__decoder_trigger;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__decoder_trigger_q;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__decoder_pseudo_trigger;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__decoder_pseudo_trigger_q;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__compressed_instr;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__is_lui_auipc_jal;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__is_lb_lh_lw_lbu_lhu;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__is_slli_srli_srai;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__is_jalr_addi_slti_sltiu_xori_ori_andi;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__is_sb_sh_sw;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__is_sll_srl_sra;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__is_lui_auipc_jal_jalr_addi_add_sub;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__is_slti_blt_slt;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__is_sltiu_bltu_sltu;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__is_beq_bne_blt_bge_bltu_bgeu;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__is_lbu_lhu_lw;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__is_alu_reg_imm;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__is_alu_reg_reg;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__is_compare;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__dbg_rs1val;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__dbg_rs2val;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__dbg_rs1val_valid;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__dbg_rs2val_valid;
reg [63:0] ff_buf__picorv32_axi__picorv32_core__q_ascii_instr;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__q_insn_imm;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__q_insn_opcode;
reg [4:0] ff_buf__picorv32_axi__picorv32_core__q_insn_rs1;
reg [4:0] ff_buf__picorv32_axi__picorv32_core__q_insn_rs2;
reg [4:0] ff_buf__picorv32_axi__picorv32_core__q_insn_rd;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__dbg_next;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__dbg_valid_insn;
reg [63:0] ff_buf__picorv32_axi__picorv32_core__cached_ascii_instr;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__cached_insn_imm;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__cached_insn_opcode;
reg [4:0] ff_buf__picorv32_axi__picorv32_core__cached_insn_rs1;
reg [4:0] ff_buf__picorv32_axi__picorv32_core__cached_insn_rs2;
reg [4:0] ff_buf__picorv32_axi__picorv32_core__cached_insn_rd;
reg [7:0] ff_buf__picorv32_axi__picorv32_core__cpu_state;
reg [1:0] ff_buf__picorv32_axi__picorv32_core__irq_state;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__latched_store;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__latched_stalu;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__latched_branch;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__latched_compr;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__latched_trace;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__latched_is_lu;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__latched_is_lh;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__latched_is_lb;
reg [5:0] ff_buf__picorv32_axi__picorv32_core__latched_rd;
reg [3:0] ff_buf__picorv32_axi__picorv32_core__pcpi_timeout_counter;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__pcpi_timeout;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__do_waitirq;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__alu_out_q;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__alu_out_0_q;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__alu_wait;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__alu_wait_2;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__clear_prefetched_high_word_q;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__genblk1__pcpi_mul__shift_out;
reg [3:0] ff_buf__picorv32_axi__picorv32_core__genblk1__pcpi_mul__active;
reg [32:0] ff_buf__picorv32_axi__picorv32_core__genblk1__pcpi_mul__rs1;
reg [32:0] ff_buf__picorv32_axi__picorv32_core__genblk1__pcpi_mul__rs2;
reg [32:0] ff_buf__picorv32_axi__picorv32_core__genblk1__pcpi_mul__rs1_q;
reg [32:0] ff_buf__picorv32_axi__picorv32_core__genblk1__pcpi_mul__rs2_q;
reg [63:0] ff_buf__picorv32_axi__picorv32_core__genblk1__pcpi_mul__rd;
reg [63:0] ff_buf__picorv32_axi__picorv32_core__genblk1__pcpi_mul__rd_q;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__genblk1__pcpi_mul__pcpi_insn_valid_q;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__genblk2__pcpi_div__instr_div;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__genblk2__pcpi_div__instr_divu;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__genblk2__pcpi_div__instr_rem;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__genblk2__pcpi_div__instr_remu;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__genblk2__pcpi_div__pcpi_wait_q;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__genblk2__pcpi_div__dividend;
reg [62:0] ff_buf__picorv32_axi__picorv32_core__genblk2__pcpi_div__divisor;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__genblk2__pcpi_div__quotient;
reg [31:0] ff_buf__picorv32_axi__picorv32_core__genblk2__pcpi_div__quotient_msk;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__genblk2__pcpi_div__running;
reg [0:0] ff_buf__picorv32_axi__picorv32_core__genblk2__pcpi_div__outsign;
//=============================
// golden register buffers
//=============================
reg [0:0] golden_buf__picorv32_axi__mem_valid;
reg [31:0] golden_buf__picorv32_axi__mem_addr;
reg [31:0] golden_buf__picorv32_axi__mem_wdata;
reg [3:0] golden_buf__picorv32_axi__mem_wstrb;
reg [0:0] golden_buf__picorv32_axi__mem_instr;
reg [0:0] golden_buf__picorv32_axi__axi_adapter__ack_awvalid;
reg [0:0] golden_buf__picorv32_axi__axi_adapter__ack_arvalid;
reg [0:0] golden_buf__picorv32_axi__axi_adapter__ack_wvalid;
reg [0:0] golden_buf__picorv32_axi__axi_adapter__xfer_done;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__trap_reg;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__pcpi_valid_reg;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__pcpi_insn_reg;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__eoi_reg;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__trace_valid_reg;
reg [35:0] golden_buf__picorv32_axi__picorv32_core__trace_data_reg;
reg [63:0] golden_buf__picorv32_axi__picorv32_core__count_cycle;
reg [63:0] golden_buf__picorv32_axi__picorv32_core__count_instr;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__reg_pc;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__reg_next_pc;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__reg_op1;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__reg_op2;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__reg_out;
reg [4:0] golden_buf__picorv32_axi__picorv32_core__reg_sh;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__next_insn_opcode;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__dbg_insn_addr;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__irq_delay;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__irq_active;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__irq_mask;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__irq_pending;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__timer;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__cpuregs__0;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__cpuregs__1;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__cpuregs__2;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__cpuregs__3;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__cpuregs__4;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__cpuregs__5;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__cpuregs__6;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__cpuregs__7;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__cpuregs__8;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__cpuregs__9;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__cpuregs__10;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__cpuregs__11;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__cpuregs__12;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__cpuregs__13;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__cpuregs__14;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__cpuregs__15;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__cpuregs__16;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__cpuregs__17;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__cpuregs__18;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__cpuregs__19;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__cpuregs__20;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__cpuregs__21;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__cpuregs__22;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__cpuregs__23;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__cpuregs__24;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__cpuregs__25;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__cpuregs__26;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__cpuregs__27;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__cpuregs__28;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__cpuregs__29;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__cpuregs__30;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__cpuregs__31;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__cpuregs__32;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__cpuregs__33;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__cpuregs__34;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__cpuregs__35;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__pcpi_div_wr;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__pcpi_div_rd;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__pcpi_div_wait;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__pcpi_div_ready;
reg [1:0] golden_buf__picorv32_axi__picorv32_core__mem_state;
reg [1:0] golden_buf__picorv32_axi__picorv32_core__mem_wordsize;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__mem_rdata_q;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__mem_do_prefetch;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__mem_do_rinst;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__mem_do_rdata;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__mem_do_wdata;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__mem_la_secondword;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__mem_la_firstword_reg;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__last_mem_valid;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__prefetched_high_word;
reg [15:0] golden_buf__picorv32_axi__picorv32_core__mem_16bit_buffer;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_lui;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_auipc;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_jal;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_jalr;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_beq;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_bne;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_blt;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_bge;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_bltu;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_bgeu;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_lb;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_lh;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_lw;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_lbu;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_lhu;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_sb;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_sh;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_sw;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_addi;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_slti;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_sltiu;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_xori;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_ori;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_andi;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_slli;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_srli;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_srai;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_add;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_sub;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_sll;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_slt;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_sltu;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_xor;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_srl;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_sra;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_or;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_and;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_rdcycle;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_rdcycleh;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_rdinstr;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_rdinstrh;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_ecall_ebreak;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_fence;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_getq;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_setq;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_retirq;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_maskirq;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_waitirq;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__instr_timer;
reg [5:0] golden_buf__picorv32_axi__picorv32_core__decoded_rd;
reg [5:0] golden_buf__picorv32_axi__picorv32_core__decoded_rs1;
reg [4:0] golden_buf__picorv32_axi__picorv32_core__decoded_rs2;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__decoded_imm;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__decoded_imm_j;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__decoder_trigger;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__decoder_trigger_q;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__decoder_pseudo_trigger;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__decoder_pseudo_trigger_q;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__compressed_instr;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__is_lui_auipc_jal;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__is_lb_lh_lw_lbu_lhu;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__is_slli_srli_srai;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__is_jalr_addi_slti_sltiu_xori_ori_andi;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__is_sb_sh_sw;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__is_sll_srl_sra;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__is_lui_auipc_jal_jalr_addi_add_sub;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__is_slti_blt_slt;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__is_sltiu_bltu_sltu;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__is_beq_bne_blt_bge_bltu_bgeu;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__is_lbu_lhu_lw;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__is_alu_reg_imm;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__is_alu_reg_reg;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__is_compare;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__dbg_rs1val;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__dbg_rs2val;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__dbg_rs1val_valid;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__dbg_rs2val_valid;
reg [63:0] golden_buf__picorv32_axi__picorv32_core__q_ascii_instr;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__q_insn_imm;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__q_insn_opcode;
reg [4:0] golden_buf__picorv32_axi__picorv32_core__q_insn_rs1;
reg [4:0] golden_buf__picorv32_axi__picorv32_core__q_insn_rs2;
reg [4:0] golden_buf__picorv32_axi__picorv32_core__q_insn_rd;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__dbg_next;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__dbg_valid_insn;
reg [63:0] golden_buf__picorv32_axi__picorv32_core__cached_ascii_instr;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__cached_insn_imm;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__cached_insn_opcode;
reg [4:0] golden_buf__picorv32_axi__picorv32_core__cached_insn_rs1;
reg [4:0] golden_buf__picorv32_axi__picorv32_core__cached_insn_rs2;
reg [4:0] golden_buf__picorv32_axi__picorv32_core__cached_insn_rd;
reg [7:0] golden_buf__picorv32_axi__picorv32_core__cpu_state;
reg [1:0] golden_buf__picorv32_axi__picorv32_core__irq_state;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__latched_store;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__latched_stalu;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__latched_branch;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__latched_compr;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__latched_trace;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__latched_is_lu;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__latched_is_lh;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__latched_is_lb;
reg [5:0] golden_buf__picorv32_axi__picorv32_core__latched_rd;
reg [3:0] golden_buf__picorv32_axi__picorv32_core__pcpi_timeout_counter;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__pcpi_timeout;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__do_waitirq;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__alu_out_q;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__alu_out_0_q;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__alu_wait;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__alu_wait_2;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__clear_prefetched_high_word_q;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__genblk1__pcpi_mul__shift_out;
reg [3:0] golden_buf__picorv32_axi__picorv32_core__genblk1__pcpi_mul__active;
reg [32:0] golden_buf__picorv32_axi__picorv32_core__genblk1__pcpi_mul__rs1;
reg [32:0] golden_buf__picorv32_axi__picorv32_core__genblk1__pcpi_mul__rs2;
reg [32:0] golden_buf__picorv32_axi__picorv32_core__genblk1__pcpi_mul__rs1_q;
reg [32:0] golden_buf__picorv32_axi__picorv32_core__genblk1__pcpi_mul__rs2_q;
reg [63:0] golden_buf__picorv32_axi__picorv32_core__genblk1__pcpi_mul__rd;
reg [63:0] golden_buf__picorv32_axi__picorv32_core__genblk1__pcpi_mul__rd_q;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__genblk1__pcpi_mul__pcpi_insn_valid_q;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__genblk2__pcpi_div__instr_div;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__genblk2__pcpi_div__instr_divu;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__genblk2__pcpi_div__instr_rem;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__genblk2__pcpi_div__instr_remu;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__genblk2__pcpi_div__pcpi_wait_q;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__genblk2__pcpi_div__dividend;
reg [62:0] golden_buf__picorv32_axi__picorv32_core__genblk2__pcpi_div__divisor;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__genblk2__pcpi_div__quotient;
reg [31:0] golden_buf__picorv32_axi__picorv32_core__genblk2__pcpi_div__quotient_msk;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__genblk2__pcpi_div__running;
reg [0:0] golden_buf__picorv32_axi__picorv32_core__genblk2__pcpi_div__outsign;


	picorv32_axi #(
		.COMPRESSED_ISA(1),
		.ENABLE_MUL(1),
		.ENABLE_DIV(1),
		.ENABLE_IRQ(1),
		.ENABLE_TRACE(1)
	) picorv32_axi (
            .resetn(tb_in__resetn),
            .mem_axi_awready(tb_in__mem_axi_awready),
            .mem_axi_wready(tb_in__mem_axi_wready),
            .mem_axi_bvalid(tb_in__mem_axi_bvalid),
            .mem_axi_arready(tb_in__mem_axi_arready),
            .mem_axi_rvalid(tb_in__mem_axi_rvalid),
            .mem_axi_rdata(tb_in__mem_axi_rdata),
            .pcpi_wr(tb_in__pcpi_wr),
            .pcpi_rd(tb_in__pcpi_rd),
            .pcpi_wait(tb_in__pcpi_wait),
            .pcpi_ready(tb_in__pcpi_ready),
            .irq(tb_in__irq),
            .trap(trap),
            .mem_axi_awvalid(mem_axi_awvalid),
            .mem_axi_awaddr(mem_axi_awaddr),
            .mem_axi_wvalid(mem_axi_wvalid),
            .mem_axi_wdata(mem_axi_wdata),
            .mem_axi_wstrb(mem_axi_wstrb),
            .mem_axi_bready(mem_axi_bready),
            .mem_axi_arvalid(mem_axi_arvalid),
            .mem_axi_araddr(mem_axi_araddr),
            .mem_axi_arprot(mem_axi_arprot),
            .mem_axi_rready(mem_axi_rready),
            .pcpi_valid(pcpi_valid),
            .pcpi_insn(pcpi_insn),
            .pcpi_rs1(pcpi_rs1),
            .pcpi_rs2(pcpi_rs2),
            .eoi(eoi),
            .trace_valid(trace_valid),
            .trace_data(trace_data),
          );

endmodule
