---
title: "Exemplo pratico 4 "
description: "Your documentation starts here."
---


# Estrutura de Decisão com `escolha` (switch-case)

Este código utiliza a estrutura de decisão `escolha` para executar diferentes blocos de código de acordo com o valor da variável `opcao`.



```lipo
inteiro opcao = 2;  // Define a variável 'opcao' com valor 2

escolha (opcao) {          // Inicia a estrutura de decisão (switch)
    caso 1:                // Se 'opcao' for igual a 1...
        imprima "Opção 1 selecionada";
        parar;             // Encerra este bloco de caso

    caso 2:                // Se 'opcao' for igual a 2...
        imprima "Opção 2 selecionada";
        parar;

    caso 3:                // Se 'opcao' for igual a 3...
        imprima "Opção 3 selecionada";
        parar;

    contrario:             // Se 'opcao' não for nenhum dos casos acima...
        imprima "Opção inválida";
}


```