`include "constants.vh"

module stage_EX (clk, rst, rs1_in, rs2_in, rs1_val_in, rs2_val_in, rd_addr_in, 
                 pc_addr_in, imm_ext_in, mux_ctl_in, alu_ctl_in, jmp_ctl_in, 
                 rd_wen_in, wb_ctl_in, bch_ctl_in, mem_ctl_in, byt_typ_in, 
                 mem_wen_in, mem_rd_in, mem_d_in, wb_wen_in, wb_rd_in, wb_d_in,
                 tgt_addr, rs2_val_out, rslt, jmp_ctl_out, rd_wen_out, wb_ctl_out,
                 bch_ctl_out, mem_ctl_out, byt_typ_out, rd_addr_out, imm_ext_out);

  parameter reg_addr_width = `REG_ADDR_WIDTH;
  parameter ins_addr_width = `MEM_ADDR_WIDTH;
  parameter word_width     = `WORD_WIDTH;

  input wire clk, rst, jmp_ctl_in, rd_wen_in, bch_ctl_in, mem_ctl_in, mem_wen_in, wb_wen_in;
  input wire [reg_addr_width-1:0] rs1_in, rs2_in, rd_addr_in, mem_rd_in, wb_rd_in;
  input wire [word_width-1:0] rs1_val_in, rs2_val_in, imm_ext_in, mem_d_in, wb_d_in;
  input wire [ins_addr_width-1:0] pc_addr_in;
  input wire [3:0] mux_ctl_in, alu_ctl_in;
  input wire [2:0] byt_typ_in;
  input wire [1:0] wb_ctl_in;
  output wire [word_width-1:0] rs2_val_out, rslt;
  output reg [ins_addr_width-1:0] tgt_addr;
  output reg jmp_ctl_out, rd_wen_out, bch_ctl_out, mem_ctl_out;
  output reg [2:0] byt_typ_out;
  output reg [1:0] wb_ctl_out;
  output reg [word_width-1:0] imm_ext_out;
  output reg [reg_addr_width-1:0] rd_addr_out;

  // Pipeline registers
  reg jmp_ctl, rd_wen, bch_ctl, mem_ctl;
  reg [reg_addr_width-1:0] rs1, rs2, rd_addr;
  reg [word_width-1:0] rs1_val, rs2_val, imm_ext;
  reg [ins_addr_width-1:0] pc_addr;
  reg [3:0] mux_ctl, alu_ctl;
  reg [2:0] byt_typ;
  reg [1:0] wb_ctl;

  // Internal wires
  wire [word_width-1:0] rs1_val_latest, rs2_val_latest;
  reg [word_width-1:0] adder_arg_2, alu_arg_1, alu_arg_2;

  always @(posedge clk)
  begin
    if (rst)
    begin
      jmp_ctl <= 0;
      rd_wen  <= 0;
      bch_ctl <= 0;
      mem_ctl <= 0;
      rs1     <= 0;
      rs2     <= 0;
      rd_addr <= 0;
      rs1_val <= 0;
      rs2_val <= 0;
      imm_ext <= 0;
      pc_addr <= 0;
      mux_ctl <= 0;
      alu_ctl <= 0;
      byt_typ <= 0;
      wb_ctl  <= 0;
    end
    else
    begin
      jmp_ctl <= jmp_ctl_in;
      rd_wen  <= rd_wen_in;
      bch_ctl <= bch_ctl_in;
      mem_ctl <= mem_ctl_in;
      rs1     <= rs1_in;
      rs2     <= rs2_in;
      rd_addr <= rd_addr_in;
      rs1_val <= rs1_val_in;
      rs2_val <= rs2_val_in;
      imm_ext <= imm_ext_in;
      pc_addr <= pc_addr_in;
      mux_ctl <= mux_ctl_in;
      alu_ctl <= alu_ctl_in;
      byt_typ <= byt_typ_in;
      wb_ctl  <= wb_ctl_in;
    end
  end

  always @(*)
  begin
    adder_arg_2 = (mux_ctl[3] == 1'b1) ? rs1_val_latest : pc_addr;
    alu_arg_1   = (mux_ctl[2] == 1'b1) ? rs1_val_latest : pc_addr;
    case (mux_ctl[1:0])
      2'b00   : alu_arg_2 = rs2_val_latest;
      2'b01   : alu_arg_2 = imm_ext;
      2'b10   : alu_arg_2 = 4;
      default : alu_arg_2 = 0;
    endcase
    tgt_addr    = imm_ext + adder_arg_2;
    jmp_ctl_out = jmp_ctl;
    rd_wen_out  = rd_wen;
    wb_ctl_out  = wb_ctl;
    bch_ctl_out = bch_ctl_out;
    mem_ctl_out = mem_ctl_out;
    byt_typ_out = byt_typ;
    rd_addr_out = rd_addr;
    imm_ext_out = imm_ext;
  end

  assign rs2_val_out = rs2_val_latest;

  alu ex_alu (
    .a(alu_arg_1), 
    .b(alu_arg_2), 
    .alu_ctl(alu_ctl), 
    .rslt(rslt)
  );

  forwardingUnit ex_fwd (
    .rs1(rs1), 
    .rs1_val(rs1_val), 
    .rs2(rs2), 
    .rs2_val(rs2_val), 
    .mem_wen(mem_wen_in), 
    .mem_rd(mem_rd_in), 
    .mem_d(mem_d_in),
    .wb_wen(wb_wen_in), 
    .wb_rd(wb_rd_in),
    .wb_d(wb_d_in),
    .rs1_fwd(rs1_val_latest),
    .rs2_fwd(rs2_val_latest)
  );

endmodule
