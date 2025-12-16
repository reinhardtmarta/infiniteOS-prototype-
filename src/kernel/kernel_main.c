#include "../drivers/vga/vga.h"
#include "../drivers/timer/timer.h"
#include "idt.h"

void kernel_main(void) {
    vga_write("InfiniteOS alive\n");
    idt_init();
    timer_init();
    vga_write("Timer armed\n");

    while (1) {
        __asm__("hlt");
    }
}
