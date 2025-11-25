ENTRY(start)

SECTIONS
{
    . = 0x100000;              /* Kernel começa em 1MB (depois do real mode) */

    .text : {
        *(.text)
        *(.rodata*)
    }

    .data : {
        *(.data)
    }

    .bss : {
        *(COMMON)
        *(.bss)
    }

    /DISCARD/ : {
        *(.eh_frame)
        *(.comment)
    }
}
