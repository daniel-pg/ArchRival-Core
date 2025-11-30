#import "@preview/basic-report:0.3.1": *

#import "bitfield-table.typ": bitfield-table

// --- Color Palette ---
#let c-op     = rgb("#d8e2dc") // Pastel Gray-Green
#let c-reg    = rgb("#ffe5d9") // Pastel Peach
#let c-imm    = rgb("#d0f4de") // Pastel Mint
#let c-func   = rgb("#e0c3fc") // Pastel Purple
#let c-shamt  = rgb("#ffffb4") // Pastel Yellow
#let c-cond   = rgb("#c0deff") // Pastel Blue
#let c-unused = rgb("#f5f5f5") // Light Gray

#show: it => basic-report(
  doc-category: "Instruction Set Manual",
  doc-title: "The ICMC ISA Specification",
  author: "Daniel Paulo Garcia",
  affiliation: "Institute of Computing, State University of Campinas (UNICAMP)",
  logo: image("../../assets/logo.svg", width: 2cm),
  language: "en",
  compact-mode: false,
  heading-color: rgb("#aa0000"),
  it
)


= Introduction

== ICMC ISA Overview

The ICMC Instruction Set Architecture (ISA) is a simplified *16-bit, load-store, RISC-ish, von Neumann architecture* designed for educational purposes. It features *isolated I/O*, *variable-length instruction encoding* (16-bit/32-bit), a bank of eight general-purpose registers, status flag registers, and support for arithmetic, logical, memory, and control flow operations.

The architecture is defined by its register set, memory model, and the instruction encodings and semantics detailed herein. All data words and registers are 16 bits wide.

Designed primarily for simplicity and ease of teaching, this ISA *does NOT support* many of the features that power almost all modern CPU architectures and even some microcontrollers, including but not limited to:

- Hardware Interrupts
- Hardware Timers and Performance Counters
- Hardware Debugging
- Exception and Trap / System Call Handling
- Memory protection and virtualization
- Privilege Levels
- Multiprocessing
- Atomic Operations
- Floating-Point Operations
- Vector Instructions
- Power and Energy Management

... and so on.

Instead, it supports a very limited set of features, such as:
- A simple *polled I/O* system consisting of a text-based screen (16 colors, 40 lines x 30 columns, with customizable _character generator ROM_) and a keyboard.
- "Debugging" support via manual single-step instruction execution.

Yes, specifying the I/O systems and peripherals as part of the ISA itself, especially when they keep changing all the time, is a questionable idea to say the least, I couldn't agree more. Unfortunately, I'm not the person who makes the rules, that's the way things are, so we must simply deal with it.

== Notation

Throughout this document, we use the following conventions to describe instructions:

#table(
  columns: (auto, auto),
  stroke: (top: 1pt, bottom: 1pt),
  align: (left, left),
  [*Notation*], [*Description*],
  [`Rx`, `Ry`, `Rz`], [General-purpose registers, where `x`, `y`, and `z` are indices from 0 to 7.],
  `M[addr]`, [The contents of memory at the 16-bit address `addr`.],
  `imm`, "A 16-bit immediate value.",
  `<=`, "Denotes assignment or data transfer.",
)


= Core Architecture

== Registers

The CPU contains a set of 16-bit registers accessible, directly or indirectly, to the programmer.

#table(
  columns: (auto, auto),
  stroke: (top: 1pt, bottom: 1pt),
  align: (left, left),
  [*Register*], [*Description*],
  [`R0`-`R7`], "Eight General-Purpose Registers (GPRs) for data manipulation.",
  `PC`, "Program Counter. Holds the address of the next instruction to be fetched.",
  `SP`, [Stack Pointer. Points to the top of the stack and grows downwards.],
  `FR`, "Flag Register. Stores status flags from arithmetic and logical operations.",
)

== Flags Register (FR)

The 16-bit Flag Register holds status bits that reflect the outcome of previous operations, and can affect how some instructions behave.

#table(
  columns: (auto, auto, auto, auto),
  stroke: (top: 1pt, bottom: 1pt),
  [*Bits*], [*Abbr.*], [*Flag Name*], [*Description*],
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


= Instruction Set Reference

== Arithmetic Instructions

Arithmetic operations typically use the suffix `10` in the upper 2 bits of the opcode.

=== ADD / SUB / MUL / DIV
Performs standard arithmetic between `Ry` and `Rz`, storing the result in `Rx`. The most significant bit (`C`) controls whether the Carry flag is included in the operation.

#bitfield-table(
  (
    ("Opcode", 6, c-op),
    ("Rx", 3, c-reg),
    ("Ry", 3, c-reg),
    ("Rz", 3, c-reg),
    ("C", 1, c-func),
  ),
  encodings: (
    ("ADD", "Dest", "Src1", "Src2", "0"),
    ("ADDC", "Dest", "Src1", "Src2", "1"),
    ("SUB", "Dest", "Src1", "Src2", "0"),
    ("SUBC", "Dest", "Src1", "Src2", "1"),
    ("MUL", "Dest", "Src1", "Src2", "0"),
    ("DIV", "Dest", "Src1", "Src2", "0"),
  )
)

=== MOD
Calculates `Rx = Ry MOD Rz`.

#bitfield-table(
  (
    ("Opcode", 6, c-op),
    ("Rx", 3, c-reg),
    ("Ry", 3, c-reg),
    ("Rz", 3, c-reg),
    ("Unused", 1, c-unused),
  ),
  encodings: (
    ("MOD", "Dest", "Src1", "Src2", text(fill: gray, "x")),
  )
)

=== INC / DEC
Increments or Decrements a register. `Bit 6` determines the operation: `0` increments, `1` decrements.

#bitfield-table(
  (
    ("Opcode", 6, c-op),
    ("Rx", 3, c-reg),
    ("Op", 1, c-func),
    ("Unused", 6, c-unused),
  ),
  encodings: (
    ("INC/DEC", "Dest", "0", text(fill: gray, "xxxxxx")),
    ("INC/DEC", "Dest", "1", text(fill: gray, "xxxxxx")),
  )
)

== Logical Instructions

Logical operations typically use the suffix `01` in the upper 2 bits of the opcode.

=== AND / OR / XOR
Bitwise logical operations.

#bitfield-table(
  (
    ("Opcode", 6, c-op),
    ("Rx", 3, c-reg),
    ("Ry", 3, c-reg),
    ("Rz", 3, c-reg),
    ("Unused", 1, c-unused),
  ),
  encodings: (
    ("AND", "Dest", "Src1", "Src2", text(fill: gray, "x")),
    ("OR", "Dest", "Src1", "Src2", text(fill: gray, "x")),
    ("XOR", "Dest", "Src1", "Src2", text(fill: gray, "x")),
  )
)

=== NOT
Bitwise NOT operation. `Rx = NOT Ry`.

#bitfield-table(
  (
    ("Opcode", 6, c-op),
    ("Rx", 3, c-reg),
    ("Ry", 3, c-reg),
    ("Unused", 4, c-unused),
  ),
  encodings: (
    ("NOT", "Dest", "Src", text(fill: gray, "xxxx")),
  )
)

=== SHIFT / ROTATE
Shifts or Rotates `Rx` by `Amount`. The `Type` field determines operation (shift or rotation), direction (left or right) and fill bit.

#bitfield-table(
  (
    ("Opcode", 6, c-op),
    ("Rx", 3, c-reg),
    ("Type", 3, c-func),
    ("Amount", 4, c-shamt),
  ),
  encodings: (
    ("SHIFT/ROTATE", "Dest", "SL0", "SH-AMNT"),
    ("SHIFT/ROTATE", "Dest", "SL1", "SH-AMNT"),
    ("SHIFT/ROTATE", "Dest", "SR0", "SH-AMNT"),
    ("SHIFT/ROTATE", "Dest", "SR1", "SH-AMNT"),
    ("SHIFT/ROTATE", "Dest", "ROR", "SH-AMNT"),
    ("SHIFT/ROTATE", "Dest", "ROL", "SH-AMNT"),
  )
)

=== CMP
Compares `Rx` and `Ry` and updates the Flags Register accordingly.

#bitfield-table(
  (
    ("Opcode", 6, c-op),
    ("Rx", 3, c-reg),
    ("Ry", 3, c-reg),
    ("Unused", 4, c-unused),
  ),
  encodings: (
    ("CMP", "Op1", "Op2", text(fill: gray, "xxxx")),
  )
)

== Data Transfer Instructions

=== MOV
Moves data between registers or the Stack Pointer.

#bitfield-table(
  (
    ("Opcode", 6, c-op),
    ("Rx", 3, c-reg),
    ("Ry", 3, c-reg),
    ("Unused", 2, c-unused),
    ("Mode", 2, c-func),
  ),
  encodings: (
    ("MOV Rx, Ry", "Dest", "Src", text(fill: gray, "xx"), "00"),
    ("MOV Rx, SP", "Dest", text(fill: gray, "xxx"), text(fill: gray, "xx"), "01"),
    ("MOV SP, Rx", "Src",  text(fill: gray, "xxx"), text(fill: gray, "xx"), "11"),
  )
)

=== LOAD / STORE (Direct Addressing)
Loads from or Stores to a 16-bit memory address provided in the immediate value.

`LOAD`: `Rx <- M[addr]`. \
`STORE`: `M[addr] <- Rx`.

*Word 1:*
#bitfield-table(
  (
    ("Opcode", 6, c-op),
    ("Rx", 3, c-reg),
    ("Unused", 7, c-unused),
  ),
  encodings: (
    ("LOAD", "Dest", text(fill: gray, "xxxxxxx")),
    ("STORE", "Src",  text(fill: gray, "xxxxxxx")),
  )
)
*Word 2:*
#bitfield-table((
  ("Immediate / Address", 16, c-imm),
))

=== LOADI / STOREI (Indirect Addressing)
Accesses memory using an address stored in a register.

`LOADI`: `Rx <- M[Ry]`. \
`STOREI`: `M[Rx] <- Ry`.

#bitfield-table(
  (
    ("Opcode", 6, c-op),
    ("Rx", 3, c-reg),
    ("Ry", 3, c-reg),
    ("Unused", 4, c-unused),
  ),
  encodings: (
    ("LOAD-INDEX", "Dest", "AddrReg", text(fill: gray, "xxxx")),
    ("STORE-INDEX", "AddrReg", "Src", text(fill: gray, "xxxx")),
  )
)

=== LOADN (Immediate)
Loads an immediate 16-bit value into `Rx`. This operation has nothing to do with memory access.

*Word 1:*
#bitfield-table(
  (
    ("Opcode", 6, c-op),
    ("Rx", 3, c-reg),
    ("Unused", 7, c-unused),
  ),
  encodings: (
    ("LOADIMED", "Dest", text(fill: gray, "xxxxxxx")),
  )
)
*Word 2:*
#bitfield-table((
  ("Immediate", 16, c-imm),
))

== Control Flow Instructions

=== JMP / CALL
Conditional Jump or Call to address.
The `Cond` field selects the flag condition (e.g., 0000=Unconditional, 0001=Equal, etc.).

// TODO: Expand flags

*Word 1:*
#bitfield-table(
  (
    ("Opcode", 6, c-op),
    ("Cond", 4, c-cond),
    ("Unused", 6, c-unused),
  ),
  encodings: (
    ("JMP", "Cond", text(fill: gray, "xxxxxx")),
    ("CALL",  "Cond", text(fill: gray, "xxxxxx")),
  )
)
*Word 2:*
#bitfield-table((
  ("Immediate / Address", 16, c-imm),
))

=== RTS
Return from Subroutine.

`PC <- M[SP]`, `SP++`.

#bitfield-table(
  (
    ("Opcode", 6, c-op),
    ("Unused", 10, c-unused),
  ),
  encodings: (
    ("RTS", text(fill: gray, "xxxxxxxxxx")),
  )
)

=== PUSH / POP
Stack operations. `Sel` bit determines if pushing/popping a General Register (`0`) or the Flag Register (`1`).

#bitfield-table(
  (
    ("Opcode", 6, c-op),
    ("Rx", 3, c-reg),
    ("Sel", 1, c-func),
    ("Unused", 6, c-unused),
  ),
  encodings: (
    ("PUSH Rx", "Src", "0", text(fill: gray, "xxxxxx")),
    ("POP Rx", "Dest", "0", text(fill: gray, "xxxxxx")),
    ("PUSH FR", text(fill: gray, "xxx"), "1", text(fill: gray, "xxxxxx")),
    ("POP FR", text(fill: gray, "xxx"), "1", text(fill: gray, "xxxxxx")),
  )
)

== System & I/O Instructions

=== INCHAR
Reads a character from the Keyboard into `Rx`.

#bitfield-table(
  (
    ("Opcode", 6, c-op),
    ("Rx", 3, c-reg),
    ("Unused", 7, c-unused),
  ),
  encodings: (
    ("INCHAR", "Dest", text(fill: gray, "xxxxxxx")),
  )
)

=== OUTCHAR
Writes a character code from `Rx` to the video position in `Ry`.

#bitfield-table(
  (
    ("Opcode", 6, c-op),
    ("Rx", 3, c-reg),
    ("Ry", 3, c-reg),
    ("Unused", 4, c-unused),
  ),
  encodings: (
    ("OUTCHAR", "Char", "Pos", text(fill: gray, "xxxx")),
  )
)

=== SETC / BREAKP / HALT / NOP
System control flags and debugging.
`SETC` uses Bit 9 to determine Set (1) or Clear (0) Carry.

#bitfield-table(
  (
    ("Opcode", 6, c-op),
    ("Param", 1, c-func),
    ("Unused", 9, c-unused),
  ),
  encodings: (
    ("SETC", "1", text(fill: gray, "xxxxxxxxx")),
    ("CLEARC", "0", text(fill: gray, "xxxxxxxxx")),
    ("BREAKP", text(fill: gray, "x"), text(fill: gray, "xxxxxxxxx")),
    ("HALT", text(fill: gray, "x"), text(fill: gray, "xxxxxxxxx")),
    ("NOP", text(fill: gray, "x"), text(fill: gray, "xxxxxxxxx")),
  )
)
