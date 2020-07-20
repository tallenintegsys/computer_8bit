module computer_8bit
(
	// Input Ports
	input	CLOCK_50,
	input	[3:0]KEY,

	// Output Ports
	output	[17:0]LEDR,
	output	[8:0]LEDG
);

reg cpu_phi;
reg mem_phi;
reg vid_phi;
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
wire [7:0]ram_dbo;
wire [7:0]rom_dbo;

clock_divider c_div(CLOCK_50, cpu_phi, mem_phi, vid_phi);

address_decode ad(cpu_adr, cpu_dbi, ram_dbo, rom_dbo, ram_ce, rom_ce);

single_port_rom rom(cpu_adr, mem_phi, rom_ce, rom_dbo);

single_port_ram ram(cpu_dbo, cpu_adr, mem_phi, rw, ram_dbo);

chip_6502 cpu (
	CLOCK_50,    // FPGA clock
	cpu_phi,    // 6502 clock
	res,
	so,
	rdy,
	nmi,
	irq,
	cpu_dbi,	// cpu data bus in
	cpu_dbo,	// cpu data bus out
	rw,
	sync,
	cpu_adr);	// cpu address bus

// The left-hand side of a continuous assignment must be a structural
// net expression.  That is, it must be a net or a concatentation of
// nets, and any index expressions must be constant.

assign	LEDR[15:0] = cpu_adr;
assign	LEDG[7:0] = cpu_dbo;
assign	res = !KEY[0];

initial begin
	#0
	so = 1;
	rdy = 1;
	nmi = 1;
	irq = 1;
end

// Module Item(s)

endmodule

