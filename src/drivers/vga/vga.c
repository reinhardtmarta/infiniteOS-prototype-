#include <stdint.h>
#include "vga.h"

static volatile char* const VGA_MEMORY = (char*) 0xB8000;
static int cursor = 0;

static inline void outb(uint16_t port, uint8_t val) {
    __asm__ volatile ("outb %0, %1" : : "a"(val), "Nd"(port));
}

void vga_write(const char* str) {
    while (*str) {
        char c = *str++;
        VGA_MEMORY[cursor++] = c;
        VGA_MEMORY[cursor++] = 0x0F; // branco sobre preto
        outb(0x3F8, c); // Enviar para porta serial COM1
    }
}
