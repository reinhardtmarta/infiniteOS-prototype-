/*
 * include/types.h - Base Types for InfiniteOS
  * Defines standard types and the new "Quantum" types.
   */

   #ifndef TYPES_H
   #define TYPES_H

   // --- 1. Tipos Binários Padrão (Compatibilidade) ---
   // O InfiniteOS ainda precisa de tipos binários para interagir com o hardware.
   typedef unsigned char  u8;  // 8-bit unsigned integer
   typedef unsigned short u16; // 16-bit unsigned integer
   typedef unsigned int   u32; // 32-bit unsigned integer
   typedef unsigned long long u64; // 64-bit unsigned integer

   // --- 2. Tipos de Abstração Pré-Quantum (Golden Ratio Kernel) ---

   /*
    * Estrutura Base para representar um TRIT (Valor Ternário).
     * Um TRIT requer 2 bits (u8) para armazenar 3 estados (-1, 0, +1).
      * * Mapeamento Binário:
       * 00 = -1 (False/Negative)
        * 01 = 0  (Unknown/Neutral)
         * 10 = +1 (True/Positive)
          * 11 = Reservado (Pode ser usado para "Erro" ou "Superposição Simples")
           */
           typedef u8 Trit_Value; // Usamos 1 byte para facilitar o alinhamento, mas só 2 bits são usados.

           // Definição da Estrutura Central (O bloco de dados mais básico do seu Kernel Adaptativo)
           typedef struct {
               // 8 unidades Ternárias (Trits) = 1 Byte Binário (1 trit * 2 bits = 16 bits necessários)
                   // No entanto, para simplicidade, vamos começar com um único valor.
                       
                           Trit_Value value; 
                               
                                   // O ponteiro é crucial: Ele armazena o endereço da memória
                                       // onde a próxima operação quântica deve ocorrer.
                                           void *next_operation_ptr; 
                                               
                                               } Quantum_Node_t;

                                               // --- 3. Constantes Ternárias (Mapeamento de Bits) ---

                                               #define TRIT_NEGATIVE 0b00 // -1
                                               #define TRIT_NEUTRAL  0b01 // 0
                                               #define TRIT_POSITIVE 0b10 // +1
                                               #define TRIT_RESERVED 0b11 // Estado de erro ou "simulação de superposição"

                                               #endif 
                                               