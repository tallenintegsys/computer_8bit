
module chip_6502_tb;

reg	clk;
reg	phi;
reg	res;
reg	so;
reg	rdy;
reg	nmi;
reg	irq;
reg	[7:0]dbi;
wire	[7:0]dbo;
wire	rw;
wire	sync;
wire	[15:0]ab;

initial begin
	$dumpfile("chip_6502.vcd");
	$dumpvars(0, uut);
	#0
	clk = 0;
	phi = 0;
	res = 0;
	so = 1;
	rdy = 1;
	nmi = 1;
	irq = 1;
	dbi = 8'hea;
	#100	res = 1;
	#5	res = 0;
	#5	res = 1;
	#500 $finish;
end

always begin
	#1	clk = !clk;
end

always begin
	#10	phi = !phi;
end

chip_6502 uut (
	clk,    // FPGA clock
	phi,    // 6502 clock
	res,
	so,
	rdy,
	nmi,
	irq,
	dbi,
	dbo,
	rw,
	sync,
	ab);

endmodule
