// src/kernel/main.c
#include <vga.h>
#include <stdint.h>

void cpu_init(void);         // declarado no cpu.c
void cpu_test_quantum(void); // opcional

void kernel_main(void)
{
    vga_clear();
    vga_print("InfiniteOS v0.∞ booting...\n");
    vga_print("   _         __ _       _\n");
    vga_print("  (_)_ __   / _(_)_ __ | |_ \n");
    vga_print("  | | '_ \\ / /_| | '_ \\| __|\n");
    vga_print("  | | | | / ___ | | | | |_ \n");
    vga_print("  |_|_| |_\\_/  |_|_| |_|\\__|\n\n");

    vga_print("Quantum-Classical Hybrid OS\n");
    vga_print("Made 100% on mobile by reinhardtmarta\n\n");

    cpu_init();

    vga_print("\nBoot successful! Quantum engine active.\n");
    vga_print("Press any key to halt forever...\n");

    // halt eterno
    while (1) {
        __asm__("hlt");
    }
}
