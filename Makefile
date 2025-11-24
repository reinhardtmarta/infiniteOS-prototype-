# ------------------------------------------------------------------------------
# Makefile para o InfiniteOS - GOLDEN RATIO QUANTUM KERNEL
# SINTAXE CORRIGIDA: Todos os comandos de ação abaixo (que começam com @ ou $)
# DEVEM ser iniciados com um caractere TAB, NUNCA com espaços.
# ------------------------------------------------------------------------------

# --- 1. CONFIGURAÇÃO DE FERRAMENTAS ---
CC = gcc
AS = nasm
LD = ld
QEMU = qemu-system-i386

# --- 2. VARIÁVEIS DE COMPILAÇÃO ---
CFLAGS = -Wall -Wextra -std=gnu99 -ffreestanding -O2 -g
CFLAGS += -I./include
LDFLAGS = -T boot/linker.ld

C_FILES = $(wildcard src/kernel/*.c)
C_FILES += $(wildcard src/drivers/*.c)
C_FILES += $(wildcard src/lib/*.c)
C_FILES += $(wildcard src/arch/*.c)
C_OBJECTS = $(patsubst %.c, %.o, $(C_FILES))

KERNEL = bin/InfiniteOS.bin

# --- 3. REGRAS PRINCIPAIS ---

.PHONY: all clean run

all: $(KERNEL)

$(KERNEL): $(C_OBJECTS) boot/boot.o boot/interrupts.o
	@mkdir -p bin
	@echo "-> Linking the InfiniteOS Kernel..."
	$(LD) $(LDFLAGS) boot/boot.o boot/interrupts.o $(C_OBJECTS) -o bin/kernel.elf
	mv bin/kernel.elf $(KERNEL)
	@echo "-> InfiniteOS Binary created: $(KERNEL)"

# --- 4. REGRAS DE COMPILAÇÃO INDIVIDUAIS ---

%.o: %.c
	@mkdir -p $(dir $@)
	@echo "-> Compiling C file: $<"
	$(CC) $(CFLAGS) -c $< -o $@

boot/boot.o: boot/boot.asm
	@echo "-> Assembling Bootloader: $<"
	$(AS) $< -f elf -o $@

boot/interrupts.o: boot/interrupts.asm
	@echo "-> Assembling Interrupts: $<"
	$(AS) $< -f elf -o $@


# --- 5. REGRAS DE EXECUÇÃO E LIMPEZA ---

run: all
	@echo "--- Executando o InfiniteOS no QEMU ---"
	$(QEMU) -fda $(KERNEL) -m 64 -cpu pentium -serial stdio -no-reboot
	@echo "--- Teste Concluído ---"

clean:
	@echo "-> Cleaning up build files..."
	rm -rf bin *.o src/kernel/*.o src/drivers/*.o src/lib/*.o src/arch/*.o boot/*.o
