`include "constants.vh"

module programCounter (clk, en, addr_next, addr);

  parameter addr_width = `MEM_ADDR_WIDTH;

  input wire clk, en;
  input wire [addr_width-1:0] addr_next;
  output reg [addr_width-1:0] addr;

  always @(posedge clk)
  begin
    addr <= addr_next;
  end

endmodule

