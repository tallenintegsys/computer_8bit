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
	input [3:0]KEY,

	// Output Ports
	output	[17:0]LEDR,
	output	[8:0]LEDG,
	output	[7:0]LCD_DATA,
	output	LCD_RW,
	output	LCD_RS,
	output	LCD_EN,
	output	LCD_ON,
	output	LCD_BLON
);

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

logic	reset;
logic	[3:0]reset_state;
logic	[31:0]counter;
logic	[7:0]i;
logic	[1:0]data_state;
logic	clock;
logic	[0:7][7:0]buffer;
logic	lcd_en;
logic	lcd_rw;
logic	lcd_rs;
logic	lcd_on;
logic	[7:0]lcd_data;
wire	[7:0]data;

single_port_rom rom(i, clock, data);

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
assign	rst = KEY[0];
assign	LCD_EN = lcd_en;
assign 	LCD_RW = lcd_rw;
assign 	LCD_RS = lcd_rs;
assign	LCD_ON = lcd_on;
assign	LCD_DATA = lcd_data;
assign	LCD_BLON = 1'b1;

initial begin
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

	reset = 1;
	reset_state = 0;
	counter = 0;
	i = 0;
	data_state = 0;
	clock = 0;
	buffer = " Coby   ";
	lcd_en = 0;
	lcd_rw = 0;
	lcd_rs = 0;
	lcd_on = 0;
	lcd_data = 0;
end

// Module Item(s)
always@(posedge CLOCK_50)
begin
	counter++;
	if (counter == 5000000) begin
		counter = 0;
		clk = ~clk;
	end
end

endmodule

