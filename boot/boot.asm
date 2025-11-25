; boot/boot.asm – bootloader 32-bit direto (o mais simples e infalível do mundo)
; nasm -f elf32 boot/boot.asm -o boot/boot.o

global start
extern kernel_main

bits 32

section .text
align 4

start:
    mov esp, 0x90000          ; stack em 576KB
    call kernel_main          ; pula pro C
    cli
    hlt
