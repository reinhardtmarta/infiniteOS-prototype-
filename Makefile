CC = gcc
AS = nasm
LD = ld
QEMU = qemu-system-i386
OBJCOPY = objcopy

CFLAGS = -std=gnu99 -ffreestanding -Wall -Wextra -O2 -g -m32 -march=i386 -I./include
LDFLAGS = -T boot/linker.ld -m elf_i386

all: bin/InfiniteOS.img

bin/InfiniteOS.img: bin/InfiniteOS.bin
	dd if=/dev/zero of=$@ bs=1024 count=1440
	dd if=\( < of= \)@ conv=notrunc

bin/InfiniteOS.bin: bin/kernel.elf
	$(OBJCOPY) -O binary bin/kernel.elf bin/InfiniteOS.bin

bin/kernel.elf: boot/boot.o src/kernel/cpu.o src/drivers/vga.o
	mkdir -p bin
	\( (LD) \)(LDFLAGS) -o bin/kernel.elf boot/boot.o src/kernel/cpu.o src/drivers/vga.o

src/kernel/cpu.o: src/kernel/cpu.c
	mkdir -p src/kernel
	gcc $(CFLAGS) -c src/kernel/cpu.c -o src/kernel/cpu.o

src/drivers/vga.o: src/drivers/vga.c
	mkdir -p src/drivers
	gcc $(CFLAGS) -c src/drivers/vga.c -o src/drivers/vga.o

boot/boot.o: boot/boot.asm
	nasm -f elf32 boot/boot.asm -o boot/boot.o

run: bin/InfiniteOS.img
	$(QEMU) -fda bin/InfiniteOS.img -serial stdio -m 128M -no-reboot

clean:
	rm -rf bin boot/*.o src/*/*.o

.PHONY: all clean run
