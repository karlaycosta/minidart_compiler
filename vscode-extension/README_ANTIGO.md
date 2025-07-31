# 🎯 Extensão VS Code para MiniDart v2.1.0

Extensão completa do Visual Studio Code para a linguagem **MiniDart v2.0** com suporte para **listas tipadas**, **sistema de imports**, **bibliotecas padrão**, **debugger visual** e **syntax highlighting avançado**.

## ✨ **Principais Recursos**

### 🎨 **Syntax Highlighting Completo**
- **Palavras-chave em português**: `se`, `senao`, `enquanto`, `para`, `lista`, `importar`
- **Tipos de dados**: `inteiro`, `real`, `texto`, `logico`, `vazio`, `lista<tipo>`
- **Operadores**: Aritméticos, lógicos, comparação, ternário (`?:`), typeof (`tipode`)
- **Literais**: `verdadeiro`, `falso`, `nulo`, números, strings, listas `[1, 2, 3]`
- **Comentários**: Suporte para `//` com syntax highlighting

### 📋 **Sistema de Listas Completo**
```minidart
lista<inteiro> numeros = [1, 2, 3, 4, 5];
lista<texto> nomes = ["Ana", "Bruno", "Carlos"];

// Métodos integrados
numeros.adicionar(6);
texto nome = nomes.remover();
inteiro tamanho = numeros.tamanho();
logico vazia = numeros.vazio();
```

### � **Sistema de Imports e Bibliotecas**
```minidart
importar math;
importar string como str;

real resultado = math.sqrt(16);
texto maiuscula = str.maiuscula("minidart");
```

### 🎯 **50+ Snippets Inteligentes**

| Snippet | Trigger | Descrição |
|---------|---------|-----------|
| `minidart` | Programa completo | Template básico com função principal |
| `principal` | Função principal | `inteiro principal() { ... }` |
| `funcao` | Função tipada | Função com parâmetros e retorno |
| `listainteiro` | Lista de inteiros | `lista<inteiro> nums = [1, 2, 3];` |
| `para` | Loop for | `para i = 1 ate 10 faca { ... }` |
| `escolha` | Switch/case | `escolha (valor) { caso 1: ... }` |
| `importar` | Import biblioteca | `importar math;` |
| `recursiva` | Função recursiva | Exemplo completo de recursão |

### ⌨️ **Atalhos de Teclado**

| Atalho | Comando | Descrição |
|--------|---------|-----------|
| `Ctrl+F5` | ▶️ Executar | Executa o programa MiniDart |
| `F5` | 🐛 Debug | Inicia sessão de debug |
| `Ctrl+Shift+B` | 🚀 Compilar | Compila o código |
| `Ctrl+Shift+A` | 🌳 Gerar AST | Gera árvore sintática |
| `Ctrl+Shift+S` | ✅ Verificar Sintaxe | Verifica erros de sintaxe |
| `Ctrl+Shift+F` | 💫 Formatar | Formata o código |
| `F1` | 📚 Documentação | Abre documentação |

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

### 🎯 Recursos de Função - ✨ ATUALIZADO em v1.5.0!

#### Funções Void (Sem Retorno)
```minidart
vazio mostrarMensagem() {
    imprima "Esta função não retorna valor";
}

vazio cumprimentar(texto nome) {
    imprima "Olá, " + nome + "!";
}

// Chamando funções void
mostrarMensagem();
cumprimentar("Maria");
```

#### Funções com Tipos Explícitos
```minidart
// Função que retorna inteiro
inteiro somar(inteiro a, inteiro b) {
    retorne a + b;
}

// Função que retorna texto
texto formatarNome(texto nome, texto sobrenome) {
    retorne nome + " " + sobrenome;
}

// Função que retorna real
real calcularMedia(real nota1, real nota2) {
    retorne (nota1 + nota2) / 2;
}
```

### 🔗 Concatenação de Strings - ✨ NOVO em v1.5.0!

#### Concatenação Básica
```minidart
texto nome = "João";
texto sobrenome = "Silva";
texto completo = nome + " " + sobrenome;
imprima completo;  // João Silva
```

#### Concatenação com Literais
```minidart
texto saudacao = "Olá, " + nome + "!";
imprima saudacao;  // Olá, João!
```

#### Concatenação em Loops
```minidart
texto lista = "";
para i = 1 ate 3 faca {
    lista = lista + "Item " + i + " ";
}
imprima lista;  // Item 1 Item 2 Item 3
```

### 📊 Operadores Compostos - ✨ NOVO em v1.5.0!

#### Operadores de Atribuição
```minidart
var x = 10;
x += 5;   // x = 15 (equivale a: x = x + 5)
x -= 3;   // x = 12 (equivale a: x = x - 3)
x *= 2;   // x = 24 (equivale a: x = x * 2)
x /= 4;   // x = 6  (equivale a: x = x / 4)
x %= 4;   // x = 2  (equivale a: x = x % 4)
```

#### Incremento e Decremento
```minidart
var y = 5;
imprima y++;  // 5 (pós-incremento: usa depois incrementa)
imprima y;    // 6

imprima ++y;  // 7 (pré-incremento: incrementa depois usa)
imprima y--;  // 7 (pós-decremento: usa depois decrementa)
imprima y;    // 6
```

### 🔄 Recursos de Loop Avançados - ✨ ATUALIZADO em v1.5.0!

#### 1. Loop For com Incremento Personalizado
```minidart
para i = 0 ate 20 incremente 2 faca {
    imprima i;  // 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20
}
```

#### 2. Loop For com Decremento
```minidart
para i = 10 ate 0 decremente 2 faca {
    imprima i;  // 10, 8, 6, 4, 2, 0
}
```

#### 3. Do-While
```minidart
var contador = 5;
faca {
    imprima contador;
    contador = contador - 1;
} enquanto (contador > 3);
```

### 🎨 Tipos Explícitos - ✨ NOVO em v1.5.0!

#### Declaração com Tipos
```minidart
inteiro numero = 42;
real decimal = 3.14159;
texto mensagem = "Olá mundo";
logico ativo = verdadeiro;
```

#### Operador Ternário
```minidart
var idade = 20;
var status = idade >= 18 ? "adulto" : "jovem";
imprima status;  // adulto
```

**Características das Novas Funcionalidades:**
- **Funções Void**: Funções que não retornam valor com palavra-chave `vazio`
- **Tipos Explícitos**: Declaração de variáveis e funções com tipos específicos
- **Concatenação Segura**: Sistema robusto de concatenação com verificação de tipos
- **Operadores Modernos**: Suporte completo a operadores compostos e incremento/decremento
- **Loops Avançados**: For com incremento/decremento personalizado e do-while
- **Expressões Ternárias**: Operador condicional `? :` para expressões condicionais

## 🐛 Reportar Problemas

Para reportar bugs ou solicitar funcionalidades, abra uma issue no [repositório do projeto](https://github.com/karlaycosta/minidart_compiler).

## 👨‍💻 Autor

**Deriks Karlay Dias Costa**
- GitHub: [@karlaycosta](https://github.com/karlaycosta)

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](../LICENSE) para mais detalhes.
