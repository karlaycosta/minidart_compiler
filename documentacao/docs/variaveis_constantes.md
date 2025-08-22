---
title: "Conversão"
description: "Your documentation starts here."
---

# Conversão Automática de Tipos

**Permitido:** Inteiros são convertidos automaticamente para reais quando necessário.

```lipo
real numero = 42;        // 42 (inteiro) → 42.0 (real)

inteiro a = 10;
real b = 3.5;

real resultado = a + b;  // 10 + 3.5 → 13.5
```

**Não permitido:** Reais não são convertidos automaticamente para inteiros — é necessário fazer a conversão de forma explícita.

```lipo inteiro número = 3.14;   // ERRO! ```

#  Literais na Linguagem

A tabela abaixo mostra os principais tipos literais utilizados na linguagem **LiPo**:

| Tipo       | Exemplos                                                      | Observações                                 |
|------------|---------------------------------------------------------------|---------------------------------------------|
| **Inteiro**   | `42`, `-17`, `0`                                               | Números sem parte decimal                   |
| **Real**      | `3.14`, `-2.5`, `0.0`, `1.0`                                   | Possuem parte decimal                       |
| **Texto**     | `"Olá, mundo!"`, `"Nome: João"`, `""`, `"Aspas: \"texto\""`   | Strings entre aspas duplas (`"`)            |
| **Booleano**  | `verdadeiro`, `falso`                                         | Usados para condições lógicas               |
| **Nulo**      | `nulo`                                                        | Representa ausência de valor ou vazio       |

