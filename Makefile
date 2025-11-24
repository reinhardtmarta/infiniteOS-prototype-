# ------------------------------------------------------------------------------
# Makefile para o InfiniteOS - GOLDEN RATIO QUANTUM KERNEL
# SOLUÇÃO FINAL: Removida a flag problemática do linker para rodar no Codespace.
# ------------------------------------------------------------------------------

# --- 1. CONFIGURAÇÃO DE FERRAMENTAS ---
# Usando GCC e LD padrão do Codespace
CC = gcc
AS = nasm
LD = ld
QEMU = qemu-system-i386

# --- 2. VARIÁVEIS DE COMPILAÇÃO ---
# Flags essenciais: -ffreestanding (sem biblioteca padrão C)
CFLAGS = -Wall -Wextra -std=gnu99 -ffreestanding -O2 -g
CFLAGS += -m32                       # Tenta forçar a compilação para 32-bit (i386)
CFLAGS += -I./include                # Inclui a pasta de cabeçalhos
LDFLAGS = -T boot/linker.ld          # O Linker Script define o formato de 32-bit

# Localiza todos os arquivos C nas pastas principais
C_FILES = $(wildcard src/kernel/*.c)
C_FILES += $(wildcard src/drivers/*.c)
C_FILES += $(wildcard src/lib/*.c)
C_FILES += $(wildcard src/arch/*.c)   # Incluindo a pasta para CPU/IDT
C_OBJECTS = $(patsubst %.c, %.o, $(C_FILES))

# Nome do arquivo final do kernel
KERNEL = bin/InfiniteOS.bin

# --- 3. REGRAS PRINCIPAIS ---

.PHONY: all clean run

# Regra padrão: Compila tudo (o alvo é bin/InfiniteOS.bin)
all: $(KERNEL)

# Regra para compilar o kernel (bin/InfiniteOS.bin)
$(KERNEL): $(C_OBJECTS) boot/boot.o boot/interrupts.o
	@mkdir -p bin
	@echo "-> Linking the InfiniteOS Kernel..."
	# Linka o boot.o, os objetos C, e o interrupts.o
	$(LD) $(LDFLAGS) boot/boot.o boot/interrupts.o $(C_OBJECTS) -o bin/kernel.elf
	
	# Move o arquivo ELF para ser carregado pelo QEMU
	mv bin/kernel.elf $(KERNEL)
	@echo "-> InfiniteOS Binary created: $(KERNEL)"

# --- 4. REGRAS DE COMPILAÇÃO INDIVIDUAIS ---

# Regra para Compilar Arquivos C (.c -> .o)
%.o: %.c
	@mkdir -p $(dir $@)
	@echo "-> Compiling C file: $<"
	$(CC) $(CFLAGS) -c $< -o $@

# Regra para o Bootloader (Assembly .asm -> .o)
boot/boot.o: boot/boot.asm
	@echo "-> Assembling Bootloader: $<"
	$(AS) $< -f elf -o $@

# Regra para Assembly de Interrupções (Novo arquivo)
boot/interrupts.o: boot/interrupts.asm
	@echo "-> Assembling Interrupts: $<"
	$(AS) $< -f elf -o $@


# --- 5. REGRAS DE EXECUÇÃO E LIMPEZA ---

# Executa o Kernel no Emulador QEMU
run: all
	@echo "--- Executando o InfiniteOS no QEMU ---"
	# -serial stdio: Conecta a porta serial (para o log de debug) ao seu terminal
	$(QEMU) -fda $(KERNEL) -m 64 -cpu pentium -serial stdio -no-reboot
	@echo "--- Teste Concluído ---"

# Limpa todos os arquivos gerados
clean:
	@echo "-> Cleaning up build files..."
	rm -rf bin *.o src/kernel/*.o src/drivers/*.o src/lib/*.o src/arch/*.o boot/*.o
