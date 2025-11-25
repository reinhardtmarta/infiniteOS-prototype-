all: InfiniteOS.img

InfiniteOS.img: kernel.bin
	dd if=/dev/zero of=$@ bs=512 count=2880 status=none
	dd if=\( < of= \)@ conv=notrunc status=none
	printf '\x55\xAA' | dd of=$@ bs=1 seek=510 conv=notrunc status=none

kernel.bin: kernel.elf
	objcopy -O binary \( < \)@

kernel.elf: boot/boot.o src/kernel/main.o src/drivers/vga.o
	ld -m elf_i386 -T boot/linker.ld -o \( @ \)^

%.o: %.c
	gcc -ffreestanding -m32 -march=i386 -c \( < -o \)@

boot/boot.o: boot/boot.asm
	nasm -f elf32 \( < -o \)@

clean:
	rm -f *.o *.elf *.bin InfiniteOS.img

.PHONY: all clean
