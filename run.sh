#!/bin/bash
# -----------------------------------------------------------------------------
# run.sh - Script de Teste Otimizado para o InfiniteOS
# -----------------------------------------------------------------------------

# 1. Limpa compilações anteriores
echo "--- 1. Limpando arquivos de build antigos..."
make clean

# 2. Compilar e Executar o Kernel (Chama a regra 'run' no Makefile)
# Esta regra chama 'all' e depois o QEMU.
echo "--- 2. Tentando COMPILAR e EXECUTAR o InfiniteOS..."
make run

# A regra 'make run' no Makefile é responsável por verificar se o binário foi criado.

if [ $? -ne 0 ]; then
    echo "--- 🛑 ERRO CRÍTICO DE COMPILAÇÃO OU EXECUÇÃO ---"
    echo "O InfiniteOS não ligou. Verifique as mensagens de erro acima."
    echo "Provável Causa: Ferramentas (gcc/ld) ou Linker Script incorretos."
fi

echo "--- Teste Finalizado ---"
