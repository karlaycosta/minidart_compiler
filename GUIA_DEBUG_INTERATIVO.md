# 🎮 GUIA COMPLETO: Como Usar o Debug Interativo

## 🚀 **Método 1: Terminal Integrado do VS Code (Recomendado)**

### **Passo 1: Abrir Terminal Integrado**
1. Pressione **Ctrl+`** (ou View → Terminal)
2. Certifique-se de estar no diretório do projeto

### **Passo 2: Executar Debug Interativo**
```bash
dart run bin/compile.dart exemplos/teste_breakpoints.mdart --debug-interactive
```

### **Passo 3: Usar Comandos do Debugger**
Quando aparecer o prompt `(minidart-debug)`, você pode digitar:

```bash
# Comandos básicos
help           # Ver todos os comandos
break 3        # Adicionar breakpoint na linha 3
break 5        # Adicionar breakpoint na linha 5  
step           # Ativar modo step-by-step
continue       # Continuar execução
vars           # Ver variáveis
quit           # Sair
```

---

## 🎯 **Método 2: Executar Fora do VS Code**

### **No PowerShell/CMD normal:**
```bash
cd "c:\Users\karla\Documents\Dart - projetos\minidart_compiler"
dart run bin/compile.dart exemplos/teste_breakpoints.mdart --debug-interactive
```

---

## 🛠️ **Método 3: Debug Pré-configurado**

Vou criar um script que automatiza alguns breakpoints:

### **Arquivo: `debug_script.txt`**
```
break 3
break 5
step
continue
vars
quit
```

### **Executar com script:**
```bash
dart run bin/compile.dart exemplos/teste_breakpoints.mdart --debug-interactive < debug_script.txt
```

---

## 📋 **Exemplo de Sessão Completa**

```
🔍 MINIDART INTERACTIVE DEBUGGER v1.13.0
🔍 ═══ PROGRAMA INICIADO - PAUSADO ═══
💡 Digite "help" para ver comandos disponíveis

(minidart-debug) break 3
🛑 Breakpoint adicionado na linha 3

(minidart-debug) break 5  
🛑 Breakpoint adicionado na linha 5

(minidart-debug) continue
▶️ Continuando execução...
🛑 BREAKPOINT atingido na linha 3

(minidart-debug) vars
📊 Estado das Variáveis:
   🌍 Globais:
     x = 10

(minidart-debug) continue
▶️ Continuando execução...
🛑 BREAKPOINT atingido na linha 5

(minidart-debug) vars
📊 Estado das Variáveis:
   🌍 Globais:
     x = 10
     y = 20
     resultado = 30

(minidart-debug) quit
👋 Saindo do debugger...
```

---

## ⚡ **Atalhos de Comandos**

| Comando Completo | Atalho | Função |
|------------------|--------|---------|
| `help` | `h` | Ajuda |
| `continue` | `c` | Continuar |
| `step` | `s` | Step-by-step |
| `next` | `n` | Próxima instrução |
| `break 5` | `b 5` | Breakpoint linha 5 |
| `list` | `l` | Listar breakpoints |
| `vars` | `v` | Mostrar variáveis |
| `watch x` | `w x` | Monitorar variável x |
| `stack` | `st` | Call stack |
| `quit` | `q` | Sair |

---

## 🎯 **TESTE AGORA:**

1. **Ctrl+`** para abrir terminal integrado
2. Cole este comando:
```bash
dart run bin/compile.dart exemplos/teste_breakpoints.mdart --debug-interactive
```
3. Quando aparecer `(minidart-debug)`, digite: `help`
4. Experimente: `break 3`, depois `continue`

**O terminal integrado do VS Code deve permitir interação completa!**
