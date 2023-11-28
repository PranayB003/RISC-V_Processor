lui x15, 0x0        // Upper 20 bits of input number
addi x10, x15, 10   // Lower 12 bits of input number

addi x6,x0,1        // Initialise fib(0)
addi x5,x0,0        // Initialise fib(1)
addi x28,x0,1       // Initialise counter

add x7,x5,x6        // next fib number in register x7
sw x7,0x4(x0)       // output stored at data memory address 0x4
sw x6,0x0(x0) 
lw x5,0x0(x0) 
lw x6,0x4(x0) 
addi x28,x28,1
beq x28,x10,0x8
jal x0,-0x1C
halt                // special instruction with opcode = 0000000
