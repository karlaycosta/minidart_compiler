---
title: "Funções Recursivas"
---
<br>

## 4. Funções Recursivas
Uma função recursiva é aquela que chama a si mesma para resolver um problema em etapas menores.

**Declaração e funcionamento:**
```LiPo
inteiro fatorial(inteiro n) {
    se (n <= 1) {
        retorne 1;
    } senao {
        retorne n * fatorial(n - 1);
    }
}
//Cabeçalho: A função fatorial recebe um inteiro n.
//Caso base: Se n for menor ou igual a 1, retorna 1 — evitando chamadas infinitas.
//Chamada recursiva: Se n > 1, retorna n * fatorial(n - 1), quebrando o problema e resolvendo-o em etapas.
```