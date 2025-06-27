# README: Dual-Port and Single-Port RAM in Verilog

This README provides a **deep, detailed explanation** of the Verilog implementations of single-port and dual-port RAM modules and their respective testbenches. It is structured to help both **beginners** and **intermediate hardware engineers** understand RAM design concepts, simulation methodology, and best practices in RTL design.

---

## Overview of RAM Architectures

### Single-Port RAM

* **One port** handles both read and write.
* Only one operation (read or write) can occur per clock cycle.
* Requires **careful address registration** for read-after-write consistency.

### Dual-Port RAM

* **Two independent ports (A and B)**: each can read or write simultaneously.
* Useful in applications where two masters (e.g., CPU + DMA controller) access memory.
* Needs **conflict management** if both ports try to write to the same address.

---

## Conceptual Summary

### Memory:

* Implemented as an array: `reg [7:0] ram [63:0];`
* 64 memory locations (addresses 0 through 63).
* Each location stores 8-bit values.

### Addressing:

* 6-bit address allows 2^6 = 64 addresses.
* Address values are passed from testbenches to the RAM modules.

### Data Bus:

* Data is 8 bits wide (`[7:0]`), allowing storage of byte-sized values.

### Clock:

* All operations are synchronous to the **rising edge** of a single `clock` signal.
* Ensures consistency and predictability in hardware simulation.

---

## File 1: dual\_port\_ram.v

### Functionality:

This module allows **two independent ports (A and B)** to simultaneously **read from or write to** memory.

### Highlights:

* Memory is shared.
* Both ports operate independently, but synchronously.
* Uses two `always @(posedge clock)` blocks for parallel control.
* Write is prioritized when `we_*` is high; otherwise, a read occurs.

### Important Considerations:

* If both ports write to the **same address at the same time**, the behavior is undefined.
* Simultaneous reads from the same address are safe.

---

## File 2: dual\_port\_ram\_tb.v

### Purpose:

Testbench that stimulates the `dual_port_ram` module.

### Simulation Goals:

* Validate that both ports can write and read independently.
* Test simultaneous read/write on different addresses.
* Ensure memory integrity across interactions.

### Features:

* Clock generator: toggles every 5ns (10ns period).
* Dumps waveform (`dump.vcd`) for GTKWave visualization.
* Structured timeline of read and write events.

---

## File 3: singleRam.v

### Functionality:

Implements a **single-port RAM** with a 1-cycle **read delay** due to `addr_reg`.

### Highlights:

* Write occurs immediately on `we = 1`.
* Read occurs by first registering the address, then reading on the next cycle.
* Uses one `always @(posedge clock)` block.
* `q` is updated on every clock cycle.

---

## File 4: single\_port\_ram\_tb.v

### Purpose:

Testbench for `singleRam` module.

### Simulation Goals:

* Validate memory writes.
* Validate 1-cycle read delay behavior.
* Test overwrite functionality.

### Features:

* Writes to addresses 0, 1, 2, and overwrites address 2.
* Reads from those addresses to confirm values.
* Writes again to address 1, and confirms it with a read.

---

## Tools and Setup

* **Simulator**: Icarus Verilog (recommended) or ModelSim.
* **Waveform Viewer**: GTKWave.
* **File Structure**:

  ```
  .
  ├── dual_port_ram.v
  ├── dual_port_ram_tb.v
  ├── singleRam.v
  ├── single_port_ram_tb.v
  └── dump.vcd
  ```

---

## How to Run Simulation

1. **Compile** the design and testbench:

   ```bash
   iverilog -o ram_test dual_port_ram.v dual_port_ram_tb.v
   ```

   or for single port:

   ```bash
   iverilog -o ram_test singleRam.v single_port_ram_tb.v
   ```

2. **Run simulation**:

   ```bash
   vvp ram_test
   ```

3. **View Waveform**:

   ```bash
   gtkwave dump.vcd
   ```

---

## Final Notes

* **Memory Safety**:

  * In dual-port mode, avoid writing to the same address from both ports at once.
  * Consider implementing arbitration logic for real-world applications.

* **Modularity**:

  * You can extend this design by making data/address widths configurable.
  * You can also build RAMs with synchronous/asynchronous reads as needed.

* **Applications**:

  * Dual-port RAM is common in FPGAs, caches, frame buffers.
  * Single-port RAM is ideal for simpler microcontroller or FSM-based designs.

---

## Learning Outcomes

* Understanding of RAM hardware architecture.
* Read/Write timing with Verilog simulation.
* Importance of write enable, address buses, and clock domains.
* Functional testbench construction and waveform debugging.

  ---

## Author
**Kourosh Rashidiyan**
**June 2025**
