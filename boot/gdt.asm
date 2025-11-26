; ============================================================
; gdt.asm — Global Descriptor Table para InfiniteOS Prototype
; ============================================================

BITS 16

; -----------------------------
; Estrutura da GDT (flat model)
; -----------------------------

GDT_START:

; 0x00 — NULL Descriptor (obrigatório)
GDT_NULL:
    dq 0

; 0x08 — Código 32-bit
GDT_CODE_SEG:
    dw 0xFFFF         ; Limit (15-0)
    dw 0x0000         ; Base (15-0)
    db 0x00           ; Base (23-16)
    db 10011010b      ; Access: Code, Readable, Present
    db 11001111b      ; Flags: 4K granularity, 32-bit
    db 0x00           ; Base (31-24)

; 0x10 — Dados 32-bit
GDT_DATA_SEG:
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 10010010b      ; Access: Data, Writable, Present
    db 11001111b      ; Flags: 4K granularity, 32-bit
    db 0x00

GDT_END:

; -----------------------------
; GDT Pointer (usado pelo LGDT)
; -----------------------------
GDT_POINTER:
    dw GDT_END - GDT_START - 1
    dd GDT_START
