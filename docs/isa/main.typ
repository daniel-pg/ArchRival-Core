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

The ICMC Instruction Set Architecture (ISA) is a 16-bit von Neumann architecture designed for educational purposes. It features a fixed-length 16-bit instruction encoding, a bank of general-purpose registers, and support for arithmetic, logical, memory, and control flow operations.

The architecture is defined by its register set, memory model, and the instruction encodings and semantics detailed herein. All data words and registers are 16 bits wide.

== Notation
- `Rx`, `Ry`, `Rz`: General-purpose registers, where `x`, `y`, and `z` are indices from 0 to 7.
- `M[addr]`: The contents of memory at the 16-bit address `addr`.
- `imm`: An immediate value.
- `<=`: Denotes assignment or data transfer.

= Registers

== General Purpose

== Special

= Instructions

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

== Input and Output Instructions

== Debugging Instructions

=== Breakpoint
