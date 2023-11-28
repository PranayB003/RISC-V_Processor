`include "constants.vh"

module processorCore (clk_in, rst, halt, final_data);

  parameter reg_addr_width = `REG_ADDR_WIDTH;
  parameter mem_addr_width = `MEM_ADDR_WIDTH;
  parameter word_width     = `WORD_WIDTH;

  input wire clk_in, rst;
  output reg halt;
  output reg [word_width-1:0] final_data;
  
  // Internal wires
  reg clk;
  // Output from IF stage
  wire [word_width-1:0] inst_if;
  wire [mem_addr_width-1:0] pc_addr_if;
  // Output from ID stage
  wire stall_en_id, pc_en_id, halt_id;
  wire [reg_addr_width-1:0] rs1_id, rs2_id, rd_addr_id;
  wire [word_width-1:0] rs1_val_id, rs2_val_id, imm_ext_id;
  wire [mem_addr_width-1:0] pc_addr_id;
  wire [3:0] mux_ctl_id, alu_ctl_id;
  wire [2:0] byt_typ_id;
  wire [1:0] wb_ctl_id;
  wire jmp_ctl_id, rd_wen_id, bch_ctl_id, mem_ctl_id;
  // Output from EX stage
  wire [reg_addr_width-1:0] rd_addr_ex;
  wire [mem_addr_width-1:0] tgt_addr_ex;
  wire [word_width-1:0] rs2_val_ex, rslt_ex, imm_ext_ex;
  wire jmp_ctl_ex, rd_wen_ex, bch_ctl_ex, mem_ctl_ex;
  wire [2:0] byt_typ_ex;
  wire [1:0] wb_ctl_ex;
  // Output from MEM stage
  wire jmp_bch_en_mem;
  wire [mem_addr_width-1:0] jmp_bch_tgt_mem;
  wire mem_wen_mem, rd_wen_mem;
  wire [reg_addr_width-1:0] mem_rd_mem, rd_addr_mem;
  wire [word_width-1:0] fwd_val_mem, rslt_mem, mem_d_mem, imm_ext_mem, final_data_mem;
  wire [1:0] wb_ctl_mem; 
  // Output from WB stage
  wire [word_width-1:0] wb_out;
  wire rd_wen_wb;
  wire [reg_addr_width-1:0] rd_addr_wb;

  always @(*)
  begin
    clk        = (clk_in && halt_id);
    halt       = halt_id;
    final_data = final_data_mem;
  end

  stage_IF s1 (
    .clk(clk), 
    .rst(rst),
    .jmp_bch_en(jmp_bch_en_mem), 
    .jmp_bch_tgt(jmp_bch_tgt_mem), 
    .pc_en(pc_en_id), 
    .stall_en(stall_en_id), 
    .inst(inst_if), 
    .pc_addr(pc_addr_if)
  );

  stage_ID s2 (
    .clk(clk), 
    .rst(rst),
    .inst_in(inst_if), 
    .pc_addr_in(pc_addr_if), 
    .rd_addr_in(rd_addr_wb), 
    .rd_wen_in(rd_wen_wb), 
    .wb_out(wb_out), 
    .rs1(rs1_id), 
    .rs2(rs2_id), 
    .rs1_val(rs1_val_id), 
    .rs2_val(rs2_val_id), 
    .rd_addr_out(rd_addr_id),
    .mux_ctl(mux_ctl_id), 
    .alu_ctl(alu_ctl_id), 
    .jmp_ctl(jmp_ctl_id), 
    .rd_wen_out(rd_wen_id), 
    .wb_ctl(wb_ctl_id), 
    .bch_ctl(bch_ctl_id), 
    .mem_ctl(mem_ctl_id), 
    .byt_typ(byt_typ_id),
    .imm_ext(imm_ext_id), 
    .pc_addr_out(pc_addr_id), 
    .stall_en(stall_en_id), 
    .pc_en(pc_en_id),
    .halt(halt_id)
  );

  stage_EX s3 (
    .clk(clk), 
    .rst(rst),
    .rs1_in(rs1_id), 
    .rs2_in(rs2_id), 
    .rs1_val_in(rs1_val_id), 
    .rs2_val_in(rs2_val_id), 
		.rd_addr_in(rd_addr_id), 
		.pc_addr_in(pc_addr_id),
		.imm_ext_in(imm_ext_id),
		.mux_ctl_in(mux_ctl_id),
		.alu_ctl_in(alu_ctl_id),
		.jmp_ctl_in(jmp_ctl_id),
		.rd_wen_in(rd_wen_id),
		.wb_ctl_in(wb_ctl_id),
		.bch_ctl_in(bch_ctl_id),
		.mem_ctl_in(mem_ctl_id),
		.byt_typ_in(byt_typ_id),
		.mem_wen_in(mem_wen_mem),
		.mem_rd_in(mem_rd_mem),
		.mem_d_in(fwd_val_mem),
		.wb_wen_in(rd_wen_wb),
		.wb_rd_in(rd_addr_wb),
		.wb_d_in(wb_out),
		.tgt_addr(tgt_addr_ex),
		.rs2_val_out(rs2_val_ex),
		.rslt(rslt_ex),
		.jmp_ctl_out(jmp_ctl_ex),
		.rd_wen_out(rd_wen_ex),
		.wb_ctl_out(wb_ctl_ex),
		.bch_ctl_out(bch_ctl_ex),
		.mem_ctl_out(mem_ctl_ex),
		.byt_typ_out(byt_typ_ex),
		.rd_addr_out(rd_addr_ex),
		.imm_ext_out(imm_ext_ex)
  );

  stage_MEM s4 (
		.clk(clk),
    .rst(rst),
    .halt(halt_id),
		.tgt_addr_in(tgt_addr_ex),
		.rs2_val_in(rs2_val_ex),
		.rslt_in(rslt_ex),
		.jmp_ctl_in(jmp_ctl_ex),
		.rd_wen_in(rd_wen_ex),
		.wb_ctl_in(wb_ctl_ex),
		.bch_ctl_in(bch_ctl_ex),
		.mem_ctl_in(mem_ctl_ex),
		.byt_typ_in(byt_typ_ex),
		.rd_addr_in(rd_addr_ex),
		.imm_ext_in(imm_ext_ex),
		.jmp_bch_tgt(jmp_bch_tgt_mem),
		.jmp_bch_en(jmp_bch_en_mem),
		.rslt_out(rslt_mem),
		.rd_wen_out(rd_wen_mem),
		.wb_ctl_out(wb_ctl_mem),
		.mem_d(mem_d_mem),
    .final_data(final_data_mem),
		.rd_addr_out(rd_addr_mem),
		.imm_ext_out(imm_ext_mem),
		.mem_fwd_en(mem_wen_mem),
		.mem_rd(mem_rd_mem),
    .mem_fwd_val(fwd_val_mem)
  );

  stage_WB s5 (
		.clk(clk),
    .rst(rst),
		.rslt_in(rslt_mem),
		.rd_wen_in(rd_wen_mem),
		.wb_ctl_in(wb_ctl_mem),
		.mem_d_in(mem_d_mem),
		.rd_addr_in(rd_addr_mem),
		.imm_ext_in(imm_ext_mem),
		.rd_addr_out(rd_addr_wb),
		.rd_wen_out(rd_wen_wb),
		.wb_out(wb_out)
  );

endmodule
