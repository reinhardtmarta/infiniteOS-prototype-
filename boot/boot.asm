; ======================================================
; infiniteOS — Boot Stage
; Arquivo: boot/boot.asm
; Target: ELF32, Protected Mode (Multiboot)
; ======================================================

bits 32

; Multiboot header
MBOOT_PAGE_ALIGN    equ 1 << 0
MBOOT_MEM_INFO      equ 1 << 1
MBOOT_HEADER_MAGIC  equ 0x1BADB002
MBOOT_HEADER_FLAGS  equ MBOOT_PAGE_ALIGN | MBOOT_MEM_INFO
MBOOT_CHECKSUM      equ -(MBOOT_HEADER_MAGIC + MBOOT_HEADER_FLAGS)

section .multiboot
    align 4
    dd MBOOT_HEADER_MAGIC
    dd MBOOT_HEADER_FLAGS
    dd MBOOT_CHECKSUM

section .text
global _start

; Símbolos externos
extern GDT_POINTER
extern kernel_main

; Seletores da GDT (índices fixos)
CODE_SEG equ 0x08
DATA_SEG equ 0x10

_start:
    ; Configurar stack inicial
    mov esp, stack_top

    ; Carregar GDT (embora o bootloader já nos coloque em PM, é bom ter a nossa)
    lgdt [GDT_POINTER]

    ; Far jump para carregar o seletor de código correto
    jmp CODE_SEG:.reload_segments

.reload_segments:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Chamar kernel C
    call kernel_main

.halt:
    cli
    hlt
    jmp .halt

section .bss
align 16
stack_bottom:
    resb 16384 ; 16 KB de stack
stack_top:
