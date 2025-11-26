# InfiniteOS – Makefile FINAL 100% FUNCIONAL (2025)
# Removidas as variáveis AS/LD de dentro da receita.

all: bin/InfiniteOS.img

# ======= IMAGEM FINAL (vai pro artefato do GitHub Actions) =======
bin/InfiniteOS.img: kernel.bin
	mkdir -p bin
	dd if=/dev/zero of=bin/InfiniteOS.img bs=512 count=2880 status=none
	dd if=kernel.bin of=bin/InfiniteOS.img conv=notrunc status=none
	printf '\x55\xAA' | dd of=bin/InfiniteOS.img bs=1 seek=510 conv=notrunc status=none

# ======= CONVERSÃO ELF → BINÁRIO =======
kernel.bin: kernel.elf
	objcopy -O binary kernel.elf kernel.bin

# ======= LINKER (ATUALIZADO) =======
# Agora inclui boot.o, gdt.o, interrupts.o e os objetos C
kernel.elf: boot/boot.o boot/gdt.o boot/interrupts.o src/kernel/main.o src/drivers/vga.o
	ld -m elf_i386 -T boot/linker.ld -o kernel.elf boot/boot.o boot/gdt.o boot/interrupts.o src/kernel/main.o src/drivers/vga.o

# ======= COMPILAÇÃO C =======
src/kernel/main.o: src/kernel/main.c
	gcc -ffreestanding -m32 -march=i386 -c src/kernel/main.c -o src/kernel/main.o

src/drivers/vga.o: src/drivers/vga.c
	gcc -ffreestanding -m32 -march=i386 -c src/drivers/vga.c -o src/drivers/vga.o

# ======= COMPILAÇÃO ASSEMBLY (NOVAS REGRAS) =======

# 1. Compila o boot.asm
boot/boot.o: boot/boot.asm
	nasm -f elf32 boot/boot.asm -o boot/boot.o

# 2. Compila o gdt.asm (Obrigatório para o linker)
boot/gdt.o: boot/gdt.asm
	nasm -f elf32 boot/gdt.asm -o boot/gdt.o

# 3. Compila o interrupts.asm (Obrigatório para o linker)
boot/interrupts.o: boot/interrupts.asm
	nasm -f elf32 boot/interrupts.asm -o boot/interrupts.o

# ======= LIMPEZA =======
clean:
	rm -rf bin *.o *.elf *.bin boot/*.o src/*/*.o

.PHONY: all clean
