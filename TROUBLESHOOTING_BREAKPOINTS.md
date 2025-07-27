# 🔧 Guia de Resolução: Breakpoints Visuais VS Code

## 🚨 **Problema Identificado**
Os breakpoints visuais (clique na margem) não estão funcionando no VS Code.

## 🎯 **Solução Passo a Passo**

### **1. Instalar a Extensão MiniDart**

```bash
# No diretório da extensão
cd vscode-extension

# Compilar a extensão
npm run compile

# Criar pacote VSIX
npm install -g vsce
vsce package

# Instalar no VS Code
code --install-extension minidart-1.6.0.vsix
```

### **2. Verificar se a Extensão está Ativa**

1. **Abra VS Code**
2. **Ctrl+Shift+X** → Extensões
3. **Procure por "MiniDart"**
4. **Certifique-se que está habilitada**

### **3. Configurar o Workspace**

1. **Abra a pasta do projeto MiniDart no VS Code**
2. **Verifique se existe `.vscode/launch.json`**
3. **Se não existir, crie:**

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Debug MiniDart",
            "type": "minidart",
            "request": "launch",
            "program": "${file}",
            "stopOnEntry": true,
            "compilerPath": "${workspaceFolder}/bin/compile.dart",
            "cwd": "${workspaceFolder}"
        }
    ]
}
```

### **4. Testar Breakpoints**

1. **Abra arquivo `.mdart`** (ex: `teste_debug.mdart`)
2. **Clique na margem esquerda** (ao lado dos números das linhas)
3. **Deve aparecer um círculo vermelho** 🔴
4. **Pressione F5** para iniciar debug
5. **O programa deve parar no breakpoint**

### **5. Se Ainda Não Funcionar**

#### **Opção A: Reiniciar VS Code**
```bash
# Feche completamente o VS Code
# Reabra o projeto
code .
```

#### **Opção B: Verificar Logs**
1. **Ctrl+Shift+P** → "Developer: Show Logs"
2. **Selecione "Extension Host"**
3. **Procure por erros relacionados ao MiniDart**

#### **Opção C: Debug Manual**
1. **Abra terminal integrado** (Ctrl+`)
2. **Execute:**
```bash
dart run bin/compile.dart teste_debug.mdart --debug-interactive
```
3. **Digite comandos manualmente:**
```
break 3
step
continue
quit
```

### **6. Verificar Dependências**

#### **Node.js e NPM:**
```bash
node --version  # Deve ser >= 16
npm --version   # Deve estar instalado
```

#### **Dart SDK:**
```bash
dart --version  # Deve estar no PATH
```

#### **VS Code:**
```bash
code --version  # Deve ser >= 1.102.0
```

## 🎮 **Teste Rápido**

1. **Abra `teste_debug.mdart`**
2. **Clique na linha 3** (margem esquerda)
3. **Deve aparecer breakpoint vermelho**
4. **F5** → Selecione "Debug MiniDart"
5. **Programa deve pausar na linha 3**

## 🔍 **Debug da Extensão**

Se nada funcionar, há um problema na extensão. Execute:

```bash
# Verificar se arquivos foram compilados
ls vscode-extension/out/

# Deve mostrar:
# debugAdapter.js
# debugMain.js
# extension.js
```

## 📞 **Próximos Passos**

Se seguir todos os passos e ainda não funcionar:

1. **Verifique se o tipo "minidart" é reconhecido no launch.json**
2. **Teste primeiro o debug terminal** (deve funcionar)
3. **Reinstale a extensão completamente**
4. **Verifique se não há conflitos com outras extensões**

---

**🎯 O problema mais comum é a extensão não estar instalada ou ativa no VS Code.**
