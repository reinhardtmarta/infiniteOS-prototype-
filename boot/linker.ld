/* linker.ld — Linker Script para InfiniteOS (32-bit) */

ENTRY(_start)

SECTIONS
{
    /* Carregar o kernel na memória física 1MB */
    . = 1M;

    .text : {
        *(.multiboot)
        *(.text*)
    }

    .rodata : {
        *(.rodata*)
    }

    .data : {
        *(.data*)
    }

    .bss : {
        *(COMMON)
        *(.bss*)
        . = ALIGN(4);
    }
}
