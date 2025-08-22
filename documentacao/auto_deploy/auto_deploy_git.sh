#!/bin/bash

# Caminho do repositório e pasta a ser monitorada
 
 
 
REPO_DIR="../"  # altere para o caminho correto do seu repositório
BRANCH="docs-v2"                   # altere para a branch desejada

# Muda para o diretório do repositório ou termina o script se não conseguir
cd "$REPO_DIR" || { echo "Repositório não encontrado: $REPO_DIR"; exit 1; }

# Certifica-se de estar na branch correta e atualiza-a com o repositório remoto
git checkout "$BRANCH"
git pull origin "$BRANCH"

# Verifica se houve qualquer alteração (adição, modificação ou remoção)
if [ -n "$(git status --porcelain)" ]; then
    # Adiciona todas as alterações
    git add -A

    # Após o git add, conta as alterações para compor a mensagem de commit
    ADICIONADOS=$(git diff --cached --name-status | grep '^A' | wc -l)
    MODIFICADOS=$(git diff --cached --name-status | grep '^M' | wc -l)
    REMOVIDOS=$(git diff --cached --name-status | grep '^D' | wc -l)
    
    # Compondo uma mensagem de commit curta, profissional e explicativa
    COMMIT_MSG="[Auto Commit] Adicionados: ${ADICIONADOS}, Modificados: ${MODIFICADOS}, Removidos: ${REMOVIDOS}"
    
    # Cria o commit e envia para o branch remoto
    git commit -m "$COMMIT_MSG"
    git push origin "$BRANCH"
else
    echo "Nenhuma alteração detectada."
fi