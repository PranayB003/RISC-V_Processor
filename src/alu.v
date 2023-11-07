`include "constants.vh"

module alu (a, b, alu_ctl, rslt);

  parameter word_width = `WORD_WIDTH;

  input wire [word_width-1:0] a, b;
  input wire [3:0] alu_ctl;
  output reg [word_width-1:0] rslt;

  wire signed sa = a;
  wire signed sb = b;

  always @(*)
  begin
    case (alu_ctl)
      `ALU_ADD : rslt = (sa + sb);
      `ALU_SUB : rslt = (sa - sb);
      `ALU_SLT : rslt = (sa < sb);
      `ALU_SLTU: rslt = (a < b);
      `ALU_AND : rslt = (a & b);
      `ALU_OR  : rslt = (a | b);
      `ALU_XOR : rslt = (a ^ b);
      `ALU_SLL : rslt = (a << b);
      `ALU_SRL : rslt = (a >> b);
      `ALU_SRA : rslt = (sa >>> b);
      `ALU_EQ  : rslt = (sa == sb);
      `ALU_NEQ : rslt = (sa != sb);
      `ALU_GE  : rslt = (sa >= sb);
      `ALU_GEU : rslt = (a >= b);
      default  : rslt = 0;
    endcase
  end

endmodule
