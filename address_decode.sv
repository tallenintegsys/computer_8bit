`timescale 10ns/10ps
module address_decode
(	input [15:0]cpu_adr,
	output reg [7:0]cpu_dbi,
	input [7:0]ram_dbo,
	input [7:0]rom_dbo,
	input phi);

bit cnt;

always @(posedge phi) begin
	cnt = ~cnt;
	if (cnt) begin
	    if (cpu_adr < (16'hffff - 20479)) begin
		    cpu_dbi <= ram_dbo;
	    end else begin
		    cpu_dbi <= rom_dbo;
	    end
    end
end

endmodule
