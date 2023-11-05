`include "constants.vh"

module controlUnit (opc, funct3, funct7,
                    mux_ctl, alu_ctl, jmp_ctl, bch_ctl, mem_ctl, rd_wen,
                    wb_ctl, byt_typ);

  input wire [6:0] opc, funct7;
  input wire [2:0] funct3;
  output reg [3:0] mux_ctl, alu_ctl;
  output reg jmp_ctl, bch_ctl, mem_ctl, rd_wen;
  output reg [1:0] wb_ctl;
  output reg [2:0] byt_typ;

  always @(*)
  begin
    case (opc)
      `OPCODE_RTYPE  : mux_ctl = 4'b0100; // R-type
      `OPCODE_ITYPE  : mux_ctl = 4'b0101; // I-type 
      `OPCODE_AUIPC  : mux_ctl = 4'b0001; // AUIPC
      `OPCODE_JAL    : mux_ctl = 4'b0010; // JAL
      `OPCODE_JALR   : mux_ctl = 4'b1010; // JALR
      `OPCODE_LOAD   : mux_ctl = 4'b0101; // LOAD
      `OPCODE_STORE  : mux_ctl = 4'b0101; // STORE
      `OPCODE_BRANCH : mux_ctl = 4'b0100; // BRANCH
      default        : mux_ctl = 4'b0000; // LUI
    endcase
  end

  always @(*)
  begin
    alu_ctl = `ALU_ADD;  // default assignment
    case (opc)
      `OPCODE_RTYPE,
      `OPCODE_ITYPE:
      begin
        case (funct3)
          `FUNCT3_ADD  :
          begin
            if (opc == `OPCODE_ITYPE) alu_ctl = `ALU_ADD;
            else alu_ctl = (funct7 == 0) ? `ALU_ADD : `ALU_SUB;
          end
          `FUNCT3_SLT  : alu_ctl = `ALU_SLT;
          `FUNCT3_SLTU : alu_ctl = `ALU_SLTU;
          `FUNCT3_AND  : alu_ctl = `ALU_AND;
          `FUNCT3_OR   : alu_ctl = `ALU_OR;
          `FUNCT3_XOR  : alu_ctl = `ALU_XOR;
          `FUNCT3_SLL  : alu_ctl = `ALU_SLL;
          `FUNCT3_SRL  : alu_ctl = (funct7 == 0) ? `ALU_SRL : `ALU_SRA;
        endcase
      end
      `OPCODE_BRANCH:
      begin
        case (funct3)
          `FUNCT3_EQ : alu_ctl = `ALU_EQ;
          `FUNCT3_NEQ: alu_ctl = `ALU_NEQ;
          `FUNCT3_LT : alu_ctl = `ALU_LT;
          `FUNCT3_LTU: alu_ctl = `ALU_LTU;
          `FUNCT3_GE : alu_ctl = `ALU_GE;
          `FUNCT3_GEU: alu_ctl = `ALU_GEU;
        endcase
      end
    endcase
  end

  always @(*)
  begin
    jmp_ctl = 1'b0; // default assignment
    bch_ctl = 1'b0;
    case (opc)
      `OPCODE_JAL,
      `OPCODE_JALR:
      begin
        jmp_ctl = 1'b1;
        bch_ctl = 1'b0;
      end
      `OPCODE_BRANCH:
      begin
        jmp_ctl = 1'b0;
        bch_ctl = 1'b1;
      end
    endcase
  end

  // mem_ctl = 1 for read, and 0 for write (data memory)
  always @(*)
  begin
    mem_ctl = (opc == `OPCODE_STORE) ? 1'b1 : 1'b0;
  end

  always @(*)
  begin
    rd_wen = 1'b0;  // default assignment for STORE, BRANCH
    wb_ctl = 2'b00;
    case (opc)
      `OPCODE_RTYPE, // R-type
      `OPCODE_ITYPE, // I-type 
      `OPCODE_JAL,    // JAL
      `OPCODE_JALR,  // JALR
      `OPCODE_AUIPC: // AUIPC
      begin 
        rd_wen = 1'b1;
        wb_ctl = 2'b00;
      end
      `OPCODE_LUI:   // LUI
      begin
        rd_wen = 1'b1;
        wb_ctl = 2'b01;
      end
      `OPCODE_LOAD:  // LOAD
      begin
        rd_wen = 1'b1;
        wb_ctl = 2'b10;
      end
    endcase
  end

  always @(*)
  begin
    byt_typ = funct3;
  end
  
endmodule
