; idt.asm — IDT mínima só para satisfazer o linker
bits 32
global IDT_START
global IDT_POINTER

IDT_START:
    times 256 dq 0         ; 256 entradas zeradas (interrupts desabilitadas)

IDT_POINTER:
    dw (IDT_END - IDT_START) - 1   ; Tamanho
    dd IDT_START                   ; Endereço base

IDT_END:
