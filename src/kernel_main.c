// kernel_main.c — Kernel mínimo para InfiniteOS
// Compila em freestanding mode (sem libc)

#include <stdint.h>

void kernel_main() {
    // Por enquanto apenas trava a CPU em hlt.
    // Depois você pode chamar drivers, printar texto, inicializar memória, etc.
    while (1) {
        __asm__ __volatile__("hlt");
    }
}
