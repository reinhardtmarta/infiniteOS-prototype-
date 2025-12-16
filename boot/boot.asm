; ======================================================
; infiniteOS — Boot Stage
; Arquivo: boot/boot.asm
; Target: ELF32, Protected Mode
; ======================================================

bits 16
global _start

; Símbolos externos
extern GDT_POINTER
extern kernel_main

; Seletores da GDT (índices fixos)
CODE_SEG equ 0x08
DATA_SEG equ 0x10

; ------------------------------------------------------
; Entry point
; ------------------------------------------------------
_start:
    cli

    ; Inicializar segmentos em real mode
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    ; Carregar GDT
    lgdt [GDT_POINTER]

    ; Ativar Protected Mode
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax

    ; Far jump para limpar pipeline
    jmp CODE_SEG:protected_mode

; ------------------------------------------------------
; Protected Mode (32-bit)
; ------------------------------------------------------
bits 32
protected_mode:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Stack segura
    mov esp, 0x90000

    ; Chamar kernel C
    call kernel_main

.halt:
    cli
    hlt
    jmp .halt
