# UART Transceiver – Verilog

A UART design in Verilog with separate transmitter and receiver modules, a top-level integration module, and testbenches for individual and full-duplex verification.

## Design Overview

- **UART TX (`uart_tx_top`)**: Converts 8-bit parallel data into serial data.
- **UART RX (`uart_rx_top`)**: Receives serial data, reconstructs the byte, and checks parity and stop bits.
- **UART Top (`uart_top`)**: Integrates one transmitter and one receiver.

## Full-Duplex Verification

The testbench instantiates two `uart_top` modules and cross-connects their serial signals:

```text
UART A TX  ----------------->  UART B RX
UART A RX  <-----------------  UART B TX
```

Both devices transmit simultaneously:
- UART A sends `8'hA5`; UART B receives `8'hA5`.
- UART B sends `8'hB6`; UART A receives `8'hB6`.

## Top-Level Interface

| Signal | Description |
|---|---|
| `tx_clk_i` / `rx_clk_i` | Transmitter and receiver clocks |
| `rst_ni` | Active-low reset |
| `par_typ_i` / `par_en_i` | Parity type and enable |
| `prescale_i` | Receiver oversampling prescale |
| `tx_data_p_i` | 8-bit parallel transmit data |
| `tx_data_valid_i` | Transmit data valid |
| `tx_data_s_o` | Serial transmit output |
| `tx_busy_o` | Transmitter busy status |
| `rx_data_s_i` | Serial receive input |
| `rx_data_p_o` | 8-bit received data |
| `rx_data_valid_o` | Received data valid |

## Testbenches

- `uart_tx_tb.v` – Tests the transmitter.
- `uart_rx_tb.v` – Tests the receiver.
- `uart_tb.v` – Tests full-duplex communication using two UART instances.

## Full-Duplex Test Configuration

- Prescale: `8`
- Parity: Disabled
- TX clock period: `1000 ns`
- RX clock period: `125 ns`

The waveform confirmed that both receivers obtained the expected data and asserted their valid signals.

## Running the Simulation

Compile the RTL files together with the desired testbench in your Verilog simulator. Select `uart_tx_tb`, `uart_rx_tb`, or `uart_tb` as the simulation top to run the corresponding test.
