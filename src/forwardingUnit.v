`include "constants.vh"

module forwardingUnit (rs1, rs1_val, rs2, rs2_val, 
                       mem_wen, mem_rd, wb_wen, wb_rd,
                       mem_d, wb_d, rs1_fwd, rs2_fwd);

  parameter addr_width = `REG_ADDR_WIDTH;
  parameter word_width = `WORD_WIDTH;

  input wire [addr_width-1:0] rs1, rs2, mem_rd, wb_rd;
  input wire [word_width-1:0] rs1_val, rs2_val, mem_d, wb_d;
  input wire mem_wen, wb_wen;
  output reg [word_width-1:0] rs1_fwd, rs2_fwd;

  always @(*)
  begin
    // Forwarding for RS1
    if ((mem_wen == 1'b1) && (mem_rd != 0) && (mem_rd == rs1))
      rs1_fwd = mem_d;
    else if ((wb_wen == 1'b1) && (wb_rd != 0) && (wb_rd == rs1))
      rs1_fwd = wb_d;
    else
      rs1_fwd = rs1_val; 
    // Forwarding for RS2
    if ((mem_wen == 1'b1) && (mem_rd != 0) && (mem_rd == rs2))
      rs2_fwd = mem_d;
    else if ((wb_wen == 1'b1) && (wb_rd != 0) && (wb_rd == rs2))
      rs2_fwd = wb_d;
    else
      rs2_fwd = rs2_val;
  end

endmodule
