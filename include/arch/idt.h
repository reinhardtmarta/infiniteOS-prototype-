/*
 * include/arch/idt.h - Estruturas para a IDT
 */

#ifndef IDT_H
#define IDT_H

#include "../types.h"

// Estrutura do Descriptor da IDT (8 bytes)
typedef struct {
    u16 base_low;    // 16 bits mais baixos do endereço do manipulador
    u16 selector;    // Seletor de segmento (GDT)
    u8  zero;        // Sempre zero
    u8  flags;       // Flags (P, DPL, Tipo)
    u16 base_high;   // 16 bits mais altos do endereço do manipulador
} __attribute__((packed)) idt_entry_t;

// Estrutura do Ponteiro da IDT (48 bits)
typedef struct {
    u16 limit;       // Tamanho da IDT - 1
    u32 base;        // Endereço base da IDT
} __attribute__((packed)) idt_ptr_t;

// O array que conterá os 256 descritores
extern idt_entry_t idt_entries[256];
extern idt_ptr_t   idt_ptr;

// Protótipos das funções
void idt_init();
void idt_set_gate(u8 num, u32 base, u16 sel, u8 flags);
extern void idt_load(); // Funcao Assembly

#endif
