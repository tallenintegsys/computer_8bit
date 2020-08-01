module computer_8bit
(
	// Input Ports
	input	CLOCK_50,
	input	[3:0]KEY,

	// Output Ports
	output	logic [17:0]LEDR,
	output	reg [8:0]LEDG
);

wire cpu_phi;
wire mem_phi;
wire vid_phi;
reg res;
reg so;
reg rdy;
reg nmi;
reg irq;
reg [7:0]cpu_dbi;
wire [7:0]cpu_dbo;
wire rw;
wire sync;
wire [15:0]cpu_adr;
wire [15:0]mem_adr;
wire [15:0]vid_adr;
wire [7:0]ram_dbo;
wire [7:0]rom_dbo;
reg [22:0] count;

clock_divider clock_divider (
    .CLOCK_50,
    .cpu_phi,
    .mem_phi,
    .vid_phi);

address_decode address_decode (
    .cpu_adr,
    .mem_adr,
    .vid_adr,
    .cpu_dbi,
    .ram_dbo,
    .rom_dbo,
    .cpu_phi,
    .vid_phi,
    .mem_phi);

single_port_rom rom (
    .addr (mem_adr),
    .clk (mem_phi),
    .ce (1'd1),
    .q (rom_dbo));

single_port_ram ram (
    .data (cpu_dbo),
    .addr (mem_adr),
    .clk (mem_phi),
    .we (rw),
    .q (ram_dbo));

//video vid(vid_adr, cpu_dbi, vid_phi);

chip_6502 cpu (
	.clk    (CLOCK_50),    // FPGA clock
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
	.ab    (cpu_adr));	// cpu address bus

// The left-hand side of a continuous assignment must be a structural
// net expression.  That is, it must be a net or a concatentation of
// nets, and any index expressions must be constant.

assign	LEDR[15:0] = cpu_adr;
assign	res = KEY[0]; //normaly high

// Module Item(s)
always @ (posedge CLOCK_50) begin
    if (res) begin
        so = 1;
        rdy = 1;
        nmi = 1;
        irq = 1;
        count++;
        if (count == 0)
            LEDG[8] <= !LEDG[8];
    end

    if (KEY[1]) begin
        LEDG[8] <= 0;
    end

	LEDG[7:0] <= cpu_dbo[7:0];
end
endmodule

