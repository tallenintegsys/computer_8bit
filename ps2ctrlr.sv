`timescale 10ns/10ps
/**************************************
* PS/2 keyboard
*     1 start bit. This is always 0.
*     8 data bits, least significant bit first.
*     1 parity bit (odd parity).
*     1 stop bit. This is always 1.
**************************************/
module ps2ctrlr (
    input                   clock,
    output  logic [7:0]     kbd,
    output  logic [7:0]     kbd_strb,
    output  logic           res,
    input                   kbd_clr,
    input                   ps2_dat_in,
    input                   ps2_clk_in);

typedef enum logic {KEYING, UNKEYING} keystate;
logic [16-1:0]  dat_buffer;
logic [16-1:0]  clk_buffer;
logic [3:0]     buffer_count;
logic           ps2_clk;
logic           ps2_dat;
logic [3:0]     kb_count;
logic           shift;
logic           cntrl;
logic           kbs;
logic [7:0]     kb_dat;
keystate        state;

initial begin
    dat_buffer      = 16'd0;
    clk_buffer      = 16'd0;
    buffer_count    = 4'd0;
    ps2_clk         = 0;
    ps2_dat         = 0;
    kb_count        = 4'hf;
    kb_dat          = 8'd0;
    shift           = 0;
    cntrl           = 0;
    kbd             = 0;
    state           = KEYING;
    res             = 1;
end

// DSP denoisify the PS2 clk and dat lines
always @ (posedge clock) begin
    buffer_count++;
    clk_buffer[buffer_count] = ps2_clk_in;
    dat_buffer[buffer_count] = ps2_dat_in;
    if (clk_buffer == 16'hffff)
        ps2_clk = 1;
    else if (clk_buffer == 16'h0000)
        ps2_clk = 0;
    else
        ; // do nothing (ignore noise)
    if (dat_buffer == 16'hffff)
        ps2_dat = 1;
    else if (dat_buffer == 16'h0000)
        ps2_dat = 0;
    else
        ; // do nothing (ignore noise)
end //always

// use the denoisified clk & dat
always @ (posedge ps2_clk, posedge kbd_clr) begin
    if (kbd_clr) begin
        kbd[7] <= 0; //the MSB is the strobe so clear it
    end else begin
        kb_count <= kb_count + 4'd1;
        case (kb_count)
            0: ; // start
            1: kb_dat[0] <= ps2_dat;
            2: kb_dat[1] <= ps2_dat;
            3: kb_dat[2] <= ps2_dat;
            4: kb_dat[3] <= ps2_dat;
            5: kb_dat[4] <= ps2_dat;
            6: kb_dat[5] <= ps2_dat;
            7: kb_dat[6] <= ps2_dat;
            8: kb_dat[7] <= ps2_dat;
            9: ; // XXX maybe actually check the parity
            default: begin //stop
    			kb_count <= 4'h0; //get ready for next key
    			if (kb_dat == 8'he1) res <= 0;
                else if (!res) res <= 1;
    			if (kb_dat == 8'hf0) state <= UNKEYING;
                else begin
        			case (state)
                        UNKEYING: begin
                            state <= KEYING;
                            kbd_strb <= 8'h00; // report key-up
                            if (kb_dat == 8'h12 || kb_dat == 8'h59) shift <= 0;
                            if (kb_dat == 8'h14) cntrl <= 0;
                        end // unkeying
                        KEYING:   begin
                            kbd_strb <= 8'h80; // report key down
                			case (kb_dat)
                                8'he0 : ; // extended key, following byte tells which
                                8'h12 : shift <= 1; // Shift (Left)
                                8'h59 : shift <= 1; // Shift (Right)
                                8'h14 : cntrl <= 1; // control
                                default: begin
                                    if (cntrl) begin // control
                                        case (kb_dat)
                                            8'h1e: kbd <= 8'h80; // "2"
                                            8'h36: kbd <= 8'h9e; // "6"
                                            8'h54: kbd <= 9'h9b; // "["
                                            8'h5d: kbd <= 8'h9c; // "\"
                                            8'h4a: kbd <= 8'haf; // "/"
                                            8'h5b: kbd <= 8'h9d; // "]"
                                            8'h1c: kbd <= 8'h81; // "A"
                                            8'h32: kbd <= 8'h82; // "B"
                                            8'h21: kbd <= 8'h83; // "C"
                                            8'h23: kbd <= 8'h84; // "D"
                                            8'h24: kbd <= 8'h85; // "E"
                                            8'h2b: kbd <= 8'h86; // "F"
                                            8'h34: kbd <= 8'h87; // "G"
                                            8'h33: kbd <= 8'h88; // "H"
                                            8'h43: kbd <= 8'h89; // "I"
                                            8'h3b: kbd <= 8'h8a; // "J"
                                            8'h42: kbd <= 8'h8b; // "K"
                                            8'h4b: kbd <= 8'h8c; // "L"
                                            8'h3a: kbd <= 8'h8d; // "M"
                                            8'h31: kbd <= 8'h8e; // "N"
                                            8'h44: kbd <= 8'h8f; // "O"
                                            8'h4d: kbd <= 8'h90; // "P"
                                            8'h15: kbd <= 8'h91; // "Q"
                                            8'h2d: kbd <= 8'h92; // "R"
                                            8'h1b: kbd <= 8'h93; // "S"
                                            8'h2c: kbd <= 8'h94; // "T"
                                            8'h3c: kbd <= 8'h95; // "U"
                                            8'h2a: kbd <= 8'h96; // "V"
                                            8'h1d: kbd <= 8'h97; // "W"
                                            8'h22: kbd <= 8'h98; // "X"
                                            8'h35: kbd <= 8'h99; // "Y"
                                            8'h1a: kbd <= 8'h9a; // "Z"
                                            default: ; //no nothing
                                        endcase
                                    end else if (shift) begin // shiftted
                                        case (kb_dat)
                                            8'h52: kbd <= 8'ha2; // """
                                            8'h16: kbd <= 8'ha1; // "!"
                                            8'h1e: kbd <= 8'hc0; // "@"
                                            8'h26: kbd <= 8'ha3; // "#"
                                            8'h25: kbd <= 8'ha4; // "$"
                                            8'h2e: kbd <= 8'ha5; // "%"
                                            8'h36: kbd <= 8'hde; // "^"
                                            8'h3d: kbd <= 8'ha6; // "&"
                                            8'h46: kbd <= 8'ha8; // "("
                                            8'h45: kbd <= 8'ha9; // ")"
                                            8'h3e: kbd <= 8'haa; // "*"
                                            8'h55: kbd <= 8'hab; // "+"
                                            8'h41: kbd <= 8'hbc; // "<"
                                            8'h49: kbd <= 8'hbe; // ">"
                                            8'h4a: kbd <= 8'hbf; // "?"
                                            8'h4c: kbd <= 8'hba; // ":"
                                            8'h4e: kbd <= 8'hdf; // "_"
                                            8'h54: kbd <= 9'hfb; // "{"
                                            8'h5b: kbd <= 8'hfd; // "}"
                                            8'h5d: kbd <= 8'hfc; // "|"
                                            8'h0e: kbd <= 8'hfe; // "~"
                                            8'h1c: kbd <= 8'he1; // "A"
                                            8'h32: kbd <= 8'he2; // "B"
                                            8'h21: kbd <= 8'he3; // "C"
                                            8'h23: kbd <= 8'he4; // "D"
                                            8'h24: kbd <= 8'he5; // "E"
                                            8'h2b: kbd <= 8'he6; // "F"
                                            8'h34: kbd <= 8'he7; // "G"
                                            8'h33: kbd <= 8'he8; // "H"
                                            8'h43: kbd <= 8'he9; // "I"
                                            8'h3b: kbd <= 8'hea; // "J"
                                            8'h42: kbd <= 8'heb; // "K"
                                            8'h4b: kbd <= 8'hec; // "L"
                                            8'h3a: kbd <= 8'hed; // "M"
                                            8'h31: kbd <= 8'hee; // "N"
                                            8'h44: kbd <= 8'hef; // "O"
                                            8'h4d: kbd <= 8'hf0; // "P"
                                            8'h15: kbd <= 8'hf1; // "Q"
                                            8'h2d: kbd <= 8'hf2; // "R"
                                            8'h1b: kbd <= 8'hf3; // "S"
                                            8'h2c: kbd <= 8'hf4; // "T"
                                            8'h3c: kbd <= 8'hf5; // "U"
                                            8'h2a: kbd <= 8'hf6; // "V"
                                            8'h1d: kbd <= 8'hf7; // "W"
                                            8'h22: kbd <= 8'hf8; // "X"
                                            8'h35: kbd <= 8'hf9; // "Y"
                                            8'h1a: kbd <= 8'hfa; // "Z"
                                            default: ; //no nothing
                                        endcase
                                    end else begin // unshifted
                                        case (kb_dat)
                                            8'h0e: kbd <= 8'he0; // "`"
                                            8'h52: kbd <= 8'ha7; // "'"
                                            8'h55: kbd <= 8'hbd; // "="
                                            8'h4c: kbd <= 8'hbb; // ";"
                                            8'h41: kbd <= 8'hac; // ","
                                            8'h4e: kbd <= 8'had; // "-"
                                            8'h49: kbd <= 8'hae; // "."
                                            8'h54: kbd <= 9'hdb; // "["
                                            8'h5b: kbd <= 8'hdd; // "]"
                                            8'h5d: kbd <= 8'hdc; // "\"
                                            8'h4a: kbd <= 8'haf; // "/"
                                            8'h45: kbd <= 8'hb0; // "0"
                                            8'h16: kbd <= 8'hb1; // "1"
                                            8'h1e: kbd <= 8'hb2; // "2"
                                            8'h26: kbd <= 8'hb3; // "3"
                                            8'h25: kbd <= 8'hb4; // "4"
                                            8'h2e: kbd <= 8'hb5; // "5"
                                            8'h36: kbd <= 8'hb6; // "6"
                                            8'h3d: kbd <= 8'hb7; // "7"
                                            8'h3e: kbd <= 8'hb8; // "8"
                                            8'h46: kbd <= 8'hb9; // "9"
                                            8'h1c: kbd <= 8'hc1; // "A"
                                            8'h32: kbd <= 8'hc2; // "B"
                                            8'h21: kbd <= 8'hc3; // "C"
                                            8'h23: kbd <= 8'hc4; // "D"
                                            8'h24: kbd <= 8'hc5; // "E"
                                            8'h2b: kbd <= 8'hc6; // "F"
                                            8'h34: kbd <= 8'hc7; // "G"
                                            8'h33: kbd <= 8'hc8; // "H"
                                            8'h43: kbd <= 8'hc9; // "I"
                                            8'h3b: kbd <= 8'hca; // "J"
                                            8'h42: kbd <= 8'hcb; // "K"
                                            8'h4b: kbd <= 8'hcc; // "L"
                                            8'h3a: kbd <= 8'hcd; // "M"
                                            8'h31: kbd <= 8'hce; // "N"
                                            8'h44: kbd <= 8'hcf; // "O"
                                            8'h4d: kbd <= 8'hd0; // "P"
                                            8'h15: kbd <= 8'hd1; // "Q"
                                            8'h2d: kbd <= 8'hd2; // "R"
                                            8'h1b: kbd <= 8'hd3; // "S"
                                            8'h2c: kbd <= 8'hd4; // "T"
                                            8'h3c: kbd <= 8'hd5; // "U"
                                            8'h2a: kbd <= 8'hd6; // "V"
                                            8'h1d: kbd <= 8'hd7; // "W"
                                            8'h22: kbd <= 8'hd8; // "X"
                                            8'h35: kbd <= 8'hd9; // "Y"
                                            8'h1a: kbd <= 8'hda; // "Z"
                                            8'h29: kbd <= 8'ha0; // Spacebar
                                            //E06B: kbd <= 8'h95; // Left Arrow
                                            //E074: kbd <= 8'h88; // Right Arrow
                                            //8'h58: kbd <= 8'h; // Caps Lock
                                            //8'h14: kbd <= 8'h; // Ctrl (left)
                                            8'h5a: kbd <= 8'h8d; // Enter
                                            8'h76: kbd <= 8'h9b; // ESC
                                            //E014: kbd <= 8'h; // Ctrl (right)
                                            //E075: kbd <= 8'h; // Up Arrow
                                            //E072: kbd <= 8'h; // Down Arrow
                                            default: ; //no nothing
                                        endcase
                                    end // else unshifted
                                end // default
                            endcase // case(kb_dat)
                        end // keying
                        default:  begin
                            state <= KEYING;
                        end // default
                    endcase // state
                end
            end // default
        endcase // kb_count
    end // else kbd_clr
end //always


endmodule

