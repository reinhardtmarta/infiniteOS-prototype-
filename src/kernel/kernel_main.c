#include "../drivers/vga/vga.h"
#include "../drivers/timer/timer.h"
#include "idt.h"
#include "paging.h"
#include "scheduler.h"

void task_a(void) {
    vga_write("A ");
}

void task_b(void) {
    vga_write("B ");
}

void kernel_main(void) {
    vga_write("InfiniteOS booting\n");

    idt_init();
    timer_init();
    paging_init();

#ifdef CI_BUILD
    vga_write("CI build OK\n");
    __asm__("hlt");
#else
    scheduler_init();
    scheduler_add(task_a);
    scheduler_add(task_b);
    scheduler_run();
#endif
}
