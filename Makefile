# ======================================================
# infiniteOS - Makefile Oficial
# ======================================================

AS       = nasm
CC       = gcc
LD       = ld
OBJCOPY  = objcopy

CFLAGS = -m32 -ffreestanding -fno-pie -nostdlib -nodefaultlibs \
         -fno-builtin -fno-stack-protector \
         -Wall -Wextra -O2 -I./include

ASFLAGS = -f elf32
LDFLAGS = -m elf_i386 -T boot/linker.ld

BOOT_OBJS   = boot/boot.o  boot/gdt.o  boot/idt.o  boot/interrupts.o
KERNEL_OBJS = src/kernel/kernel_main.o src/kernel/isr.o
DRIVER_OBJS = src/drivers/vga.o

OBJS = $(BOOT_OBJS) $(KERNEL_OBJS) $(DRIVER_OBJS)

BIN_DIR = bin

# ======================================================
# ALVO PRINCIPAL
# ======================================================
all: $(BIN_DIR)/infiniteOS.img

$(BIN_DIR)/infiniteOS.img: kernel.bin
	mkdir -p $(BIN_DIR)
	dd if=/dev/zero of=$(BIN_DIR)/infiniteOS.img bs=512 count=2880 status=none
	dd if=kernel.bin of=$(BIN_DIR)/infiniteOS.img conv=notrunc status=none
	printf "\x55\xAA" | dd of=$(BIN_DIR)/infiniteOS.img bs=1 seek=510 conv=notrunc status=none
	@echo "[OK] infiniteOS.img criado"

# ======================================================
# ELF → BIN
# ======================================================
kernel.bin: kernel.elf
	$(OBJCOPY) -O binary kernel.elf kernel.bin
	@echo "[OK] kernel.bin gerado"

# ======================================================
# LINKAGEM
# ======================================================
kernel.elf: $(OBJS)
	$(LD) $(LDFLAGS) -o kernel.elf $(OBJS)
	@echo "[OK] kernel.elf linkado"

# ======================================================
# COMPILAÇÃO C
# ======================================================
src/kernel/kernel_main.o: src/kernel/kernel_main.c include/vga.h
	$(CC) $(CFLAGS) -c $< -o $@

src/kernel/isr.o: src/kernel/isr.c include/isr.h
	$(CC) $(CFLAGS) -c $< -o $@

src/drivers/vga.o: src/drivers/vga.c include/vga.h
	$(CC) $(CFLAGS) -c $< -o $@

# ======================================================
# ASSEMBLY
# ======================================================
boot/boot.o: boot/boot.asm boot/gdt.asm
	$(AS) $(ASFLAGS) $< -o $@

boot/gdt.o: boot/gdt.asm
	$(AS) $(ASFLAGS) $< -o $@

boot/idt.o: boot/idt.asm
	$(AS) $(ASFLAGS) $< -o $@

boot/interrupts.o: boot/interrupts.asm
	$(AS) $(ASFLAGS) $< -o $@

# ======================================================
# EXECUTAR NO QEMU
# ======================================================
run: $(BIN_DIR)/infiniteOS.img
	qemu-system-i386 -fda $(BIN_DIR)/infiniteOS.img

debug: $(BIN_DIR)/infiniteOS.img
	qemu-system-i386 -s -S -fda $(BIN_DIR)/infiniteOS.img

# ======================================================
# LIMPEZA
# ======================================================
clean:
	rm -rf *.bin *.elf $(BIN_DIR)
	rm -f boot/*.o src/kernel/*.o src/drivers/*.o
	@echo "[OK] Limpeza completa"

.PHONY: all run clean debug
