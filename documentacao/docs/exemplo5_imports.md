---
title: "Exemplo pratico 5 "
---

# Exemplo 5: `Sistema de Imports`  

```lipo
importar math;
importar io como saida;

real angulo = 1.5708;  // 90 graus em radianos

saida.imprimir("=== Calculadora Científica ===");
saida.imprimir("Ângulo: " + angulo);
saida.imprimir("Seno: " + math.sin(angulo));
saida.imprimir("Cosseno: " + math.cos(angulo));
saida.imprimir("Raiz quadrada de 16: " + math.sqrt(16));
saida.imprimir("2 elevado a 3: " + math.pow(2, 3));

```