#include <stdio.h>

void main(void) {

	for (int y2 = 0x400; y2 < 0x800; y2 += 0x080)
		for (int x = 0x0; x < 0x28; x++)
			printf("%x\n", y2+x);

	for (int y2 = 0x428; y2 < 0x800; y2 += 0x080)
		for (int x = 0x0; x < 0x28; x++)
			printf("%x\n", y2+x);

	for (int y2 = 0x450; y2 < 0x800; y2 += 0x080)
		for (int x = 0x0; x < 0x28; x++)
			printf("%x\n", y2+x);
}
