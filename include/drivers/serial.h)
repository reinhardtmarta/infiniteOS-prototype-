/*
 * include/drivers/serial.h - Definições para o Driver Serial (COM1)
 */

#ifndef SERIAL_H
#define SERIAL_H

#include "../types.h" // Para usar u16

// Endereço base da Porta Serial 1 (COM1)
#define COM1 0x3F8 

// Protótipos das funções do driver
void serial_init();
int serial_received();
char serial_read();
int serial_transmit_empty();
void serial_write(char a);
void serial_print(const char *str);

#endif
