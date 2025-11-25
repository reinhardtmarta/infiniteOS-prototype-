all: bin/InfiniteOS.img

bin/InfiniteOS.img: bin/InfiniteOS.bin
	dd if=/dev/zero of=bin/InfiniteOS.img bs=1024 count=1440
	dd if=bin/InfiniteOS.bin of=bin/InfiniteOS.img conv=notrunc

bin/InfiniteOS.bin: bin/kernel.elf
	objcopy -O binary bin/kernel.elf bin/InfiniteOS.bin

bin/kernel.elf: boot/boot.o src/kernel/cpu.o src/drivers/vga.o
	mkdir -p bin
	ld -T boot/linker.ld -m elf_i386 -o bin/kernel.elf boot/boot.o src/kernel/cpu.o src/drivers/vga.o

src/kernel/cpu.o: src/kernel/cpu.c
	mkdir -p src/kernel
	gcc -std=gnu99 -ffreestanding -Wall -Wextra -O2 -g -m32 -march=i386 -I./include -c src/kernel/cpu.c -o src/kernel/cpu.o

src/drivers/vga.o: src/drivers/vga.c
	mkdir -p src/drivers
	gcc -std=gnu99 -ffreestanding -Wall -Wextra -O2 -g -m32 -march=i386 -I./include -c src/drivers/vga.c -o src/drivers/vga.o

boot/boot.o: boot/boot.asm
	nasm -f elf32 boot/boot.asm -o boot/boot.o

run: bin/InfiniteOS.img
	qemu-system-i386 -fda bin/InfiniteOS.img -serial stdio -m 128M -no-reboot

clean:
	rm -rf bin boot/*.o src/*/*.o

.PHONY: all run clean
