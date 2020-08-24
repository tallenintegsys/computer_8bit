`timescale 10ns/10ps
module computer_8bit_tb;

    // Input Ports
    reg     CLOCK_50;
    reg     [3:0]KEY;
    reg     PS2_CLK;
    reg     PS2_DAT;

    // Output Ports
    wire    [17:0]LEDR;
    wire    [8:0]LEDG;
    wire    [7:0]LCD_DATA;
    wire    LCD_RW;
    wire    LCD_RS;
    wire    LCD_EN;
    wire    LCD_ON;
    wire    LCD_BLON;
    wire    [7:0]VGA_B;
    wire    VGA_BLANK_N;    // to D2A chip, active low
    wire    VGA_CLK;        // latch the RGBs and put 'em on the DACs
    wire    [7:0]VGA_G;
    wire    VGA_HS;         // DB19 pin, active low
    wire    [7:0]VGA_R;
    wire    VGA_SYNC_N;     // to D2A chip, active low
    wire    VGA_VS;         // DB19 pin, active low

initial begin
    $dumpfile("computer_8bit.vcd");
    $dumpvars(0, uut);
    //$dumpoff;
    #0
    CLOCK_50 = 0;
    KEY[0] = 1;
    KEY[1] = 1;
    KEY[2] = 1;
    KEY[3] = 1;
    #5
    KEY[0] = 0;
    #30
    KEY[0] = 1;
    //#500000
    // $dumpon;
    #5000
    $finish;
end

always begin
    #1
    CLOCK_50 = !CLOCK_50;
end

computer_8bit uut (
    .CLOCK_50,
    .PS2_CLK,
    .PS2_DAT,
    .KEY,
    .LEDR,
    .LEDG,
    .VGA_B,
    .VGA_BLANK_N,
    .VGA_CLK,
    .VGA_G,
    .VGA_HS,
    .VGA_R,
    .VGA_SYNC_N,
    .VGA_VS);
endmodule
