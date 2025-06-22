`timescale 1ns/1ps  // Set the time unit to 1ns, and the simulation precision to 1ps

module dual_port_ram_tb;

  // Declare test input registers (inputs to DUT)
  reg [7:0] data_a, data_b;     // Data to be written by port A and port B
  reg [5:0] addr_a, addr_b;     // Addresses to access for each port (0 to 63)
  reg we_a, we_b;               // Write-enable signals for ports A and B
  reg clock;                    // Shared clock signal for the memory

  // Declare output wires (outputs from DUT)
  wire [7:0] q_a, q_b;          // Data read out by each port

  // Instantiate the dual_port_ram module and connect testbench signals
  dual_port_ram dpr1 (
    .data_a(data_a),   // Connect data_a from testbench to module
    .data_b(data_b),   // Connect data_b
    .addr_a(addr_a),   // Connect addr_a
    .addr_b(addr_b),   // Connect addr_b
    .we_a(we_a),       // Connect write-enable for port A
    .we_b(we_b),       // Connect write-enable for port B
    .clock(clock),     // Shared clock signal
    .q_a(q_a),         // Output from port A
    .q_b(q_b)          // Output from port B
  );

  // Clock generation block
  // Starts at logic high, toggles every 5ns → 10ns full period
  initial begin
    $dumpfile("dump.vcd");             // VCD file for GTKWave waveform viewer
    $dumpvars(1, dual_port_ram_tb);    // Record variables inside testbench for waveform
    clock = 1'b1;                      // Initialize clock to 1
    forever #5 clock = ~clock;        // Toggle clock every 5ns (creates square wave)
  end

  // Test sequence for reading and writing
  initial begin
    // Time = 0ns
    // Both ports write to different addresses
    data_a = 8'h33; addr_a = 6'h01;    // Port A writes 0x33 to address 1
    data_b = 8'h44; addr_b = 6'h02;    // Port B writes 0x44 to address 2
    we_a = 1'b1; we_b = 1'b1;          // Both ports enabled for write
    #10;                               // Wait 10ns (1 clock cycle)

    // Time = 10ns
    // Port A writes again, Port B reads address previously written by A
    data_a = 8'h55; addr_a = 6'h03;    // Port A writes 0x55 to address 3
    addr_b = 6'h01; we_b = 1'b0;       // Port B reads from address 1 (expect 0x33)
    #10;

    // Time = 20ns
    // Both ports read from each other’s previous write addresses
    addr_a = 6'h02; we_a = 1'b0;       // Port A reads from address 2 (expect 0x44)
    addr_b = 6'h03;                    // Port B reads from address 3 (expect 0x55)
    #10;

    // Time = 30ns
    // Port A reads from original write; Port B writes new data
    addr_a = 6'h01;                    // Port A reads from address 1 (expect 0x33)
    data_b = 8'h77; addr_b = 6'h02;    // Port B writes 0x77 to address 2
    we_b = 1'b1;                       // Enable Port B for write
    #10;
  end

  // Stop simulation after 40ns
  initial
    #40 $stop;

endmodule
