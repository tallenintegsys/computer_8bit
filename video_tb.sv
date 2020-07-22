module video_tb;

reg [15:0]vid_adr;
reg phi;
reg [7:0]vid_dbi;
reg [7:0]txt[16'hffff:0];

initial begin
	$dumpfile("video.vcd");
	$dumpvars(0, uut);
	//$dumpoff;
	#0
	phi <= 0;
	//$dumpon;
	#10000
	$writememh("txtBuf.txt", txt, 16'h400, 16'h7ff);
	$finish;

end

always begin
	#1
	phi <= ~phi;
	vid_dbi <= txt[vid_adr];
end

video uut(vid_adr, vid_dbi, phi);
endmodule
