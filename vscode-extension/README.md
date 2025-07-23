# MiniDart VS Code Extension

Extensão oficial para suporte à linguagem MiniDart no Visual Studio Code.

## 🚀 Funcionalidades

### 🎨 Syntax Highlighting
- Destaque de sintaxe completo para arquivos `.mdart`
- Cores específicas para palavras-chave em português
- Suporte para strings, números, comentários e operadores

### 🛠️ Comandos Integrados
- **Compilar** (`Ctrl+Shift+B`): Compila o arquivo MiniDart atual
- **Executar** (`Ctrl+F5`): Compila e executa o programa
- **Gerar AST** (`Ctrl+Shift+A`): Cria visualização da Árvore Sintática Abstrata
- **Visualizar AST**: Abre a imagem da AST gerada
- **Novo Arquivo**: Cria um novo arquivo MiniDart com template

### 📝 Snippets e AutoComplete
- Templates para estruturas básicas (algoritmo, função, procedimento)
- Snippets para estruturas de controle (se, enquanto, para)
- Autocomplete para palavras-chave da linguagem

### ⚙️ Configurações
- `minidart.compilerPath`: Caminho para o compilador
- `minidart.autoCompile`: Compilação automática ao salvar
- `minidart.showAST`: Geração automática da AST

## 📦 Instalação

### Pré-requisitos
- Visual Studio Code 1.74.0 ou superior
- Dart SDK instalado
- Compilador MiniDart no workspace

### Instalação Local
1. Clone o repositório
2. Navegue até a pasta `vscode-extension`
3. Execute `npm install`
4. Execute `npm run compile`
5. Pressione F5 para abrir uma nova janela do VS Code com a extensão

### Instalação via VSIX
```bash
# Gerar pacote VSIX
vsce package

# Instalar extensão
code --install-extension minidart-1.1.1.vsix
```

## 🔧 Uso

### Criando um novo arquivo MiniDart
1. Use o comando `MiniDart: Novo Arquivo MiniDart`
2. Ou crie um arquivo com extensão `.mdart`

### Compilando e executando
1. Abra um arquivo `.mdart`
2. Use `Ctrl+Shift+B` para compilar
3. Use `Ctrl+F5` para executar
4. Ou use os botões na barra de título do editor

### Visualizando a AST
1. Use `Ctrl+Shift+A` para gerar a AST
2. A imagem será aberta automaticamente se o Graphviz estiver instalado

## 📋 Estrutura da Linguagem

### Palavras-chave suportadas
- **Estrutura**: `algoritmo`, `inicio`, `fim`
- **Controle**: `se`, `senao`, `enquanto`, `para`, `faca`, `ate`
- **Funções**: `funcao`, `procedimento`, `retorne`
- **Tipos**: `inteiro`, `real`, `texto`, `logico`, `vazio`
- **Valores**: `verdadeiro`, `falso`, `nulo`
- **I/O**: `leia`, `escreva`
- **Operadores**: `e`, `ou`, `nao`

### Exemplo de código
```minidart
algoritmo exemplo_completo

funcao somar(a: inteiro, b: inteiro): inteiro
inicio
    retorne a + b;
fim

procedimento mostrar_resultado(resultado: inteiro)
inicio
    escreva("O resultado é: ");
    escreva(resultado);
fim

inicio
    var num1: inteiro = 10;
    var num2: inteiro = 20;
    var soma: inteiro;
    
    soma = somar(num1, num2);
    mostrar_resultado(soma);
fim
```

## 🐛 Reportar Problemas

Para reportar bugs ou solicitar funcionalidades, abra uma issue no [repositório do projeto](https://github.com/karlaycosta/minidart_compiler).

## 👨‍💻 Autor

**Deriks Karlay Dias Costa**
- GitHub: [@karlaycosta](https://github.com/karlaycosta)

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](../LICENSE) para mais detalhes.
