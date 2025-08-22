---
title: "Estrutura Léxica "
---


A estrutura léxica é o primeiro passo da análise de um código-fonte. Nessa etapa, o programa (chamado de analisador léxico) percorre o código escrito e o separa em partes menores chamadas **tokens**.

Esse processo funciona como se o código fosse uma frase, e o analisador léxico estivesse identificando cada palavra, pontuação e número dessa frase para que o computador possa entender corretamente.

<br>

# O que são Tokens?

Tokens são os menores pedaços de código que ainda têm um significado. Eles são como as palavras de uma linguagem de programação. Um token pode ser, por exemplo:

- Uma palavra-chave (`if`, `while`, `return`)
- Um identificador (como nomes de variáveis: `contador`, `nome`)
- Um número (`10`, `3.14`)
- Um símbolo (`+`, `==`, `(`, `)`)
- Uma string (`"Olá, mundo!"`)

<br>


# O que o analisador léxico ignora?

Ao transformar o código em tokens, o analisador ignora automaticamente elementos que **não afetam a lógica do programa**, como:

- **Espaços em branco**
- **Quebras de linha**
- **Tabulações**
- **Comentários**

Esses elementos servem apenas para organizar visualmente o código e facilitar a leitura humana, mas não influenciam no funcionamento do programa.

<br>


# Exemplo prático

Considere o seguinte trecho de código:

```lipo
// Soma dois números
resultado = a + b
```

<br>


#  Análise Léxica: Identificação de Tokens

O analisador léxico vai identificar os seguintes tokens no código:

| **Trecho do Código** | **Token Identificado**         |
|----------------------|---------------------------------|
| `resultado`          | identificador                   |
| `=`                  | símbolo de atribuição           |
| `a`                  | identificador                   |
| `+`                  | operador de adição              |
| `b`                  | identificador                   |

> O comentário (`// Soma dois números`) e os espaços em branco **serão ignorados**.

<br>


#  Por que isso é importante?

A **análise léxica** é essencial para que o compilador ou interpretador compreenda corretamente o que o programador escreveu.

Sem essa divisão em tokens, o código seria apenas uma **sequência confusa de caracteres** para a máquina.

