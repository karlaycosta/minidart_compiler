---
title: "Operadores "
description: "Your documentation starts here."
---

# Operadores em LiPo — Resumo Rápido

Os operadores são símbolos que realizam operações entre valores. Eles são essenciais para cálculos, comparações, controle lógico e manipulação de variáveis.

---

## 1. Operadores Aritméticos  
Usados para calcular valores numéricos ou concatenar textos.

| Operador | Descrição                   | Exemplo                    |
|----------|-----------------------------|----------------------------|
| `+`      | Soma ou concatenação         | `a + b` / `"Oi " + nome`   |
| `-`      | Subtração                   | `preco - desconto`          |
| `*`      | Multiplicação               | `largura * altura`          |
| `/`      | Divisão                    | `total / quantidade`        |
| `%`      | Resto da divisão (módulo)   | `10 % 3` → `1`             |

---

## 2. Operadores de Comparação  
Comparam valores e retornam `verdadeiro` ou `falso`.

| Operador | Descrição               | Exemplo           |
|----------|-------------------------|-------------------|
| `==`     | Igual                   | `idade == 18`     |
| `!=`     | Diferente               | `senha != "1234"` |
| `<`      | Menor que               | `nota < 7`        |
| `>`      | Maior que               | `pontuacao > 100` |
| `<=`     | Menor ou igual          | `tempo <= 60`     |
| `>=`     | Maior ou igual          | `nivel >= 5`      |

---

## 3. Operadores Lógicos  
Combinam expressões booleanas para decisões mais complexas.

| Operador | Nome | Descrição                            |
|----------|-------|------------------------------------|
| `e` / `&&` | AND   | Verdadeiro se todas condições forem verdadeiras |
| `ou` / `||`| OR    | Verdadeiro se alguma condição for verdadeira   |
| `!`       | NOT   | Inverte o valor lógico (verdadeiro → falso)    |

---

## 4. Operadores de Atribuição  
Atualizam o valor de variáveis de forma prática.

| Operador | Descrição                 | Exemplo          |
|----------|---------------------------|------------------|
| `=`      | Atribuição simples        | `x = 10`         |
| `+=`     | Soma e atribui            | `x += 5` (x = x + 5)  |
| `-=`     | Subtrai e atribui         | `x -= 2`         |
| `*=`     | Multiplica e atribui      | `x *= 3`         |
| `/=`     | Divide e atribui          | `x /= 2`         |
| `%=`     | Módulo e atribui          | `x %= 4`         |

---

## 5. Incremento e Decremento  
Aumentam ou diminuem o valor de uma variável numérica em 1.

| Operador | Descrição              |
|----------|------------------------|
| `++`     | Incremento (pré/pós)    |
| `--`     | Decremento (pré/pós)    |

---

## 6. Operador `tipode`  
Retorna o tipo da expressão como texto: `"inteiro"`, `"real"`, `"texto"`, `"logico"`, etc.

```lipo
imprima tipode 42;         // "inteiro"
imprima tipode 3.14;       // "real"
imprima tipode "texto";    // "texto"
imprima tipode verdadeiro; // "logico"
```

## 6. Precedência de `Operadores` 

Define a ordem de execução em expressões compostas.

# Precedência dos Operadores em LiPo

| Prioridade | Categoria             | Operadores                   |
|------------|----------------------|------------------------------|
| 1          | Unários              | `!`, `-`, `tipode`, `++`, `--` |
| 2          | Multiplicação/Divisão| `*`, `/`, `%`                |
| 3          | Adição/Subtração     | `+`, `-`                    |
| 4          | Comparação           | `<`, `<=`, `>`, `>=`        |
| 5          | Igualdade            | `==`, `!=`                  |
| 6          | Lógico AND           | `e`                        |
| 7          | Lógico OR            | `ou`                       |
| 8          | Ternário             | `? :`                      |
| 9          | Atribuição           | `=`, `+=`, `-=`, `*=`, `/=`, `%=` |
