`timescale 10ns/10ps
module ps2ctrlr (
    input                   clock,
    output  logic [7:0]     kbd,
    output  logic [7:0]     kbd_strb,
    input                   clr,
    input                   ps2_dat_in,
    input                   ps2_clk_in);

logic [16-1:0]      dat_buffer;
logic [16-1:0]      clk_buffer;
logic [3:0]         buffer_count;
logic               ps2_clk, ps2_dat;
logic [3:0]         kb_count;
logic [7:0]         kb_dat;
logic               lift, shift;
logic               kbs;

initial begin
    dat_buffer = 16'd0;
    clk_buffer = 16'd0;
    buffer_count = 4'd0;
    ps2_clk = 0;
    ps2_dat = 0;
    kb_count = 4'hf;
    kb_dat = 8'd0;
    lift = 0;
    shift = 0;
    kbd = 0;
end

// Module Item(s)
always @ (posedge clock) begin
    buffer_count++;
    clk_buffer[buffer_count] = ps2_clk_in;
    dat_buffer[buffer_count] = ps2_dat_in;
    if (clk_buffer == 16'hffff)
        ps2_clk = 1;
    if (clk_buffer == 16'h0000)
        ps2_clk = 0;
    if (dat_buffer == 16'hffff)
        ps2_dat = 1;
    if (dat_buffer == 16'h0000)
        ps2_dat = 0;
end //always

always @ (negedge ps2_clk , posedge clr) begin
    if (clr) begin
        kbd[7] = 0; //the MSB is the strobe so clear it
    end else begin
        kb_count = kb_count + 4'd1;
        case (kb_count)
            0: ; // start
            1: kb_dat[0] = ps2_dat;
            2: kb_dat[1] = ps2_dat;
            3: kb_dat[2] = ps2_dat;
            4: kb_dat[3] = ps2_dat;
            5: kb_dat[4] = ps2_dat;
            6: kb_dat[5] = ps2_dat;
            7: kb_dat[6] = ps2_dat;
            8: kb_dat[7] = ps2_dat;
            9: ; // XXX parity
            default: begin //stop

			kb_count = 4'hf; //get ready for next key
                if (kb_dat == 8'hf0) begin // F0
                    lift = 1; //lift
                end else if (kb_dat == 8'he0) begin
                    shift = 1;
                end else if (lift) begin
                    lift = 0; //lift (break) key
                    case (kb_dat)
                        8'h12: shift = 0; // Shift (Left)
                        8'h59: shift = 0; // Shift (Right)
                        default: ; //no nothing
                    endcase
                end else if (shift) begin // shiftted
                    case (kb_dat)
                        8'h52 : kbd = 8'ha2; // "\"
                        8'h16 : kbd = 8'ha1; // "!"
                        8'h1e : kbd = 8'hc0; // "@"
                        8'h26 : kbd = 8'ha3; // "#"
                        8'h25 : kbd = 8'ha4; // "$"
                        8'h2e : kbd = 8'ha5; // "%"
                        8'h36 : kbd = 8'hde; // "^"
                        8'h3d : kbd = 8'ha6; // "&"
                        8'h46 : kbd = 8'ha8; // "("
                        8'h45 : kbd = 8'ha9; // ")"
                        8'h3e : kbd = 8'haa; // "*"
                        8'h55 : kbd = 8'hab; // "+"
                        8'h41 : kbd = 8'hbc; // "<"
                        8'h49 : kbd = 8'hbe; // ">"
                        8'h4a : kbd = 8'hbf; // "?"
                        8'h4c : kbd = 8'hba; // ":"
                        default: ; //no nothing
                    endcase
                end else begin // unshifted
                    case (kb_dat)
                        8'h52: kbd = 8'ha7; // "'"
                        8'h55: kbd = 8'hbd; // "="
                        8'h4c: kbd = 8'hbb; // ";"
                        8'h41: kbd = 8'hac; // ","
                        8'h4e: kbd = 8'had; // "-"
                        8'h49: kbd = 8'hae; // "."
                        8'h4a: kbd = 8'haf; // "/"
                        8'h45: kbd = 8'hb0; // "0"
                        8'h16: kbd = 8'hb1; // "1"
                        8'h1e: kbd = 8'hb2; // "2"
                        8'h26: kbd = 8'hb3; // "3"
                        8'h25: kbd = 8'hb4; // "4"
                        8'h2e: kbd = 8'hb5; // "5"
                        8'h36: kbd = 8'hb6; // "6"
                        8'h3d: kbd = 8'hb7; // "7"
                        8'h3e: kbd = 8'hb8; // "8"
                        8'h46: kbd = 8'hb9; // "9"
                        8'h1c: kbd = 8'hc1; // "A"
                        8'h32: kbd = 8'hc2; // "B"
                        8'h21: kbd = 8'hc3; // "C"
                        8'h23: kbd = 8'hc4; // "D"
                        8'h24: kbd = 8'hc5; // "E"
                        8'h2b: kbd = 8'hc6; // "F"
                        8'h34: kbd = 8'hc7; // "G"
                        8'h33: kbd = 8'hc8; // "H"
                        8'h43: kbd = 8'hc9; // "I"
                        8'h3b: kbd = 8'hca; // "J"
                        8'h42: kbd = 8'hcb; // "K"
                        8'h4b: kbd = 8'hcc; // "L"
                        8'h3a: kbd = 8'hcd; // "M"
                        8'h31: kbd = 8'hce; // "N"
                        8'h44: kbd = 8'hcf; // "O"
                        8'h4d: kbd = 8'hd0; // "P"
                        8'h15: kbd = 8'hd1; // "Q"
                        8'h2d: kbd = 8'hd2; // "R"
                        8'h1b: kbd = 8'hd3; // "S"
                        8'h2c: kbd = 8'hd4; // "T"
                        8'h3c: kbd = 8'hd5; // "U"
                        8'h2a: kbd = 8'hd6; // "V"
                        8'h1d: kbd = 8'hd7; // "W"
                        8'h22: kbd = 8'hd8; // "X"
                        8'h35: kbd = 8'hd9; // "Y"
                        8'h1a: kbd = 8'hda; // "Z"
                        8'h29: kbd = 8'ha0; // Spacebar
                        //E06B: kbd = 8'h95; // Left Arrow
                        //E074: kbd = 8'h88; // Right Arrow
                        //8'h58: kbd = 8'h; // Caps Lock
                        //8'h14: kbd = 8'h; // Ctrl (left)
                        8'h5a: kbd = 8'h8d; // Enter
                        8'h76: kbd = 8'h9b; // ESC
                        8'h12: shift = 1; // Shift (Left)
                        8'h59: shift = 1; // Shift (Right)
                        //E014: kbd = 8'h; // Ctrl (right)
                        //E075: kbd = 8'h; // Up Arrow
                        //E072: kbd = 8'h; // Down Arrow
                        default: ; //no nothing
                    endcase
                end
            end
        endcase
    end
end //always
endmodule

