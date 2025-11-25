// src/drivers/vga.c – versão sem libc, sem string.h, sem nada
#include <vga.h>
#include <stdint.h>

// Função strlen manual (substitui string.h)
static uint32_t strlen(const char *str)
{
    uint32_t len = 0;
    while (str[len]) len++;
    return len;
}

static uint16_t* const vga = (uint16_t*)0xB8000;
static uint16_t cursor_x = 0;
static uint16_t cursor_y = 0;
static uint8_t color = 0x0F; // branco sobre preto

void vga_clear(void)
{
    for (int i = 0; i < 80 * 25; i++) {
        vga[i] = (color << 8) | ' ';
    }
    cursor_x = cursor_y = 0;
}

void vga_putchar(char c)
{
    if (c == '\n') {
        cursor_x = 0;
        cursor_y++;
    } else if (c == '\r') {
        cursor_x = 0;
    } else {
        vga[cursor_y * 80 + cursor_x] = (color << 8) | c;
        cursor_x++;
        if (cursor_x >= 80) {
            cursor_x = 0;
            cursor_y++;
        }
    }

    if (cursor_y >= 25) {
        // scroll simples
        for (int y = 0; y < 24; y++) {
            for (int x = 0; x < 80; x++) {
                vga[y * 80 + x] = vga[(y + 1) * 80 + x];
            }
        }
        for (int x = 0; x < 80; x++) {
            vga[24 * 80 + x] = (color << 8) | ' ';
        }
        cursor_y = 24;
    }
}

void vga_print(const char *str)
{
    while (*str) vga_putchar(*str++);
}

void vga_print_hex(uint32_t n)
{
    char buf[11] = "0x00000000";
    for (int i = 9; i >= 2; i--) {
        uint8_t d = n & 0xF;
        buf[i] = (d < 10) ? '0' + d : 'A' + d - 10;
        n >>= 4;
    }
    vga_print(buf);
}
