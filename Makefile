PGM=$(HOME)/altera/13.1/quartus/bin/quartus_pgm

all: syn

.PHONY: syn sim pgm clean
syn :
	iverilog -o output_files/chip_6502 chip_6502.v MUX.v

sim :
	iverilog chip_6502_tb.v chip_6502.v MUX.v
	./a.out

pgm :
	$(PGM) -c 1 --mode=JTAG -o 'p;output_files/cobyLCD.sof'

clean:
	rm *.vcd a.out
