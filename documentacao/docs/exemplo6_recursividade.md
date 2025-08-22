---
title: " Exemplo 6: Recursividade "
---


# Exemplo `Recursividade`  
 

```lipo
// Função recursiva para calcular a sequência de Fibonacci
real fibonacci(inteiro n) {
    se (n <= 1) {
        retorne n;
    } senao {
        retorne fibonacci(n - 1) + fibonacci(n - 2);
    }
}

// Exibe os 10 primeiros termos da sequência
imprima "Sequência de Fibonacci:";
para i = 0 ate 9 faca {
    imprima "F(" + i + ") = " + fibonacci(i);
}


```