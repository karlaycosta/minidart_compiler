# 🚀 Como Usar o MiniDart Compiler Web

## ✅ Problema Resolvido!

A aplicação estava apresentando erro de codificação de caracteres UTF-8. O problema foi corrigido no servidor HTTP.

## 🎯 Como Executar

### 1. **Iniciar o Servidor**
```bash
cd "c:\Users\karla\Documents\Dart - projetos\minidart_compiler\web"
dart run server.dart
```

### 2. **Acessar a Aplicação**
- **Versão JavaScript (Tradicional)**: http://localhost:8080
- **Versão WebAssembly (Otimizada)**: http://localhost:8080/index_wasm.html

## 🛠️ Funcionalidades Disponíveis

### ✨ **Interface Principal**
- **Editor de Código**: Digite código MiniDart com syntax highlighting
- **Exemplos Pré-carregados**: 6 exemplos prontos para testar
- **Execução Interativa**: Botão "Executar" para compilar e executar

### 📊 **Abas de Resultado**
1. **📤 Saída**: Resultado da execução do programa
2. **🌳 AST**: Árvore Sintática Abstrata gerada
3. **⚙️ Bytecode**: Código intermediário produzido
4. **❌ Erros**: Relatório de erros de compilação

### ⌨️ **Comandos MiniDart Suportados**
```dart
// Declaração de variáveis
var nome = "Mundo";
var idade = 25;

// Impressão
imprimir "Olá, Mundo!";
imprimir nome;

// Estruturas de controle
se (idade > 18) {
    imprimir "Maior de idade";
}

// Loops
enquanto (i < 10) {
    imprimir i;
    i = i + 1;
}

// Funções
funcao saudacao(nome) {
    imprimir "Olá, " + nome;
}
```

## 🔧 **Solução dos Problemas**

### **Problema Original**: Erro de codificação UTF-8
- **Causa**: Servidor HTTP não estava configurado para UTF-8
- **Solução**: Adicionado `charset=utf-8` nos headers HTTP

### **Melhorias Implementadas**:
1. ✅ Suporte completo a WebAssembly
2. ✅ Serve todos os tipos de arquivo necessários
3. ✅ Encoding UTF-8 correto
4. ✅ Headers de cache otimizados
5. ✅ Tratamento de erro melhorado

## 🎮 **Como Testar**

1. **Teste Básico**:
   ```dart
   var mensagem = "Olá, MiniDart!";
   imprimir mensagem;
   ```

2. **Teste com Estruturas**:
   ```dart
   var contador = 0;
   enquanto (contador < 3) {
       imprimir "Contagem: " + contador;
       contador = contador + 1;
   }
   ```

3. **Teste de Função**:
   ```dart
   funcao calcular(a, b) {
       var resultado = a + b;
       imprimir resultado;
   }
   
   calcular(5, 3);
   ```

## 🚀 **Próximos Passos**

- Use os exemplos pré-carregados para aprender
- Experimente diferentes comandos MiniDart
- Veja como a AST é gerada para entender o funcionamento
- Compare a performance entre JS e WebAssembly

A aplicação está **100% funcional** agora! 🎉
