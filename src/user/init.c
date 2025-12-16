#include "syscall.h"

void _start(void) {
    syscall(SYS_WRITE, (int)"Hello from userland\n", 0, 0);
    syscall(SYS_EXIT, 0, 0, 0);
}
