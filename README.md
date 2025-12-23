# FPGA VHDL Designs

Welcome! This repository showcases **digital logic designs implemented in VHDL**, suitable for FPGA deployment and simulation.  
Projects demonstrate modular design, control logic, datapath construction, testbench verification, and hardware interfacing.

## 📁 Projects

### 🧠 Conditional Program Counter (VHDL)
Location: `conditional-program-counter-vhdl/`

A VHDL implementation of a program counter with conditional jump logic.  
The counter increments normally or jumps to a specified address when control and flag bits match.

- Core logic: `program_counter.vhd`
- Control + 7-segment display logic: `controller.vhd`
- Testbench: `program_counter_tb.vhd`

---

### ⚙️ Simple Processor Datapath (VHDL)
Location: `simple-processor-datapath-vhdl/`

A datapath integrating registers (A and D), an ALU, and a program counter, driven by control inputs to emulate a simple processor architecture.

- Datapath module: `datapath.vhd`
- ALU: `alu.vhd`
- Generic register: `reg_generic.vhd`
- Program counter: `program_counter.vhd`
- Board top-level wrapper: `lab11_top.vhd`
- Testbench: `datapath_tb.vhd`

---

## 🛠️ Tools & Workflow

These designs were developed and tested using:

- **VHDL**
- **Intel/Altera Quartus Prime**
- **ModelSim/Intel FPGA Simulation**
- Target hardware such as **DE10-Lite FPGA**

---

## 📌 Tips for Reviewers

- Each project contains a project-specific `README.md`.
- Testbenches are included for simulation verification.
- No proprietary project files — all code is source-only.

---

## 📌 About

**Author:** Samuel Oke  
Open to feedback, collaborations, and opportunities in FPGA/embedded design.
