bits 32
global isr_timer
extern timer_tick

isr_timer:
    pusha
    call timer_tick
    popa
    iret
