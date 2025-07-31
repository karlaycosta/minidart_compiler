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

### 📚 **Sistema de Imports e Bibliotecas**
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

### 🐛 **Debug Integrado**
- **Breakpoints visuais**: Clique na margem esquerda
- **Watch variables**: Observar variáveis durante execução
- **Call stack**: Visualizar pilha de chamadas
- **Step debugging**: Execução passo a passo
- **Debug console**: Console interativo

### ⚙️ **Configurações Avançadas**

```json
{
  "minidart.compilerPath": "bin/compile.dart",
  "minidart.autoCompile": false,
  "minidart.autoFormat": true,
  "minidart.syntaxHighlighting": true,
  "minidart.enableLinting": true,
  "minidart.enableAutoCompletion": true,
  "minidart.theme": "default"
}
```

## 🚀 **Exemplo de Uso**

### 📝 **Programa Básico**
```minidart
inteiro principal() {
    imprima "Bem-vindo ao MiniDart!";
    retorne 0;
}
```

### 📊 **Trabalhando com Listas**
```minidart
inteiro principal() {
    // Lista de notas
    lista<real> notas = [8.5, 7.2, 9.1, 6.8];
    
    // Calcular média
    real soma = 0.0;
    para i = 0 ate notas.tamanho() - 1 faca {
        soma += notas[i];
    }
    real media = soma / notas.tamanho();
    
    imprima "Média: " + paraTexto(media);
    retorne 0;
}
```

### 🔄 **Função Recursiva**
```minidart
inteiro fatorial(inteiro n) {
    se (n <= 1) {
        retorne 1;
    }
    retorne n * fatorial(n - 1);
}

inteiro principal() {
    inteiro resultado = fatorial(5);
    imprima "5! = " + paraTexto(resultado);
    retorne 0;
}
```

### 📚 **Usando Bibliotecas**
```minidart
importar math;
importar string como str;

inteiro principal() {
    // Matemática
    real raiz = math.sqrt(16);
    real potencia = math.pow(2, 3);
    
    // Strings
    texto nome = "minidart";
    texto maiuscula = str.maiuscula(nome);
    
    imprima "Raiz de 16: " + paraTexto(raiz);
    imprima "2^3 = " + paraTexto(potencia);
    imprima "Nome: " + maiuscula;
    
    retorne 0;
}
```

## 📦 **Instalação**

### 🔧 **Via VS Code Marketplace**
1. Abrir VS Code
2. Ir para Extensions (Ctrl+Shift+X)
3. Buscar "MiniDart Language Support"
4. Clicar em "Install"

### 📁 **Via VSIX Local**
```bash
code --install-extension minidart-2.1.0.vsix
```

## 🎯 **Como Usar**

### 1️⃣ **Criar Novo Arquivo**
- Criar arquivo com extensão `.mdart`
- Ou usar comando: `MiniDart: Novo Arquivo MiniDart`

### 2️⃣ **Escrever Código**
- Use snippets para acelerar: digite `minidart` + Tab
- Syntax highlighting automático
- Auto-completion inteligente

### 3️⃣ **Executar**
- Pressionar `Ctrl+F5`
- Ou clicar no ícone ▶️ na barra de título
- Ou usar menu: `MiniDart: Executar MiniDart`

### 4️⃣ **Debug**
- Pressionar `F5` para iniciar debug
- Adicionar breakpoints clicando na margem
- Usar debug console para inspeção

## 🆕 **Novidades v2.1.0**

### ✨ **Recursos Adicionados**
- ✅ **Listas tipadas completas**: `lista<inteiro>`, `lista<real>`, `lista<texto>`, `lista<logico>`
- ✅ **Métodos de lista**: `.tamanho()`, `.adicionar()`, `.remover()`, `.vazio()`
- ✅ **Sistema de imports**: `importar biblioteca` e `importar biblioteca como alias`
- ✅ **Bibliotecas padrão**: `math`, `string`, `data`, `io`
- ✅ **Operador typeof**: `tipode variavel`
- ✅ **Função de conversão**: `paraTexto(valor)`
- ✅ **Switch/case**: `escolha/caso/contrario`
- ✅ **Loops do-while**: `faca...enquanto`
- ✅ **Comandos de debug**: `debug()`, `info_debug()`
- ✅ **Operador ternário**: `condicao ? valor1 : valor2`

### 🎨 **Melhorias de Interface**
- 🎯 **4 novos comandos**: Verificar sintaxe, analisar código, formatar código, documentação
- ⌨️ **3 novos atalhos**: Ctrl+Shift+S, Ctrl+Shift+F, F1
- 📋 **15+ novos snippets**: Para listas, imports, recursão, switch/case
- 🎨 **Auto-fechamento para `<>`**: Suporte para listas tipadas
- ⚙️ **7 novas configurações**: Formatação, linting, autocompletion, temas

### 🔧 **Funcionalidades Técnicas**
- 📝 **Syntax highlighting expandido**: Cobertura 100% da sintaxe v2.0
- 🎯 **IntelliSense melhorado**: Detecção de tipos e métodos
- 🔍 **Análise de código**: Verificação sintática em tempo real
- 📊 **Suporte para dobramento**: Navegação de código otimizada

## 🎓 **Recursos Suportados**

### 📊 **Tipos de Dados**
- `inteiro` - Números inteiros
- `real` - Números de ponto flutuante  
- `texto` - Strings/texto
- `logico` - Valores booleanos
- `vazio` - Tipo void para funções
- `lista<tipo>` - Listas homogêneas tipadas

### 🔄 **Estruturas de Controle**
- `se/senao` - Condicionais
- `enquanto` - Loop while
- `para...ate...faca` - Loop for MiniDart
- `faca...enquanto` - Loop do-while
- `escolha/caso/contrario` - Switch/case
- `parar/continuar` - Break/continue

### ⚙️ **Operadores**
- **Aritméticos**: `+`, `-`, `*`, `/`, `%`, `++`, `--`
- **Comparação**: `==`, `!=`, `<`, `<=`, `>`, `>=`
- **Lógicos**: `e`, `ou`, `!`
- **Atribuição**: `=`, `+=`, `-=`, `*=`, `/=`, `%=`
- **Ternário**: `? :`
- **Typeof**: `tipode`

### 📚 **Bibliotecas Padrão**
- **math**: `sqrt()`, `pow()`, `sin()`, `cos()`, `abs()`, `max()`, `min()`
- **string**: `maiuscula()`, `minuscula()`, `tamanho()`, `contem()`, `substituir()`
- **data**: `hoje()`, `horaAtual()`, `diferenca()`, `formatar()`
- **io**: `imprimir()`, `escrever()`, `novaLinha()`

## 🔧 **Requisitos**

- **VS Code**: >= 1.102.0
- **Dart SDK**: >= 2.17.0 (para compilador)
- **Node.js**: >= 16.0.0 (para debug adapter)

## 🐛 **Suporte e Bugs**

### 📞 **Reportar Problemas**
- [GitHub Issues](https://github.com/karlaycosta/minidart_compiler/issues)
- Use template específico para bugs da extensão

### 💡 **Sugestões de Recursos**
- [GitHub Discussions](https://github.com/karlaycosta/minidart_compiler/discussions)
- Feature requests bem-vindas!

### 📚 **Documentação Completa**
- [Documentação da Linguagem](../DOCUMENTACAO_SINTAXE_MINIDART.md)
- [Guia de Instalação](INSTALLATION.md)
- [Recursos da Extensão](RECURSOS_EXTENSAO.md)

## 📄 **Licença**

ISC License - veja [LICENSE](LICENSE) para detalhes.

## 👨‍💻 **Autor**

**Deriks Karlay Dias Costa**
- GitHub: [@karlaycosta](https://github.com/karlaycosta)
- Email: karlay@example.com

---

**MiniDart Extension v2.1.0 - Programação em Português Nunca Foi Tão Fácil!** 🚀🇧🇷
