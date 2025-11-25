bits 32
extern kernel_main

section .text
global _start
_start:
    mov esp, 0x90000
    call kernel_main
    cli
    hlt
