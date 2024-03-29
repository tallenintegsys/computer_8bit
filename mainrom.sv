`timescale 10ns/10ps
// Quartus Prime Verilog Template
// Single Port ROM

module mainrom
#(parameter DATA_WIDTH=8, parameter ADDR_WIDTH=16)
(
	input [(ADDR_WIDTH-1):0] addr,
	input clk, ce,
	output reg [(DATA_WIDTH-1):0] q
);

	// Declare the ROM variable
	reg [DATA_WIDTH-1:0] rom[2**ADDR_WIDTH-1:0];
	int File, dk;

	// Initialize the ROM with $readmemb.  Put the memory contents
	// in the file single_port_rom_init.txt.  Without this file,
	// this design will not compile.

	// See Verilog LRM 1364-2001 Section 17.2.8 for details on the
	// format of this file, or see the "Using $readmemb and $readmemh"
	// template later in this section.

	initial
	begin
		//$readmemh("AppleII.txt", rom, 16'hffff - 20479, 16'hffff);
		$readmemh("AppleII.txt", rom, 16'hd000, 16'hffff);
		//$readmemh("AppleIIe.txt", rom, 16'hffff - 32767, 16'hffff);
		//$readmemh("AppleIIeEnh.txt", rom, 16'hffff - 12287, 16'hffff);
	end

	always @ (posedge clk) begin
		if (!ce) begin
			q = 8'hz;
		end else begin
			q = rom[addr];
		end
	end
endmodule

