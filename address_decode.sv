`timescale 10ns/10ps

module address_decode (
    input  wire     [15:0] cpu_adr,
    output reg      [7:0] cpu_dbi,
    input  wire     [7:0] kbd,
    input  wire     [7:0] kbd_strb,
    output reg      kbd_clr,
    input  wire     [7:0] ram_dbo,
    input  wire     [7:0] rom_dbo,
    input  wire     phi);

always @(posedge phi) begin
    if (kbd_clr == 1) kbd_clr <= 0; // clear it if it's set
    if (cpu_adr < (16'hffff - 20479)) begin
        cpu_dbi <= ram_dbo; // ROM
    end else if (cpu_adr[15:4] == 12'hc00) begin
        cpu_dbi <= kbd; // keyboard data and strobe
    end else if (cpu_adr[15:4] == 12'hc01) begin
        cpu_dbi <= kbd_strb; // any-key-down flag and clear-strobe switch
        kbd_clr <= 1; // tell the kbdctrlr to clear the strobe
    end else begin
        cpu_dbi <= rom_dbo; // RAM
    end
end

endmodule
