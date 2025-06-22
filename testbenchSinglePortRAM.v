`timescale 1ns/1ps  // Set time unit to 1ns and time precision to 1ps
                    // This means #10 = 10 nanoseconds in simulation

module single_port_ram_tb;

  // Testbench signals (reg = driven by initial blocks, wire = outputs)
  reg [7:0] data;     // 8-bit data input to be written into RAM
  reg [5:0] addr;     // 6-bit address input, selects 1 of 64 memory locations (2^6 = 64)
  reg we;             // Write Enable: 1 = Write, 0 = Read
  reg clock;          // Clock signal for driving RAM operations
  wire [7:0] q;       // 8-bit output from RAM (read data)

  // Instantiate the RAM module (named 'singleRam' — make sure this matches your actual RAM file)
  singleRam spr1 (
    .data(data),      // Connect 'data' input to RAM's data input
    .addr(addr),      // Connect 'addr' input to RAM's address input
    .we(we),          // Connect 'we' input to RAM's write enable
    .clock(clock),    // Connect 'clock' to RAM's clock
    .q(q)             // Connect RAM's output 'q' to testbench wire
  );

  // Clock generation block
  // This block creates a free-running clock that toggles every 5ns
  // This gives a full clock period of 10ns (50% duty cycle)
  initial begin
    clock = 1'b0;            // Start with clock low
    forever #5 clock = ~clock; // Invert clock every 5ns (toggle)
  end

  // Waveform generation setup
  // This generates a VCD file that GTKWave or other viewers can display
  initial begin
    $dumpfile("dump.vcd");              // Name of the waveform output file
    $dumpvars(1, single_port_ram_tb);   // Record all variables in this module (level 1)
  end

  // Main test sequence
  initial begin
    // === WRITE PHASE 1 ===
    // Enable write mode and store different data into addresses 0, 1, and 2

    we = 1;  // Enable write mode

    data = 8'h01; addr = 6'd0; #10;   // Write 0x01 to address 0
    data = 8'h02; addr = 6'd1; #10;   // Write 0x02 to address 1
    data = 8'h03; addr = 6'd2; #10;   // Write 0x03 to address 2

    // === OVERWRITE TEST ===
    // Write a new value to address 2 to check if overwrite works correctly

    data = 8'hAA; addr = 6'd2; #10;   // Overwrite address 2 with 0xAA (10101010)

    // === READ PHASE 1 ===
    // Switch to read mode and observe output 'q' for previously written values

    we = 0;            // Disable write mode (read mode active)

    addr = 6'd0; #10;  // Read from address 0 → Expect q = 0x01
    addr = 6'd1; #10;  // Read from address 1 → Expect q = 0x02
    addr = 6'd2; #10;  // Read from address 2 → Expect q = 0xAA (overwritten value)

    // === WRITE PHASE 2 ===
    // Write a new value to address 1, then read it back

    we = 1;                          // Enable write mode
    data = 8'h04; addr = 6'd1; #10;  // Write 0x04 to address 1

    // === READ PHASE 2 ===
    // Read the new value at address 1 to confirm it was updated

    we = 0;            // Switch back to read mode
    addr = 6'd1; #10;  // Read from address 1 → Expect q = 0x04

    $finish;  // End simulation cleanly
  end

endmodule

