; -----------------------------------------------------------------------------
; boot/boot.asm - O Bootloader do InfiniteOS
; Objetivo: Carregar a CPU e pular para o Protected Mode (32-bit)
; -----------------------------------------------------------------------------

[ORG 0x7C00]     ; O endereço onde o BIOS carrega o setor de boot

BITS 16          ; Começamos em 16-bit Real Mode

; --- 1. JUMP PARA O MODO DE INICIALIZAÇÃO (JUMP TO START) ---
; O código principal
START:
    cli          ; Desabilita as interrupções (Interrupts)
        mov ax, 0x00 ; Zera o registrador AX
            mov ss, ax   ; Zera o Segmento de Stack (SS)
                mov ds, ax   ; Zera o Segmento de Dados (DS)
                    mov es, ax   ; Zera o Segmento Extra (ES)
                        mov fs, ax   ; Zera o Segmento de Arquivo (FS)
                            mov gs, ax   ; Zera o Segmento Global (GS)
                                mov sp, 0x7C00 ; Define o ponteiro da Stack (SP)
                                    
                                        ; Chama a rotina para saltar para o 32-bit Protected Mode
                                            call switch_to_pm
                                                jmp $        ; Loop infinito em caso de falha

                                                ; --- 2. CONFIGURAÇÃO DA GDT (Global Descriptor Table) ---
                                                ; Esta tabela define a memória que o kernel pode usar no Protected Mode
                                                gdt_start:
                                                    ; GDT null descriptor
                                                        dd 0x0        ; 4 bytes
                                                            dd 0x0        ; 4 bytes

                                                            ; GDT code descriptor
                                                            gdt_code:
                                                                dw 0xFFFF     ; Segment limit 0..15
                                                                    dw 0x0        ; Base 0..15
                                                                        db 0x0        ; Base 16..23
                                                                            db 0x9A       ; Access byte: Present, Priv level 0, Executable, Read/Write
                                                                                db 0xCF       ; Flags: Granularity 4K, 32-bit segment (D/B bit)
                                                                                    db 0x0        ; Base 24..31

                                                                                    ; GDT data descriptor
                                                                                    gdt_data:
                                                                                        dw 0xFFFF     ; Segment limit 0..15
                                                                                            dw 0x0        ; Base 0..15
                                                                                                db 0x0        ; Base 16..23
                                                                                                    db 0x92       ; Access byte: Present, Priv level 0, Read/Write
                                                                                                        db 0xCF       ; Flags: Granularity 4K, 32-bit segment (D/B bit)
                                                                                                            db 0x0        ; Base 24..31

                                                                                                            gdt_end:

                                                                                                            gdt_descriptor:
                                                                                                                dw gdt_end - gdt_start - 1 ; GDT Size
                                                                                                                    dd gdt_start               ; GDT Address (Base)

                                                                                                                    CODE_SEG equ gdt_code - gdt_start
                                                                                                                    DATA_SEG equ gdt_data - gdt_start

                                                                                                                    ; --- 3. ROTINA DE SWITCH PARA PROTECTED MODE ---
                                                                                                                    switch_to_pm:
                                                                                                                        cli                           ; Desabilita interrupções
                                                                                                                            lgdt [gdt_descriptor]         ; Carrega a GDT no processador
                                                                                                                                mov eax, cr0                  ; Move o conteúdo de CR0 para EAX
                                                                                                                                    or eax, 0x1                   ; Seta o bit 0 (Protected Mode Enable)
                                                                                                                                        mov cr0, eax                  ; Move o EAX de volta para CR0 (Muda para Protected Mode!)
                                                                                                                                            jmp CODE_SEG:init_pm          ; Jump far (Salto longo) para limpar a fila de instruções

                                                                                                                                            BITS 32          ; A partir daqui, estamos no modo 32-bit!

                                                                                                                                            ; --- 4. CÓDIGO DE INICIALIZAÇÃO 32-BIT ---
                                                                                                                                            init_pm:
                                                                                                                                                mov ax, DATA_SEG              ; Carrega o seletor de dados
                                                                                                                                                    mov ds, ax                    ; Seta o DS
                                                                                                                                                        mov es, ax                    ; Seta o ES
                                                                                                                                                            mov fs, ax                    ; Seta o FS
                                                                                                                                                                mov gs, ax                    ; Seta o GS
                                                                                                                                                                    mov ss, ax                    ; Seta o SS
                                                                                                                                                                        mov esp, 0x90000              ; Seta o ponteiro da Stack para um endereço seguro

                                                                                                                                                                            ; Aqui, o bootloader deve carregar o Kernel C para a memória
                                                                                                                                                                                ; e em seguida, pular para a função kmain()
                                                                                                                                                                                    
                                                                                                                                                                                        ; Por enquanto, vamos apenas mostrar que chegamos ao 32-bit:
                                                                                                                                                                                            mov ebx, 0x01
                                                                                                                                                                                                mov ecx, 0x02

                                                                                                                                                                                                    ; AQUI DEVE SER O JUMP FINAL PARA kmain()
                                                                                                                                                                                                        jmp $ ; Loop infinito por segurança, até que o kmain() seja implementado

                                                                                                                                                                                                        ; --- 5. ASSINATURA MÁGICA ---
                                                                                                                                                                                                        times 510 - ($ - $$) db 0  ; Preenche o restante do setor com zeros
                                                                                                                                                                                                        dw 0xAA55                  ; Assinatura de Boot (obrigatória)
                                                                                                                                                                                                        