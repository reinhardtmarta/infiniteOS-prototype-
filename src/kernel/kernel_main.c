#include "../drivers/vga/vga.h"
#include "../drivers/timer/timer.h"
#include "idt.h"

void kernel_main(void) {
    vga_write("InfiniteOS timing online\n");

    idt_init();
    timer_init();

    while (1) {
        __asm__("hlt");
    }
}
