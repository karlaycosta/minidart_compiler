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
   - `minidart.autoCompile`: `false` (padrão - desabilitado)

### 4. Funcionalidades disponíveis
- ✅ Syntax highlighting para arquivos `.mdart`
- ✅ Snippets para estruturas da linguagem
- ✅ Comandos de compilação e execução
- ✅ Geração automática de AST
- ✅ Templates para novos arquivos
- ✅ **NOVO:** Suporte ao loop `para` com contador automático

### 5. Atalhos de teclado
- `Ctrl+F5`: Executar arquivo MiniDart
- `Ctrl+Shift+B`: Compilar arquivo
- `Ctrl+Shift+A`: Gerar AST

### 6. Novo Recurso: Loop Para
O loop `para` foi implementado com duas variações:

#### Snippets disponíveis:
- `para` - Template básico do loop para (incremento 1)
- `parapasso` - Template para loop com incremento personalizado
- `paracontador` - Loop de contador de 1 até N
- `parapasso2` - Loop com incremento de 2
- `parapasso5` - Loop com incremento de 5
- `parasoma` - Loop para calcular soma de números
- `paracalculo` - Loop para cálculos matemáticos

#### Sintaxe 1 - Incremento automático:
```minidart
para variavel = inicio ate fim faca {
    // código executado a cada iteração (incremento = 1)
}
```

#### Sintaxe 2 - Incremento personalizado:
```minidart
para variavel = inicio ate fim passo incremento faca {
    // código executado a cada iteração (incremento customizado)
}
```

#### Exemplos de uso:
```minidart
// Incremento automático (1)
para i = 1 ate 5 faca {
    imprimir i;  // 1, 2, 3, 4, 5
}

// Incremento personalizado (2)
para x = 0 ate 10 passo 2 faca {
    imprimir x;  // 0, 2, 4, 6, 8, 10
}

// Incremento personalizado (3)
para contador = 3 ate 15 passo 3 faca {
    imprimir contador;  // 3, 6, 9, 12, 15
}

// Cálculo de soma com incremento customizado
var total = 0;
para num = 5 ate 25 passo 5 faca {
    total = total + num;  // Soma: 5+10+15+20+25 = 75
}
```

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
