# Makefile do InfiniteOS – versão que funciona 100% no celular + GitHub Actions
CC      = gcc
AS      = nasm
LD      = ld
QEMU    = qemu-system-i386

CFLAGS  = -std=gnu99 -ffreestanding -Wall -Wextra -O2 -g -m32 -march=i386
CFLAGS += -I./include -fno-pic -fno-pie
LDFLAGS = -T boot/linker.ld -m elf_i386 --oformat=binary

# Todos os arquivos C
C_SOURCES = $(shell find src -name '*.c')
OBJECTS   = boot/boot.o $(C_SOURCES:.c=.o)

all: bin/InfiniteOS.img

bin/InfiniteOS.img: bin/InfiniteOS.bin
	dd if=/dev/zero of=$@ bs=1024 count=1440
	dd if=\( < of= \)@ conv=notrunc

bin/InfiniteOS.bin: bin/kernel.elf
	objcopy -O binary \( < \)@

bin/kernel.elf: $(OBJECTS)
	@mkdir -p bin
	\( (LD) \)(LDFLAGS) -o \( @ \)^

%.o: %.c
	@mkdir -p \( (dir \)@)
	\( (CC) \)(CFLAGS) -c \( < -o \)@

boot/%.o: boot/%.asm
	\( (AS) \)< -f elf32 -o $@

run: bin/InfiniteOS.img
	\( (QEMU) -fda \)< -serial stdio -m 128M

clean:
	rm -rf bin src/**/*.o boot/*.o

.PHONY: all clean run
