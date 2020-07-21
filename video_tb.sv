module video_tb;


reg [15:0]vid_adr;
reg phi;
reg [7:0]vid_dbi;
reg [7:0]txt[15:0];

initial begin
	$dumpfile("video.vcd");
	$dumpvars(0, uut);
	//$dumpoff;
	#0
	phi <= 0;
	//$dumpon;
	#50000
	$finish;

end

always begin
	#1
	phi <= ~phi;
	vid_dbi <= txt[vid_adr];
end

video uut(vid_adr, vid_dbi, phi);
endmodule
