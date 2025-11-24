#!/bin/bash
# -----------------------------------------------------------------------------
# run.sh - Script de Teste e Execução para o InfiniteOS
# -----------------------------------------------------------------------------

# 1. Compilar o Kernel
echo "--- 1. Compilando o InfiniteOS Kernel..."
# Chama o nosso Makefile para construir o binário (InfiniteOS.bin)
make all

# Verifica se a compilação foi bem-sucedida (o arquivo foi criado)
if [ ! -f bin/InfiniteOS.bin ]; then
    echo "ERRO: A compilação falhou! O arquivo bin/InfiniteOS.bin não foi encontrado."
        exit 1
        fi

        # 2. Executar no Emulador QEMU
        echo "--- 2. Executando o InfiniteOS no QEMU..."

        # Opções do QEMU:
        # -fda bin/InfiniteOS.bin: Simula um disquete (floppy disk) com o seu kernel
        # -m 64: Aloca 64MB de RAM para a máquina virtual
        # -cpu pentium: Simula um CPU 32-bit básico (compatível com o seu código)
        # -monitor stdio: Permite interagir com o monitor do QEMU
        # -no-reboot: O QEMU simplesmente sai quando o sistema operacional desliga

        qemu-system-i386 -fda bin/InfiniteOS.bin -m 64 -cpu pentium -monitor stdio -no-reboot

        echo "--- Teste Concluído ---"
        