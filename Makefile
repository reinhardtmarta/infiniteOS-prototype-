# ==========================================================
# Makefile — InfiniteOS Prototype
# Arquitetura fractal: boot → kernel → drivers
# ==========================================================

ASM = nasm
CC  = gcc
LD  = ld

# ----------------------------------------------------------
# FLAGS
# ----------------------------------------------------------

CFLAGS = -ffreestanding -nostdlib -nodefaultlibs -fno-builtin \
         -fno-pie -fno-stack-protector -m32 -march=i386 \
         -Wall -Wextra -O2 \
         -Isrc -Iinclude

LDFLAGS = -T boot/linker.ld -m elf_i386

# ----------------------------------------------------------
# OBJETOS (crescimento fractal)
# ----------------------------------------------------------

OBJS = \
    boot/boot.o \
    boot/gdt.o \
    boot/idt.o \
    boot/interrupts.o \
    src/kernel/kernel_main.o \
    src/kernel/idt.o \
    src/drivers/vga/vga.o \
    src/drivers/timer/timer.o
    src/kernel/paging.o


# ----------------------------------------------------------
# TARGET PRINCIPAL
# ----------------------------------------------------------

all: kernel.bin

kernel.bin: $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $(OBJS)

# ----------------------------------------------------------
# COMPILAÇÃO ASM
# ----------------------------------------------------------

boot/%.o: boot/%.asm
	$(ASM) -f elf32 $< -o $@

# ----------------------------------------------------------
# COMPILAÇÃO C — kernel
# ----------------------------------------------------------

src/kernel/%.o: src/kernel/%.c
	$(CC) $(CFLAGS) -c $< -o $@

# ----------------------------------------------------------
# COMPILAÇÃO C — drivers
# ----------------------------------------------------------

src/drivers/%.o: src/drivers/%.c
	$(CC) $(CFLAGS) -c $< -o $@

# ----------------------------------------------------------
# LIMPEZA
# ----------------------------------------------------------

clean:
	rm -f $(OBJS) kernel.bin

# ==========================================================
# FIM
# ==========================================================
