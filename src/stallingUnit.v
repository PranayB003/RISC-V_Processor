`include "constants.vh"

module stallingUnit (opc, stall_en, pc_en);

  input wire [6:0] opc;
  output reg stall_en, pc_en;
  
  reg nop_counter, pc_disable_counter;

  always @(*)
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

  always @(*)
  begin
    stall_en = (nop_counter != 0);
    pc_en    = (pc_disable_counter != 0);
  end

endmodule

