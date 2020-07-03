module computer_8bit_tb;

	// Input Ports
	reg	CLOCK_50;
	reg 	[3:0]KEY;

	// Output Ports
	wire	[17:0]LEDR;
	wire	[8:0]LEDG;
	wire	[7:0]LCD_DATA;
	wire	LCD_RW;
	wire	LCD_RS;
	wire	LCD_EN;
	wire	LCD_ON;
	wire	LCD_BLON;

initial begin
	$dumpfile("computer_8bit.vcd");
	$dumpvars(0, uut);
	#0
	CLOCK_50 = 0;
	KEY[0] = 0;
	KEY[1] = 0;
	KEY[2] = 0;
	KEY[3] = 0;
	#1000
	KEY[0] = 1;
	#1000
	KEY[0] = 0;
	#50000 $finish;
end

always begin
	#1
	CLOCK_50 = !CLOCK_50;
end

computer_8bit uut (
	CLOCK_50,
	KEY,
	LEDR,
	LEDG);

endmodule