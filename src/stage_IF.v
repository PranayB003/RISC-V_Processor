`include "constants.vh"

module stage_IF (clk, jmp_bch_en, jmp_bch_tgt, pc_en, stall_en, inst, pc_addr);

  parameter addr_width = `MEM_ADDR_WIDTH;
  parameter word_width = `WORD_WIDTH;

  input wire clk, jmp_bch_en, pc_en, stall_en;
  input wire [addr_width-1:0] jmp_bch_tgt;
  output reg [word_width-1:0] inst;
  output wire [addr_width-1:0] pc_addr;

  reg [addr_width-1:0] pc_addr_p4, next_pc_addr;
  wire [word_width-1:0] imem_out;

  // NOP Instruction (ADDI x0, x0, 0)
  reg NOP_inst = 32'b000000000000_00000_000_00000_0010011;

  programCounter if_pc (
    .clk(clk),
    .en(pc_en),
    .addr_next(next_pc_addr),
    .addr(pc_addr)
  );

  instMemory if_imem (
    .addr(pc_addr),
    .inst(imem_out)
  );

  always @(*)
  begin
    pc_addr_p4   = pc_addr + 4;
    next_pc_addr = (jmp_bch_en == 1'b0) ? pc_addr_p4 : jmp_bch_tgt;
    inst         = (stall_en   == 1'b0) ? imem_out   : NOP_inst;
  end

endmodule


