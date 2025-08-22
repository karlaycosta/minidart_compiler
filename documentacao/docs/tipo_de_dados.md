---
title: "Tipos de Dados "
---

<br>

A linguagem **LiPo** possui um conjunto simples e eficiente de **tipos de dados primitivos** utilizados para declarar **variáveis**, **constantes** e **expressões**.  
Esses tipos permitem uma programação mais clara, direta e acessível.

<br>

#  Tipos Primitivos Disponíveis

Abaixo estão os principais tipos primitivos suportados pela linguagem:

| Tipo     | Descrição                                              | Exemplos                        |
|----------|--------------------------------------------------------|---------------------------------|
| `inteiro`| Números inteiros (positivos, negativos e zero)         | `-5`, `0`, `42`                 |
| `real`   | Números com casas decimais (ponto flutuante)           | `3.14`, `-2.5`, `0.001`         |
| `texto`  | Sequência de caracteres (strings)                      | `"Olá mundo"`, `""`, `"Teste"` |
| `lógico` | Valores booleanos (verdadeiro ou falso)                | `verdadeiro`, `falso`          |

> **Dica:**  
> O tipo de dado escolhido define as 
> operações que você poderá realizar com ele.


<br>

#  Tipo `inteiro`

Utilizado para representar números inteiros. Pode ser positivo, negativo ou zero.

## Exemplos:

```lipo
inteiro idade = 25;
inteiro temperatura = -10;
inteiro quantidade = 0;
```

<br>

# Tipo `real` 

Representa números com parte decimal. Útil para medidas, porcentagens, notas, etc.

## Exemplos:

```lipo
real nota = 8.75;
real peso = 65.5;
real temperatura = -3.2;
```

<br>

# Tipo `texto`

Utilizado para armazenar cadeias de caracteres como palavras, frases e símbolos.

## Exemplos:

```lipo
texto nome = "Maria";
texto mensagem = "Bem-vindo!";
texto vazio = "";
```

> Observação:
Textos são sempre definidos entre aspas duplas (").

<br>

# Tipo `lógico`

Usado para expressar valores booleanos: verdadeiro ou falso. Ideal para estruturas de decisão.

## Exemplos:

```lipo
lógico aprovado = verdadeiro;
lógico ligado = falso;
```

<br>

# Dicas para o uso de tipos


* Utilize o tipo adequado para economizar memória e evitar erros de execução.

* Ao fazer comparações ou condições, use o tipo lógico.

* Aspas são obrigatórias em variáveis do tipo texto.

* Utilize ponto (.) e não vírgula (,) para separar casas decimais no tipo real.

 





