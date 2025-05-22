# RISC-V 5-Stage Pipelined Processor (Verilog)

## **Overview**

This repository contains a **5-stage pipelined RISC-V** processor written in Verilog, following the standard IF/ID/EX/MEM/WB architecture. It is suitable for simulation and educational purposes, and features a modular design for easy expansion.

## **Features**

- **5-stage Pipeline:** IF, ID, EX, MEM, WB
- **Hazard Detection:** Stalling on load-use hazards
- **Register File:** 32 registers, 32 bits each
- **Memory:** 256x32 word-aligned data/instruction memory
- **Simulation Ready:** Testbench and waveform output included
- **Extensible:** Modular for enhancements (forwarding, prediction, etc.)

## **Directory Table**

| **File**           | **Description**                                      |
|--------------------|------------------------------------------------------|
| `pipeline.v`       | Top-level pipeline module                            |
| `pipeline_tb.v`    | Testbench for simulation                             |
| `mem_stage.v`      | Memory access pipeline stage                         |
| `mem_wb.v`         | MEM/WB pipeline register                             |
| `memory.v`         | Instruction ROM, loads from `instructions.mem`       |
| `register.v`       | Register file (32 x 32)                              |
| `programcounter.v` | Program counter logic                                |
| `instructions.mem` | RISC-V test program in hex                           |
| `waveform.vcd`     | Example simulation waveform output                   |
| ...                | (Other pipeline stages, hazard unit, etc.)           |


## **Pipeline Stages**

| **Stage** | **Purpose**                                                                       |
|-----------|-----------------------------------------------------------------------------------|
| IF        | Instruction fetch from program memory                                             |
| ID        | Instruction decode and register file read                                         |
| EX        | ALU operations and branch calculation                                             |
| MEM       | Data RAM access (loads/stores)                                                    |
| WB        | Write ALU/memory result back to register file                                     |

## **Testing & Simulation**

- **Testbench:** `pipeline_tb.v` runs a simulation and produces `waveform.vcd`.
- **Test Program:** `instructions.mem` is preloaded with ADDI, ADD, SUB, SLL, LW, SW, BEQ, etc.
- **Waveforms:** Open `waveform.vcd` in GTKWave to inspect the pipeline.


## **File Details**

| **File**              | **Purpose**                                             |
|-----------------------|--------------------------------------------------------|
| `pipeline.v`          | Top-level design                                       |
| `pipeline_tb.v`       | Simulation testbench                                   |
| `mem_stage.v`         | Memory access                                          |
| `mem_wb.v`            | MEM/WB pipeline register                               |
| `memory.v`            | Instruction memory (ROM)                               |
| `register.v`          | 32-register file                                       |
| `programcounter.v`    | PC control logic                                       |
| `instructions.mem`    | Test assembly in hex (see below for sample)            |
| `waveform.vcd`        | Sample waveform for GTKWave                            |

## **Supported Instructions Example**

_Sample from `instructions.mem`:_

```
00000013 // ADDI x0, x0, 0 (NOP)
00100093 // ADDI x1, x0, 1
00311233 // SLL x4, x2, x3
00940C63 // BEQ x8, x9, 24
00142403 // LW x8, 1(x8)
0014A023 // SW x1, 0(x9)
```
