# 🐛 Guia de Teste dos Breakpoints MiniDart

## 📋 **Passos para Testar Breakpoints Visuais**

### **1. Verificar Extensão**
```bash
# Verificar se está instalada
code --list-extensions | findstr minidart
# Deve mostrar: deriks-karlay.minidart
```

### **2. Reiniciar VS Code**
- Feche VS Code completamente
- Reabra: `code .` no diretório do projeto

### **3. Abrir Arquivo de Teste**
- Abra `exemplos/teste_validacao_data.mdart`
- Verifique no canto inferior direito se mostra "MiniDart" como linguagem

### **4. Testar Breakpoints**

#### **Método 1: Clique na Margem**
1. Clique na **margem esquerda** ao lado dos números das linhas
2. Linhas recomendadas para teste:
   - Linha 8: `var data1 = "2024-07-25";`
   - Linha 15: `saida.escrever(dt.ehDataValida(data1));`
   - Linha 35: `saida.escrever(dt.ehDataValida(dataInv1));`

#### **Método 2: Menu de Contexto**
1. Clique com botão direito em uma linha
2. Procure opção "Toggle Breakpoint"

#### **Método 3: Atalho F9**
1. Posicione cursor em uma linha
2. Pressione **F9**

### **5. Iniciar Debug**

#### **Opção A: Atalho F5**
1. Pressione **F5**
2. Selecione "Debug MiniDart (Arquivo Atual)"

#### **Opção B: Botão Debug**
1. Procure botão 🐛 na barra superior
2. Clique para iniciar debug

#### **Opção C: Command Palette**
1. **Ctrl+Shift+P**
2. Digite "Debug: Start Debugging"
3. Selecione "Debug MiniDart (Arquivo Atual)"

### **6. Verificar se Funcionou**

#### **✅ Sinais de Sucesso:**
- Círculo vermelho 🔴 aparece na margem (breakpoint)
- Debug console abre na parte inferior
- Programa pausa no breakpoint
- Botões de debug aparecem (Continue, Step Over, etc.)

#### **❌ Problemas Comuns:**
- **Círculo não aparece**: Arquivo não é reconhecido como MiniDart
- **Debug não inicia**: Problema na configuração
- **Erro na extensão**: Logs mostram problemas

### **7. Debug Manual (Fallback)**
Se breakpoints visuais não funcionarem:

```bash
# Terminal integrado (Ctrl+`)
dart run bin/compile.dart exemplos/teste_validacao_data.mdart --debug-interactive

# No debugger, digite:
break 8
break 15
step
continue
vars
quit
```

### **8. Verificar Logs**

#### **Developer Tools:**
1. **Ctrl+Shift+P** → "Developer: Toggle Developer Tools"
2. Aba "Console" → Procurar erros

#### **Extension Logs:**
1. **Ctrl+Shift+P** → "Developer: Show Logs"
2. Selecione "Extension Host"
3. Procurar por "MiniDart" ou erros

### **9. Troubleshooting**

#### **Se breakpoints não aparecem:**
```bash
# Reinstalar extensão
code --uninstall-extension deriks-karlay.minidart
code --install-extension vscode-extension/minidart-1.7.0.vsix

# Recarregar VS Code
Ctrl+Shift+P → "Developer: Reload Window"
```

#### **Se debug não funciona:**
- Verificar se `dart` está no PATH
- Verificar se `bin/compile.dart` existe
- Testar compilação manual primeiro

### **10. Teste de Validação**

Arquivo: `teste_breakpoints.mdart`
```minidart
// Teste simples para breakpoints
imprima "Início";        // Breakpoint aqui (linha 2)
var x = 10;              // Breakpoint aqui (linha 3) 
var y = 20;              // Breakpoint aqui (linha 4)
var resultado = x + y;   // Breakpoint aqui (linha 5)
imprima resultado;       // Breakpoint aqui (linha 6)
```

**Resultado Esperado:**
- 5 breakpoints vermelhos na margem
- F5 inicia debug e para na linha 2
- Botões Step Over/Continue funcionam
- Variáveis aparecem no painel lateral

---

**Se seguir todos os passos e ainda não funcionar, há um problema fundamental na extensão que precisa ser investigado mais profundamente.**
