#include "kernel/log.h"
#include "drivers/vga/vga.h"

void klog(const char* msg) {
    vga_write("[KERNEL] ");
    vga_write(msg);
    vga_write("\n");
}
