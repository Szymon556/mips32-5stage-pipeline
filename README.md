Verification
------------

The processor is verified using a self-checking directed
testbench based on the reference MIPS program from book
Digital Design and Computer Architecture.

The test exercises:

- arithmetic instructions
- logical instructions
- data forwarding
- load-use stalls
- conditional branches
- jump
- load/store operations

Expected final memory writes:

0x50 -> 0x00000007
0x54 -> 0x00000007
