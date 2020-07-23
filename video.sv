/*TOP/         MIDDLE/      BOTTOM/      (SCREEN HOLES)
BASE  FIRST 40     SECOND 40    THIRD 40     UNUSED 8
ADDR  #  RANGE     #  RANGE     #  RANGE     RANGE
$400  00 $400-427  08 $428-44F  16 $450-477  $478-47F
$480  01 $480-4A7  09 $4A8-4CF  17 $4D0-4F7  $4F8-4FF
$500  02 $500-527  10 $528-54F  18 $550-577  $578-57F
$580  03 $580-5A7  11 $5A8-5CF  19 $5D0-5F7  $5F8-5FF
$600  04 $600-627  12 $628-64F  20 $650-677  $678-67F
$680  05 $680-6A7  13 $6A8-6CF  21 $6D0-6F7  $6F8-6FF
$700  06 $700-727  14 $728-74F  22 $750-777  $778-77F
$780  07 $780-7A7  15 $7A8-7CF  23 $7D0-7F7  $7F8-7FF */
module video (
output [15:0]vid_adr,
input [7:0]dbi,
input phi);

logic [15:0]adr;
reg [6:0]h;
reg [5:0]v;
reg [7:0]buffer[40*24-1:0];

assign vid_adr = adr;

initial begin
	h <= 0;
	v <= 0;
end

always @ (posedge phi) begin
	h <= h + 7'd1;
	if (h == 7'd39) begin
		h <= 0;
		v <= v + 6'd1;
	end
	if (v == 6'd24) begin
		v <= 0;
	end
	adr <= 16'h400 + h + v[2:0] * 8'h80 + v[4:3] * 8'h28; // theres a better way
end
endmodule
