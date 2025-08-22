---
title: "Break"
description: "Comando para interromper a execução de loops"
---

# Break (Parar)

O comando **`parar`** é usado para **interromper imediatamente a execução de um loop**, seja ele um `enquanto` (while), `para` (for) ou outro tipo de repetição.

Quando o programa encontra um `parar`, ele sai do loop atual e continua a execução a partir da próxima linha após o loop.

---

## Exemplo prático

```dart
enquanto (verdadeiro) {
    se (condicao) {
        parar;  // interrompe o loop e sai imediatamente
    }
    // outras instruções do loop
}
