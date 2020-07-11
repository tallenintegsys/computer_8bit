module clock_divider
(
	input CLOCK_50,
	output logic phi
);

int counter;

initial
begin
	phi = 0;
	counter = 0;
end

always@(posedge CLOCK_50)
begin
	counter++;
`ifdef __ICARUS__
	if (counter == 10) begin
`else
	if (counter == 50) begin
`endif
		counter = 0;
		phi = ~phi;
	end
end
endmodule

