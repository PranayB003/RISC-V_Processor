`include "constants.vh"

module dataMemory (clk, wen, type, addr, wd, halt, rd, fd);

  parameter addr_width    = `MEM_ADDR_WIDTH;
  parameter mem_size      = `DMEM_DEPTH;
  parameter word_width    = `WORD_WIDTH;
  parameter final_op_addr = 4;
  
  input wire clk, wen, halt;
  input wire [2:0] type;
  input wire [addr_width-1:0] addr;
  input wire [word_width-1:0] wd;
  output reg [word_width-1:0] rd, fd;

  reg [word_width-1:0] memory [mem_size-1:0];

  // synchronous write
  always @(posedge clk)
  begin
    if (wen == 1'b1)
    begin
      case (type)
        `FUNCT3_SB: memory[addr] <= { {24{1'b0}}, wd[7:0] };
        `FUNCT3_SH: memory[addr] <= { {16{1'b0}}, wd[15:0] };
        `FUNCT3_SW: memory[addr] <= wd;
      endcase
    end
  end

  // asynchronous read
  always @(*)
  begin
    case (type)
      `FUNCT3_LW  : rd = memory[addr];
      `FUNCT3_LH  : rd = { {16{memory[addr][15]}}, memory[addr][15:0] };
      `FUNCT3_LHU : rd = { {16{1'b0}}, memory[addr][15:0] };
      `FUNCT3_LB  : rd = { {24{memory[addr][7]}}, memory[addr][7:0] };
      `FUNCT3_LBU : rd = { {24{1'b0}}, memory[addr][7:0] };
      default     : rd = 0;
    endcase
  end

  // final output
  always @(*)
  begin
    if ((clk == 1'b0) && (halt == 1'b1))
      fd = memory[final_op_addr];
    else
      fd = 32'b0;
  end

endmodule
