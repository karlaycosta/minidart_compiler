---
title: "Comentários"

---

<br>

Comentários são **trechos de texto** no código que **não são executados** pelo programa.  
Eles servem para:

- Documentar o código
- Explicar a lógica de funcionamento
- Fazer anotações úteis para quem lê ou mantém o código

<br>

#  Comentário de Linha

No **LiPo**, para criar um comentário de **uma única linha**, use `//` antes do texto.

```LiPo
// Este é um comentário de linha
var x = 10;  // Comentário após uma instrução
```

> Dica: Comentários também podem vir depois de uma instrução na mesma linha.

<br>

# Limitação atual

Atualmente, o LiPo suporta apenas comentários de linha usando `//` .

Comentários de bloco, como:

```LiPo
/* 
   Comentário de várias linhas
   ainda não é suportado.
*/

```

ainda não foram implementados.