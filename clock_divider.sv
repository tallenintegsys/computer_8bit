module clock_divider
(
	input CLOCK_50,
	output reg cpu_phi,
	output reg mem_phi,
	output reg vid_phi
);

int counter;

initial
begin
	cpu_phi = 0;
	mem_phi = 1;
	vid_phi = 1;
	counter = 0;
end

always@(posedge CLOCK_50) begin
	counter++;
`ifdef __ICARUS__
	if (counter == 2) begin
`else
	if (counter == 10) begin
`endif
		mem_phi = ~mem_phi;
	end
`ifdef __ICARUS__
	if (counter == 4) begin
`else
	if (counter == 20) begin
`endif
		mem_phi = ~mem_phi;
	end
`ifdef __ICARUS__
	if (counter == 6) begin
`else
	if (counter == 30) begin
`endif
		mem_phi = ~mem_phi;
	end
`ifdef __ICARUS__
	if (counter == 8) begin
`else
	if (counter == 40) begin
`endif
		counter = 0;
		cpu_phi = ~cpu_phi;
		vid_phi = ~vid_phi;
		mem_phi = ~mem_phi;
	end
end
endmodule

