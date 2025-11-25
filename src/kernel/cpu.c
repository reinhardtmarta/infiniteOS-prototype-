/*
 * src/kernel/cpu.c - Inicialização de baixo nível da CPU e Funções de Controle.
 */

// 1. INCLUSÕES ESSENCIAIS
#include <stdint.h>
#include <quantum/types.h>
// Se você tiver um arquivo de cabeçalho para a CPU (e.g., para a GDT, IDT), inclua-o aqui.
// #include "../../include/arch/gdt.h"
// #include "../../include/arch/idt.h" 
//  #include "../../include/types.h"
// ----------------------------------------------------------------------
// Variáveis e Funções de Teste (que causaram o erro)
// ----------------------------------------------------------------------

// Função de teste que utiliza o tipo Qubit_State_t
// Isso simula a necessidade de inicializar a camada adaptativa
void cpu_initialize_quantum_adapter(Qubit_State_t initial_state) {
    
    // Isso é um stub: 
    // Em um SO real, inicializaria registradores, a GDT e a IDT.
    
    // Exemplo de uso do tipo (Para teste)
    if (initial_state == QUBIT_ENTANGLED) {
        // Envia log para o serial
    }
}


// Função principal de inicialização da CPU
void cpu_init() {
    // 1. Configura a Memória e Registradores (GDT, Paging)
    // gdt_init();
    
    // 2. Configura a Tabela de Interrupções (IDT)
    // idt_init();
    
    // 3. Inicializa a camada quântica adaptativa (simulação)
    cpu_initialize_quantum_adapter(QUBIT_NEUTRAL);
}

// Funções de I/O de baixo nível (Assembly inline)

// Função (inline assembly) para enviar um byte para uma porta I/O
u8 inb(u16 port) {
    u8 data;
    asm volatile("inb %1, %0" : "=a"(data) : "Nd"(port));
    return data;
}

// Função (inline assembly) para ler um byte de uma porta I/O
void outb(u16 port, u8 data) {
    asm volatile("outb %0, %1" : : "a"(data), "Nd"(port));
}
