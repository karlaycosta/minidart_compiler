---
title: "Identificadores "
---

<br>

Um **identificador** é o nome que damos para variáveis, funções, constantes e outros elementos criados pelo programador.

<br>

# Regras para Identificadores

- Deve começar com **uma letra** (`a` a `z` ou `A` a `Z`) ou um **sublinhado** (`_`)
- Pode conter **letras**, **números** (`0` a `9`) e **sublinhados** (`_`) após o primeiro caractere
- Não pode começar com número, símbolo ou caractere especial diferente de sublinhado

<br>

# Expressão regular que representa essas regras:

```regex
[a-zA-Z_][a-zA-Z0-9_]*
```

<br>

# Exemplos Inválidos


```regex
2nome       // Não pode começar com número
meu-nome    // Hífen (-) não é permitido
@variavel   // Símbolo @ não é permitido

```

<br>

# Por que essa regra existe?

As regras garantem que os nomes sejam fáceis de ler e interpretar pelo computador e evitem conflitos com palavras reservadas ou símbolos especiais da linguagem.

Seguir essas regras ajuda o programa a entender corretamente quais são nomes definidos pelo programador e quais são comandos ou operadores.

