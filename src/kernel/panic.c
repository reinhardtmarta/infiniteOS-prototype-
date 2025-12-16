#include "kernel/panic.h"
#include "kernel/log.h"

void panic(const char* msg) {
    __asm__ volatile ("cli");

    klog("KERNEL PANIC");
    klog(msg);

    for (;;) {
        __asm__ volatile ("hlt");
    }
}
