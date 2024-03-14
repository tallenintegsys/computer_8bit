`timescale 10ns/10ps
module computer_8bit ( 
    input           clock_50,
    input           [3:0]key,
    output logic    [17:0]ledr,
    output logic    [8:0]ledg,
    input           ps2_dat,
    input           ps2_clk,
    output logic    [7:0]vga_b,
    output logic    vga_blank_n,    // to D2A chip, active low
    output logic    vga_clk,        // latch the RGBs and put 'em on the DACs
    output logic    [7:0]vga_g,
    output logic    vga_hs,         // DB19 pin, active low
    output logic    [7:0]vga_r,
    output logic    vga_sync_n,     // to D2A chip, active low
    output logic    vga_vs);        // DB19 pin, active low

wire  cpu_phi;
wire  mem_phi;
wire  vid_phi;
reg   res;
reg   so;
reg   rdy;
reg   nmi;
reg   irq;
reg   [7:0]cpu_dbi;
wire  [7:0]cpu_dbo;
wire  rw;
wire  sync;
wire  [15:0]cpu_adr;
wire  [15:0]vid_adr;
wire  [7:0]vid_dbi;
wire  [7:0]ram_dbo;
wire  [7:0]rom_dbo;
reg   [22:0] count;
logic heartbeat;
logic [7:0] kbd;
logic [7:0] kbd_strb;
logic kbd_clr;

clock_divider clock_divider (
    .clock_50,
    .cpu_phi,
    .mem_phi,
    .vid_phi);

address_decode address_decode (
    .kbd        (kbd),
    .kbd_strb   (kbd_strb),
    .kbd_clr    (kbd_clr),
    .cpu_adr,
    .cpu_dbi,
    .ram_dbo,
    .rom_dbo,
    .phi        (mem_phi));

mainrom rom (
    .addr   (cpu_adr),
    .clk    (mem_phi),
    .ce     (1'd1),
    .q      (rom_dbo));

ram #(8,16) ram (
    .data_a (cpu_dbo),
    .data_b (8'd0),
    .addr_a (cpu_adr),
    .addr_b (vid_adr),
    .we_a   (rw),
    .we_b   (1'd0),
    .clk_a  (mem_phi),
    .clk_b  (vid_phi),
    .q_a    (ram_dbo),
    .q_b    (vid_dbi));

vdp vdp (
    .clock_50    (clock_50),
    .clk         (vid_phi),
    .vga_b       (vga_b),
    .vga_blank_n (vga_blank_n),    // to D2A chip, active low
    .vga_clk     (vga_clk),        // latch the RGBs and put 'em on the DACs
    .vga_g       (vga_g),
    .vga_hs      (vga_hs),         // DB19 pin, active low
    .vga_r       (vga_r),
    .vga_sync_n  (vga_sync_n),     // to D2A chip, active low
    .vga_vs      (vga_vs),         // DB19 pin, active low
    .txt_adr     (vid_adr),
    .txt_q       (vid_dbi),
    .res         (res));

ps2ctrlr ps2ctrlr (
    .clock      (clock_50),
    .ps2_dat_in (ps2_dat),
    .ps2_clk_in (ps2_clk),
    .kbd_clr    (kbd_clr),
    .kbd        (kbd),
    .kbd_strb   (kbd_strb));

chip_6502 cpu (
    .clk    (clock_50),    // FPGA clock
    .phi    (cpu_phi),    // 6502 clock
    .res    (res),
    .so     (so),
    .rdy    (rdy),
    .nmi    (nmi),
    .irq    (irq),
    .dbi    (cpu_dbi),	// cpu data bus in
    .dbo    (cpu_dbo),	// cpu data bus out
    .rw     (rw),
    .sync   (sync),
    .ab     (cpu_adr));	// cpu address bus

// The left-hand side of a continuous assignment must be a structural
// net expression.  That is, it must be a net or a concatentation of
// nets, and any index expressions must be constant.

assign ledr[15:0]   = cpu_adr;
assign res          = key[0]; //normaly high
assign ledg[7:0]    = kbd[7:0];
assign ledg[8]      = heartbeat;

// Module Item(s)
always @ (posedge clock_50) begin
    if (!res) begin
        heartbeat <= 0;
    end else begin
        so  = 1;
        rdy = 1;
        nmi = 1;
        irq = 1;
        count++;
        if (count == 0) begin
            heartbeat <= !heartbeat;
        end
    end
end //always

endmodule
