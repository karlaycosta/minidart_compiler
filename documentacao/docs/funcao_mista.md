---
title: "Funções com tipos mistos"
---
<br>

## 3. Funções com tipos mistos
Funções podem aceitar diferentes tipos de dados como entrada e gerar saídas variadas.

**Exemplo:**
```LiPo
texto formatarNome(texto nome, texto sobrenome) {
    retorne nome + " " + sobrenome;
}
//Une o nome e sobrenome com espaço, gerando uma string formatada.
```

**Exemplo com real:**
```LiPo
real calcularMedia(real nota1, real nota2) {
    retorne (nota1 + nota2) / 2;
}
//Calcula a média entre duas notas decimais e retorna o resultado.
```