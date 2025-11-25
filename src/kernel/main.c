// src/kernel/main.c
#ifndef VGA_H
#define VGA_H
void vga_clear(void);
void vga_putchar(char c);
void vga_print(const char* s);
#endif

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
    vga_print("Qubit engine: ATIVO\n");
    vga_print("Boot successful! Quantum engine active.\n");

    while(1) __asm__("hlt");
}
