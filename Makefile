PGM=$(HOME)/altera/13.1/quartus/bin/quartus_pgm
modules=clock_divider.sv \
		single_port_rom.sv \
		single_port_ram.sv \
		address_decode.sv \
		chip_6502.v \
		MUX.v

all: syn

.PHONY: syn video sim pgm clean
syn :
	iverilog -g2012 -o output_files/computer_8bit computer_8bit.sv $(modules)

video:
	iverilog -g2012 video_tb.sv video.sv
	./a.out

sim :
	iverilog -g2012 computer_8bit_tb.sv computer_8bit.sv $(modules)
	./a.out

pgm :
	$(PGM) -c 1 --mode=JTAG -o 'p;output_files/computer_8bit.sof'

clean:
	rm *.vcd a.out
