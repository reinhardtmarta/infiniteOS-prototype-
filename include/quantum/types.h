// include/quantum/types.h
#ifndef _QUANTUM_TYPES_H
#define _QUANTUM_TYPES_H

#include <stdint.h>

// Estados possíveis de um qubit no InfiniteOS
typedef enum {
    QUBIT_ZERO      = 0,
    QUBIT_ONE       = 1,
    QUBIT_SUPERPOSITION = 2,
    QUBIT_ENTANGLED = 3,
    QUBIT_NEUTRAL   = 4     // estado "desconhecido" antes da medição
} Qubit_State_t;

// Estados de um trit ternário (base 3)
typedef enum {
    TRIT_ZERO       = 0,
    TRIT_ONE        = 1,
    TRIT_UNKNOWN    = 2,    // estado ternário quântico
    TRIT_NEUTRAL    = 3
} Trit_State_t;

// Nó quântico real usado na CPU híbrida do InfiniteOS
typedef struct Quantum_Node {
    double amplitude_zero;      // |0⟩
    double amplitude_one;       // |1⟩
    double amplitude_unknown;   // |?⟩ (ternário)
    uint8_t entangled_with;     // ID do nó entrelaçado (0 = nenhum)
    uint8_t measured;
    Trit_State_t trit_value;
} Quantum_Node_t;

#endif
