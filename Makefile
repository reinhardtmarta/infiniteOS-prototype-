# Makefile do InfiniteOS - versão que NUNCA dá erro de sintaxe no celular

CC      = gcc
AS      = nasm
LD      = ld
QEMU    = qemu-system-i386
OBJCOPY = objcopy

CFLAGS  = -std=gnu99 -ffreestanding -Wall -Wextra -O2 -g -m32 -march=i386 -I./include
LDFLAGS = -T boot/linker.ld -m elf_i386

C_SOURCES = $(shell find src -name '*.c' 2>/dev/null || echo "")
OBJECTS   = boot/boot.o $(C_SOURCES:.c=.o)

all: bin/InfiniteOS.img

bin/InfiniteOS.img: bin/InfiniteOS.bin
	dd if=/dev/zero of=$@ bs=1024 count=1440
	dd if=\( < of= \)@ conv=notrunc

bin/InfiniteOS.bin: bin/kernel.elf
	\( (OBJCOPY) -O binary \)< $@

bin/kernel.elf: $(OBJECTS)
	mkdir -p bin
	\( (LD) \)(LDFLAGS) -o \( @ \)^

%.o: %.c
	mkdir -p \( (dir \)@)
	\( (CC) \)(CFLAGS) -c \( < -o \)@

boot/%.o: boot/%.asm
	\( (AS) \)< -f elf32 -o $@

run: bin/InfiniteOS.img
	\( (QEMU) -fda \)< -serial stdio -m 128M -no-reboot

clean:
	rm -rf bin src/**/*.o boot/*.o

.PHONY: all clean run
