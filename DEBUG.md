# 🔍 **Sistema de Debug Completo - MiniDart Compiler v1.12.11**

Este documento oferece um guia completo sobre como usar todas as funcionalidades de debug disponíveis no MiniDart Compiler.

---

## 📋 **Índice**

- [Visão Geral](#-visão-geral)
- [Flags de Debug do Compilador](#-flags-de-debug-do-compilador)
- [Funções Nativas de Debug](#-funções-nativas-de-debug)
- [Debug da VM em Tempo Real](#-debug-da-vm-em-tempo-real)
- [Exemplos Práticos](#-exemplos-práticos)
- [Casos de Uso Comuns](#-casos-de-uso-comuns)
- [Dicas e Melhores Práticas](#-dicas-e-melhores-práticas)

---

## 🎯 **Visão Geral**

O sistema de debug do MiniDart oferece três níveis de debugging:

1. **🚩 Flags de Compilador** - Debug durante a compilação (lexer, parser, semantic, vm)
2. **📝 Funções Nativas** - Debug dentro do código MiniDart (`debug()`, `tipo()`, `info_debug()`)
3. **⚡ VM em Tempo Real** - Monitoramento da execução instrução por instrução

### **🎛️ Modos de Debug Disponíveis**

| Modo | Flag | Descrição |
|------|------|-----------|
| **Tokens** | `--debug-tokens` | Mostra todos os tokens do lexer |
| **Parser** | `--debug-parser` | Mostra processo de parsing e AST |
| **Semântico** | `--debug-semantic` | Mostra análise semântica detalhada |
| **VM** | `--debug-vm` | Mostra execução instrução por instrução |
| **Completo** | `--debug-all` / `-d` | Ativa todos os modos simultaneamente |

---

## 🚩 **Flags de Debug do Compilador**

### **1. Debug de Tokens (`--debug-tokens`)**

Mostra todos os tokens gerados pelo analisador léxico:

```bash
dart run bin/compile.dart exemplos/exemplo.mdart --debug-tokens
```

**Saída típica:**
```
--- DEBUG: Tokens ---
[0] VAR (var) na linha 1
[1] IDENTIFIER (numero) na linha 1
[2] EQUAL (=) na linha 1
[3] NUMBER (42) na linha 1
[4] SEMICOLON (;) na linha 1
[5] SE (se) na linha 2
[6] LEFT_PAREN (() na linha 2
...
[62] EOF na linha 10
--------------------
```

**🎯 Quando usar:**
- Problemas de sintaxe não identificados
- Verificar se keywords estão sendo reconhecidas
- Debugging do analisador léxico

---

### **2. Debug do Parser (`--debug-parser`)**

Mostra o processo de análise sintática e a estrutura da AST:

```bash
dart run bin/compile.dart exemplos/exemplo.mdart --debug-parser
```

**Saída típica:**
```
--- DEBUG: Parser ---
Parsing statement: VarStatement
  Variable: numero
  Type: null
  Initializer: LiteralExpression(42)
Parsing statement: IfStatement
  Condition: BinaryExpression(numero > 10)
  Then branch: BlockStatement
...
--------------------
```

**🎯 Quando usar:**
- Erros de precedência de operadores
- Problemas com estruturas de controle
- Verificar se a AST está sendo construída corretamente

---

### **3. Debug Semântico (`--debug-semantic`)**

Mostra a análise semântica detalhada:

```bash
dart run bin/compile.dart exemplos/exemplo.mdart --debug-semantic
```

**Saída típica:**
```
--- DEBUG: Semantic ---
Entering scope: global
Declaring variable: numero (type: inteiro)
Resolving variable: numero
Type check: BinaryExpression (inteiro > inteiro) → logico
Exiting scope: global
------------------------
```

**🎯 Quando usar:**
- Erros de tipo não identificados
- Problemas de escopo de variáveis
- Verificar análise de tipos

---

### **4. Debug da VM (`--debug-vm`)**

Mostra execução instrução por instrução:

```bash
dart run bin/compile.dart exemplos/exemplo.mdart --debug-vm
```

**Saída típica:**
```
--- DEBUG: VM ---
IP: 0, Stack: [], Globals: {}
Executing: OP_CONSTANT [0] → 42

IP: 1, Stack: [42], Globals: {}
Executing: OP_DEFINE_GLOBAL [0] → numero

IP: 2, Stack: [], Globals: {numero: 42}
Executing: OP_GET_GLOBAL [0] → numero
...
-----------------
```

**🎯 Quando usar:**
- Problemas de execução em runtime
- Verificar estado da pilha e variáveis
- Debugging de lógica complexa

---

### **5. Debug Completo (`--debug-all` / `-d`)**

Ativa todos os modos simultaneamente:

```bash
dart run bin/compile.dart exemplos/exemplo.mdart --debug-all
# ou
dart run bin/compile.dart exemplos/exemplo.mdart -d
```

**🎯 Quando usar:**
- Análise completa de problemas complexos
- Desenvolvimento de novas funcionalidades
- Entendimento profundo do processo de compilação

---

## 📝 **Funções Nativas de Debug**

### **1. Função `debug(valor)`**

Inspeciona um valor e retorna o valor original (não interrompe o fluxo):

```minidart
var numero = 42;
var resultado = debug(numero);  // Inspeciona e retorna 42
imprima resultado;              // 42
```

**Saída típica:**
```
🔍 DEBUG: valor=42, tipo=inteiro
42
```

**Características:**
- ✅ **Não invasiva** - Retorna o valor original
- ✅ **Inspetora** - Mostra valor e tipo
- ✅ **Flexível** - Funciona com qualquer tipo

---

### **2. Função `tipo(valor)`**

Retorna o tipo de uma variável como string:

```minidart
var numero = 42;
var decimal = 3.14;
var texto = "MiniDart";
var flag = verdadeiro;

imprima tipo(numero);   // "inteiro"
imprima tipo(decimal);  // "real"
imprima tipo(texto);    // "texto"
imprima tipo(flag);     // "logico"
```

**Tipos suportados:**
- `inteiro` - para valores `int`
- `real` - para valores `double`
- `texto` - para valores `String`
- `logico` - para valores `bool`
- `nulo` - para valores `null`
- `desconhecido` - fallback

---

### **3. Função `info_debug()`**

Mostra informações do sistema:

```minidart
info_debug();
```

**Saída típica:**
```
=== INFORMAÇÕES DE DEBUG ===
MiniDart Compiler v1.12.11
Sistema de Debug Ativo
Desenvolvido em Dart
============================
```

---

## ⚡ **Debug da VM em Tempo Real**

### **Componentes do Debug da VM**

Quando `--debug-vm` está ativo, cada instrução mostra:

1. **IP (Instruction Pointer)** - Posição atual da execução
2. **Stack State** - Estado completo da pilha
3. **Global Variables** - Variáveis globais disponíveis
4. **Current Instruction** - OpCode e operandos

### **Exemplo de Fluxo de Execução**

```minidart
var x = 10;
x = x + 5;
imprima x;
```

**Debug Output:**
```
IP: 0, Stack: [], Globals: {}
Executing: OP_CONSTANT [0] → 10

IP: 1, Stack: [10], Globals: {}
Executing: OP_DEFINE_GLOBAL [0] → x

IP: 2, Stack: [], Globals: {x: 10}
Executing: OP_GET_GLOBAL [0] → x

IP: 3, Stack: [10], Globals: {x: 10}
Executing: OP_CONSTANT [1] → 5

IP: 4, Stack: [10, 5], Globals: {x: 10}
Executing: OP_ADD

IP: 5, Stack: [15], Globals: {x: 10}
Executing: OP_SET_GLOBAL [0] → x

IP: 6, Stack: [], Globals: {x: 15}
Executing: OP_GET_GLOBAL [0] → x

IP: 7, Stack: [15], Globals: {x: 15}
Executing: OP_PRINT
15
```

---

## 💡 **Exemplos Práticos**

### **Exemplo 1: Debug Básico**

```minidart
// exemplo_debug_basico.mdart
var numero = 25;
var decimal = 3.14;
var nome = "Debug";

imprima "=== TESTE BÁSICO ===";
imprima debug(numero);
imprima debug(decimal);
imprima debug(nome);

imprima "Tipos:";
imprima "numero: " + tipo(numero);
imprima "decimal: " + tipo(decimal);
imprima "nome: " + tipo(nome);

info_debug();
```

**Como executar:**
```bash
# Execução normal
dart run bin/compile.dart exemplos/exemplo_debug_basico.mdart

# Com debug de VM
dart run bin/compile.dart exemplos/exemplo_debug_basico.mdart --debug-vm

# Debug completo
dart run bin/compile.dart exemplos/exemplo_debug_basico.mdart -d
```

---

### **Exemplo 2: Debug de Função**

```minidart
// exemplo_debug_funcao.mdart
funcao inteiro calcular(inteiro a, inteiro b) {
    var soma = debug(a + b);
    imprima "Tipo da soma: " + tipo(soma);
    retornar soma;
}

var x = debug(10);
var y = debug(20);
var resultado = calcular(x, y);

imprima "Resultado final: " + debug(resultado);
```

**Como executar:**
```bash
# Debug da VM para ver chamadas de função
dart run bin/compile.dart exemplos/exemplo_debug_funcao.mdart --debug-vm
```

---

### **Exemplo 3: Debug de Estruturas de Controle**

```minidart
// exemplo_debug_controle.mdart
var contador = 0;

enquanto (contador < 3) {
    imprima "Iteração: " + debug(contador);
    contador = debug(contador + 1);
    
    se (debug(contador) == 2) {
        imprima "Ponto médio alcançado!";
    }
}

imprima "Contador final: " + debug(contador);
```

**Como executar:**
```bash
# Debug completo para ver todo o fluxo
dart run bin/compile.dart exemplos/exemplo_debug_controle.mdart -d
```

---

## 🎯 **Casos de Uso Comuns**

### **1. Debugging de Erros de Compilação**

```bash
# Erro léxico - verificar tokens
dart run bin/compile.dart arquivo.mdart --debug-tokens

# Erro sintático - verificar parser
dart run bin/compile.dart arquivo.mdart --debug-parser

# Erro semântico - verificar tipos
dart run bin/compile.dart arquivo.mdart --debug-semantic
```

### **2. Debugging de Comportamento Runtime**

```bash
# Ver execução instrução por instrução
dart run bin/compile.dart arquivo.mdart --debug-vm

# Debugging completo
dart run bin/compile.dart arquivo.mdart --debug-all
```

### **3. Inspeção de Valores no Código**

```minidart
// Usar debug() para inspecionar valores
var valor = calcularAlgo();
valor = debug(valor);  // Inspeciona mas mantém o fluxo

// Verificar tipos
se (tipo(valor) == "inteiro") {
    imprima "É um número inteiro";
}
```

### **4. Análise de Performance**

```minidart
// Contar instruções com debug da VM
funcao inteiro fibonacci(inteiro n) {
    se (debug(n) <= 1) {
        retornar debug(n);
    }
    retornar fibonacci(n - 1) + fibonacci(n - 2);
}

var resultado = fibonacci(5);
```

---

## 🛠️ **Dicas e Melhores Práticas**

### **✅ Boas Práticas**

1. **Use `debug()` para não quebrar o fluxo**:
   ```minidart
   var x = debug(calcular());  // ✅ Inspeciona e mantém o valor
   ```

2. **Combine flags para análise específica**:
   ```bash
   # Só parser e semântico
   dart run bin/compile.dart arquivo.mdart --debug-parser --debug-semantic
   ```

3. **Use `info_debug()` para informações do ambiente**:
   ```minidart
   // No início do programa para contexto
   info_debug();
   ```

4. **`tipo()` para verificações condicionais**:
   ```minidart
   se (tipo(variavel) == "inteiro") {
       // Lógica específica para inteiros
   }
   ```

### **⚠️ Evite**

1. **Não use apenas `imprima` para debug**:
   ```minidart
   imprima valor;        // ❌ Não mostra tipo
   imprima debug(valor); // ✅ Mostra valor e tipo
   ```

2. **Não ignore o debug da VM para problemas de execução**:
   ```bash
   # ❌ Só resultado
   dart run bin/compile.dart arquivo.mdart
   
   # ✅ Ver execução completa
   dart run bin/compile.dart arquivo.mdart --debug-vm
   ```

### **🔧 Troubleshooting**

| Problema | Solução |
|----------|---------|
| **Erro léxico** | Use `--debug-tokens` |
| **Erro sintático** | Use `--debug-parser` |
| **Erro de tipo** | Use `--debug-semantic` |
| **Comportamento estranho** | Use `--debug-vm` |
| **Problema complexo** | Use `--debug-all` |

### **📊 Interpretando Saídas**

**Debug de Tokens:**
- Verifique se keywords são reconhecidas
- Confirme numeração sequencial
- Observe tipos de token corretos

**Debug de Parser:**
- Verifique estrutura da AST
- Confirme tipos de statement
- Observe precedência de operadores

**Debug Semântico:**
- Verifique declarações de variáveis
- Confirme análise de tipos
- Observe escopo de variáveis

**Debug de VM:**
- Monitore estado da pilha
- Verifique variáveis globais
- Acompanhe IP (Instruction Pointer)

---

## 🎉 **Exemplo Completo de Uso**

Crie o arquivo `debug_completo_exemplo.mdart`:

```minidart
// Debug completo - todos os recursos
imprima "=== SISTEMA DE DEBUG MINIDART ===";
info_debug();

// Variáveis com debug
var numero = debug(42);
var decimal = debug(3.14);
var texto = debug("MiniDart");

// Verificação de tipos
imprima "Tipos detectados:";
imprima "numero: " + tipo(numero);
imprima "decimal: " + tipo(decimal);
imprima "texto: " + tipo(texto);

// Função com debug
funcao inteiro somar(inteiro a, inteiro b) {
    var resultado = debug(a + b);
    imprima "Soma calculada: " + tipo(resultado);
    retornar resultado;
}

// Teste da função
var soma = somar(debug(numero), debug(10));
imprima "Resultado final: " + debug(soma);

// Estrutura de controle com debug
se (debug(soma > 50)) {
    imprima "Soma maior que 50!";
} senao {
    imprima "Soma menor ou igual a 50";
}

imprima "=== FIM DO DEBUG ===";
```

**Execute com:**
```bash
# Debug completo - vê tudo
dart run bin/compile.dart debug_completo_exemplo.mdart --debug-all

# Só execução com debug nativo
dart run bin/compile.dart debug_completo_exemplo.mdart

# Só VM debug
dart run bin/compile.dart debug_completo_exemplo.mdart --debug-vm
```

---

**🎯 O sistema de debug do MiniDart oferece ferramentas poderosas para entender e depurar tanto o processo de compilação quanto a execução do seu código. Use essas ferramentas para se tornar mais eficiente no desenvolvimento em MiniDart!**
