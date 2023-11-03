`include "constants.vh"

module reg_file (clk, w_en, rd_addr, rs1_addr, rs2_addr, rd_val, rs1_val, rs2_val);

  parameter word_width = `WORD_WIDTH;
  parameter addr_width = `REG_ADDR_WIDTH;
  parameter nregs      = 1 << addr_width;

  input wire clk, w_en;
  input [addr_width-1:0] rd_addr, rs1_addr, rs2_addr;
  input [word_width-1:0] rd_val;
  output [word_width-1:0] rs1_val, rs2_val;

  integer i;
  reg [word_width-1:0] regs [nregs-1:0];

  always @(posedge clk)
  begin
    if (w_en && rd_addr != {addr_width{1'b0}}) begin
      regs[rd_addr] <= rd_val; // synchronous write
    end
  end

  // asynchronous read
  assign rs1_val = (rs1_addr == {addr_width{1'b0}}) ? {word_width{1'b0}} : regs[rs1_addr];
  assign rs2_val = (rs2_addr == {addr_width{1'b0}}) ? {word_width{1'b0}} : regs[rs2_addr];

endmodule
