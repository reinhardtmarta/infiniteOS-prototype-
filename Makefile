# ==========================================================
# Makefile — InfiniteOS Prototype
# Compila bootloader, tabelas, interrupções e kernel C
# ==========================================================

ASM = nasm
CC = gcc
LD = ld

CFLAGS = -ffreestanding -nostdlib -nodefaultlibs -fno-builtin \
         -fno-pie -fno-stack-protector -m32 -march=i386 \
         -Wall -Wextra -O2 -I./include

LDFLAGS = -T linker.ld -m elf_i386

# ----------------------------------------------------------
# OBJETOS
# ----------------------------------------------------------

OBJS = \
    boot/boot.o \
    boot/gdt.o \
    boot/idt.o \
    boot/interrupts.o \
    src/kernel/kernel_main.o

# ----------------------------------------------------------
# REGRAS PRINCIPAIS
# ----------------------------------------------------------

all: kernel.bin

kernel.bin: $(OBJS)
	$(LD) $(LDFLAGS) -o kernel.bin $(OBJS)

# ----------------------------------------------------------
# COMPILAÇÃO ASM
# ----------------------------------------------------------

boot/%.o: boot/%.asm
	$(ASM) -f elf32 $< -o $@

# ----------------------------------------------------------
# COMPILAÇÃO C
# ----------------------------------------------------------

src/kernel/%.o: src/kernel/%.c
	$(CC) $(CFLAGS) -c $< -o $@

# ----------------------------------------------------------
# LIMPEZA
# ----------------------------------------------------------

clean:
	rm -f $(OBJS) kernel.bin

# ==========================================================
# FIM
# ==========================================================
