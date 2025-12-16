; ==========================================================
; idt.asm — Loader da IDT (usada pelo kernel C)
; ==========================================================

bits 32

global idt_load
extern idtp

idt_load:
    lidt [idtp]
    ret
