#import "@preview/basic-report:0.3.1": *

#show: it => basic-report(
  doc-category: "Instruction Set Manual",
  doc-title: "ICMC Processor ISA Specification",
  author: "Daniel Paulo Garcia",
  affiliation: "Institute of Computing, State University of Campinas (UNICAMP)",
  logo: image("../../assets/logo.svg", width: 2cm),
  language: "en",
  compact-mode: false,
  heading-color: red,
  it
)

= Introduction

The ICMC Instruction Set Architecture (ISA) is a very simplified 16-bit, von Neumann, load-store, isolated I/O, RISC(ish) architecture designed for educational purposes. It features a variable-length 16-bit/32-bit instruction encoding, a bank of eight general-purpose registers, status flag registers, and support for arithmetic, logical, memory, and control flow operations.

The architecture is defined by its register set, memory model, and the instruction encodings and semantics detailed herein. All data words and registers are 16 bits wide.

As an ISA that has been designed mainly for simplicity and ease of teaching, it *does NOT support* many of the features that power almost all modern CPU architectures and even some microcontrollers, including but not limited to:

- Hardware Interrupts
- Hardware Timers and Performance Counters
- Hardware Debugging
- Exception and Trap / System Call Handling
- Memory protection and virtualization
- Privilege Levels
- Atomic Operations
- Floating-Point Operations
- Vector Instructions
- Power and Energy Management

... and so on.

Instead, it only supports a very limited set of features, like:
- A very simple polled I/O system consisting of a 16 color, 40 lines x 30 columns, text-based screen, and a keyboard.
- "Debugging support" via manual single-step instruction execution.

If you think that specifying the I/O systems and peripherals as part of the ISA itself is a questionable idea to say the least, I'd say that I couldn't agree more, but then that's the way things are so we have to just deal with it, unfortunately.

== Notation

Throughout this document, we use the following conventions to describe instructions:

- `Rx`, `Ry`, `Rz`: General-purpose registers, where `x`, `y`, and `z` are indices from 0 to 7.
- `M[addr]`: The contents of memory at the 16-bit address `addr`.
- `imm16`: A 16-bit immediate value.
- `<=`: Denotes assignment or data transfer.

= Core Architecture

== Registers

The CPU contains a set of 16-bit registers accessible, directly or indirectly, to the programmer.

#table(
  columns: (auto, auto, auto),
  stroke: (top: 1pt, bottom: 1pt),
  align: (left, left, left),
  [*Register*], [*Width*], [*Description*],
  `R0-R7`, `16-bit`, "Eight General-Purpose Registers (GPRs) for data manipulation.",
  `PC`, `16-bit`, "Program Counter. Holds the address of the next instruction to be fetched.",
  `SP`, `16-bit`, [Stack Pointer. Points to the top of the stack. It is initialized to `0x7F00` and grows downwards.],
  `FR`, `16-bit`, "Flag Register. Stores status flags from arithmetic and logical operations.",
)

== Flags Register (FR)



= Instruction Formats

= Instruction Set Reference

== Integer Computational Instructions

=== Arithmetic

=== Logic

== Memory Instructions

=== Load and Store

=== Stack

== Execution Flow Instructions

=== Unconditional Jumps

=== Conditional Branches

=== Halt

=== Breakpoint

== Input and Output Instructions

