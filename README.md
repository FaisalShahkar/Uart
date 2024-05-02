# UART Module

This repository contains a UART (Universal Asynchronous Receiver-Transmitter) module written in Verilog. The UART module facilitates asynchronous serial communication between devices.

## Modules Overview

### UART Module (`uart.v`)

This is the main UART module responsible for coordinating data transmission and reception.

#### Inputs

- `t_byte_i`: Indicates when a byte is ready for transmission.
- `byte_ready_i`: Signal indicating that new data is ready to be transmitted.
- `clk_i`: Clock input for timing operations.
- `reset_i`: Reset signal for resetting the module.
- `data_in`: 8-bit input data to be transmitted.

#### Outputs

- `Tx`: Transmitted data output.

### Mux Module (`mux.v`)

This module acts as a multiplexer to control data transmission.

#### Inputs

- `clk_i`: Clock input for timing.
- `serial_out_o`: Output data from the shift register.
- `start_o`: Control signal to start data transmission.

#### Outputs

- `Tx`: Transmitted data output.

### Shift Register Module (`shift_reg.v`)

The shift register module handles the shifting of data bits for transmission.

#### Inputs

- `clk_i`: Clock input for timing operations.
- `reset_i`: Reset signal for resetting the register.
- `shift_o`: Control signal for shifting data bits.
- `load_xmt_shftreg_o`: Control signal to load data into the register.
- `data_in`: 8-bit input data to be loaded into the register.

#### Outputs

- `serial_out_o`: Shifted data output for transmission.

### Baud Counter Module (`Baud_Counter.v`)

This module counts clock cycles to determine baud rate timing.

#### Inputs

- `clk_i`: Clock input for timing.
- `clear_baud_o`: Control signal to clear the counter.

#### Outputs

- `counter_baud_of_i`: Signal indicating completion of a baud cycle.

### Bit Counter Module (`Bit_Counter.v`)

The bit counter module counts clock cycles to track the number of bits transmitted.

#### Inputs

- `clk_i`: Clock input for timing.
- `clear_o`: Control signal to clear the counter.

#### Outputs

- `counter_of_i`: Signal indicating completion of counting bits.

### Controller Module (`controller.v`)

This module acts as the Finite State Machine (FSM) controller for managing the UART operations.

#### Inputs

- `clk_i`: Clock input for timing operations.
- `reset_i`: Reset signal for resetting the FSM.
- `byte_ready_i`: Signal indicating that new data is ready to be transmitted.
- `counter_baud_of_i`: Signal indicating completion of a baud cycle.
- `counter_of_i`: Signal indicating completion of counting bits.
- `t_byte_i`: Signal indicating when a byte is ready for transmission.

#### Outputs

- `load_xmt_shftreg_o`: Control signal to load data into the shift register.
- `start_o`: Control signal to start data transmission.
- `clear_o`: Control signal to clear the bit counter.
- `clear_baud_o`: Control signal to clear the baud rate counter.
- `shift_o`: Control signal for shifting data in the shift register.

---

Feel free to explore and use these Verilog modules for implementing UART functionality in your projects!
