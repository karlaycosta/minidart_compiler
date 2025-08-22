---
title: "Conversão de Tipos em LiPo "
---

<br>

Na linguagem **LiPo**, algumas conversões de tipos são feitas automaticamente (implícitas), enquanto outras exigem conversão manual (explícita).

<br>

#  Conversão Automática Permitida

Em certas situações, **valores inteiros** são automaticamente convertidos para **valores reais**, especialmente em **operações matemáticas mistas**.

<br>

#  Exemplo:

```lipo
real numero = 42;        // 42 (inteiro) → 42.0 (real)

inteiro a = 10;
real b = 3.5;

real resultado = a + b;  // 10 + 3.5 → 13.5
```

> Como a é um inteiro e b é um real, o valor de a é convertido para real automaticamente durante a operação.

<br>

#  Conversão Não Permitida (Explícita Necessária)

Reais não são convertidos automaticamente para inteiros.
É necessário fazer essa conversão de forma explícita, pois pode haver perda de informação (parte decimal).

<br>

# Exemplo incorreto:

'''bash
inteiro numero = 3.14;   //  ERRO: tentativa de atribuir real a inteiro
'''

> Nesse caso, será necessário aplicar uma conversão explícita 
(quando suportada pela linguagem) para truncar ou arredondar o valor.

