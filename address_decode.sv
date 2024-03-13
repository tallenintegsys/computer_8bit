`timescale 10ns/10ps

module address_decode (
    input  wire     [15:0] cpu_adr,
    output reg      [7:0] cpu_dbi,
    input  wire     [7:0] KBD,
    input  wire     [7:0] KBDSTRB,
    output reg      KBDCLR,
    input  wire     [7:0] ram_dbo,
    input  wire     [7:0] rom_dbo,
    input  wire     phi);

always @(posedge phi) begin
    if (KBDCLR == 1) KBDCLR <= 0;
        if (cpu_adr < (16'hffff - 20479)) begin
            cpu_dbi <= ram_dbo; // ROM
        end else if (cpu_adr[15:4] == 12'hc00) begin
            cpu_dbi <= KBD; // keyboard data and strobe
        end else if (cpu_adr[15:4] == 12'hc01) begin
            cpu_dbi <= KBDSTRB; // any-key-down flag and clear-strobe switch
            KBDCLR <= 1; // clear the keyboard strobe
        end else begin
        cpu_dbi <= rom_dbo; // RAM
    end
end

endmodule
