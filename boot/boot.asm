; ====================== boot.asm (Fase 1: 16-bit) ======================

bits 16
global _start

CODE_SEG equ 0x08 ; Endereço do descritor de Código na GDT
DATA_SEG equ 0x10 ; Endereço do descritor de Dados na GDT

_start:
    ; 1. Configurar segmentos iniciais e a pilha
    cli                     ; Desabilita interrupções
    mov ax, 0x0000
    mov ds, ax
    mov es, ax
    mov ss, ax              ; Assumindo que a pilha estará em 0x7C00
    mov sp, 0x7C00          ; Pilha abaixo do bootloader

    ; 2. Habilitar a Linha A20 (Geralmente opcional, mas boa prática)
    ; (Código para A20 ficaria aqui, omitido por simplicidade)

    ; 3. Carregar a GDT
    lgdt [GDT_POINTER]      ; Carrega a Tabela de Descritores Global

    ; 4. Mudar para Modo Protegido
    mov eax, cr0            ; Pega o valor do registro de controle CR0
    or eax, 0x1             ; Seta o bit 0 (PE - Protection Enable)
    mov cr0, eax            ; Muda para o Modo Protegido!

    ; 5. Pular para o código de 32 bits
    jmp CODE_SEG:Modo_Protegido ; Far jump para limpar o cache da CPU e iniciar 32-bit


; ====================== boot.asm (Fase 2: 32-bit) ======================

bits 32
Modo_Protegido:
    ; 6. Configurar os registradores de segmento de 32 bits
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; 7. Configurar a pilha de 32 bits
    ; Endereço 0x90000 é um bom lugar seguro para a pilha.
    mov esp, 0x90000 

    ; 8. Chamar o kernel C
    extern kernel_main
    call kernel_main

    ; Se o kernel retornar, parar a CPU
    cli
    hlt

; Inclua aqui o arquivo da GDT (depende do seu sistema de compilação)
; Se for um único arquivo, apenas coloque o código do gdt.asm no final.
