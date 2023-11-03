`include "constants.vh"

module reg_file (clk, reset, w_en, rd_addr, rs1_addr, rs2_addr, rd_val, rs1_val, rs2_val);

  input wire clk, reset, w_en;
  input [`REGADDRSZ-1:0] rd_addr, rs1_addr, rs2_addr;
  input [`WORDSZ-1:0] rd_val;
  output [`WORDSZ-1:0] rs1_val, rs2_val;

  integer i;
  reg [`WORDSZ-1:0]regs[`NREGS-1:0];

  always @(posedge clk)
  begin
    if (w_en && rd_addr != {`REGADDRSZ{1'b0}}) begin
      regs[rd_addr] <= rd_val;
    end
  end

  assign rs1_val = (rs1_addr == {`REGADDRSZ{1'b0}}) ? {`WORDSZ{1'b0}} : regs[rs1_addr];
  assign rs2_val = (rs2_addr == {`REGADDRSZ{1'b0}}) ? {`WORDSZ{1'b0}} : regs[rs2_addr];

endmodule
