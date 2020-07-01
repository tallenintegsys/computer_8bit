// Quartus Prime Verilog Template
// Single Port ROM

module single_port_rom
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
		File = $fopen("rom.bin", "rb");
		dk = $fread(rom, File, 16'hffff - 20479);
		q <= 8'hzz;
	end

	always @ (posedge clk)
	begin
		if (!ce) begin
			q <= 8'hzz;
		end else begin
			q <= rom[addr];
		end
	end

endmodule

