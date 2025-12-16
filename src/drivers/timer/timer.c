#include "timer.h"

static inline void outb(unsigned short port, unsigned char val) {
    __asm__ volatile ("outb %0, %1" : : "a"(val), "Nd"(port));
}

void timer_init(void) {
    outb(0x43, 0x36);
    outb(0x40, 0x9B);
    outb(0x40, 0x2E);
}
