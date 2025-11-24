/*
 * src/arch/cpu_idt.c - Inicialização da Tabela de Descritores de Interrupção
 */

#include "../../include/arch/idt.h"

idt_entry_t idt_entries[256];
idt_ptr_t   idt_ptr;

// Endereço que será carregado pela função Assembly idt_load
idt_ptr_t idt_load_ptr;

// Implementa o set_gate
void idt_set_gate(u8 num, u32 base, u16 sel, u8 flags) {
    idt_entries[num].base_low = base & 0xFFFF;
    idt_entries[num].base_high = (base >> 16) & 0xFFFF;
    idt_entries[num].selector = sel;
    idt_entries[num].zero = 0;
    // As flags (0x8E = Present, DPL 0, Tipo 32-bit Interrupt Gate)
    idt_entries[num].flags = flags; 
}

// Inicialização da IDT (chamada do kmain.c)
void idt_init() {
    // 1. Configura o ponteiro
    idt_ptr.limit = sizeof(idt_entry_t) * 256 - 1;
    idt_ptr.base = (u32)&idt_entries;

    // 2. Preenche os descritores (aqui vai o código para cada uma das 256 interrupções)
    
    // Exemplo: idt_set_gate(0, (u32)isr0, 0x08, 0x8E); // Divisão por Zero
    
    // 3. Carrega a IDT no processador
    idt_load();
}
