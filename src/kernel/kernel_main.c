#include "../drivers/vga/vga.h"
#include "../drivers/timer/timer.h"

#include "kernel.h"
#include "idt.h"
#include "paging.h"
#include "scheduler.h"

/* -------------------------------------------------
 * Tasks de teste (scheduler)
 * ------------------------------------------------- */

void task_a(void) {
    vga_write("A ");
}

void task_b(void) {
    vga_write("B ");
}

/* -------------------------------------------------
 * Kernel entry point
 * ------------------------------------------------- */

void kernel_main(void) {
    vga_write("InfiniteOS booting\n");

    /* Inicialização base */
    idt_init();
    timer_init();
    paging_init();

#ifdef CI_BUILD
    vga_write("CI build OK\n");
    __asm__ volatile ("hlt");
#else
    /* Scheduler só roda fora do CI */
    scheduler_init();
    scheduler_add(task_a);
    scheduler_add(task_b);
    scheduler_run();
#endif

    /* Segurança: nunca retornar */
    for (;;) {
        __asm__ volatile ("hlt");
    }
}
