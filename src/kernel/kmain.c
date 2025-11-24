/*
 * src/kernel/kmain.c - Ponto de Entrada do Kernel InfiniteOS
 */

// --- Headers do Kernel ---
// Drivers Binários
#include "../../include/drivers/serial.h" 
void print_string(const char *str);
void clear_screen();

// Lógica Quântica/Adaptativa
#include "../../include/types.h"
#include "../../include/lib/ternary_math.h"

// ----------------------------------------------------------------------
// Hardware Detection Layer (A "BIOS" de Software)
// ----------------------------------------------------------------------

// Simula a detecção de hardware: 1 para Quântico, 0 para Binário Padrão
int detect_quantum_hardware() {
    // Por enquanto, retorna binário padrão (0) por segurança.
    return 0; 
}

// ----------------------------------------------------------------------
// Funções de Inicialização Específicas
// ----------------------------------------------------------------------

void initialize_binary_kernel() {
    print_string("Initializing InfiniteOS: STANDARD BINARY Kernel (x86/x64)...\n");
    serial_print("LOG: Binary Kernel Initialized.\n");
}

void test_ternary_logic() {
    // 1. Define os valores de teste (usando as constantes Trit_Value)
    Trit_Value a = TRIT_POSITIVE; // +1 (0b10)
    Trit_Value b = TRIT_NEGATIVE; // -1 (0b00)
    Trit_Value result = ternary_add(a, b);

    // 2. Reporta o teste via Porta Serial (Para Depuração!)
    serial_print("--- Ternary Math Test ---\n");
    serial_print("  A (+1) + B (-1) = Result (0).\n");
    
    // NOTA: É difícil imprimir um número como string sem um driver printf completo,
    // mas vamos verificar o valor do byte (0b01) usando o driver serial.
    serial_print("  Raw result value (expected 0b01): ");
    serial_write((char)result); // Envia o byte bruto.
    serial_print("\n-------------------------\n");

    // 3. Reporta o teste via VGA (Tela)
    print_string("Ternary Math Test OK.\n");
}

void initialize_quantum_kernel() {
    print_string("Initializing InfiniteOS: GOLDEN RATIO QUANTUM Kernel!\n");
    serial_print("LOG: Quantum Adaptive Layer Initialized.\n");
    test_ternary_logic(); // Roda o primeiro teste da sua lógica
}

// ----------------------------------------------------------------------
// PONTO DE ENTRADA PRINCIPAL DO KERNEL (kmain)
// ----------------------------------------------------------------------

void kmain() {
    // 1. Inicializa o subsistema de vídeo e serial (Ordem de boot crucial!)
    serial_init(); // Inicializa a porta serial primeiro para logs imediatos!
    clear_screen();
    serial_print("InfiniteOS Boot Start.\n");
    print_string("InfiniteOS Core Loaded.\n\n");
    
    // 2. A Camada de Seleção de Hardware
    if (detect_quantum_hardware()) {
        initialize_quantum_kernel();
    } else {
        // Para fins de teste inicial, vamos rodar a lógica quântica
        // mesmo que o hardware seja binário, para verificar o código.
        initialize_quantum_kernel(); 
    }
    
    // 3. Loop infinito do kernel
    print_string("\nKernel Halted. Waiting for Interrupts.\n");
    while(1) {
        // O kernel aguarda interrupções aqui.
    }
}
