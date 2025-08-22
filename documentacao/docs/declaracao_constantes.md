---
title: "Declaração de Constantes"
description: "Your documentation starts here."
---

#  Constantes com Tipo Explícito

Em **LiPo**, constantes são declaradas com a palavra-chave `constante`, seguida do **tipo** e do **nome em letras maiúsculas**, por convenção. Elas **não podem ser alteradas após a atribuição**.

| Declaração                             | Tipo      | Significado                                |
|----------------------------------------|-----------|--------------------------------------------|
| `constante inteiro MAXIMO = 100;`      | inteiro   | Valor inteiro fixo para `MAXIMO`           |
| `constante real PI = 3.14159;`         | real      | Valor decimal fixo para `PI`               |
| `constante texto VERSAO = "v1.0.0";`   | texto     | Texto fixo representando a versão do sistema |
| `constante logico DEBUG = verdadeiro;` | lógico    | Flag booleana para modo de depuração       |

> Dica: Use constantes para valores que não devem mudar durante a execução do programa. Isso melhora a legibilidade e evita erros.

#  Constantes com Inferência de Tipo

Assim como variáveis, constantes podem ser declaradas usando `constante var`, onde o tipo é inferido automaticamente pelo valor atribuído.

| Declaração                     | Tipo Inferido | Descrição                                  |
|--------------------------------|---------------|---------------------------------------------|
| `constante var LIMITE = 50;`   | inteiro       | Constante inteira com valor fixo            |
| `constante var TAXA = 0.15;`   | real          | Constante real (decimal)                     |
| `constante var NOME = "Sistema";` | texto      | Constante texto (string)                     |



