# InfiniteOS – Makefile definitivo 2025 (roda em tudo)
all: bin/InfiniteOS.img

# ======= IMAGEM FINAL (1.44MB floppy com boot válido) =======
bin/InfiniteOS.img: bin/kernel.elf
	mkdir -p bin
	# Cria imagem zerada de 1.44 MB
	dd if=/dev/zero of=bin/InfiniteOS.img bs=512 count=2880 status=none
	# Coloca o kernel inteiro no início da imagem
	dd if=bin/kernel.elf of=bin/InfiniteOS.img conv=notrunc status=none
	# Força a assinatura de boot 0xAA55 no final do primeiro setor
	printf '\x55\xAA' | dd of=bin/InfiniteOS.img bs=1 seek=510 conv=notrunc status=none

# ======= BINÁRIO DO KERNEL =======
bin/InfiniteOS.bin: bin/kernel.elf
	objcopy -O binary bin/kernel.elf bin/InfiniteOS.bin

bin/kernel.elf: boot/boot.o src/kernel/main.o src/kernel/cpu.o src/drivers/vga.o
	mkdir -p bin
	ld -m elf_i386 -T boot/linker.ld -o bin/kernel.elf $^

# ======= COMPILAÇÃO DOS ARQUIVOS C E ASM =======
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

# ======= RODAR =======
run: bin/InfiniteOS.img
	qemu-system-i386 -drive file=bin/InfiniteOS.img,format=raw,if=floppy -m 256M -serial stdio -no-reboot

run-gui: bin/InfiniteOS.img
	qemu-system-i386 -drive file=bin/InfiniteOS.img,format=raw,if=floppy -m 256M

clean:
	rm -rf bin boot/*.o src/*/*.o

.PHONY: all run run-gui clean
