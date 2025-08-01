---
title: "Loop_Do_While"
description: "Your documentation starts here."
---

# Loop_Do_While (faca ... enquanto):

Semelhante ao while, mas garante pelo menos uma execução, pois a condição é avaliada após o bloco.

# Exemplo: 
var num = 5;
faca {
    imprima num;
    num = num - 1;
} enquanto (num > 0);

//Imprime de 5 até 1. Mesmo que num fosse 0, o bloco seria executado uma vez.

