# MiniDart VS Code Extension

Extensão oficial para suporte à linguagem MiniDart no Visual Studio Code com suporte completo a funções.

## 🚀 Funcionalidades

### 🎨 Syntax Highlighting
- Destaque de sintaxe completo para arquivos `.mdart`
- Cores específicas para palavras-chave em português
- Suporte para strings, números, comentários e operadores
- Highlighting para palavras-chave de função (`funcao`, `retornar`)

### 🛠️ Comandos Integrados
- **Compilar** (`Ctrl+Shift+B`): Compila o arquivo MiniDart atual
- **Executar** (`Ctrl+F5`): Compila e executa o programa
- **Gerar AST** (`Ctrl+Shift+A`): Cria visualização da Árvore Sintática Abstrata
- **Visualizar AST**: Abre a imagem da AST gerada
- **Novo Arquivo**: Cria um novo arquivo MiniDart com template

### 📝 Snippets e AutoComplete
- Templates para funções (`funcao`, `funcaosimples`, `funcaomultipla`)
- Snippets para estruturas de controle (`se`, `enquanto`, `para`)
- Templates para programas completos (`calculadora`)
- Autocomplete para palavras-chave da linguagem

### ⚙️ Configurações
- `minidart.compilerPath`: Caminho para o compilador
- `minidart.autoCompile`: Compilação automática ao salvar (padrão: desabilitado)
- `minidart.showAST`: Geração automática da AST

> **💡 Dica:** Para habilitar a compilação automática ao salvar, vá em **Configurações** > **Extensões** > **MiniDart** e marque a opção **Auto Compile**.

## 📦 Instalação

### Pré-requisitos
- Visual Studio Code 1.102.0 ou superior
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
code --install-extension minidart-1.4.0.vsix
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
- **Declarações**: `var` (declaração de variável)
- **Controle**: `se`, `senao`, `enquanto`, `para`, `faca`, `ate`, `passo`
- **Funções**: `funcao`, `retornar` - **✨ NOVO em v1.4.0!**
- **Valores**: `verdadeiro`, `falso`, `nulo`
- **I/O**: `imprimir`
- **Operadores**: `e`, `ou`, `!` (negação)

### 🎯 Exemplo completo com funções
```minidart
// Declaração de funções
funcao area_retangulo(largura, altura) {
    retornar largura * altura;
}

funcao quadrado(x) {
    retornar x * x;
}

funcao eh_par(numero) {
    retornar (numero % 2) == 0;
}

// Usando as funções
var resultado = area_retangulo(8, 6);
imprimir "Área do retângulo: ";
imprimir resultado;

var quad = quadrado(7);
imprimir "Quadrado de 7: ";
imprimir quad;

// Chamadas aninhadas
var complexo = quadrado(area_retangulo(3, 4));
imprimir "Quadrado da área 3x4: ";
imprimir complexo;

// Loop com funções
imprimir "Quadrados de 1 a 5:";
para i = 1 ate 5 faca {
    var sq = quadrado(i);
    imprimir sq;
}
```

### 🔄 Recursos de Loop
A extensão suporta dois tipos de loop `para`:

#### 1. Loop com incremento automático (incremento = 1)
```minidart
para variavel = inicio ate fim faca {
    // código a ser executado
}

// Exemplo
para i = 1 ate 5 faca {
    imprimir i;  // Imprime: 1, 2, 3, 4, 5
}
```

#### 2. Loop com incremento personalizado
```minidart
para variavel = inicio ate fim passo incremento faca {
    // código a ser executado
}

// Exemplos
para x = 0 ate 10 passo 2 faca {
    imprimir x;  // Imprime: 0, 2, 4, 6, 8, 10
}

para contador = 5 ate 25 passo 5 faca {
    imprimir contador;  // Imprime: 5, 10, 15, 20, 25
}
```

### 🎯 Recursos de Função - ✨ NOVO em v1.4.0!

#### Declaração de Funções
```minidart
funcao nome_da_funcao(parametro1, parametro2) {
    // código da função
    retornar valor;
}
```

#### Chamadas de Função
```minidart
var resultado = nome_da_funcao(argumento1, argumento2);
```

#### Exemplos Práticos
```minidart
// Função com um parâmetro
funcao quadrado(x) {
    retornar x * x;
}

// Função com múltiplos parâmetros
funcao somar(a, b) {
    retornar a + b;
}

// Usando as funções
var num = 5;
var quad_resultado = quadrado(num);    // 25
var soma_resultado = somar(10, 20);    // 30

// Chamadas aninhadas
var complexo = quadrado(somar(3, 4));  // 49
```

**Características das Funções:**
- **Parâmetros múltiplos**: Suporte a funções com qualquer número de parâmetros
- **Valores de retorno**: Use `retornar valor;` para retornar resultados
- **Chamadas aninhadas**: Funções podem ser chamadas dentro de expressões
- **Escopo isolado**: Cada função tem seu próprio contexto de execução
- **Integração completa**: Funciona perfeitamente com loops, condicionais e expressões

## 🐛 Reportar Problemas

Para reportar bugs ou solicitar funcionalidades, abra uma issue no [repositório do projeto](https://github.com/karlaycosta/minidart_compiler).

## 👨‍💻 Autor

**Deriks Karlay Dias Costa**
- GitHub: [@karlaycosta](https://github.com/karlaycosta)

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](../LICENSE) para mais detalhes.
