/*
 * src/lib/ternary_math.c - Funções de Aritmética para a Camada Adaptativa Quântica
 * Opera sobre o tipo Trit_Value (0b00, 0b01, 0b10)
 */

#include "../include/types.h" // Inclui as definições Trit_Value

// Array de lookup para a lógica de soma ternária (Carry in = 0)
// Indices: [Trit_A] [Trit_B]
// 00 (-1), 01 (0), 10 (+1)
const Trit_Value TERNARY_SUM_TABLE[3][3] = {
    // A B | Soma (Resultado)
    // -1 + -1 = -2  (Representado como -1 e um carry)
    {TRIT_NEGATIVE, TRIT_NEGATIVE, TRIT_NEUTRAL}, // A = -1
    // 0 + (-1) = -1
    {TRIT_NEGATIVE, TRIT_NEUTRAL, TRIT_POSITIVE}, // A = 0
    // 1 + (-1) = 0
    {TRIT_NEUTRAL, TRIT_POSITIVE, TRIT_POSITIVE}  // A = +1
};

/*
 * ternary_add - Adiciona dois valores Trit_Value.
 * NOTA: Esta é uma simulação simplificada da soma sem considerar o Carry.
 */
Trit_Value ternary_add(Trit_Value a, Trit_Value b) {
    // Para usar a tabela, precisamos mapear 0b00, 0b01, 0b10 para os índices 0, 1, 2.
    // Como 0b00=0, 0b01=1, 0b10=2, o valor do bit já serve como índice.
    
    // Filtra o valor do Trit para garantir que não ultrapasse 0b10 (+1)
    if (a > TRIT_POSITIVE) a = TRIT_POSITIVE;
    if (b > TRIT_POSITIVE) b = TRIT_POSITIVE;

    // Retorna o resultado da soma usando a tabela de lookup.
    return TERNARY_SUM_TABLE[a][b];
}
