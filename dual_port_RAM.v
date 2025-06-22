// Declare a module named 'dual_port_ram' which defines a dual-port memory block
module dual_port_ram(

  // Declare 8-bit data input ports for each port (A and B)
  // These carry the values you want to write into the memory
  input [7:0] data_a, data_b,

  // Declare 6-bit address input ports for each port (A and B)
  // 6 bits allows addressing 2^6 = 64 memory locations (0 to 63)
  input [5:0] addr_a, addr_b,

  // Write-enable control inputs for each port (A and B)
  // When 'we_a' is high (1), Port A writes data; when low (0), it reads
  // Same logic applies for Port B with 'we_b'
  input we_a, we_b,

  // Shared clock input for both ports
  // All operations (read or write) are synchronized with the rising edge of this clock
  input clock,

  // 8-bit output ports for each port (A and B)
  // These output the data read from memory when the respective port is not writing
  output reg [7:0] q_a, q_b
);

  // Declare the RAM block as a 2D register array with 64 entries (0 to 63), each 8 bits wide
  // This is the actual physical memory array shared by both ports
  reg [7:0] ram [63:0];

  // Define an always block for Port A, triggered on the rising edge of the clock
  // All read/write behavior for Port A is handled here
  always @(posedge clock) begin

    // If write-enable for Port A is high, perform a write operation
    // 'ram[addr_a]' means write to the memory location given by address 'addr_a'
    // '<=' is a non-blocking assignment, ensuring proper scheduling in synchronous logic
    if (we_a)
      ram[addr_a] <= data_a;

    // Else, if write-enable is low, perform a read operation
    // Assign the value at memory location 'addr_a' to output 'q_a'
    // 'q_a' holds the data being read from memory
    else
      q_a <= ram[addr_a];
  end

  // Define a second always block for Port B, also triggered on the rising edge of the clock
  // This allows Port B to independently read or write at the same time as Port A
  always @(posedge clock) begin

    // If write-enable for Port B is high, perform a write operation
    // Write 'data_b' to memory at location 'addr_b'
    if (we_b)
      ram[addr_b] <= data_b;

    // Else, perform a read operation from 'addr_b' and assign to output 'q_b'
    else
      q_b <= ram[addr_b];
  end

// End of module definition
endmodule
