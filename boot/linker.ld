ENTRY(_start)

SECTIONS
{
    /* 1. Definir o endereço de carga do MBR para 0x7C00 */
    . = 0x7C00;

    .text : AT(0x7C00) { 
        *(.text) 
    }
    
    .rodata : { *(.rodata*) }
    .data : { *(.data) }
    .bss : { *(.bss) *(COMMON) }

    /* 2. Adicionar seção para a assinatura mágica no final */
    /* Garante que o arquivo de saída tenha pelo menos 510 bytes (0x7DFE) */
    .sig :
    {
        . = 0x7DFE; /* 510º byte de 0x7C00, pois 0x7C00 + 510 = 0x7DFE */
        SHORT(0xAA55); /* Assinatura Mágica: 0x55AA (little-endian) */
    }
}
