PGM=$(HOME)/altera/13.1/quartus/bin/quartus_pgm

all: syn

.PHONY: syn sim pgm clean
syn :
	iverilog -g2012 -o output_files/computer_8bit computer_8bit.sv single_port_rom.sv chip_6502.v MUX.v

sim :
	iverilog -g2012 computer_8bit_tb.sv computer_8bit.sv single_port_rom.sv chip_6502.v MUX.v
	./a.out

pgm :
	$(PGM) -c 1 --mode=JTAG -o 'p;output_files/computer_8bit.sof'

clean:
	rm *.vcd a.out
