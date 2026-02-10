global isr_syscall
global isr_timer
extern syscall_handler
extern timer_handler

isr_syscall:
    pusha
    push edx
    push ecx
    push ebx
    push eax
    call syscall_handler
    add esp, 16
    popa
    iretd

isr_timer:
    pusha
    call timer_handler
    
    ; Enviar EOI para o PIC (End of Interrupt)
    mov al, 0x20
    out 0x20, al
    
    popa
    iretd
