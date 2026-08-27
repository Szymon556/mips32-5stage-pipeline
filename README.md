# MIPS32 5-Stage Pipelined Processor

A 32-bit pipelined MIPS processor implemented in Verilog as a digital design and computer architecture project.

The processor uses the classic five-stage pipeline:

**IF → ID → EX → MEM → WB**

The project focuses primarily on pipeline organization, data hazards, control hazards, forwarding, stalls, and branch handling rather than full MIPS32 ISA compatibility.

## Features

- 32-bit datapath
- 5-stage instruction pipeline
- Separate pipeline registers:
  - IF/ID
  - ID/EX
  - EX/MEM
  - MEM/WB
- Data forwarding from:
  - Memory stage to Execute stage
  - Writeback stage to Execute stage
- Forwarding to the branch comparator in Decode
- Load-use hazard detection
- Pipeline stalls and bubble insertion
- Branch dependency detection
- Early branch resolution in Decode
- Static predict-not-taken branch behavior
- Jump instruction support
- Arithmetic and logical instructions
- Load/store operations
- Shift operations
- Self-checking directed testbench

## Pipeline Architecture

```text
           ┌────────┐
           │   IF   │
           └───┬────┘
               │
             IF/ID
               │
           ┌───▼────┐
           │   ID   │
           │        │
           │ Decode │
           │ Branch │
           │ Compare│
           └───┬────┘
               │
             ID/EX
               │
           ┌───▼────┐
           │   EX   │
           │        │
           │  ALU   │
           └───┬────┘
               │
             EX/MEM
               │
           ┌───▼────┐
           │  MEM   │
           └───┬────┘
               │
             MEM/WB
               │
           ┌───▼────┐
           │   WB   │
           └────────┘
```

## Hazard Handling

RAW data hazards are handled using forwarding from the Memory and Writeback stages to the Execute stage. Load-use dependencies are resolved by stalling the Fetch and Decode stages and inserting a bubble into the Execute stage.

Branches are resolved in the Decode stage. Dedicated forwarding to the branch comparator and additional branch stalls are used when branch operands depend on preceding instructions.

## Supported Instructions

The processor implements a subset of the MIPS32 instruction set, including:

- Arithmetic: `add`, `sub`, `addi`
- Logical: `and`, `or`
- Comparison: `slt`
- Memory: `lw`, `sw`
- Control flow: `beq`, `j`
- Shift operations

## Verification

The design is verified using a self-checking directed Verilog testbench. The test program exercises arithmetic and logical operations, forwarding, load-use stalls, branch dependencies, jumps, and memory accesses.

Correct execution is automatically checked using expected memory writes, with the testbench reporting a PASS or FAIL result.

## Example test program 
  20020005
  2003000c
  2067fff7
  00e22025
  00642824
  00a42820
  10a7000a
  0064202a
  10800001
  20050000
  00e2202a
  00853820
  00e23822
  ac670044
  8c020050
  08000011
  20020001
  ac020054

## Tools

- Verilog HDL
- AMD Vivado
- Vivado Simulator

## Reference

The processor architecture and reference test program are based on *Digital Design and Computer Architecture* by David Money Harris and Sarah L. Harris.
