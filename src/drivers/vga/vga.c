#include "vga.h"

static volatile char* const VGA_MEMORY = (char*) 0xB8000;
static int cursor = 0;

void vga_write(const char* str) {
    while (*str) {
        VGA_MEMORY[cursor++] = *str++;
        VGA_MEMORY[cursor++] = 0x0F; // branco sobre preto
    }
}
