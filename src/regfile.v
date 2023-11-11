`include "constants.vh"

module reg_file (clk, w_en, ra1, ra2, wa3, rd1, rd2, wd3);

  parameter word_width = `WORD_WIDTH;
  parameter addr_width = `REG_ADDR_WIDTH;
  parameter nregs      = 1 << addr_width;

  input wire clk, w_en;
  input wire [addr_width-1:0] ra1, ra2, wa3;
  input wire [word_width-1:0] wd3;
  output reg [word_width-1:0] rd1, rd2;

  reg [word_width-1:0] regs [nregs-1:0];

  always @(posedge clk)
  begin
    if (w_en && wa3 != 0)
      regs[wa3] <= wd3; // synchronous write 
  end

  // asynchronous read, selects updated values if available
  always @(*)
  begin
    rd1 = (ra1 == 0)                       ? 0   : 
          ((ra1 == wa3) && (w_en == 1'b1)) ? wd3 : regs[ra1];
    rd2 = (ra2 == 0)                       ? 0   :
          ((ra2 == wa3) && (w_en == 1'b1)) ? wd3 : regs[ra2];
  end

endmodule
