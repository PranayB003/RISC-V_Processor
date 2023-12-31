`define WORD_WIDTH     32
`define REG_ADDR_WIDTH 5
`define MEM_ADDR_WIDTH 32
`define IMEM_DEPTH     1024
`define DMEM_DEPTH     1024

`define OPCODE_RTYPE  7'b0110011 
`define OPCODE_ITYPE  7'b0010011
`define OPCODE_LOAD   7'b0000011
`define OPCODE_STORE  7'b0100011
`define OPCODE_BRANCH 7'b1100011
`define OPCODE_JAL    7'b1101111
`define OPCODE_JALR   7'b1100111
`define OPCODE_LUI    7'b0110111
`define OPCODE_AUIPC  7'b0010111
                      
`define FUNCT3_ADD   3'b000
`define FUNCT3_SLT   3'b010 
`define FUNCT3_SLTU  3'b011
`define FUNCT3_AND   3'b111
`define FUNCT3_OR    3'b110
`define FUNCT3_XOR   3'b100
`define FUNCT3_SLL   3'b001
`define FUNCT3_SRL   3'b101
`define FUNCT3_SUB   3'b000
`define FUNCT3_SRA   3'b101

`define FUNCT3_EQ    3'b000
`define FUNCT3_NEQ   3'b001
`define FUNCT3_LT    3'b100
`define FUNCT3_LTU   3'b110
`define FUNCT3_GE    3'b101
`define FUNCT3_GEU   3'b111

`define FUNCT3_LB    3'b000
`define FUNCT3_LH    3'b001
`define FUNCT3_LW    3'b010
`define FUNCT3_LBU   3'b100
`define FUNCT3_LHU   3'b101
`define FUNCT3_SB    3'b000
`define FUNCT3_SH    3'b001
`define FUNCT3_SW    3'b010

`define ALU_ADD  4'b0000
`define ALU_SUB  4'b0001
`define ALU_SLT  4'b0010
`define ALU_SLTU 4'b0011
`define ALU_AND  4'b0100
`define ALU_OR   4'b0101
`define ALU_XOR  4'b0110
`define ALU_SLL  4'b0111
`define ALU_SRL  4'b1000
`define ALU_SRA  4'b1001
`define ALU_EQ   4'b1010
`define ALU_NEQ  4'b1011
`define ALU_GE   4'b1100
`define ALU_GEU  4'b1101
