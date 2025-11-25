// src/drivers/vga.c
#include <vga.h>
#include <string.h>

static uint16_t* const vga = (uint16_t*)VGA_BUFFER;
static uint16_t cursor_x = 0;
static uint16_t cursor_y = 0;
static uint8_t color = 0x0F; // branco sobre preto

void vga_clear(void)
{
    for (int i = 0; i < VGA_WIDTH * VGA_HEIGHT; i++) {
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
        vga[cursor_y * VGA_WIDTH + cursor_x] = (color << 8) | c;
        cursor_x++;
        if (cursor_x >= VGA_WIDTH) {
            cursor_x = 0;
            cursor_y++;
        }
    }

    if (cursor_y >= VGA_HEIGHT) {
        // scroll simples
        for (int y = 0; y < VGA_HEIGHT - 1; y++) {
            for (int x = 0; x < VGA_WIDTH; x++) {
                vga[y * VGA_WIDTH + x] = vga[(y + 1) * VGA_WIDTH + x];
            }
        }
        for (int x = 0; x < VGA_WIDTH; x++) {
            vga[(VGA_HEIGHT - 1) * VGA_WIDTH + x] = (color << 8) | ' ';
        }
        cursor_y = VGA_HEIGHT - 1;
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
        uint8_t digit = n & 0xF;
        buf[i] = digit < 10 ? '0' + digit : 'A' + digit - 10;
        n >>= 4;
    }
    vga_print(buf);
}
