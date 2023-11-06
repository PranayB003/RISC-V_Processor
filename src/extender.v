`include "constants.vh"

module extender (inst, imm_ext);

  parameter word_width = `WORD_WIDTH;

  input wire [word_width-1:0] inst;
  output reg [word_width-1:0] imm_ext;

  wire opc    = inst[6:0];
  wire funct3 = inst[14:12];

  always @(*)
  begin
    case (opc)
      `OPCODE_ITYPE: 
      begin
        case (funct3)
          `FUNCT3_SLL,
          `FUNCT3_SRL,
          `FUNCT3_SRA : imm_ext = { {27{1'b0}}, inst[24:20] };
          default     : imm_ext = { {20{inst[31]}}, inst[31:20] };
        endcase
      end
      `OPCODE_LUI,
      `OPCODE_AUIPC : imm_ext = { inst[31:12], {12{1'b0}} };
      `OPCODE_JAL   : imm_ext = { {12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0 };
      `OPCODE_JALR  : imm_ext = { {20{inst[31]}}, inst[31:20] };
      `OPCODE_BRANCH: imm_ext = { {20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0 };
      `OPCODE_LOAD  : imm_ext = { {20{inst[31]}}, inst[31:20] };
      `OPCODE_STORE : imm_ext = { {20{inst[31]}}, inst[31:25], inst[11:7] };
      default       : imm_ext = 0;
    endcase
  end

endmodule
