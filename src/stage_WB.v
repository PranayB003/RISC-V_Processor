`include "constants.vh"

module stage_WB (clk, rst, rslt_in, rd_wen_in, wb_ctl_in, mem_d_in, rd_addr_in, imm_ext_in,
                 rd_addr_out, rd_wen_out, wb_out);

  parameter reg_addr_width = `REG_ADDR_WIDTH;
  parameter word_width     = `WORD_WIDTH;

  input wire clk, rst, rd_wen_in;
  input wire [word_width-1:0] rslt_in, mem_d_in, imm_ext_in;
  input wire [reg_addr_width-1:0] rd_addr_in;
  input wire [1:0] wb_ctl_in;
  output reg rd_wen_out;
  output reg [reg_addr_width-1:0] rd_addr_out;
  output reg [word_width-1:0] wb_out;

  // Pipeline registers
  reg rd_wen;
  reg [word_width-1:0] rslt, mem_d, imm_ext;
  reg [reg_addr_width-1:0] rd_addr;
  reg [1:0] wb_ctl;

  always @(posedge clk)
  begin
    if (rst)
    begin
      rd_wen  <= 0;
      rslt    <= 0;
      mem_d   <= 0;
      imm_ext <= 0;
      rd_addr <= 0;
      wb_ctl  <= 0;
    end
    else
    begin
      rd_wen  <= rd_wen_in;
      rslt    <= rslt_in;
      mem_d   <= mem_d_in;
      imm_ext <= imm_ext_in;
      rd_addr <= rd_addr_in;
      wb_ctl  <= wb_ctl_in;
    end
  end

  always @(*)
  begin
    rd_wen_out  = rd_wen;
    rd_addr_out = rd_addr;
    case (wb_ctl)
      2'b00   : wb_out = rslt;
      2'b01   : wb_out = imm_ext;
      2'b10   : wb_out = mem_d;
      default : wb_out = 0;
    endcase
  end

endmodule
