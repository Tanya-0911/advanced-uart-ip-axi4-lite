# Advanced UART IP Core with AXI4-Lite Interface

**RTL Design | Verilog | SystemVerilog | Functional Verification**

## Overview

Design and verification of a configurable UART IP Core with an AXI4-Lite interface.

The project aims to develop a processor-accessible UART peripheral with serial transmission, reception, buffering, programmable baud rate and interrupt support.

## Architecture

- Baud Rate Generator
- UART Transmitter (TX)
- UART Receiver (RX)
- FIFO Buffers
- UART Register Bank
- AXI4-Lite Slave Interface
- Interrupt Controller
- Top-Level Integration

## Development Status

| Module | Status |
|---|---|
| Baud Generator | Initial simulation passed |
| UART TX | Functional simulation passed |
| UART RX | Initial functional simulation passed |
| FIFO | RTL implemented; verification pending |
| UART Register Bank | Pending |
| AXI4-Lite Slave | Pending |
| Interrupt Controller | Pending |
| Top-Level Integration | Pending |

## Tools

- Verilog HDL
- SystemVerilog
- Icarus Verilog
- GTKWave
- Yosys
- Ubuntu
- Git and GitHub

## Repository Structure

```text
advanced-uart-ip/
├── constraints/
├── docs/
├── reports/
├── rtl/
├── scripts/
├── sim/
└── tb/
```

## Verification Goals

- UART 8N1 transmission and reception
- FIFO read/write and boundary conditions
- AXI4-Lite read/write transactions
- Interrupt verification
- End-to-end UART communication

## Author

**Tanya Sinha**

GitHub: [Tanya-0911](https://github.com/Tanya-0911)

*Project under active development.*
