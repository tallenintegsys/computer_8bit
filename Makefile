ALTERA=$(HOME)/altera/13.1/quartus/bin/
#INTEL=$(HOME)/intelFPGA_lite/20.1/quartus/bin/
INTEL=$(HOME)/intelFPGA_lite/23.1std/quartus/bin/
MAP=$(INTEL)quartus_map
FIT=$(INTEL)quartus_fit
ASM=$(INTEL)quartus_asm
STA=$(INTEL)quartus_sta
EDA=$(INTEL)quartus_eda
PGM=$(INTEL)quartus_pgm
modules=clock_divider.sv \
		mainrom.sv \
		ram.sv \
		address_decode.sv \
		chip_6502.v MUX.v \
		vdp.sv vga.sv crom.sv vram.sv \
		ps2ctrlr.sv
VFLAGS= -Wall -g2012

all: sim

.PHONY: syn sim pgm clean distclean run
syn:
	$(MAP) --read_settings_files=on --write_settings_files=off computer_8bit -c computer_8bit
	$(FIT) --read_settings_files=off --write_settings_files=off computer_8bit -c computer_8bit
	$(ASM) --read_settings_files=off --write_settings_files=off computer_8bit -c computer_8bit
#	$(STA) computer_8bit -c computer_8bit
	$(EDA) --read_settings_files=off --write_settings_files=off computer_8bit -c computer_8bit

sim:
	iverilog $(VFLAGS)  computer_8bit_tb.sv computer_8bit.sv $(modules)
	./a.out

pgm:
	$(PGM) -c 1 --mode=JTAG -o 'p;output_files/computer_8bit.sof'

run: syn pgm


clean:
	rm -f *.vcd a.out

distclean:
	rm -rf *.vcd a.out db incremental_db output_files simulation
