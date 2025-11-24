/*
 * src/drivers/serial.c - Implementação do Driver Serial
 * Usa portas de I/O para COM1 (0x3F8)
 */

#include "../../include/drivers/serial.h"

// Função (inline assembly) para enviar um byte para uma porta I/O
static inline void outb(u16 port, u8 data) {
    asm volatile("outb %0, %1" : : "a"(data), "Nd"(port));
}

// Função (inline assembly) para ler um byte de uma porta I/O
static inline u8 inb(u16 port) {
    u8 data;
    asm volatile("inb %1, %0" : "=a"(data) : "Nd"(port));
    return data;
}

// Inicializa a Porta Serial (configura a velocidade)
void serial_init() {
    outb(COM1 + 1, 0x00);    // Desabilita todas as interrupções
    outb(COM1 + 3, 0x80);    // Habilita DLAB (para setar taxa de baud)
    outb(COM1 + 0, 0x03);    // Seta a baixa ordem do divisor para 3 (38400 baud)
    outb(COM1 + 1, 0x00);    // Seta a alta ordem do divisor para 0
    outb(COM1 + 3, 0x03);    // Desabilita DLAB, 8 bits de dados, sem paridade, 1 stop bit
    outb(COM1 + 2, 0xC7);    // Habilita FIFO, 14-byte threshold
    outb(COM1 + 4, 0x0B);    // IRQs ativas, seta o loopback
}

// Verifica se a Porta Serial está pronta para transmitir
int serial_transmit_empty() {
    // Linha 5 (bit 5) do Line Status Register (COM1 + 5)
    return inb(COM1 + 5) & 0x20;
}

// Envia um caractere pela porta serial
void serial_write(char a) {
    // Espera até que o transmissor esteja vazio
    while (serial_transmit_empty() == 0);
    
    // Envia o caractere
    outb(COM1, a);
}

// Envia uma string pela porta serial (para logging/debugging)
void serial_print(const char *str) {
    int i = 0;
    while (str[i] != '\0') {
        serial_write(str[i]);
        i++;
    }
}
