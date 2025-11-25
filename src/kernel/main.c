// src/kernel/main.c
#include "../include/vga.h"

void kernel_main(void)
{
    vga_clear();
    
    vga_print("InfiniteOS v0.∞ booting...\n\n");
    vga_print("   ___        __ _       _ _   \n");
    vga_print("  |_ _|_ __  / _(_)_ __ | | |  \n");
    vga_print("   | || '_ \\| |_| | '_ \\| | |  \n");
    vga_print("   | || | | |  _| | | | | | |  \n");
    vga_print("  |___|_| |_|_| |_|_| |_|_|_| \n\n");
    
    vga_print("Quantum-Classical Hybrid OS\n");
    vga_print("Made 100% on mobile by reinhardtmarta\n\n");
    vga_print("InfiniteOS Quantum CPU v0.∞ online\n");
    vga_print("Qubit engine: ATIVO\n");
    vga_print("Ternary logic: ATIVO\n");
    vga_print("Pronto para computação infinita!\n\n");
    vga_print("Boot successful! Quantum engine active.\n");

    while (1) {
        __asm__ volatile ("hlt");
    }
}
