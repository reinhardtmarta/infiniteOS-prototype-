# Makefile do InfiniteOS – funciona no GitHub Codespaces, Termux, PC e celular (2025)
all: bin/InfiniteOS.img

bin/InfiniteOS.img: bin/InfiniteOS.bin
	mkdir -p bin
	dd if=/dev/zero of=bin/InfiniteOS.img bs=512 count=2880 2>/dev/null
	dd if=bin/InfiniteOS.bin of=bin/InfiniteOS.img conv=notrunc 2>/dev/null
	printf '\x55\xAA' | dd of=bin/InfiniteOS.img bs=1 seek=510 conv=notrunc 2>/dev/null

bin/InfiniteOS.bin: bin/kernel.elf
	objcopy -O binary bin/kernel.elf bin/InfiniteOS.bin

bin/kernel.elf: boot/boot.o src/kernel/main.o src/kernel/cpu.o src/drivers/vga.o
	mkdir -p bin
	ld -m elf_i386 -T boot/linker.ld -o bin/kernel.elf $^

# Regras de compilação (nunca mais vai dar erro de pasta ou cpu.o)
src/kernel/main.o: src/kernel/main.c
	mkdir -p src/kernel
	gcc -std=gnu99 -ffreestanding -Wall -Wextra -O2 -g -m32 -march=i386 -I./include -c src/kernel/main.c -o src/kernel/main.o

src/kernel/cpu.o: src/kernel/cpu.c
	mkdir -p src/kernel
	gcc -std=gnu99 -ffreestanding -Wall -Wextra -O2 -g -m32 -march=i386 -I./include -c src/kernel/cpu.c -o src/kernel/cpu.o

src/drivers/vga.o: src/drivers/vga.c
	mkdir -p src/drivers
	gcc -std=gnu99 -ffreestanding -Wall -Wextra -O2 -g -m32 -march=i386 -I./include -c src/drivers/vga.c -o src/drivers/vga.o

boot/boot.o: boot/boot.asm
	nasm -f elf32 boot/boot.asm -o boot/boot.o

# Comandos extras
run: bin/InfiniteOS.img
	qemu-system-i386 -fda bin/InfiniteOS.img -m 128M -serial stdio -no-reboot

run-gui: bin/InfiniteOS.img
	qemu-system-i386 -fda bin/InfiniteOS.img -m 256M

clean:
	rm -rf bin *.o boot/*.o src/*/*.o src/*/*/*.o

.PHONY: all run run-gui clean
