---
title: "Exemplo pratico 2 "
description: "Your documentation starts here."
---

# Verificação de Paridade e Cálculo do Fatorial

Este código realiza duas operações com um número inteiro:  
1. Verifica se ele é par ou ímpar.  
2. Calcula o seu fatorial.

---

```lipo
inteiro numero = 15;  // Define a variável 'numero' com valor 15

// Verifica se o número é par ou ímpar
se (numero % 2 == 0) {  
    imprima numero + " é par";  // Se o resto da divisão por 2 for zero, é par
} senao {  
    imprima numero + " é ímpar";  // Caso contrário, é ímpar
}

// Calcula o fatorial do número
inteiro fatorial = 1;  // Inicializa o fatorial como 1

para i = 1 ate numero faca {  
    fatorial *= i;  // Multiplica fatorial pelo valor de i a cada iteração
}

imprima "Fatorial de " + numero + " é " + fatorial;  // Mostra o resultado do fatorial
```