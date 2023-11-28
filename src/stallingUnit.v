`include "constants.vh"

module stallingUnit (opc, rst, stall_en, pc_en, halt);

  input wire [6:0] opc;
  input wire rst;
  output reg stall_en, pc_en;
  output reg halt;

  reg nop_counter, pc_disable_counter;

  always @(*)
  begin
    if (rst)
    begin
      nop_counter        = 0;
      pc_disable_counter = 0;
    end
    else
    begin
      case (opc)
        `OPCODE_JAL,
        `OPCODE_JALR,
        `OPCODE_BRANCH:
        begin
          nop_counter        = 3;
          pc_disable_counter = 2;
        end
        `OPCODE_LOAD:
        begin
          nop_counter        = 1;
          pc_disable_counter = 1;
        end
        default:
        begin
          nop_counter        = (nop_counter > 0)        ? (nop_counter - 1)        : 0;
          pc_disable_counter = (pc_disable_counter > 0) ? (pc_disable_counter - 1) : 0;
        end
      endcase
    end
  end

  always @(*)
  begin
    stall_en = (nop_counter != 0)        ? 1'b1 : 1'b0;
    pc_en    = (pc_disable_counter != 0) ? 1'b1 : 1'b0;
  end

  always @(*)
  begin
    if (rst)
      halt = 0;
    else if (opc == 0)
      halt = 1;
  end

endmodule

