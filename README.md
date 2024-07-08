# UART Interface Projects

## Description

- This repository contains VHDL implementations of UART (Universal Asynchronous Receiver/Transmitter) modules, designed for FPGA-based communication systems.  
- These projects include a UART receiver (UART_Rx) and a UART transmitter (UART_Tx).
- Each module is designed to handle serial communication with high reliability and accuracy.

## Features

### UART Receiver (UART_Rx)
- **Configurable Clock Frequency and Baud Rate:** The receiver can be configured with different clock frequencies and baud rates.
- **State Machine Implementation:** Utilizes a finite state machine (FSM) for reliable data reception.
- **Debounced Inputs:** Ensures stable operation of the receiver.
- **Output Signals:** Provides received data and a signal indicating completion of data reception.

### UART Transmitter (UART_Tx)
- **Configurable Clock Frequency and Baud Rate:** The transmitter can be configured with different clock frequencies and baud rates.
- **State Machine Implementation:** Utilizes a finite state machine (FSM) for reliable data transmission.
- **Multiple Stop Bits:** Supports configuration of the number of stop bits.
- **Output Signals:** Provides a signal indicating completion of data transmission.

## Setup Instructions

### Prerequisites

- Xilinx Vivado Design Suite
- FPGA development board (e.g., Xilinx FPGA)
- Knowledge of VHDL and FPGA development

### Steps

1. **Clone the Repository:**
   ```sh
   git clone https://github.com/yourusername/UART-Interface-Projects.git
   cd UART-Interface-Projects

2. **Open Vivado Design Suite:**
   - Launch the Xilinx Vivado Design Suite on your computer.

3. **Create a New Project:**
   - Create a new project in Vivado and select your FPGA development board.

4. **Add Source Files:**
   - Add the `UART_Rx.vhd` and `UART_Tx.vhd` files to your project.

5. **Configure Constraints:**
   - Configure the appropriate constraints for your FPGA board.

6. **Synthesize and Implement:**
   - Synthesize and implement the design in Vivado.

7. **Program the FPGA:**
   - Program the FPGA with the generated bitstream file.

## File Structure

```
UART-Interface-Projects/
├── UART_Rx.vhd
├── UART_Tx.vhd
├── README.md
```

## Usage

- **UART_Rx:** Connect the `rx_line_i` input to the UART line you want to receive data from. The received data will be available on `rx_line_o` and `rx_completed_o` will indicate when data reception is complete.
- **UART_Tx:** Connect the `data_i` input to the data you want to transmit. The `start_i` signal will initiate the transmission, and the `tx_line_o` will output the transmitted data. The `tx_completed_o` signal will indicate when data transmission is complete.

## Serial Monitor

- **HTerm**: HTerm is a terminal program for serial communication. To use it, follow these steps:

 1. Connect your FPGA to Vivado.
 2. Start running the transmitter code on the FPGA.
 3. Send data serially to a Windows or Linux machine.
 4. Use HTerm to observe the received data from the serial monitor.

    
![image](https://github.com/htmos6/SerialX-UART500/assets/88316097/c471d192-e672-4129-929d-4c1f34ad5b09)


## License

This project is licensed under the MIT License - see the LICENSE file for details.


