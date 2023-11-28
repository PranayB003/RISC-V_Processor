`include "constants.vh"

module stage_ID (clk, inst_in, pc_addr_in, rd_addr_in, rd_wen_in, wb_out, 
                 rs1, rs2, rs1_val, rs2_val, rd_addr_out,
                 mux_ctl, alu_ctl, jmp_ctl, rd_wen_out, wb_ctl, bch_ctl, mem_ctl, byt_typ,
                 imm_ext, pc_addr_out, stall_en, pc_en, halt);

  parameter reg_addr_width = `REG_ADDR_WIDTH;
  parameter ins_addr_width = `MEM_ADDR_WIDTH;
  parameter word_width     = `WORD_WIDTH;

  input wire clk, rd_wen_in;
  input wire [word_width-1:0] inst_in, wb_out;
  input wire [ins_addr_width-1:0] pc_addr_in;
  input wire [reg_addr_width-1:0] rd_addr_in;
  output reg [ins_addr_width-1:0] pc_addr_out;
  output reg [reg_addr_width-1:0] rs1, rs2, rd_addr_out;
  output wire [word_width-1:0] rs1_val, rs2_val, imm_ext;
  output wire [3:0] mux_ctl, alu_ctl;
  output wire [2:0] byt_typ;
  output wire [1:0] wb_ctl;
  output wire jmp_ctl, rd_wen_out, bch_ctl, mem_ctl, stall_en, pc_en, halt;

  // Pipeline registers
  reg [word_width-1:0] inst;
  reg [ins_addr_width-1:0] pc_addr;

  // Internal wires
  wire [6:0] opc    = inst[6:0], funct7 = inst[31:25];
  wire [4:0] ra1    = inst[19:15], ra2 = inst[24:20];
  wire [2:0] funct3 = inst[14:12];

  always @(posedge clk)
  begin
    inst    <= inst_in;
    pc_addr <= pc_addr_in;
  end

  always @(*)
  begin
    rs1         = ra1;
    rs2         = ra2;
    rd_addr_out = inst[11:7];
    pc_addr_out = pc_addr;
  end

  regfile id_reg(
    .clk(clk),
    .w_en(rd_wen_in),
    .ra1(ra1),
    .ra2(ra2),
    .wa3(rd_addr_in),
    .rd1(rs1_val),
    .rd2(rs2_val),
    .wd3(wb_out)
  );

  controlUnit id_cu(
    .opc(opc),
    .funct3(funct3),
    .funct7(funct7),
    .mux_ctl(mux_ctl), 
    .alu_ctl(alu_ctl), 
    .jmp_ctl(jmp_ctl), 
    .bch_ctl(bch_ctl), 
    .mem_ctl(mem_ctl), 
    .rd_wen(rd_wen_out),
    .wb_ctl(wb_ctl), 
    .byt_typ(byt_typ)
  );

  extender id_ext(
    .inst(inst),
    .imm_ext(imm_ext)
  );

  stallingUnit id_su(
    .opc(opc),
    .stall_en(stall_en),
    .pc_en(pc_en),
    .halt(halt)
  );

endmodule

