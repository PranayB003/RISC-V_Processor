`include "constants.vh"

module stage_MEM (clk, halt, tgt_addr_in, rs2_val_in, rslt_in, jmp_ctl_in, rd_wen_in,
                  wb_ctl_in, bch_ctl_in, mem_ctl_in, byt_typ_in, rd_addr_in, imm_ext_in,
                  jmp_bch_tgt, jmp_bch_en, rslt_out, rd_wen_out, wb_ctl_out, final_data,
                  mem_d, rd_addr_out, imm_ext_out, mem_fwd_en, mem_rd, mem_fwd_val);

  parameter reg_addr_width = `REG_ADDR_WIDTH;
  parameter mem_addr_width = `MEM_ADDR_WIDTH;
  parameter word_width     = `WORD_WIDTH;

  input wire clk, halt, jmp_ctl_in, rd_wen_in, bch_ctl_in, mem_ctl_in;
  input wire [mem_addr_width-1:0] tgt_addr_in;
  input wire [word_width-1:0] rs2_val_in, rslt_in, imm_ext_in;
  input wire [reg_addr_width-1:0] rd_addr_in;
  input wire [1:0] wb_ctl_in;
  input wire [2:0] byt_typ_in;
  output reg [mem_addr_width-1:0] jmp_bch_tgt;
  output reg jmp_bch_en, rd_wen_out, mem_fwd_en;
  output reg [word_width-1:0] rslt_out, imm_ext_out, mem_fwd_val;
  output reg [reg_addr_width-1:0] rd_addr_out, mem_rd;
  output reg [1:0] wb_ctl_out;
  output wire [word_width-1:0] mem_d, final_data;

  // Pipeline registers
  reg jmp_ctl, rd_wen, bch_ctl, mem_ctl;
  reg [mem_addr_width-1:0] tgt_addr;
  reg [word_width-1:0] rs2_val, rslt, imm_ext;
  reg [reg_addr_width-1:0] rd_addr;
  reg [1:0] wb_ctl;
  reg [2:0] byt_typ;
  
  always @(posedge clk)
  begin
    jmp_ctl   <= jmp_ctl_in;
    rd_wen    <= rd_wen_in;
    bch_ctl   <= bch_ctl_in;
    mem_ctl   <= mem_ctl_in;
    tgt_addr  <= tgt_addr_in;
    rs2_val   <= rs2_val_in;
    rslt      <= rslt_in;
    imm_ext   <= imm_ext_in;
    rd_addr   <= rd_addr_in;
    wb_ctl    <= wb_ctl_in;
    byt_typ   <= byt_typ_in;
  end

  always @(*)
  begin
    jmp_bch_tgt = tgt_addr;
    jmp_bch_en  = ((rslt != 0) && (bch_ctl == 1'b1)) || (jmp_ctl == 1'b1);
    rslt_out    = rslt;
    rd_wen_out  = rd_wen;
    wb_ctl_out  = wb_ctl;
    rd_addr_out = rd_addr;
    imm_ext_out = imm_ext;
    mem_fwd_en  = (rd_wen == 1'b1) && (!wb_ctl[1]);
    mem_rd      = rd_addr;
    mem_fwd_val = (wb_ctl[0] == 1'b1) ? imm_ext : rslt;
  end

  dataMemory mem_dm (
    .clk(clk), 
    .wen(mem_ctl), 
    .type(byt_typ), 
    .addr(rslt), 
    .wd(rs2_val), 
    .halt(halt),
    .rd(mem_d),
    .fd(final_data)
  );

endmodule
