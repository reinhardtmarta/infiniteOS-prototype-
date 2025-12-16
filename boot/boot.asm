bits 16
global _start

extern GDT_START
extern GDT_POINTER
extern GDT_CODE_SEG
extern GDT_DATA_SEG

CODE_SEG equ GDT_CODE_SEG - GDT_START
DATA_SEG equ GDT_DATA_SEG - GDT_START

_start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    lgdt [GDT_POINTER]

    mov eax, cr0
    or eax, 0x1
    mov cr0, eax

    jmp CODE_SEG:Modo_Protegido

; ====================== 32-bit mode ======================
bits 32
Modo_Protegido:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov esp, 0x90000

    extern kernel_main
    call kernel_main

halt:
    cli
    hlt
    jmp halt
