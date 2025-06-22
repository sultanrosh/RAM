module singleRam(
  input [7:0] data,       // 8-bit input: the value to be written into RAM during a write
  input [5:0] addr,       // 6-bit input: selects which of the 64 RAM locations to access
  input clock,            // Clock signal: operations happen on the rising edge
  input we,               // Write Enable: 1 = write to RAM, 0 = prepare to read
  output reg [7:0] q      // 8-bit output: delivers the data read from RAM
);

// Declare a memory array named 'ram':
//  - 64 locations (from index 0 to 63)
//  - Each location holds 8 bits
reg [7:0] ram [63:0];

// Register to hold the address during a read operation
//  - Since reads are delayed by 1 clock cycle, this saves the address until next cycle
reg [5:0] addr_reg;

// This always block executes on the **rising edge** of the clock.
// It handles both **write** and **read** operations based on the `we` signal.
always @(posedge clock) begin
  if (we) begin
    // Write Operation:
    // If write-enable is high (we == 1),
    // store the input data into the RAM at the specified address.
    // This does **not** read anything, just saves the value in RAM.
    ram[addr] <= data;  // "Store this data at this RAM address"
  end else begin
    // Read Operation:
    // If write-enable is low (we == 0),
    // capture the current address so it can be used to fetch data next cycle.
    addr_reg <= addr;   // Save the address to read from next cycle

    // Output Operation:
    // Read the data from the RAM at the previously saved address
    // and assign it to output `q`. This introduces a 1-cycle read delay.
    q <= ram[addr_reg];  // "Retrieve data from saved address and send it to output"
  end
end

endmodule
