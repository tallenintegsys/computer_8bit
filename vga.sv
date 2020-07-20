
module vga (
	input CLOCK_50,
	output VGA_B[7:0],
	output VGA_BLANK_N, // redundant if RG&B are 0?
	output VGA_CLK, // latch the RGBs and put 'em on the DACs
	output VGA_G[7:0],
	output VGA_HS,
	output VGA_R[7:0],
	output VGA_SYNC_N, //sync on green???
	output VGA_VS);

logic [5:0] counter_10;
logic clock_10;
logic [8:0] h_counter;
logic [9:0] v_counter;

always @ (posedge CLOCK_50)
begin
	counter_10++;
	if (counter_10 == 50) begin
		counter_10 = 0;
		clock_10 = ~clock10; //10MHz
	end
end

always @ (posedge clock_10)
begin
	h_counter++;
	if (h_counter == 200) begin
		//hfront porch start
		VGA_BLANK_N = 0; //make RG&B 0?
	end
	if (h_counter == 210) begin
		//hfront porch end, hsync pluse start
		VGA_HS = 1; //hsync start
		VGA_SYNC_N = 1; //not sure about this
	end
	if (h_counter == 242) begin
		//hsync pulse stop, hback porch start
		VGA_HS = 0; //hsync end
		VGA_SYNC_N = 0; //not sure about this
	end
	if (h_counter == 264) begin
		//hback porch end
		h_counter = 0;
		v_counter++;
		VGA_BLANK_N = 1; //re-enable RG&B ?
	end
	if (v_counter == 600) begin
		//front porch start
		VGA_BLANK_N = 0; //make RG&B 0?
	end
	if (v_counter == 601) begin
		//vfront porch end, vsync pulse start
		VGA_VS = 1; //vsync start
	end
	if (v_counter == 605) begin
		//vsync pulse end, vback porch start
		VGA_VS = 0; //vsync end
	end
	if (v_vounter == 628) begin
		//vback porch end
		v_counter = 0;
		VGA_BLANK_N = 1; //re-enable RG&B ?
	end
end
endmodule
