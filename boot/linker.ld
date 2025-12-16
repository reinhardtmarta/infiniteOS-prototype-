/* linker.ld - Simple linker script for bootable kernel */

ENTRY(_start)

SECTIONS
{
    . = 1M; /* Start from the 1MB mark */

    .text :
    {
        *(.text)   /* Collects all text (code) sections */
    }

    .data :
    {
        *(.data)   /* Collects all data sections */
    }

    .bss :
    {
        *(.bss)    /* Collects all uninitialized data */
    }
}
