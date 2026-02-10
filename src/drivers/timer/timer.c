#include "timer.h"
#include "../vga/vga.h"

#include "drivers/timer/timer.h"
#include "scheduler.h"

static volatile uint32_t ticks = 0;

void timer_handler(void) {
    ticks++;
    scheduler_tick();
}

static inline void outb(uint16_t port, uint8_t val) {
    __asm__ volatile ("outb %0, %1" : : "a"(val), "Nd"(port));
}

void timer_tick(void) {
    ticks++;

    if (ticks % 100 == 0) {
        vga_write(".");
    }
}

uint32_t timer_get_ticks(void) {
    return ticks;
}

void timer_init(void) {
    outb(0x43, 0x36);
    outb(0x40, 0x9B);
    outb(0x40, 0x2E);
}
