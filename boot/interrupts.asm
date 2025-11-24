; -----------------------------------------------------------------------------
; boot/interrupts.asm - Funções de Assembly para a IDT
; -----------------------------------------------------------------------------

[BITS 32]
; Extern: Funções C a serem chamadas
extern idt_load_ptr

; Função para carregar a IDT no processador
global idt_load
idt_load:
    ; Carrega o IDTR (Interrupt Descriptor Table Register)
    lidt [idt_load_ptr] 
    ret
