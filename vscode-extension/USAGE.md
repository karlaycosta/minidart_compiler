# MiniDart VS Code Extension

## 🎯 Como usar a extensão

### 1. Desenvolvimento local
```bash
# 1. Navegue até a pasta da extensão
cd vscode-extension

# 2. Instale as dependências
npm install

# 3. Compile a extensão
npm run compile

# 4. Pressione F5 no VS Code para testar
# Isso abrirá uma nova janela com a extensão carregada
```

### 2. Instalação manual (VSIX)
```bash
# 1. Instalar o vsce (VS Code Extension manager)
npm install -g vsce

# 2. Gerar o pacote VSIX
vsce package

# 3. Instalar a extensão
code --install-extension minidart-1.1.1.vsix
```

### 3. Configuração no workspace
1. Abra o projeto MiniDart no VS Code
2. Configure o caminho do compilador em Settings:
   - `minidart.compilerPath`: `bin/compile.dart`
   - `minidart.autoCompile`: `true`

### 4. Funcionalidades disponíveis
- ✅ Syntax highlighting para arquivos `.mdart`
- ✅ Snippets para estruturas da linguagem
- ✅ Comandos de compilação e execução
- ✅ Geração automática de AST
- ✅ Templates para novos arquivos

### 5. Atalhos de teclado
- `Ctrl+F5`: Executar arquivo MiniDart
- `Ctrl+Shift+B`: Compilar arquivo
- `Ctrl+Shift+A`: Gerar AST

## 📁 Estrutura criada
```
vscode-extension/
├── package.json          # Manifest da extensão
├── tsconfig.json         # Configuração TypeScript
├── src/
│   └── extension.ts      # Código principal da extensão
├── syntaxes/
│   └── minidart.tmLanguage.json  # Gramática para highlighting
├── language/
│   └── minidart-configuration.json  # Configuração da linguagem
├── snippets/
│   └── minidart.json     # Snippets de código
└── README.md            # Documentação da extensão
```

A extensão está pronta para uso! 🚀
