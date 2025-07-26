# 🔍 **Debugger Interativo MiniDart v1.13.0**

## **Visão Geral**

O Debugger Interativo do MiniDart é um sistema avançado de debugging que permite executar código passo a passo, definir breakpoints, monitorar variáveis e visualizar a call stack em tempo real.

---

## 🚀 **Como Usar**

### **Ativação do Debugger**

Para ativar o debugger interativo, use a flag `--debug-interactive` ou `-i`:

```bash
dart run bin/compile.dart arquivo.mdart --debug-interactive
```

### **Interface do Debugger**

Quando o debugger é iniciado, você verá:

```
🔍 ═══════════════════════════════════════════════════════════════
🔍 MINIDART INTERACTIVE DEBUGGER v1.13.0
🔍 ═══════════════════════════════════════════════════════════════
🔍 Digite "help" para ver comandos disponíveis
🔍 ═══════════════════════════════════════════════════════════════

🔍 ═══ ESTADO ATUAL ═══
📍 Linha: 1
🎯 IP: 0
🏷️  Função: main
🔍 ═══════════════════

(minidart-debug) 
```

---

## 📋 **Comandos Disponíveis**

### **🎮 Controle de Execução**

| Comando | Atalho | Descrição |
|---------|--------|-----------|
| `continue` | `c` | Continua a execução até o próximo breakpoint |
| `step` | `s` | Ativa modo step-by-step (pausa a cada instrução) |
| `next` | `n` | Executa a próxima instrução |
| `quit` | `q` | Sai do debugger |

### **🛑 Breakpoints**

| Comando | Descrição |
|---------|-----------|
| `break <linha>` | Adiciona breakpoint na linha especificada |
| `clear <linha>` | Remove breakpoint da linha especificada |
| `clear` | Remove todos os breakpoints |
| `list` | Lista todos os breakpoints ativos |

### **👁️ Monitoramento de Variáveis**

| Comando | Atalho | Descrição |
|---------|--------|-----------|
| `watch <variável>` | `w` | Adiciona variável ao monitoramento |
| `unwatch <variável>` | - | Remove variável do monitoramento |
| `watch` | `w` | Mostra todas as variáveis monitoradas |

### **📊 Informações de Estado**

| Comando | Atalho | Descrição |
|---------|--------|-----------|
| `stack` | `st` | Mostra a call stack atual |
| `vars` | `v` | Mostra todas as variáveis (globais e stack) |
| `state` | - | Mostra o estado atual completo |
| `help` | `h` | Mostra lista de comandos |

---

## 💡 **Exemplos de Uso**

### **Exemplo 1: Breakpoints Básicos**

```bash
# Inicie o debugger
dart run bin/compile.dart exemplos/teste_debug.mdart -i

# No prompt do debugger:
(minidart-debug) break 5      # Adiciona breakpoint na linha 5
(minidart-debug) break 10     # Adiciona breakpoint na linha 10
(minidart-debug) list         # Lista breakpoints
(minidart-debug) continue     # Executa até o primeiro breakpoint
```

### **Exemplo 2: Monitoramento de Variáveis**

```bash
# No prompt do debugger:
(minidart-debug) watch contador    # Monitora variável 'contador'
(minidart-debug) watch soma        # Monitora variável 'soma'
(minidart-debug) step              # Ativa modo step-by-step
(minidart-debug) continue          # Executa mostrando valores monitorados
```

### **Exemplo 3: Debugging de Funções**

```bash
# No prompt do debugger:
(minidart-debug) break 15          # Breakpoint antes da chamada da função
(minidart-debug) continue          # Executa até a função
(minidart-debug) step              # Entra na função
(minidart-debug) stack             # Mostra call stack
(minidart-debug) vars              # Mostra variáveis locais
```

---

## 🎯 **Recursos Avançados**

### **📚 Call Stack Visualization**

O comando `stack` mostra a pilha de chamadas atual:

```
📚 Call Stack:
   🏠 main
      📞 calcular(10, 20) [linha 15]
         📞 somar(10, 20) [linha 8]
```

### **👁️ Watch Variables**

Variáveis adicionadas ao watch são automaticamente monitoradas:

```
👁️ Variáveis monitoradas:
   contador = 2
   soma = 30
   resultado = <undefined>
```

### **📊 Estado Completo**

O comando `state` mostra informações detalhadas:

```
🔍 ═══ ESTADO ATUAL ═══
📍 Linha: 8
🎯 IP: 25
🏷️ Função: somar

👁️ Variáveis monitoradas:
   a = 10
   b = 20
🔍 ═══════════════════
```

---

## 🔧 **Fluxo de Trabalho Típico**

### **1. Preparação**
```bash
# Execute com debugger interativo
dart run bin/compile.dart meu_programa.mdart -i
```

### **2. Configuração de Breakpoints**
```bash
(minidart-debug) break 10    # Breakpoint em linha crítica
(minidart-debug) break 25    # Breakpoint em função importante
```

### **3. Monitoramento**
```bash
(minidart-debug) watch resultado
(minidart-debug) watch contador
```

### **4. Execução Controlada**
```bash
(minidart-debug) continue    # Executa até primeiro breakpoint
(minidart-debug) step        # Ativa step-by-step
(minidart-debug) vars        # Inspeciona estado
(minidart-debug) continue    # Continua execução
```

---

## 🛠️ **Casos de Uso Comuns**

### **🐛 Debugging de Loops**

```minidart
var i = 0;
enquanto (i < 10) {    // <- break 2
    imprima i;         // <- break 3
    i = i + 1;         // <- break 4
}
```

```bash
(minidart-debug) break 2
(minidart-debug) watch i
(minidart-debug) continue
# A cada iteração, veja o valor de 'i'
```

### **🔍 Debugging de Funções**

```minidart
funcao inteiro fatorial(inteiro n) {
    se (n <= 1) {           // <- break 2
        retornar 1;         // <- break 3
    }
    retornar n * fatorial(n - 1);  // <- break 5
}
```

```bash
(minidart-debug) break 2
(minidart-debug) break 5
(minidart-debug) watch n
(minidart-debug) continue
# Use 'stack' para ver recursão
```

### **📊 Debugging de Operações**

```minidart
var a = 10;
var b = 20;
var soma = a + b;      // <- break 3
var produto = a * b;   // <- break 4
```

```bash
(minidart-debug) break 3
(minidart-debug) watch a
(minidart-debug) watch b
(minidart-debug) step
(minidart-debug) vars  # Veja todas as variáveis
```

---

## ⚠️ **Dicas e Limitações**

### **✅ Dicas**

1. **Use `help`** para lembrar dos comandos
2. **Combine `watch` com `step`** para monitoramento detalhado
3. **Use `stack`** para entender chamadas de função
4. **Use `state`** para visão geral completa

### **⚠️ Limitações Atuais**

1. **Mapeamento de linhas** é aproximado (baseado em IP)
2. **Variáveis locais** são mostradas como globais
3. **Breakpoints condicionais** não são suportados ainda
4. **Editing de variáveis** não é possível durante debug

---

## 🎉 **Exemplo Completo**

Crie o arquivo `debug_exemplo.mdart`:

```minidart
var contador = 0;
var limite = 5;

enquanto (contador < limite) {
    imprima "Contador: " + contador;
    contador = contador + 1;
    
    se (contador == 3) {
        imprima "Meio do caminho!";
    }
}

funcao inteiro dobrar(inteiro x) {
    var resultado = x * 2;
    retornar resultado;
}

var numero = 21;
var dobrado = dobrar(numero);
imprima "Resultado: " + dobrado;
```

**Sessão de debugging:**

```bash
dart run bin/compile.dart debug_exemplo.mdart -i

(minidart-debug) break 4      # No meio do loop
(minidart-debug) break 13     # Na função dobrar
(minidart-debug) watch contador
(minidart-debug) watch numero
(minidart-debug) continue

🛑 BREAKPOINT atingido na linha 4
👁️ Variáveis monitoradas:
   contador = 0

(minidart-debug) step
(minidart-debug) continue

🛑 BREAKPOINT atingido na linha 13
📞 CALL: dobrar(21)

(minidart-debug) stack
📚 Call Stack:
   🏠 main
      📞 dobrar(21) [linha 17]

(minidart-debug) watch resultado
(minidart-debug) step
(minidart-debug) vars
(minidart-debug) continue

✅ Programa executado com sucesso
🔍 Debugger finalizado
```

---

**🎯 O Debugger Interativo do MiniDart oferece controle total sobre a execução do seu programa, permitindo identificar e resolver problemas de forma eficiente!**
