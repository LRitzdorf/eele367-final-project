# EELE 367 Final Project

The final project for EELE 367, Logic Design (a course covering logic circuit
design with VHDL, as well as implementation on an FPGA).

## Project Phases

This project consists of several stages, culminating in an FPGA implementation
of a rudimentary RISC computer system:

1. VHDL skeleton
2. Simulation of four basic instructions
3. FPGA implementation of basic instructions
4. Implementing additional instructions

## System Architecture

The computer system can run in a simulation environment, or as real logic
circuitry allocated from the fabric of a field-programmable gate array (FPGA)
chip. The simulation environment allows for simple verification of functionality
and direct observation of internal system components, and is incredibly useful
when debugging systems such as this.

### Simulation

When run as a simulation, the computer system is comprised of the following entities:

- `computer_TB`: VHDL test bench to verify system functionality; provides basic
  control signals and I/O connections, but is not synthesizable
  - `computer` core entity (see below)

### FPGA Implementation

When synthesized and implemented on an FPGA, the computer system is comprised of the following entities:

- `top`: top-level entity; forms the basis for synthesis and flashing to an FPGA
  - `computer` core entity (see below)
  - `char_decoder`: translates 4-bit binary numbers into control signals for a
    seven-segment display
  - `precision_clock_divider`: divides the 50MHz clock on the Intel DE10-Lite
    board down to another (selectable) frequency; allows logic to be run at
    observable speeds for verification and high speeds for practical testing

### Computer Core

The core `computer` entity is composed of:

  - `computer`: the "real" computer entity; instantiates and connects the CPU
    and memory components
    - `cpu`: instantiates and connects the processor control unit and the data
      path
      - `control_unit`: finite state machine; implements the CPU's
        fetch-decode-execute cycle to control operations in the data path
      - `data_path`: contains registers, buses, and general data wiring;
        performs data manipulation as directed by the control unit
        - `alu`: arithmetic/logical unit; performs more complex data
          manipulation (arithmetic and logical operations) as necessary
    - `memory`: directly implements I/O ports and instantiates ROM and RW memory
      modules; controls memory mapping so that subcomponents do not need to be
      aware of their positions in the mapped system
      - `rom_128x8_sync`: synchronous ROM (program) memory, containing 128 8-bit
        addresses (1024 bits of total space)
      - `rw_96x8_sync`: synchronous RW (data) memory, containing 96 8-bit
        addresses (768 bits of total space)

## Opcodes/Instructions

At present, the computer system implements the following instructions:

Mnemonic  | Opcode | Argument(s)     | Function
----------|--------|-----------------|---------
`LDA_IMM` | `0x86` | Value           | Load register A using immediate addressing
`LDA_DIR` | `0x87` | Data address    | Load register A using direct addressing
`STA_DIR` | `0x96` | Data address    | Store from register A using direct addressing
`BRA`     | `0x20` | Program address | Branch always
`NOP`     | `0x00` |                 | No-op (do nothing and continue executing)
`HALT`    | `0xFF` |                 | End program execution

## Memory Mapping

Total available address space ranges from `0x00` to `0xFF`, and is allocated as
follows:

Allocation   | Start  | End
-------------|--------|----
ROM          | `0x00` | `0x7F`
RW memory    | `0x80` | `0xDF`
Input ports  | `0xE0` | `0xEF`
Output ports | `0xF0` | `0xFF`
