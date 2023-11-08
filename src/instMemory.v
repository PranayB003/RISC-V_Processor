`include "constants.vh"

module instMemory (addr, inst);

  parameter addr_width = `MEM_ADDR_WIDTH;
  parameter mem_size   = `IMEM_DEPTH;
  parameter word_width = `WORD_WIDTH;
  
  input wire [addr_width-1:0] addr;
  output wire [word_width-1:0] inst;

  reg [word_width-1:0] memory [mem_size-1:0];

  assign inst = memory[addr];

  initial
  begin
    $readmemb("inst_mem.bin", memory);
  end

endmodule
  