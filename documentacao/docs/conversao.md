---
title: "Conversão"
description: "Your documentation starts here."
---

# Conversão Automática de Tipos

**Permitido:** Inteiros são convertidos automaticamente para reais quando necessário.

real numero = 42;        // 42 (inteiro) → 42.0 (real)

inteiro a = 10;
real b = 3.5;

real resultado = a + b;  // 10 + 3.5 → 13.5

**Não permitido:** Reais não são convertidos automaticamente para inteiros — é necessário fazer a conversão de forma explícita.

inteiro número = 3.14;   // ERRO!

# Literais

* Inteiros: 42, -17, 0

* Reais: 3.14, -2.5, 0.0, 1.0

* Texto: "Olá, mundo!", "Nome: João", "", "Aspas: \"texto\""

* Booleanos: verdadeiro, falso
	
* Nulo: nulo
