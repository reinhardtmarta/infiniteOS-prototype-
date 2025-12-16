/* linker.ld - Simple linker script for a kernel */

ENTRY(_start)  /* Define the entry point */

/* Memory layout sections */
SECTIONS
{
    /* Text (code) section */
    .text :
    {
        *(.text)  /* All text (code) sections */
    }

    /* Data section */
    .data :
    {
        *(.data)  /* All data sections */
    }

    /* Uninitialized data section (bss) */
    .bss :
    {
        *(.bss)   /* All bss (uninitialized data) sections */
    }

    /* Stack section */
    .stack (NOLOAD) :
    {
        *(.stack)  /* Stack section if defined */
    }
}
