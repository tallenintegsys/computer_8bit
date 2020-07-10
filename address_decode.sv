module address_decode
(
	input [15:0]addr,	
	output logic [7:0]dbi,
	input [7:0]ram_dbi,
	input [7:0]rom_dbi,
	output logic ram_ce,
	output logic rom_ce
);

always @(*) begin
	if (addr < (16'hffff - 20479)) begin
		ram_ce <= 1;
		rom_ce <= 0;
		dbi <= ram_dbi;
	end else begin
		ram_ce <= 0;
		rom_ce <= 1;
		dbi <= rom_dbi;
	end
end
endmodule
