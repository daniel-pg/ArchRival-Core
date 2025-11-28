# ArchRival Core

![ArchRival Banner](assets/banner.svg)

**ArchRival** is a small and modular **SoC + CPU core** that implements the [ICMC-Processor](https://github.com/simoesusp/Processador-ICMC/)'s ISA, developed from scratch with maintainability, portability, and educational value in mind.


## Key Goals

- Write clean, readable and maintainable SystemVerilog.
- Organize the codebase by separating design, verification, and target-specific files.
- Document every aspect of the processor's design, architecture, and the ISA to ensure the CPU is built on a solid, unambiguous foundation.
- Maintain full compatibility with original ICMC-Processor.
- Make the platform suitable for teaching and experimentation, by allowing easy addition of new features.
- Implement a new pipelined and performant datapath, as well as a better modular SoC design.


## Motivation

The ICMC-Processor is a CPU architecture developed at USP (University of São Paulo) for teaching Computer Organization. The original project successfully created a full ecosystem: the processor design, an assembler, a simulator (with commendable modern web/GUI implementations by students), a compiler, and some documentation.

However, a closer inspection of their FPGA implementation reveals significant technical and organizational deficiencies:

1. Technical Debt: The design is riddled with poor hardware practices, such as:
    - Inefficient Arithmetic: The use of single-cycle combinational integer division limits the maximum clock frequency and increases the complexity of the synthesized logic circuit.
    - Complex Control Logic: Features a complex instruction decoding mechanism, which increases the critical path and makes verification difficult.
    - Poor Clock Management: Relies on a long cascade of flip-flop clock dividers instead of using PLLs, leading to poor clock skew, slew and jitter.
    - Unsafe Reset Implementation: Usage of asynchronous reset without synchronous deassertion creates potential metastability problems.
    - Low Performance Design: The inherent multi-cycle further exacerbates the poor performance, negatively affecting both instruction throughput and latency.

2. Code Quality: Despite its intention to be a simple design, the VHDL code is verbose, lacks clarity, and is generally hard to read and maintain.

3. Project Organization: The repository is a mess, with different versions and FPGA targets spread over multiple directories. Source files are buried alongside hundreds of project files, automatically generated outputs, and abandoned .bak files, violating every project management principle.


## Getting Started

To begin working with the ArchRival Core, whether for simulation, synthesis, or programming an FPGA, please refer to the **BUILD.md** file for a comprehensive guide on required tools, dependencies, and build instructions.

To familiarize yourself with the processor's Instruction Set Architecture (ISA), its microarchitecture, logic design, and implementation, please refer to our documentation.


## 📁 Project Structure

```text
ArchRival/
├── assets/             # Graphics, logo, banner, diagrams, and schematics.
├── docs/               # Documentation and design notes.
├── scripts/            # Build and automation scripts
├── design/             # Synthesizable SystemVerilog code
│   ├── rtl/            # Core RTL modules (ALU, datapath, control, etc.)
│   └── lib/            # Shared packages, interfaces, constants, and macros
├── verif/                  # Verification environment
│   ├── vip/                # Reusable Verification IP (Agents, UVM components)
│   ├── testbench/          # Unit/module test harnesses & sequences for simulation
│   ├── tests/              # Benchmarks & ISA Coverage
│   │   ├── isa_coverage/   # Assembly/C programs for ISA coverage
│   │   └── benchmarks/     # Synthetic load tests (e.g., Dhrystone)
│   └── formal/             # Formal verification
├── model/              # High-level cycle-accurate models and algorithms
├── ip/                 # Vendor-specific IP (memories, PLLs, etc.)
│   ├── intel/
│   ├── xilinx/
│   ├── sky130/
│   └── gf180mcu/
└── targets/            # Target-specific files and synthesis outputs
    ├── fpga/
    │   └── DE2_115/
    │       ├── constraints/    # Timing constraints (.sdc), pin assignments
    │       ├── synth/          # Post-synthesis netlists
    │       ├── impl/           # Post-P&R bitstream (.sof)
    │       └── reports/        # Timing, utilization, and power reports
    └── asic/
        └── sky130/
            ├── constraints/    # Timing constraints, floorplan
            ├── results/        # Final GDSII, netlists, Liberty files
            ├── reports/        # Timing, utilization, and power reports
            └── workspace/      # Intermediate files generated by tools
```


## Contributing

We welcome contributions to the design, verification, and documentation! Please read our **CONTRIBUTING.md** file to learn how you can help and for guidelines on submitting pull requests.


## License

This project is licensed under the **CERN Open Hardware Licence Version 2 - Strongly Reciprocal**. See the **LICENSE** file for details.
