module singleRam(
  input [7:0] data,       // 8-bit data input line (to write into RAM)
  input [5:0] addr,       // 6-bit address input (64 addresses → 2^6 = 64)
  input clock,            // Clock signal, drives sequential logic
  input we,               // Write Enable signal (1 = write, 0 = read)
  output [7:0] q          // 8-bit data output line (to read from RAM)
);

  // Memory declaration: 64 locations of 8-bit wide registers
  reg [7:0] ram [63:0];

  // Register to hold the address for reading
  reg [5:0] addr_reg;

  // Always block triggered on the rising edge of the clock
  always @(posedge clock) begin
    if (we)
      ram[addr] <= data;        // Write 'data' into RAM at 'addr' when write-enable is high
    else
      addr_reg <= addr;         // On read, capture the address into addr_reg (not data!)
  end

  // Continuous assignment: output 'q' is driven by data at addr_reg
  assign q = ram[addr_reg];

endmodule
