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

== ICMC ISA Overview

The ICMC Instruction Set Architecture (ISA) is a very simplified *16-bit, load-store, RISC(ish), von Neumann architecture* designed for educational purposes. It features *isolated I/O*,  *variable-length instruction encoding* (16-bit/32-bit), a bank of eight general-purpose registers, status flag registers, and support for arithmetic, logical, memory, and control flow operations.

The architecture is defined by its register set, memory model, and the instruction encodings and semantics detailed herein. All data words and registers are 16 bits wide.

Designed primarily for simplicity and ease of teaching, this ISA *does NOT support* many of the features that power almost all modern CPU architectures and even some microcontrollers, including but not limited to:

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

Instead, it supports a very limited set of features, such as:
- A simple *polled I/O* system consisting of a text-based screen (16 colors, 40 lines x 30 columns) and a keyboard.
- "Debugging support" via manual single-step instruction execution.

Yes, specifying the I/O systems and peripherals as part of the ISA itself is a questionable idea to say the least, I couldn't agree more. Unfortunately, I'm not the person who makes the rules, that's the way things are, so we must simply deal with it.

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
  [`R0`-`R7`], `16-bit`, "Eight General-Purpose Registers (GPRs) for data manipulation.",
  `PC`, `16-bit`, "Program Counter. Holds the address of the next instruction to be fetched.",
  `SP`, `16-bit`, [Stack Pointer. Points to the top of the stack. It is initialized to `0x7F00` and grows downwards.],
  `FR`, `16-bit`, "Flag Register. Stores status flags from arithmetic and logical operations.",
)

== Flags Register (FR)

The 16-bit Flag Register holds status bits that reflect the outcome of previous operations. These flags are used for conditional branching.

#table(
  columns: (auto, auto, auto, auto),
  stroke: (top: 1pt, bottom: 1pt),
  [*Bits*], [*Flag*], [*Name*], [*Description*],
  [`15`-`10`], `-`, `-`, "Reserved.",
  `9`, `N`, `Negative`, "Set if the result of an arithmetic operation is negative.",
  `8`, `SOV`, `Stack_Overflow`, "Stack Overflow flag (Architecturally defined).",
  `7`, `SUN`, `Stack_Underflow`, "Stack Underflow flag (Architecturally defined).",
  `6`, `DZ`, `Divide_by_Zero`, "Set if a division by zero is attempted.",
  `5`, `OV`, `Overflow`, "Set if an arithmetic operation results in an overflow.",
  `4`, `C`, `Carry`, "Set if an operation generates a carry out of the most significant bit.",
  `3`, `Z`, `Zero`, "Set if the result of an operation is zero.",
  `2`, `E`, `Equal`, [Set if a comparison results in equality (`x == y`).],
  `1`, `L`, `Lesser`, [Set if a comparison results in less than (`x < y`).],
  `0`, `G`, `Greater`, [Set if a comparison results in greater than (`x > y`).],
)

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

