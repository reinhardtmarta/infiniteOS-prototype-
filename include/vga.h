// include/vga.h
#ifndef _VGA_H
#define _VGA_H

#include <stdint.h>

#define VGA_WIDTH  80
#define VGA_HEIGHT 25
#define VGA_BUFFER 0xB8000

void vga_clear(void);
void vga_print(const char *str);
void vga_print_hex(uint32_t n);
void vga_putchar(char c);
void vga_set_color(uint8_t fg, uint8_t bg);

#endif
