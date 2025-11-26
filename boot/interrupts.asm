; ====================== boot/interrupts.asm ======================

; Certifique-se de que a função idt_load é global
global idt_load

; Localize o ponteiro e adicione global:
global idt_load_ptr ; <--- ADICIONE ISSO!

idt_load_ptr:
    dw 0x0000 ; Limite (tamanho da IDT - 1)
    dd 0x00000000 ; Endereço base da IDT
