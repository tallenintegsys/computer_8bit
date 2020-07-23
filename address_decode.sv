module address_decode
(	input [15:0]cpu_adr,
	output reg [15:0]mem_adr,
	input [15:0]vid_adr,
	output reg [7:0]cpu_dbi,
	input [7:0]ram_dbo,
	input [7:0]rom_dbo,
	input logic cpu_phi,
	input logic vid_phi,
	input logic mem_phi);

bit cnt;

always @(posedge mem_phi) begin
	cnt = ~cnt;
	if (cnt) begin
	if (cpu_adr < (16'hffff - 20479)) begin
		cpu_dbi <= ram_dbo;
	end else begin
		cpu_dbi <= rom_dbo;
	end
end

	if (cpu_phi)
		mem_adr <= vid_adr;
	else
		mem_adr <= cpu_adr;
end

endmodule
