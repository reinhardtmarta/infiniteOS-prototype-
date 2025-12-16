#include "../drivers/vga/vga.h"

void kernel_main(void) {
    vga_write("InfiniteOS booted.\n");

    while (1) {
        __asm__("hlt");
    }
}
