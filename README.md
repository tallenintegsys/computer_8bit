# computer_8bit

Implementation of an 8-bit computer on a Cyclone IV based DE2-115
![Dev Setup](/doc/boots_FB_in_progress.png) 
Text mode works
![FB text mode works](doc/txt_mode_works.png) 

The ROMs are "programed" during synthesys (I'm not using external flash etc.). I used xxd to format the file:
`xxd -ps -c1 romfile.bin > romfile.txt` The roms can be downloaded from http://ftp.apple.asimov.net/emulators/rom_images/
