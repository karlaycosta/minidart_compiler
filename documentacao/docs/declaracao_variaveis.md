---
title: "Declaração de Variáveis"
description: "Your documentation starts here."
---


#  Declaração com Tipo Explícito

Na linguagem **LiPo**, as variáveis podem ser declaradas especificando seu tipo de forma clara e direta. Veja exemplos:

| Tipo      | Exemplo                      | Significado                        |
|-----------|------------------------------|------------------------------------|
| `inteiro` | `inteiro idade = 25;`        | Declara a variável `idade` como número inteiro |
| `real`    | `real altura = 1.75;`        | Declara `altura` como número com casas decimais |
| `texto`   | `texto nome = "Maria";`      | Declara `nome` como uma string     |
| `logico`  | `logico ativo = verdadeiro;` | Declara `ativo` como valor booleano (`verdadeiro` ou `falso`) |


#  Declaração com Inferência de Tipo

Na linguagem **LiPo**, também é possível declarar variáveis sem especificar o tipo explicitamente.  
A palavra-chave `var` permite que o compilador **deduza automaticamente o tipo** com base no valor atribuído.

| Declaração                        | Tipo Inferido     | Explicação                             |
|----------------------------------|-------------------|----------------------------------------|
| `var idade = 25;`                | `inteiro`         | Valor é um número inteiro              |
| `var altura = 1.75;`             | `real`            | Valor possui casas decimais            |
| `var nome = "Maria";`            | `texto`           | Valor é uma string entre aspas         |
| `var ativo = verdadeiro;`        | `lógico`          | Valor é booleano (`verdadeiro` ou `falso`) |

#  Declaração Sem Inicialização

Em **LiPo**, é possível declarar variáveis sem atribuir imediatamente um valor.  
Nesse caso, apenas o **tipo** e o **nome da variável** são definidos, e o valor será atribuído depois.

| Declaração              | Tipo     | Situação                              |
|--------------------------|----------|----------------------------------------|
| `inteiro contador;`      | inteiro  | Variável numérica sem valor inicial    |
| `real media;`            | real     | Número com ponto flutuante, sem valor  |
| `texto resultado;`       | texto    | String declarada, mas ainda vazia      |

>  Importante: Usar variáveis não inicializadas pode causar erros se forem acessadas antes de receber um valor.