# ArchRival

![ArchRival Logo](logo.png)

> *A clean SystemVerilog implementation of the ICMC-Processor — redesigned at UNICAMP.*

**ArchRival** is a modernized and modular reimplementation of the [ICMC-Processor](https://github.com/simoesusp/Processador-ICMC/), originally designed by students and faculty from the University of São Paulo (USP). Developed from scratch with clarity, portability, and educational value in mind, this project brings the architecture into a new era — with upgraded structure, refined RTL code, and a layout that cleanly supports multiple FPGA targets.

---

### 🏁 Key Goals

- ✅ Replace ugly and verbose VHDL with clean, readable SystemVerilog.  
- ✅ Organize the codebase by separating design, verification, and FPGA-specific files.  
- ✅ Make the platform suitable for teaching and experimentation.  
- ✅ Celebrate UNICAMP's champion-level commitment to computing education. 😉

---

### 📁 Project Structure

```text
ArchRival/
├── docs/               # Documentation and design notes.
│   ├── architecture/
│   └── assembly/
├── design/             # Synthesizable SystemVerilog code
│   ├── rtl/            # Core RTL modules (ALU, datapath, control, etc.)
│   └── include/        # Shared packages, constants, and macros
├── verif/              # Verification environment
│   ├── testbench/      # Simulation testbenches
│   └── formal/         # Formal verification files (future)
├── fpga/               # FPGA-specific files
│   └── DE2_115/
└── scripts/            # Build and automation scripts
```

Stay tuned for documentation, simulator, and toolchain updates.
PRs and contributions are welcome — unless you're from USP. 😉
