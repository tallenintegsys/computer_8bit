// Quartus Prime Verilog Template
// Single Port ROM

module single_port_rom
#(parameter DATA_WIDTH=8, parameter ADDR_WIDTH=16)
(
	input [(ADDR_WIDTH-1):0] addr,
	input clk, ce,
	output reg [(DATA_WIDTH-1):0] q
);

	initial
	begin
		q <= 8'hzz;
	end

	always @ (posedge clk)
	begin
		case (addr)
			`include "rom_bin.v"
		default: q <= 8'hea;
		endcase
	end

endmodule

