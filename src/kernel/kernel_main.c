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

    #ifndef CI_BUILD
    scheduler_init();
    scheduler_add(task_a);
    scheduler_add(task_b);
#endif

    /* Segurança: nunca retornar */
    for (;;) {
        __asm__ volatile ("hlt");
    }
}
