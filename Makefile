ALTERA=$(HOME)/altera/13.1/quartus/bin/
INTEL=$(HOME)/intelFPGA_lite/20.1/quartus/bin/
MAP=$(INTEL)quartus_map
FIT=$(INTEL)quartus_fit
ASM=$(INTEL)quartus_asm
STA=$(INTEL)quartus_sta
EDA=$(INTEL)quartus_eda
PGM=$(ALTERA)quartus_pgm
modules=clock_divider.sv \
		single_port_rom.sv \
		single_port_ram.sv \
		address_decode.sv \
		chip_6502.v \
		MUX.v
VFLAGS= -Wall -g2012

all: sim

.PHONY: syn video sim pgm clean
syn:
	$(MAP) --read_settings_files=on --write_settings_files=off computer_8bit -c computer_8bit
	$(FIT) --read_settings_files=off --write_settings_files=off computer_8bit -c computer_8bit
	$(ASM) --read_settings_files=off --write_settings_files=off computer_8bit -c computer_8bit
#	$(STA) computer_8bit -c computer_8bit
	$(EDA) --read_settings_files=off --write_settings_files=off computer_8bit -c computer_8bit


video:
	iverilog $(VFLAGS) video_tb.sv video.sv
	./a.out

sim:
	iverilog $(VFLAGS)  computer_8bit_tb.sv computer_8bit.sv $(modules)
	./a.out

pgm:
	$(PGM) -c 1 --mode=JTAG -o 'p;output_files/computer_8bit.sof'

clean:
	rm *.vcd a.out
