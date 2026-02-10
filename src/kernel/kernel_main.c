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
    vga_write("InfiniteOS booting...\n");

    /* Inicialização base */
    vga_write("Initializing IDT...\n");
    idt_init();
    
    vga_write("Initializing Timer...\n");
    timer_init();
    
    vga_write("Initializing Paging...\n");
    paging_init();

    vga_write("Initializing Scheduler...\n");
    scheduler_init();
    scheduler_add(task_a);
    scheduler_add(task_b);

    vga_write("System Ready. Enabling Interrupts...\n");
    __asm__ volatile ("sti");

    /* Segurança: nunca retornar */
    vga_write("Entering main loop...\n");
    for (;;) {
        __asm__ volatile ("hlt");
    }
}
