# Advanced UART IP Core with AXI4-Lite Interface

<p align="center">
  <b>A Modular, Configurable UART Peripheral with Memory-Mapped Processor Interface</b>
</p>

<p align="center">
  Verilog HDL · SystemVerilog · AXI4-Lite · RTL Design · Functional Verification
</p>

---

## Overview

This project focuses on the design and verification of an **Advanced UART (Universal Asynchronous Receiver/Transmitter) IP Core with an AXI4-Lite interface**.

The objective is to develop a modular, processor-accessible UART peripheral capable of reliable asynchronous serial communication, configurable baud-rate generation, buffered data transmission and reception, and interrupt-based status reporting.

The design is being developed using synthesizable Verilog RTL, with SystemVerilog testbenches for functional verification.

The project follows a modular RTL development and verification approach, with individual modules tested before top-level integration.

## Architecture

The proposed UART IP Core consists of the following modules:

| Module | Description |
|---|---|
| Baud Rate Generator | Generates timing pulses for UART communication |
| UART Transmitter (TX) | Serializes parallel data into UART frames |
| UART Receiver (RX) | Receives and reconstructs serial data |
| FIFO Buffers | Temporarily store transmit and receive data |
| UART Register Bank | Provides programmable configuration and status registers |
| AXI4-Lite Slave | Provides a memory-mapped processor interface |
| Interrupt Controller | Generates interrupt requests based on UART events |
| UART Top Module | Integrates the individual functional blocks |

### UART Communication Format

The initial implementation uses the standard UART 8N1 frame format:

- 1 Start Bit
- 8 Data Bits (LSB first)
- 1 Stop Bit
- No Parity Bit

## System Architecture

```text
             Processor / AXI Master
                      |
                      |
              AXI4-Lite Interface
                      |
              +---------------+
              | AXI4-Lite     |
              | Slave         |
              +---------------+
                      |
              +---------------+
              | UART Register |
              | Bank          |
              +---------------+
                      |
          +-----------+-----------+
          |                       |
    +-----------+           +-----------+
    | TX FIFO   |           | RX FIFO   |
    +-----------+           +-----------+
          |                       |
    +-----------+           +-----------+
    | UART TX   |           | UART RX   |
    +-----------+           +-----------+
          |                       |
         TXD                     RXD
          |                       |
          +-----------+-----------+
                      |
              Interrupt Controller
```
*Conceptual architecture. Final integration is under development.*

## Development Progress

| Component | Status |
|---|---|
| Baud Rate Generator | Initial simulation passed |
| UART Transmitter | Functional testbench passed |
| UART Receiver | Initial functional testbench passed |
| FIFO | RTL implemented; verification pending |
| UART Register Bank | Pending implementation and verification |
| AXI4-Lite Slave | Pending implementation and verification |
| Interrupt Controller | Pending implementation and verification |
| Top-Level Integration | Pending |

## Technology Stack

### Hardware Description Languages
- Verilog HDL
- SystemVerilog

### Simulation and Verification
- Icarus Verilog
- GTKWave

### Synthesis and Hardware Analysis
- Yosys

### Development Environment
- Ubuntu Linux
- Windows Subsystem for Linux (WSL)
- Git
- GitHub

## Repository Structure

```text
advanced-uart-ip-axi4-lite/
│
├── constraints/
│
├── docs/
│
├── reports/
│
├── rtl/
│   ├── axi_lite_slave.v
│   ├── baud_generator.v
│   ├── fifo.v
│   ├── interrupt_controller.v
│   ├── uart_registers.v
│   ├── uart_rx.v
│   ├── uart_top.v
│   └── uart_tx.v
│
├── scripts/
│
├── sim/
│
├── tb/
│   ├── tb_axi_lite_slave.sv
│   ├── tb_baud_generator.sv
│   ├── tb_fifo.sv
│   ├── tb_uart_rx.sv
│   ├── tb_uart_top.sv
│   └── tb_uart_tx.sv
│
├── .gitignore
└── README.md
```

## Verification Strategy

Each functional block is developed and verified independently before integration.

### Completed Initial Verification

- Baud generator timing verification.
- UART transmitter 8N1 frame verification.
- UART receiver data reception verification.

### Planned Verification

- FIFO data integrity and ordering.
- FIFO full and empty conditions.
- Simultaneous FIFO read and write.
- AXI4-Lite write and read transactions.
- Register access and reset behaviour.
- Interrupt generation and clearing.
- Integrated UART transmission and reception.
- End-to-end processor-to-UART communication.

## Design Goals

The final implementation aims to support:

- Configurable baud-rate generation.
- Independent UART transmission and reception.
- Buffered TX and RX operations.
- Memory-mapped register access.
- AXI4-Lite protocol-compliant transactions.
- Interrupt-driven communication.
- Modular and reusable RTL architecture.
- Functional verification and synthesis analysis.

## Future Enhancements

- Programmable UART frame configuration.
- Configurable FIFO depth.
- Parity and framing error detection.
- Overrun and underrun handling.
- AXI4-Lite protocol verification.
- FPGA implementation and hardware validation.
- Synthesis resource and timing analysis.

## Learning Outcomes

This project explores practical concepts in:

- RTL microarchitecture and modular hardware design.
- Finite State Machines (FSMs).
- Serial communication protocols.
- FIFO architecture and pointer management.
- Memory-mapped peripheral design.
- AXI4-Lite bus protocol.
- Functional verification using SystemVerilog.
- RTL synthesis using Yosys.

## Author

**Tanya Sinha**

B.Tech – Electronics Engineering  
VLSI Design & Technology

GitHub: [Tanya-0911](https://github.com/Tanya-0911)

Project Repository: [Advanced UART IP Core with AXI4-Lite](https://github.com/Tanya-0911/advanced-uart-ip-axi4-lite)

---

<p align="center">
  <b>Designed and developed as an ongoing RTL engineering project.</b>
</p>
