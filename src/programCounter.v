`include "constants.vh"

module programCounter (clk, en, addr, addr_next);

  parameter addr_width = `REG_ADDR_WIDTH;

  input wire clk, en;
  input wire [addr_width-1:0] addr_next;
  output reg [addr_width-1:0] addr;

  always @(posedge clk)
  begin
    addr <= addr_next;
  end

endmodule

