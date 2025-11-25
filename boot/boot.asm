; boot/boot.asm – bootloader do InfiniteOS (MBR clássico)
; Compila com: nasm -f elf32 boot/boot.asm -o boot/boot.o

global start
extern kernel_main

bits 16                     ; começa em real mode

start:
    cli                     ; desabilita interrupções
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00          ; stack logo abaixo do bootloader

    ; Carrega o kernel de 1MB (128 setores depois do boot)
    mov bx, 0x1000          ; ES:BX = 0000:1000 (endereço físico 0x1000)
    mov es, bx
    xor bx, bx

    mov ah, 0x02            ; função read sectors
    mov al, 64              ; quantos setores ler (64 × 512 = 32KB – suficiente pro kernel)
    mov ch, 0               ; cilindro 0
    mov cl, 2               ; setor 2 (1 = bootloader)
    mov dh, 0               ; cabeça 0
    mov dl, [drive]         ; drive (já vem em DL)
    int 0x13
    jc disk_error

    ; Pula pro modo protegido 32-bit
    cli
    lgdt [gdt_descriptor]

    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp CODE_SEG:protected_mode_start

disk_error:
    mov si, msg_error
    call print16
    jmp $

print16:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print16
.done:
    ret

msg_error: db "Disk read error!", 0

bits 32
protected_mode_start:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x90000        ; stack em 576KB

    ; Pula pro kernel C
    call kernel_main

    cli
    hlt

; GDT mínima (só code e data 4GB flat)
gdt_start:
    ; null descriptor
    dq 0x0000000000000000

    ; code segment (base=0, limit=4GB, 32-bit)
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 0x9A
    db 0xCF
    db 0x00

    ; data segment (base=0, limit=4GB, 32-bit)
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 0x92
    db 0xCF
    db 0x00
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

CODE_SEG equ 0x08
DATA_SEG equ 0x10

drive: db 0

times 510-($-$$) db 0
dw 0xAA55                   ; assinatura de boot                                                                                                                                                                                                        times 510 - ($ - $$) db 0  ; Preenche o restante do setor com zeros
                                                                                                                                                                                                        dw 0xAA55                  ; Assinatura de Boot (obrigatória)
                                                                                                                                                                                                        
