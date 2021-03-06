`timescale 10ns/10ps
module address_decode
(	input           [15:0]cpu_adr,
	output reg      [7:0]cpu_dbi,
    input           [7:0] kbd_dbo,
    output logic    kbd_clr,
	input           [7:0]ram_dbo,
	input           [7:0]rom_dbo,
	input           phi);

always @(posedge phi) begin
    if (kbd_clr == 1) kbd_clr = 0;
	    if (cpu_adr < (16'hffff - 20479)) begin
		    cpu_dbi <= ram_dbo; // ROM
	    end else if (cpu_adr[15:4] == 12'hc00) begin
            cpu_dbi <= kbd_dbo; // read keyboard
        end else if (cpu_adr[15:4] == 12'hc01) begin
            cpu_dbi <= 8'h00; // no sure what to return here
            kbd_clr <= 1; // clear the keyboard strobe
        end else begin
		    cpu_dbi <= rom_dbo; // RAM
	    end
end

endmodule
