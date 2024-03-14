`timescale 10ns/10ps

module vga (
    input clock_50,
    input [23:0] d,
    output logic [15:0] adr,
    output logic [7:0]vga_b,
    output logic vga_blank_n, // to D2A chip, active low
    output logic vga_clk, // latch the RGBs and put 'em on the DACs
    output logic [7:0]vga_g,
    output logic vga_hs, // DB19 pin, active low
    output logic [7:0]vga_r,
    output logic vga_sync_n, // to D2A chip, active low
    output logic vga_vs); // DB19 pin, active low

logic [9:0] h_counter; //visible + blanking
logic [9:0] v_counter; //visible + blanking
logic h_blank, v_blank;
logic v_advance;
logic reset;
logic [3:0]reset_counter;

//640x480, 60Hz 25.175  640 16  96  48  480 11  2   31

assign vga_blank_n = h_blank & v_blank;
initial reset = 0;
initial reset_counter = 0;
initial vga_clk = 0;

always @ (posedge clock_50) begin
    reset_counter++;
    if (reset_counter == 4'd5)
        reset <= 1;
    vga_clk <= ~vga_clk; //25MHz
end

always @ (posedge vga_clk) begin
if (reset == 0) begin //active low reset
    h_counter <= 0;
    v_counter <= 0;
    vga_hs <= 1'd1;
    vga_vs <= 1'd1;
    vga_sync_n <= 0; //no sync on green
    h_blank <= 0;
    v_blank <= 0;
    adr <= 0;
    v_advance <= 0;
end else begin
    h_counter <= h_counter + 10'd1;
    case (h_counter)
    000: h_blank <= 0; //blank
    039: h_blank <= 1; //unblank
    599: h_blank <= 0; //blank
    639: h_blank <= 0; //hfront porch start
    655: begin //hfront porch end
        vga_hs <= 0; //hsync start
        v_advance <= ~v_advance;
        if (!v_counter[0] && v_blank)
            adr <= adr - 16'd280; //redo the line (line double)
    end
    751: vga_hs <= 1'd1; //hback porch start
    800: begin //hback porch end
        h_counter <= 0;
        v_counter <= v_counter + 1;
    end
    endcase

    if ((h_blank & v_blank))
        if (!h_counter[0])
            adr <= adr + 1'd1;

    case (v_counter)
    000: v_blank <= 0; //blank
    048: v_blank <= 1; //unblank
    432: v_blank <= 0; //blank
    480: begin //vfront porch start
        v_blank <= 0; //disable RGB DACs
        adr <= 0;
    end
    491: vga_vs <= 0; //vfront porch end//vsync start
    493: vga_vs <= 1'd1; //vsync pulse end//vsync end
    524: begin //vback porch end
        v_blank <= 1'd1; //enable RGB DACs
        v_counter <= 0;
        v_advance <= 0;
    end
    endcase

    vga_r <= d[23:16];
    vga_g <= d[15:8];
    vga_b <= d[7:0];
end //if reset
end //always
endmodule
