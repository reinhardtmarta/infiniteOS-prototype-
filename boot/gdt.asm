; ====================== gdt.asm ======================

; Define os endereços da GDT
GDT_START:
    ; 1. Descritor NULO (0x00) - Obrigatório, mas não usado
    dd 0x0
    dd 0x0

; 2. Descritor de Código (0x08) - Segmento de Código (CS)
; Base: 0, Limite: 4GB. Acesso: Executável/Legível, 32-bit (D=1)
GDT_CODE_SEG:
    dw 0xFFFF    ; Limite de 0-15
    dw 0x0000    ; Base de 0-15
    db 0x00      ; Base de 16-23
    db 10011010b ; Acesso: Present, DPL=0, Type=Code, Exec/Read
    db 11001111b ; Limite de 16-19, Granularidade G=1 (4KB), 32-bit (D=1)
    db 0x00      ; Base de 24-31

; 3. Descritor de Dados (0x10) - Segmento de Dados (DS/SS/ES/FS/GS)
; Base: 0, Limite: 4GB. Acesso: Leitura/Escrita
GDT_DATA_SEG:
    dw 0xFFFF    ; Limite de 0-15
    dw 0x0000    ; Base de 0-15
    db 0x00      ; Base de 16-23
    db 10010010b ; Acesso: Present, DPL=0, Type=Data, Writeable
    db 11001111b ; Limite de 16-19, Granularidade G=1 (4KB), 32-bit (D=1)
    db 0x00      ; Base de 24-31

GDT_END:

; Ponteiro de 48 bits (para instrução LGDT)
; O ponteiro contém o limite da tabela (16 bits) e o endereço inicial (32 bits)
GDT_POINTER:
    dw GDT_END - GDT_START - 1 ; Limite (tamanho - 1)
    dd GDT_START               ; Endereço da GDT
