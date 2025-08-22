---
title: "Exemplo Pratico de função  "
description: "Your documentation starts here."
---


# Exemplo Funções 

```lipo
// Função que verifica se um número é primo
logico ehPrimo(inteiro num) {
    se (num <= 1) {
        retorne falso;
    }

    para i = 2 ate num / 2 faca {
        se (num % i == 0) {
            retorne falso;
        }
    }
    retorne verdadeiro;
}

// Testa a função com números de 2 a 20
para i = 2 ate 20 faca {
    se (ehPrimo(i)) {
        imprima i + " é primo";
    }
}

```