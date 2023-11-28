`include "constants.vh"

module programCounter (clk, rst, en, addr_next, addr);

  parameter addr_width = `MEM_ADDR_WIDTH;

  input wire clk, rst, en;
  input wire [addr_width-1:0] addr_next;
  output reg [addr_width-1:0] addr;

  always @(posedge clk)
  begin
    if (rst)
      addr <= 0;
    else if (en)
      addr <= addr_next;
  end

endmodule

