# Simple Processor Datapath (VHDL)

## Overview
This project implements a simplified 16-bit processor datapath in VHDL.
It integrates two registers (A and D), an ALU, and a program counter.
Control inputs select sources for the A register and ALU B input, and enable writes into A/D.

## What this demonstrates
- Modular VHDL design (ALU / generic register / program counter / datapath)
- Conditional program counter support via PZN flags
- FPGA wrapper with step-clock debouncing (`lab11_top`)

## Files
- `datapath.vhd` (entity: `ece3140_dp`) — top-level datapath wiring
- `alu.vhd` — ALU
- `reg_generic.vhd` — parameterized register
- `program_counter.vhd` — conditional program counter
- `lab11_top.vhd` — board wrapper with step clock and 7-seg output
- `datapath_tb.vhd` — basic testbench

Author: Samuel Oke
