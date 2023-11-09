`include "constants.vh"

module dataMemory (clk, wen, type, addr, wd, rd);

  parameter addr_width = `MEM_ADDR_WIDTH;
  parameter mem_size   = `DMEM_DEPTH;
  parameter word_width = `WORD_WIDTH;
  
  input wire clk, wen;
  input wire [2:0] type;
  input wire [addr_width-1:0] addr;
  input wire [word_width-1:0] wd;
  output wire [word_width-1:0] rd;

  reg [word_width-1:0] memory [mem_size-1:0];

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

  assign rd = (type == `FUNCT3_LW) ? memory[addr] :
              (type == `FUNCT3_LH) ? { {16{memory[addr][15]}}, memory[addr][15:0] } :
              (type == `FUNCT3_LHU)? { {16{1'b0}}, memory[addr][15:0] } :
              (type == `FUNCT3_LB) ? { {24{memory[addr][7]}}, memory[addr][7:0] } :
              (type == `FUNCT3_LBU)? { {24{1'b0}}, memory[addr][7:0] } : 0;


endmodule
