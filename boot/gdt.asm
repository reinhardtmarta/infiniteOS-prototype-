; ============================================================
;   infiniteOS - GDT (Global Descriptor Table)
;   Arquivo: boot/gdt.asm
; ============================================================

bits 16

global GDT_START
global GDT_POINTER
global GDT_CODE_SEG
global GDT_DATA_SEG

; ------------------------------------------------------------
; Estrutura da GDT
;   Entrada 0 = Null
;   Entrada 1 = Code Segment
;   Entrada 2 = Data Segment
; ------------------------------------------------------------

GDT_START:

; -----------------------------
; 0: Null Descriptor
; -----------------------------
GDT_NULL_DESC:
    dd 0x00000000
    dd 0x00000000

; -----------------------------
; 1: Code Segment Descriptor
; -----------------------------
GDT_CODE_SEG:
    ; Base = 0x00000000
    ; Limit = 0xFFFFF (4GB)
    ; Granularity = 4KB
    ; Execution, Readable

    dw 0xFFFF          ; Limit low
    dw 0x0000          ; Base low
    db 0x00            ; Base middle
    db 10011010b       ; Access byte (code segment)
    db 11001111b       ; Flags + limit high
    db 0x00            ; Base high

; -----------------------------
; 2: Data Segment Descriptor
; -----------------------------
GDT_DATA_SEG:
    ; Base = 0x00000000
    ; Limit = 0xFFFFF
    ; Writable

    dw 0xFFFF          ; Limit low
    dw 0x0000          ; Base low
    db 0x00            ; Base middle
    db 10010010b       ; Access byte (data segment)
    db 11001111b       ; Flags + limit high
    db 0x00            ; Base high


; ------------------------------------------------------------
; GDT Pointer
; ------------------------------------------------------------
GDT_END:

GDT_POINTER:
    dw GDT_END - GDT_START - 1   ; Tamanho da GDT
    dd GDT_START                 ; Endereço da GDT
