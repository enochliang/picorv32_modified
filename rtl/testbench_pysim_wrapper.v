// This is free and unencumbered software released into the public domain.
//
// Anyone is free to copy, modify, publish, use, compile, sell, or
// distribute this software, either in source code form or as a compiled
// binary, for any purpose, commercial or non-commercial, and by any
// means.

`timescale 1 ns / 1 ps

`ifndef VERILATOR
module testbench #(
	parameter AXI_TEST = 0,
	parameter VERBOSE = 0
);
//=============================
// Tasks
//=============================
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
	reg clk = 1;
	reg resetn = 0;
	wire trap;

	always #5 clk = ~clk;

	initial begin
		repeat (100) @(posedge clk);
		resetn <= 1;
	end

	initial begin
		if ($test$plusargs("vcd")) begin
			$dumpfile("testbench.vcd");
			$dumpvars(0, testbench);
		end
		repeat (1000000) @(posedge clk);
		$display("TIMEOUT");
		$finish;
	end

	wire trace_valid;
	wire [35:0] trace_data;
	integer trace_file;

	initial begin
		if ($test$plusargs("trace")) begin
			trace_file = $fopen("testbench.trace", "w");
			repeat (10) @(posedge clk);
			while (!trap) begin
				@(posedge clk);
				if (trace_valid)
					$fwrite(trace_file, "%x\n", trace_data);
			end
			$fclose(trace_file);
			$display("Finished writing testbench.trace.");
		end
	end

//=============================
// Generate Counter
//=============================
reg [31:0] cycle;
always@(posedge clk) begin
  if(!resetn) cycle <= 0;
  else            cycle <= cycle + 1;
end
//============================
// Generate Counter String
//============================
  reg [55:0] cycle_str;
//============================
// Dump Logic Value for Pysim
//============================
integer ffi_f;
always@(posedge clk) begin
  if(resetn) begin
    if(1) begin
      cycle2num(cycle,cycle_str);
      ffi_f = $fopen({"pysim_ff_value/ff_value_C",cycle_str,".txt"},"w");
      $fwrite(ffi_f,"%b\n",top.uut.resetn);
      $fwrite(ffi_f,"%b\n",top.uut.trap);
      $fwrite(ffi_f,"%b\n",top.uut.mem_axi_awvalid);
      $fwrite(ffi_f,"%b\n",top.uut.mem_axi_awready);
      $fwrite(ffi_f,"%b\n",top.uut.mem_axi_awaddr);
      $fwrite(ffi_f,"%b\n",top.uut.mem_axi_wvalid);
      $fwrite(ffi_f,"%b\n",top.uut.mem_axi_wready);
      $fwrite(ffi_f,"%b\n",top.uut.mem_axi_wdata);
      $fwrite(ffi_f,"%b\n",top.uut.mem_axi_wstrb);
      $fwrite(ffi_f,"%b\n",top.uut.mem_axi_bvalid);
      $fwrite(ffi_f,"%b\n",top.uut.mem_axi_bready);
      $fwrite(ffi_f,"%b\n",top.uut.mem_axi_arvalid);
      $fwrite(ffi_f,"%b\n",top.uut.mem_axi_arready);
      $fwrite(ffi_f,"%b\n",top.uut.mem_axi_araddr);
      $fwrite(ffi_f,"%b\n",top.uut.mem_axi_arprot);
      $fwrite(ffi_f,"%b\n",top.uut.mem_axi_rvalid);
      $fwrite(ffi_f,"%b\n",top.uut.mem_axi_rready);
      $fwrite(ffi_f,"%b\n",top.uut.mem_axi_rdata);
      $fwrite(ffi_f,"%b\n",top.uut.pcpi_valid);
      $fwrite(ffi_f,"%b\n",top.uut.pcpi_insn);
      $fwrite(ffi_f,"%b\n",top.uut.pcpi_rs1);
      $fwrite(ffi_f,"%b\n",top.uut.pcpi_rs2);
      $fwrite(ffi_f,"%b\n",top.uut.pcpi_wr);
      $fwrite(ffi_f,"%b\n",top.uut.pcpi_rd);
      $fwrite(ffi_f,"%b\n",top.uut.pcpi_wait);
      $fwrite(ffi_f,"%b\n",top.uut.pcpi_ready);
      $fwrite(ffi_f,"%b\n",top.uut.irq);
      $fwrite(ffi_f,"%b\n",top.uut.eoi);
      $fwrite(ffi_f,"%b\n",top.uut.trace_valid);
      $fwrite(ffi_f,"%b\n",top.uut.trace_data);
      $fwrite(ffi_f,"%b\n",top.uut.mem_valid);
      $fwrite(ffi_f,"%b\n",top.uut.mem_addr);
      $fwrite(ffi_f,"%b\n",top.uut.mem_wdata);
      $fwrite(ffi_f,"%b\n",top.uut.mem_wstrb);
      $fwrite(ffi_f,"%b\n",top.uut.mem_instr);
      $fwrite(ffi_f,"%b\n",top.uut.mem_ready);
      $fwrite(ffi_f,"%b\n",top.uut.axi_adapter.ack_awvalid);
      $fwrite(ffi_f,"%b\n",top.uut.axi_adapter.ack_arvalid);
      $fwrite(ffi_f,"%b\n",top.uut.axi_adapter.ack_wvalid);
      $fwrite(ffi_f,"%b\n",top.uut.axi_adapter.xfer_done);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.mem_la_read);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.mem_la_write);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.mem_la_addr);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.mem_la_wdata);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.mem_la_wstrb);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.trap_reg);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.pcpi_valid_reg);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.pcpi_insn_reg);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.eoi_reg);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.trace_valid_reg);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.trace_data_reg);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.count_cycle);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.count_instr);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.reg_pc);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.reg_next_pc);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.reg_op1);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.reg_op2);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.reg_out);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.reg_sh);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.next_insn_opcode);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.dbg_insn_opcode);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.dbg_insn_addr);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.next_pc);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.irq_delay);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.irq_active);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.irq_mask);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.irq_pending);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.timer);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs[0]);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs[1]);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs[2]);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs[3]);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs[4]);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs[5]);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs[6]);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs[7]);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs[8]);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs[9]);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs[10]);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs[11]);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs[12]);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs[13]);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs[14]);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs[15]);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs[16]);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs[17]);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs[18]);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs[19]);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs[20]);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs[21]);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs[22]);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs[23]);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs[24]);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs[25]);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs[26]);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs[27]);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs[28]);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs[29]);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs[30]);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs[31]);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs[32]);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs[33]);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs[34]);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs[35]);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.pcpi_mul_wr);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.pcpi_mul_rd);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.pcpi_div_wr);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.pcpi_div_rd);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.pcpi_div_wait);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.pcpi_div_ready);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.pcpi_int_wr);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.pcpi_int_rd);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.pcpi_int_wait);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.pcpi_int_ready);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.mem_state);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.mem_wordsize);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.mem_rdata_word);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.mem_rdata_q);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.mem_do_prefetch);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.mem_do_rinst);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.mem_do_rdata);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.mem_do_wdata);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.mem_xfer);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.mem_la_secondword);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.mem_la_firstword_reg);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.last_mem_valid);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.mem_la_firstword);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.mem_la_firstword_xfer);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.prefetched_high_word);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.clear_prefetched_high_word);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.mem_16bit_buffer);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.mem_rdata_latched_noshuffle);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.mem_rdata_latched);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.mem_la_use_prefetched_high_word);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.mem_done);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_lui);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_auipc);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_jal);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_jalr);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_beq);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_bne);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_blt);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_bge);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_bltu);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_bgeu);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_lb);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_lh);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_lw);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_lbu);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_lhu);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_sb);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_sh);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_sw);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_addi);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_slti);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_sltiu);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_xori);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_ori);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_andi);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_slli);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_srli);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_srai);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_add);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_sub);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_sll);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_slt);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_sltu);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_xor);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_srl);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_sra);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_or);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_and);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_rdcycle);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_rdcycleh);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_rdinstr);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_rdinstrh);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_ecall_ebreak);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_fence);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_getq);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_setq);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_retirq);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_maskirq);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_waitirq);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_timer);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.instr_trap);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.decoded_rd);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.decoded_rs1);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.decoded_rs2);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.decoded_imm);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.decoded_imm_j);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.decoder_trigger);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.decoder_trigger_q);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.decoder_pseudo_trigger);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.decoder_pseudo_trigger_q);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.compressed_instr);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.is_lui_auipc_jal);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.is_lb_lh_lw_lbu_lhu);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.is_slli_srli_srai);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.is_jalr_addi_slti_sltiu_xori_ori_andi);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.is_sb_sh_sw);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.is_sll_srl_sra);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.is_lui_auipc_jal_jalr_addi_add_sub);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.is_slti_blt_slt);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.is_sltiu_bltu_sltu);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.is_beq_bne_blt_bge_bltu_bgeu);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.is_lbu_lhu_lw);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.is_alu_reg_imm);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.is_alu_reg_reg);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.is_compare);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.is_rdcycle_rdcycleh_rdinstr_rdinstrh);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.new_ascii_instr);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.dbg_ascii_instr);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.dbg_insn_imm);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.dbg_insn_rs1);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.dbg_insn_rs2);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.dbg_insn_rd);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.dbg_rs1val);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.dbg_rs2val);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.dbg_rs1val_valid);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.dbg_rs2val_valid);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.q_ascii_instr);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.q_insn_imm);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.q_insn_opcode);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.q_insn_rs1);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.q_insn_rs2);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.q_insn_rd);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.dbg_next);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.launch_next_insn);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.dbg_valid_insn);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cached_ascii_instr);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cached_insn_imm);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cached_insn_opcode);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cached_insn_rs1);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cached_insn_rs2);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cached_insn_rd);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpu_state);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.irq_state);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.dbg_ascii_state);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.set_mem_do_rinst);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.set_mem_do_rdata);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.set_mem_do_wdata);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.latched_store);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.latched_stalu);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.latched_branch);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.latched_compr);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.latched_trace);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.latched_is_lu);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.latched_is_lh);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.latched_is_lb);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.latched_rd);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.current_pc);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.pcpi_timeout_counter);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.pcpi_timeout);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.next_irq_pending);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.do_waitirq);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.alu_out);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.alu_out_q);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.alu_out_0);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.alu_out_0_q);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.alu_wait);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.alu_wait_2);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.alu_add_sub);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.alu_shl);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.alu_shr);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.alu_eq);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.alu_ltu);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.alu_lts);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.clear_prefetched_high_word_q);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs_write);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs_wrdata);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs_rs1);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.cpuregs_rs2);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.genblk1.pcpi_mul.instr_mul);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.genblk1.pcpi_mul.instr_mulh);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.genblk1.pcpi_mul.instr_mulhsu);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.genblk1.pcpi_mul.instr_mulhu);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.genblk1.pcpi_mul.instr_any_mul);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.genblk1.pcpi_mul.instr_any_mulh);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.genblk1.pcpi_mul.instr_rs1_signed);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.genblk1.pcpi_mul.shift_out);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.genblk1.pcpi_mul.active);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.genblk1.pcpi_mul.rs1);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.genblk1.pcpi_mul.rs2);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.genblk1.pcpi_mul.rs1_q);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.genblk1.pcpi_mul.rs2_q);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.genblk1.pcpi_mul.rd);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.genblk1.pcpi_mul.rd_q);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.genblk1.pcpi_mul.pcpi_insn_valid);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.genblk1.pcpi_mul.pcpi_insn_valid_q);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.genblk2.pcpi_div.instr_div);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.genblk2.pcpi_div.instr_divu);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.genblk2.pcpi_div.instr_rem);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.genblk2.pcpi_div.instr_remu);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.genblk2.pcpi_div.instr_any_div_rem);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.genblk2.pcpi_div.pcpi_wait_q);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.genblk2.pcpi_div.start);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.genblk2.pcpi_div.dividend);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.genblk2.pcpi_div.divisor);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.genblk2.pcpi_div.quotient);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.genblk2.pcpi_div.quotient_msk);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.genblk2.pcpi_div.running);
      $fwrite(ffi_f,"%b\n",top.uut.picorv32_core.genblk2.pcpi_div.outsign);
      $fclose(ffi_f);
    end
  end
end

	picorv32_wrapper #(
		.AXI_TEST (AXI_TEST),
		.VERBOSE  (VERBOSE)
	) top (
		.clk(clk),
		.resetn(resetn),
		.trap(trap),
		.trace_valid(trace_valid),
		.trace_data(trace_data)
	);
endmodule
`endif

module picorv32_wrapper #(
	parameter AXI_TEST = 0,
	parameter VERBOSE = 0
) (
	input clk,
	input resetn,
	output trap,
	output trace_valid,
	output [35:0] trace_data
);
	wire tests_passed;
	reg [31:0] irq = 0;

	reg [15:0] count_cycle = 0;
	always @(posedge clk) count_cycle <= resetn ? count_cycle + 1 : 0;

	always @* begin
		irq = 0;
		irq[4] = &count_cycle[12:0];
		irq[5] = &count_cycle[15:0];
	end

	wire        mem_axi_awvalid;
	wire        mem_axi_awready;
	wire [31:0] mem_axi_awaddr;
	wire [ 2:0] mem_axi_awprot;

	wire        mem_axi_wvalid;
	wire        mem_axi_wready;
	wire [31:0] mem_axi_wdata;
	wire [ 3:0] mem_axi_wstrb;

	wire        mem_axi_bvalid;
	wire        mem_axi_bready;

	wire        mem_axi_arvalid;
	wire        mem_axi_arready;
	wire [31:0] mem_axi_araddr;
	wire [ 2:0] mem_axi_arprot;

	wire        mem_axi_rvalid;
	wire        mem_axi_rready;
	wire [31:0] mem_axi_rdata;

	axi4_memory #(
		.AXI_TEST (AXI_TEST),
		.VERBOSE  (VERBOSE)
	) mem (
		.clk             (clk             ),
		.mem_axi_awvalid (mem_axi_awvalid ),
		.mem_axi_awready (mem_axi_awready ),
		.mem_axi_awaddr  (mem_axi_awaddr  ),
		.mem_axi_awprot  (mem_axi_awprot  ),

		.mem_axi_wvalid  (mem_axi_wvalid  ),
		.mem_axi_wready  (mem_axi_wready  ),
		.mem_axi_wdata   (mem_axi_wdata   ),
		.mem_axi_wstrb   (mem_axi_wstrb   ),

		.mem_axi_bvalid  (mem_axi_bvalid  ),
		.mem_axi_bready  (mem_axi_bready  ),

		.mem_axi_arvalid (mem_axi_arvalid ),
		.mem_axi_arready (mem_axi_arready ),
		.mem_axi_araddr  (mem_axi_araddr  ),
		.mem_axi_arprot  (mem_axi_arprot  ),

		.mem_axi_rvalid  (mem_axi_rvalid  ),
		.mem_axi_rready  (mem_axi_rready  ),
		.mem_axi_rdata   (mem_axi_rdata   ),

		.tests_passed    (tests_passed    )
	);

`ifdef RISCV_FORMAL
	wire        rvfi_valid;
	wire [63:0] rvfi_order;
	wire [31:0] rvfi_insn;
	wire        rvfi_trap;
	wire        rvfi_halt;
	wire        rvfi_intr;
	wire [4:0]  rvfi_rs1_addr;
	wire [4:0]  rvfi_rs2_addr;
	wire [31:0] rvfi_rs1_rdata;
	wire [31:0] rvfi_rs2_rdata;
	wire [4:0]  rvfi_rd_addr;
	wire [31:0] rvfi_rd_wdata;
	wire [31:0] rvfi_pc_rdata;
	wire [31:0] rvfi_pc_wdata;
	wire [31:0] rvfi_mem_addr;
	wire [3:0]  rvfi_mem_rmask;
	wire [3:0]  rvfi_mem_wmask;
	wire [31:0] rvfi_mem_rdata;
	wire [31:0] rvfi_mem_wdata;
`endif

	picorv32_axi #(
`ifndef SYNTH_TEST
`ifdef SP_TEST
		.ENABLE_REGS_DUALPORT(0),
`endif
`ifdef COMPRESSED_ISA
		.COMPRESSED_ISA(1),
`endif
		.ENABLE_FAST_MUL(1),
		.ENABLE_DIV(1),
		.ENABLE_IRQ(1),
		.ENABLE_TRACE(1)
`endif
	) uut (
		.clk            (clk            ),
		.resetn         (resetn         ),
		.trap           (trap           ),
		.mem_axi_awvalid(mem_axi_awvalid),
		.mem_axi_awready(mem_axi_awready),
		.mem_axi_awaddr (mem_axi_awaddr ),
		.mem_axi_awprot (mem_axi_awprot ),
		.mem_axi_wvalid (mem_axi_wvalid ),
		.mem_axi_wready (mem_axi_wready ),
		.mem_axi_wdata  (mem_axi_wdata  ),
		.mem_axi_wstrb  (mem_axi_wstrb  ),
		.mem_axi_bvalid (mem_axi_bvalid ),
		.mem_axi_bready (mem_axi_bready ),
		.mem_axi_arvalid(mem_axi_arvalid),
		.mem_axi_arready(mem_axi_arready),
		.mem_axi_araddr (mem_axi_araddr ),
		.mem_axi_arprot (mem_axi_arprot ),
		.mem_axi_rvalid (mem_axi_rvalid ),
		.mem_axi_rready (mem_axi_rready ),
		.mem_axi_rdata  (mem_axi_rdata  ),
		.irq            (irq            ),
`ifdef RISCV_FORMAL
		.rvfi_valid     (rvfi_valid     ),
		.rvfi_order     (rvfi_order     ),
		.rvfi_insn      (rvfi_insn      ),
		.rvfi_trap      (rvfi_trap      ),
		.rvfi_halt      (rvfi_halt      ),
		.rvfi_intr      (rvfi_intr      ),
		.rvfi_rs1_addr  (rvfi_rs1_addr  ),
		.rvfi_rs2_addr  (rvfi_rs2_addr  ),
		.rvfi_rs1_rdata (rvfi_rs1_rdata ),
		.rvfi_rs2_rdata (rvfi_rs2_rdata ),
		.rvfi_rd_addr   (rvfi_rd_addr   ),
		.rvfi_rd_wdata  (rvfi_rd_wdata  ),
		.rvfi_pc_rdata  (rvfi_pc_rdata  ),
		.rvfi_pc_wdata  (rvfi_pc_wdata  ),
		.rvfi_mem_addr  (rvfi_mem_addr  ),
		.rvfi_mem_rmask (rvfi_mem_rmask ),
		.rvfi_mem_wmask (rvfi_mem_wmask ),
		.rvfi_mem_rdata (rvfi_mem_rdata ),
		.rvfi_mem_wdata (rvfi_mem_wdata ),
`endif
		.trace_valid    (trace_valid    ),
		.trace_data     (trace_data     )
	);

`ifdef RISCV_FORMAL
	picorv32_rvfimon rvfi_monitor (
		.clock          (clk           ),
		.reset          (!resetn       ),
		.rvfi_valid     (rvfi_valid    ),
		.rvfi_order     (rvfi_order    ),
		.rvfi_insn      (rvfi_insn     ),
		.rvfi_trap      (rvfi_trap     ),
		.rvfi_halt      (rvfi_halt     ),
		.rvfi_intr      (rvfi_intr     ),
		.rvfi_rs1_addr  (rvfi_rs1_addr ),
		.rvfi_rs2_addr  (rvfi_rs2_addr ),
		.rvfi_rs1_rdata (rvfi_rs1_rdata),
		.rvfi_rs2_rdata (rvfi_rs2_rdata),
		.rvfi_rd_addr   (rvfi_rd_addr  ),
		.rvfi_rd_wdata  (rvfi_rd_wdata ),
		.rvfi_pc_rdata  (rvfi_pc_rdata ),
		.rvfi_pc_wdata  (rvfi_pc_wdata ),
		.rvfi_mem_addr  (rvfi_mem_addr ),
		.rvfi_mem_rmask (rvfi_mem_rmask),
		.rvfi_mem_wmask (rvfi_mem_wmask),
		.rvfi_mem_rdata (rvfi_mem_rdata),
		.rvfi_mem_wdata (rvfi_mem_wdata)
	);
`endif

	reg [1023:0] firmware_file;
	initial begin
		if (!$value$plusargs("firmware=%s", firmware_file))
			firmware_file = "firmware/firmware.hex";
		$readmemh(firmware_file, mem.memory);
	end

	integer cycle_counter;
	always @(posedge clk) begin
		cycle_counter <= resetn ? cycle_counter + 1 : 0;
		if (resetn && trap) begin
`ifndef VERILATOR
			repeat (10) @(posedge clk);
`endif
			$display("TRAP after %1d clock cycles", cycle_counter);
			if (tests_passed) begin
				$display("ALL TESTS PASSED.");
				$finish;
			end else begin
				$display("ERROR!");
				if ($test$plusargs("noerror"))
					$finish;
				$stop;
			end
		end
	end
endmodule

module axi4_memory #(
	parameter AXI_TEST = 0,
	parameter VERBOSE = 0
) (
	/* verilator lint_off MULTIDRIVEN */

	input             clk,
	input             mem_axi_awvalid,
	output reg        mem_axi_awready,
	input      [31:0] mem_axi_awaddr,
	input      [ 2:0] mem_axi_awprot,

	input             mem_axi_wvalid,
	output reg        mem_axi_wready,
	input      [31:0] mem_axi_wdata,
	input      [ 3:0] mem_axi_wstrb,

	output reg        mem_axi_bvalid,
	input             mem_axi_bready,

	input             mem_axi_arvalid,
	output reg        mem_axi_arready,
	input      [31:0] mem_axi_araddr,
	input      [ 2:0] mem_axi_arprot,

	output reg        mem_axi_rvalid,
	input             mem_axi_rready,
	output reg [31:0] mem_axi_rdata,

	output reg        tests_passed
);
	reg [31:0]   memory [0:128*1024/4-1] /* verilator public */;
	reg verbose;
	initial verbose = $test$plusargs("verbose") || VERBOSE;

	reg axi_test;
	initial axi_test = $test$plusargs("axi_test") || AXI_TEST;

	initial begin
		mem_axi_awready = 0;
		mem_axi_wready = 0;
		mem_axi_bvalid = 0;
		mem_axi_arready = 0;
		mem_axi_rvalid = 0;
		tests_passed = 0;
	end

	reg [63:0] xorshift64_state = 64'd88172645463325252;

	task xorshift64_next;
		begin
			// see page 4 of Marsaglia, George (July 2003). "Xorshift RNGs". Journal of Statistical Software 8 (14).
			xorshift64_state = xorshift64_state ^ (xorshift64_state << 13);
			xorshift64_state = xorshift64_state ^ (xorshift64_state >>  7);
			xorshift64_state = xorshift64_state ^ (xorshift64_state << 17);
		end
	endtask

	reg [2:0] fast_axi_transaction = ~0;
	reg [4:0] async_axi_transaction = ~0;
	reg [4:0] delay_axi_transaction = 0;

	always @(posedge clk) begin
		if (axi_test) begin
				xorshift64_next;
				{fast_axi_transaction, async_axi_transaction, delay_axi_transaction} <= xorshift64_state;
		end
	end

	reg latched_raddr_en = 0;
	reg latched_waddr_en = 0;
	reg latched_wdata_en = 0;

	reg fast_raddr = 0;
	reg fast_waddr = 0;
	reg fast_wdata = 0;

	reg [31:0] latched_raddr;
	reg [31:0] latched_waddr;
	reg [31:0] latched_wdata;
	reg [ 3:0] latched_wstrb;
	reg        latched_rinsn;

	task handle_axi_arvalid; begin
		mem_axi_arready <= 1;
		latched_raddr = mem_axi_araddr;
		latched_rinsn = mem_axi_arprot[2];
		latched_raddr_en = 1;
		fast_raddr <= 1;
	end endtask

	task handle_axi_awvalid; begin
		mem_axi_awready <= 1;
		latched_waddr = mem_axi_awaddr;
		latched_waddr_en = 1;
		fast_waddr <= 1;
	end endtask

	task handle_axi_wvalid; begin
		mem_axi_wready <= 1;
		latched_wdata = mem_axi_wdata;
		latched_wstrb = mem_axi_wstrb;
		latched_wdata_en = 1;
		fast_wdata <= 1;
	end endtask

	task handle_axi_rvalid; begin
		if (verbose)
			$display("RD: ADDR=%08x DATA=%08x%s", latched_raddr, memory[latched_raddr >> 2], latched_rinsn ? " INSN" : "");
		if (latched_raddr < 128*1024) begin
			mem_axi_rdata <= memory[latched_raddr >> 2];
			mem_axi_rvalid <= 1;
			latched_raddr_en = 0;
		end else begin
			$display("OUT-OF-BOUNDS MEMORY READ FROM %08x", latched_raddr);
			$finish;
		end
	end endtask

	task handle_axi_bvalid; begin
		if (verbose)
			$display("WR: ADDR=%08x DATA=%08x STRB=%04b", latched_waddr, latched_wdata, latched_wstrb);
		if (latched_waddr < 128*1024) begin
			if (latched_wstrb[0]) memory[latched_waddr >> 2][ 7: 0] <= latched_wdata[ 7: 0];
			if (latched_wstrb[1]) memory[latched_waddr >> 2][15: 8] <= latched_wdata[15: 8];
			if (latched_wstrb[2]) memory[latched_waddr >> 2][23:16] <= latched_wdata[23:16];
			if (latched_wstrb[3]) memory[latched_waddr >> 2][31:24] <= latched_wdata[31:24];
		end else
		if (latched_waddr == 32'h1000_0000) begin
			if (verbose) begin
				if (32 <= latched_wdata && latched_wdata < 128)
					$display("OUT: '%c'", latched_wdata[7:0]);
				else
					$display("OUT: %3d", latched_wdata);
			end else begin
				$write("%c", latched_wdata[7:0]);
`ifndef VERILATOR
				$fflush();
`endif
			end
		end else
		if (latched_waddr == 32'h2000_0000) begin
			if (latched_wdata == 123456789)
				tests_passed = 1;
		end else begin
			$display("OUT-OF-BOUNDS MEMORY WRITE TO %08x", latched_waddr);
			$finish;
		end
		mem_axi_bvalid <= 1;
		latched_waddr_en = 0;
		latched_wdata_en = 0;
	end endtask

	always @(negedge clk) begin
		if (mem_axi_arvalid && !(latched_raddr_en || fast_raddr) && async_axi_transaction[0]) handle_axi_arvalid;
		if (mem_axi_awvalid && !(latched_waddr_en || fast_waddr) && async_axi_transaction[1]) handle_axi_awvalid;
		if (mem_axi_wvalid  && !(latched_wdata_en || fast_wdata) && async_axi_transaction[2]) handle_axi_wvalid;
		if (!mem_axi_rvalid && latched_raddr_en && async_axi_transaction[3]) handle_axi_rvalid;
		if (!mem_axi_bvalid && latched_waddr_en && latched_wdata_en && async_axi_transaction[4]) handle_axi_bvalid;
	end

	always @(posedge clk) begin
		mem_axi_arready <= 0;
		mem_axi_awready <= 0;
		mem_axi_wready <= 0;

		fast_raddr <= 0;
		fast_waddr <= 0;
		fast_wdata <= 0;

		if (mem_axi_rvalid && mem_axi_rready) begin
			mem_axi_rvalid <= 0;
		end

		if (mem_axi_bvalid && mem_axi_bready) begin
			mem_axi_bvalid <= 0;
		end

		if (mem_axi_arvalid && mem_axi_arready && !fast_raddr) begin
			latched_raddr = mem_axi_araddr;
			latched_rinsn = mem_axi_arprot[2];
			latched_raddr_en = 1;
		end

		if (mem_axi_awvalid && mem_axi_awready && !fast_waddr) begin
			latched_waddr = mem_axi_awaddr;
			latched_waddr_en = 1;
		end

		if (mem_axi_wvalid && mem_axi_wready && !fast_wdata) begin
			latched_wdata = mem_axi_wdata;
			latched_wstrb = mem_axi_wstrb;
			latched_wdata_en = 1;
		end

		if (mem_axi_arvalid && !(latched_raddr_en || fast_raddr) && !delay_axi_transaction[0]) handle_axi_arvalid;
		if (mem_axi_awvalid && !(latched_waddr_en || fast_waddr) && !delay_axi_transaction[1]) handle_axi_awvalid;
		if (mem_axi_wvalid  && !(latched_wdata_en || fast_wdata) && !delay_axi_transaction[2]) handle_axi_wvalid;

		if (!mem_axi_rvalid && latched_raddr_en && !delay_axi_transaction[3]) handle_axi_rvalid;
		if (!mem_axi_bvalid && latched_waddr_en && latched_wdata_en && !delay_axi_transaction[4]) handle_axi_bvalid;
	end
endmodule
