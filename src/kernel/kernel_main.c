#include "../drivers/vga/vga.h"
#include "../drivers/timer/timer.h"
#include "idt.h"
#include "paging.h"

void kernel_main(void) {
    vga_write("InfiniteOS\n");

    idt_init();
    timer_init();
    paging_init();

    vga_write("Paging enabled\n");

    while (1) {
        __asm__("hlt");
    }
}
