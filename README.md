# computer_8bit
Implementation of a popular 8-bit computer on a Cyclone IV based DE2-115
![Dev Setup](/doc/boots_FB_in_progress.png) 
Text mode works
![FB text mode works](doc/txt_mode_works.png) 


The ROMs are "programmed" during synthesis (I'm not using external flash etc.). I used xxd to format the file:
`xxd -ps -c1 3410036.bin > AppleII_crom.txt` The roms can be dumped from your Apple II or downloaded from http://ftp.apple.asimov.net/emulators/rom_images/ 

The CROM (character ROM) begins with 00 1c 22 2a 2e 2c 20 1e... Look for a file named `3410036.bin` The file contains bitmaps of the character set.
<pre>
0x00   
0x1c      XXX  
0x22     X   X 
0x2a     X X  X
0x2e     X XX X
0x2c     X XX
0x20     X
0x1e      XXXX
</pre>

For the main ROM `APPLE2_.ROM` from `https://ftp.apple.asimov.net/emulators/rom_images/` might be a good choice. 
