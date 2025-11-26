; ====================== boot/boot.asm ======================

; Este código é carregado pelo BIOS em 0x7C00 no Modo Real (16-bit)
; Ele deve caber em 512 bytes (o MBR) para ser carregado pelo BIOS
bits 16
global _start

; Inclui o arquivo da GDT (gdt.asm) para que os símbolos GDT_POINTER e os
; valores CODE_SEG e DATA_SEG sejam definidos antes de serem usados.
%include "boot/gdt.asm" 

; Valores dos Descritores (Offsets dentro da GDT)
CODE_SEG equ GDT_CODE_SEG - GDT_START
DATA_SEG equ GDT_DATA_SEG - GDT_START

_start:
    ; 1. Configurar segmentos e a pilha em 16-bit
    cli                     ; Desabilita interrupções
    mov ax, 0x0000
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00          ; Pilha abaixo do bootloader

    ; 2. Carregar a GDT
    lgdt [GDT_POINTER]      ; Carrega a Tabela de Descritores Global

    ; 3. Mudar para Modo Protegido
    mov eax, cr0            ; Pega o valor do registro de controle CR0
    or eax, 0x1             ; Seta o bit 0 (PE - Protection Enable)
    mov cr0, eax            ; Transição para Modo Protegido!

    ; 4. Pular para o código de 32 bits
    jmp CODE_SEG:Modo_Protegido ; Far jump (CODE_SEG = seletor de segmento)

; ====================== Fim da Fase 16-bit ======================


; ====================== Fase 32-bit ======================
bits 32
Modo_Protegido:
    ; 5. Configurar os registradores de segmento de 32 bits
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; 6. Configurar a pilha de 32 bits
    mov esp, 0x90000 

    ; 7. Chamar o kernel C
    extern kernel_main
    call kernel_main

    ; Se o kernel retornar (o que não deve), parar a CPU
    cli
    hlt
