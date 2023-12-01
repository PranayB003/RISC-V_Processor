# SREEYU
**S**talling, **R**ISC-V, **E**x**E**cution b**Y**passing **U**nit (SREEYU) is an implementation of a 5-stage pipelined RISC-V processor, that supports the RV32I base integer instruction set.
The 5 pipeline stages are:
- IF (Instruction Fetch)
- ID (Instruction Decode)
- EX (Execute)
- MEM (Memory Access)
- WB (Writeback)

The RISC-V ISA implemented here is based on [The RISC-V Instruction Set Manual, Volume I: User-Level ISA, Document Version
2.2](https://riscv.org/wp-content/uploads/2017/05/riscv-spec-v2.2.pdf). This project has been built using Verilog HDL.

## Top Level Architecture
![RISC-V Processor Design](https://github.com/PranayB003/RISC-V_Processor/assets/66739544/2511fd9e-db7d-4abb-9ef1-95296b59f26c)

## Features
- This design uses separate instruction and data memories (Harvard architecture), to avoid structural hazards.
- The forwarding/bypassing unit deals with all data hazards except the ones that can be caused by LOAD instructions (`LW`, `LH`, `LB`, `LHU`, `LBU`), by forwarding the most recent register values from the `MEM` and `WB` stage to the `EX` stage.
- The stalling unit deals with control hazards caused by JUMP and BRANCH instructions (`JAL`, `JALR`, `BEQ`, `BNE`, `BLT`, `BLTU`, `BGE`, `BGEU`), and data hazards caused by LOAD instructions.
- As a result of stalling, JUMP and BRANCH instructions always take 4 clock cycles to execute. Similarly, LOAD instructions take 2 clock cycles.

## Installation
To compile the Verilog files/test benches, you need to have `Icarus Verilog` installed. Then, run the following commands:
```bash
git clone git@github.com:PranayB003/RISC-V_Processor.git
cd RISC-V_Processor
iverilog -o proc ./tests/processorCore_tb.v ./src/*.v
vvp proc
```
The instructions to be executed by the processor must be loaded in `inst_mem.bin` first. The final instruction which signals the end of the program should be `0x00000000`. The `inst_mem.bin` file currently contains instructions for the Fibonacci number program present in `fib.s`.
