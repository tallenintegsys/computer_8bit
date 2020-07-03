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
    if (counter == 100) begin
        counter = 0;
        phi = ~phi;
    end
end
endmodule

