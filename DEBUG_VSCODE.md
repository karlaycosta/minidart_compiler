# Debug Visual no VS Code - MiniDart

## 📖 Visão Geral

O MiniDart agora oferece suporte completo ao debug visual no VS Code através do Debug Adapter Protocol (DAP). Isso permite uma experiência de debugging profissional com interface gráfica, similar às linguagens mainstream.

## 🎯 Funcionalidades do Debug Visual

### ✨ Recursos Principais
- **Breakpoints Visuais**: Clique na margem esquerda do editor para criar/remover breakpoints
- **Step-by-Step Visual**: Botões na interface para avançar linha por linha
- **Watch de Variáveis**: Painel lateral mostrando valores em tempo real
- **Call Stack Visual**: Visualização da pilha de chamadas de funções
- **Console de Debug**: Output do programa e comandos interativos

### 🔧 Compatibilidade
- **VS Code**: Versão 1.102.0 ou superior
- **MiniDart**: Versão 1.13.0 com debugger interativo
- **Plataformas**: Windows, macOS, Linux

## 🚀 Configuração Inicial

### 1. Instalação da Extensão
```bash
# Na pasta da extensão
cd vscode-extension
npm install
npm run compile

# Instalar no VS Code (modo desenvolvimento)
code --install-extension minidart-1.6.0.vsix
```

### 2. Configuração do Workspace
Crie um arquivo `.vscode/launch.json` no seu projeto:

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
            "compilerPath": "bin/compile.dart",
            "cwd": "${workspaceFolder}"
        }
    ]
}
```

## 🎮 Como Usar o Debug Visual

### 📍 Definindo Breakpoints
1. **Breakpoint Simples**: Clique na margem esquerda do editor (número da linha)
2. **Breakpoint Condicional**: Clique direito no breakpoint → "Edit Breakpoint" → definir condição
3. **Remover Breakpoint**: Clique novamente na margem ou use F9

### ▶️ Iniciando uma Sessão de Debug
1. **Via Menu**: Run → Start Debugging (F5)
2. **Via Command Palette**: Ctrl+Shift+P → "Debug: Start Debugging"
3. **Via Botão**: Clique no botão de debug na barra lateral

### 🎮 Controles de Debug
| Botão | Ação | Atalho | Descrição |
|-------|------|---------|-----------|
| ▶️ | Continue | F5 | Continua execução até próximo breakpoint |
| ⏸️ | Pause | F6 | Pausa execução atual |
| ⏭️ | Step Over | F10 | Executa linha atual sem entrar em funções |
| ⬇️ | Step Into | F11 | Entra dentro de funções chamadas |
| ⬆️ | Step Out | Shift+F11 | Sai da função atual |
| 🔄 | Restart | Ctrl+Shift+F5 | Reinicia sessão de debug |
| ⏹️ | Stop | Shift+F5 | Para sessão de debug |

### 👁️ Painéis de Debug

#### 📋 Painel de Variáveis
- **Locais**: Variáveis do escopo atual
- **Globais**: Variáveis globais do programa
- **Watch**: Expressões customizadas para monitorar

#### 📞 Call Stack
- Mostra a pilha de chamadas de funções
- Clique em qualquer frame para navegar
- Visualiza argumentos de cada função

#### 🔍 Debug Console
- Output do programa em execução
- Comandos interativos de debug
- Avaliação de expressões

## 📝 Exemplo Prático

### Arquivo: `exemplo_debug.mdart`
```minidart
programa ExemploDebug
    numero x = 10
    numero y = 20
    
    numero resultado = calcular(x, y)
    escrever("Resultado: " + resultado)
fim

funcao calcular(numero a, numero b) -> numero
    numero temp = a * 2
    temp = temp + b
    retornar temp
fim
```

### 🎯 Cenário de Debug
1. **Definir Breakpoints**: Linhas 4, 10, 11
2. **Iniciar Debug**: F5
3. **Monitorar Variáveis**: `x`, `y`, `resultado`
4. **Step Into**: F11 na função `calcular`
5. **Watch Expression**: `temp * 2`
6. **Continue**: F5 até o fim

## ⚙️ Configurações Avançadas

### 🎛️ Opções de Launch
```json
{
    "name": "Debug Avançado",
    "type": "minidart",
    "request": "launch",
    "program": "${workspaceFolder}/main.mdart",
    "args": ["arg1", "arg2"],
    "cwd": "${workspaceFolder}",
    "compilerPath": "bin/compile.dart",
    "stopOnEntry": false,
    "console": "integratedTerminal"
}
```

### 📊 Configurações de Workspace
```json
{
    "minidart.debugPort": 4711,
    "minidart.debugTimeout": 10000,
    "minidart.verboseDebug": true,
    "minidart.autoBreakOnError": true
}
```

## 🐛 Troubleshooting

### ❌ Problemas Comuns

#### "Debugger não inicia"
```bash
# Verificar compilador
dart --version
dart run bin/compile.dart --help

# Testar modo debug
dart run bin/compile.dart exemplo.mdart --debug-interactive
```

#### "Breakpoints não funcionam"
- Verificar se o arquivo foi salvo
- Confirmar que a linha contém código executável
- Recompilar a extensão (`npm run compile`)

#### "Variáveis não aparecem"
- Aguardar alguns segundos após pause
- Verificar se as variáveis estão no escopo atual
- Recarregar janela do VS Code (Ctrl+Shift+P → "Reload Window")

### 📋 Logs de Debug
```bash
# Habilitar logs detalhados
code --log debug

# Ver logs da extensão
Ctrl+Shift+P → "Developer: Show Logs" → Extension Host
```

## 🎓 Dicas Avançadas

### 🔍 Debug Eficiente
1. **Use Watch Expressions**: Monitore cálculos complexos
2. **Step Over vs Step Into**: Use Step Over para pular funções conhecidas
3. **Breakpoints Condicionais**: Para loops grandes, use condições como `i > 50`
4. **Call Stack Navigation**: Clique nos frames para ver contexto

### 🎯 Workflow Recomendado
1. **Análise Inicial**: Execute sem breakpoints para visão geral
2. **Pontos Estratégicos**: Coloque breakpoints em funções críticas
3. **Step-by-Step**: Use para entender algoritmos complexos
4. **Watch Variáveis**: Monitore estado durante loops

### 📈 Performance
- Minimize breakpoints desnecessários
- Use Continue em vez de Step para trechos conhecidos
- Feche sessões não utilizadas

## 🆕 Próximas Funcionalidades

### 🚧 Em Desenvolvimento
- [ ] Breakpoints condicionais avançados
- [ ] Hot reload durante debug
- [ ] Visualização de estruturas de dados
- [ ] Timeline de execução
- [ ] Debug remoto

### 💡 Planejado
- [ ] Profile de performance
- [ ] Memory viewer
- [ ] Reverse debugging
- [ ] Multi-thread debugging

## 📚 Recursos Adicionais

### 🔗 Links Úteis
- [Documentação Completa do MiniDart](README.md)
- [Debug Interativo Terminal](DEBUGGER_INTERATIVO.md)
- [Guia de Instalação](INSTALACAO.md)
- [Exemplos de Código](exemplos/)

### 📞 Suporte
- **Issues**: GitHub Issues do repositório
- **Discussões**: GitHub Discussions
- **Email**: suporte@minidart.dev

---

**🎉 Aproveite o poder do debug visual no MiniDart!**

*O debug visual torna o desenvolvimento muito mais produtivo e intuitivo. Use os breakpoints e watches para entender melhor o comportamento do seu código.*
