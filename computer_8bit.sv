module computer_8bit
/*#(
// Parameter Declarations
parameter <param_name> = <default_value>,
	parameter [<msb>:<lsb>] <param_name> = <default_value>,
	parameter signed [<msb>:<lsb>] <param_name> = <default_value>
	...
)*/

(
	// Input Ports
	input	CLOCK_50,
	input	[3:0]KEY,

	// Output Ports
	output	[17:0]LEDR,
	output	[8:0]LEDG
);

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
int	counter;

single_port_rom rom(ab, phi, rw, dbi);

chip_6502 cpu (
	CLOCK_50,    // FPGA clock
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

// The left-hand side of a continuous assignment must be a structural
// net expression.  That is, it must be a net or a concatentation of
// nets, and any index expressions must be constant.

assign	LEDR[15:0] = ab;
assign	LEDG[7:0] = dbo;
assign	res = !KEY[0];

initial begin
	#0
	phi = 1;
	so = 1;
	rdy = 1;
	nmi = 1;
	irq = 1;

	counter = 0;
end

// Module Item(s)
always@(posedge CLOCK_50)
begin
	counter++;
	if (counter == 100) begin
		counter = 0;
		phi = ~phi;
	end
end

endmodule

