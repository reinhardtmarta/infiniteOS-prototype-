// src/kernel/cpu.c
// Módulo de CPU híbrida do InfiniteOS – suporta x86 clássico + qubits/ternary logic

#include <stdint.h>        // uint8_t, uint16_t, etc (obrigatório!)
#include <quantum/types.h> // Qubit_State_t, Quantum_Node_t, etc
#include <vga.h>           // pra printar na tela

// ===============================================
// Funções de I/O de portas (clássicas, mas necessárias)
// ===============================================
static inline uint8_t inb(uint16_t port)
{
    uint8_t ret;
    __asm__ volatile ("inb %1, %0" : "=a"(ret) : "Nd"(port));
    return ret;
}

static inline void outb(uint16_t port, uint8_t data)
{
    __asm__ volatile ("outb %0, %1" : : "a"(data), "Nd"(port));
}

// ===============================================
// Subsistema quântico da CPU
// ===============================================
static Quantum_Node_t quantum_core[64]; // até 64 q-nós simultâneos (por enquanto)

void cpu_initialize_quantum_adapter(Qubit_State_t initial_state)
{
    vga_print("[QUANTUM] Inicializando adaptador quântico... ");

    // Zera todos os nós quânticos
    for (int i = 0; i < 64; i++) {
        quantum_core[i].amplitude_zero    = 1.0;
        quantum_core[i].amplitude_one     = 0.0;
        quantum_core[i].amplitude_unknown = 0.0;
        quantum_core[i].entangled_with    = 0;
        quantum_core[i].measured          = 0;
        quantum_core[i].trit_value        = TRIT_NEUTRAL;
    }

    if (initial_state == QUBIT_ENTANGLED) {
        vga_print("ENTANGLED\n");
        quantum_core[0].entangled_with = 1;
        quantum_core[1].entangled_with = 0;
    } else if (initial_state == QUBIT_NEUTRAL) {
        vga_print("NEUTRAL (safe boot)\n");
    } else {
        vga_print("CLASSIC mode\n");
    }
}

// ===============================================
// Inicialização principal da CPU
// ===============================================
void cpu_init(void)
{
    vga_print("InfiniteOS Quantum CPU v0.∞ online\n");
    vga_print("Arquitetura: x86-64 + Qubit/Ternary Logic\n");

    // Detecta CPU clássica (só pra mostrar que funciona)
    uint32_t eax, ebx, ecx, edx;
    __asm__ volatile ("cpuid" : "=a"(eax), "=b"(ebx), "=c"(ecx), "=d"(edx) : "a"(1));
    vga_print("CPUID detectado | Stepping: ");
    vga_print_hex(eax & 0xF);
    vga_print("\n");

    // Ativa o subsistema quântico
    cpu_initialize_quantum_adapter(QUBIT_NEUTRAL);

    vga_print("Qubit engine: ATIVO\n");
    vga_print("Ternary logic: ATIVO\n");
    vga_print("Pronto para computação infinita!\n\n");
}

// Função de teste rápido (pode chamar do kernel_main)
void cpu_test_quantum(void)
{
    vga_print("Teste: aplicando Hadamard no q0...\n");
    // Simulação simples de porta H (só pra mostrar vida)
    quantum_core[0].amplitude_zero = 0.7071;
    quantum_core[0].amplitude_one  = 0.7071;
    vga_print("q0 agora em superposição perfeita (|0> + |1>)/√2\n");
}
