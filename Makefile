# InfiniteOS – Makefile
all: bin/InfiniteOS.img

# ======= VARIÁVEIS (Movidas para o topo) =======
AS = nasm
LD = ld

# ======= IMAGEM FINAL (Cria o disco virtual e adiciona a assinatura mágica) =======
bin/InfiniteOS.img: kernel.bin
	mkdir -p bin
	dd if=/dev/zero of=bin/InfiniteOS.img bs=512 count=2880 status=none
	dd if=kernel.bin of=bin/InfiniteOS.img conv=notrunc status=none
	printf '\x55\xAA' | dd of=bin/InfiniteOS.img bs=1 seek=510 conv=notrunc status=none

# ======= CONVERSÃO ELF → BINÁRIO =======
kernel.bin: kernel.elf
	objcopy -O binary kernel.elf kernel.bin

# ======= LINKER (CORRIGIDO: Não inclui gdt.o e interrupts.o) =======
# O boot.o agora contém a GDT. O interrupts.o precisa ser linkado separadamente.
kernel.elf: boot/boot.o boot/interrupts.o src/kernel/main.o src/drivers/vga.o
	$(LD) -m elf_i386 -T boot/linker.ld -o kernel.elf boot/boot.o boot/interrupts.o src/kernel/main.o src/drivers/vga.o

# ======= COMPILAÇÃO C =======
src/kernel/main.o: src/kernel/main.c
	gcc -ffreestanding -m32 -march=i386 -c src/kernel/main.c -o src/kernel/main.o

src/drivers/vga.o: src/drivers/vga.c
	gcc -ffreestanding -m32 -march=i386 -c src/drivers/vga.c -o src/drivers/vga.o

# ======= COMPILAÇÃO ASSEMBLY =======

# 1. Compila o boot.asm (AGORA INCLUI GDT)
boot/boot.o: boot/boot.asm boot/gdt.asm
	$(AS) -f elf32 boot/boot.asm -o boot/boot.o

# 2. Compila o interrupts.asm
boot/interrupts.o: boot/interrupts.asm
	$(AS) -f elf32 boot/interrupts.asm -o boot/interrupts.o

# ======= LIMPEZA =======
clean:
	rm -rf bin *.o *.elf *.bin boot/*.o src/*/*.o

.PHONY: all clean
