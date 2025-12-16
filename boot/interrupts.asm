global isr_syscall
extern syscall_handler

isr_syscall:
    pusha
    push edx
    push ecx
    push ebx
    push eax
    call syscall_handler
    add esp, 20
    popa
    iretd
