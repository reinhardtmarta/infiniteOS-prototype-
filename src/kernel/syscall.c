#include "../drivers/vga/vga.h"
#include "scheduler.h"

int syscall_handler(int num, int a, int b, int c) {
    switch (num) {
        case 1: // SYS_WRITE
            vga_write((const char*)a);
            return 0;

        case 3: // SYS_YIELD
            scheduler_yield();
            return 0;

        case 2: // SYS_EXIT
            scheduler_exit();
            return 0;

        default:
            return -1;
    }
}
