#include <stdint.h>
typedef uint16_t vga_char;
static vga_char* const VGA = (vga_char*)0xB8000;

void vga_clear(void) {
    for(int i = 0; i < 80*25; i++) VGA[i] = 0x0720;
}

void vga_putchar(char c) {
    static int x = 0, y = 0;
    if(c == '\n') { x = 0; y++; }
    else { VGA[y*80 + x] = 0x0700 | c; x++; if(x >= 80) { x=0; y++; } }
    if(y >= 25) y = 24;
}

void vga_print(const char* s) {
    while(*s) vga_putchar(*s++);
}
