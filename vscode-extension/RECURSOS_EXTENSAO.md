# 🎯 Extensão VS Code MiniDart v2.1.0

## 📋 Recursos Implementados

### 🎨 **Realce de Sintaxe Completo**

#### 🔤 Palavras-Chave
- **Controle de Fluxo**: `se`, `senao`, `enquanto`, `para`, `faca`, `ate`, `escolha`, `caso`, `contrario`
- **Loops**: `incremente`, `decremente`, `parar`, `continuar`
- **Declarações**: `var`, `constante`, `funcao`, `principal`
- **Tipos**: `inteiro`, `real`, `texto`, `logico`, `vazio`, `lista`
- **Literais**: `verdadeiro`, `falso`, `nulo`
- **Operações**: `retorne`, `imprima`, `tipode`, `tipo`, `paraTexto`
- **Imports**: `importar`, `como`
- **Debug**: `debug`, `info_debug`

#### 📊 Tipos de Dados
- **Primitivos**: `inteiro`, `real`, `texto`, `logico`, `vazio`
- **Listas Tipadas**: `lista<inteiro>`, `lista<real>`, `lista<texto>`, `lista<logico>`
- **Métodos de Lista**: `tamanho()`, `adicionar()`, `remover()`, `vazio()`

#### 🔢 Números e Strings
- Inteiros: `42`, `-17`, `0`
- Reais: `3.14`, `-2.5`, `0.0`
- Texto: `"Olá mundo"`, `""`
- Escape sequences em strings

#### 💬 Comentários
- Comentários de linha: `// comentário`
- Suporte para comentários de documentação

### 🎯 **Snippets Inteligentes**

#### 📝 Estruturas Básicas
- `minidart` - Programa básico completo
- `principal` - Função principal
- `funcao` - Declaração de função
- `funcaovoid` - Função sem retorno

#### 🔄 Estruturas de Controle
- `se` - Condicional simples
- `sesenao` - Condicional com else
- `enquanto` - Loop while
- `para` - Loop for tradicional
- `parapasso` - Loop for com incremento
- `facaenquanto` - Loop do-while
- `escolha` - Switch/case

#### 📋 Sistema de Listas
- `listainteiro` - Lista de inteiros
- `listatexto` - Lista de strings
- `listareal` - Lista de números reais
- `listavazia` - Lista vazia
- `listoperacoes` - Operações completas com listas

#### 🔧 Recursos Avançados
- `recursiva` - Função recursiva
- `funcaolista` - Função que trabalha com listas
- `ternario` - Operador ternário
- `tipode` - Operador typeof
- `paratexto` - Conversão para texto

#### 📚 Sistema de Imports
- `importar` - Import básico
- `importaralias` - Import com alias

#### 🐛 Debug
- `debug` - Comandos de debug

### ⌨️ **Atalhos de Teclado**

| Atalho | Comando | Descrição |
|--------|---------|-----------|
| `Ctrl+F5` | Executar | Executa o programa MiniDart |
| `F5` | Debug | Inicia sessão de debug |
| `Ctrl+Shift+B` | Compilar | Compila o código |
| `Ctrl+Shift+A` | Gerar AST | Gera árvore sintática |
| `Ctrl+Shift+S` | Verificar Sintaxe | Verifica erros de sintaxe |
| `Ctrl+Shift+F` | Formatar | Formata o código |
| `F1` | Documentação | Abre documentação |

### 🎛️ **Comandos da Paleta**

#### 🚀 Execução
- `🚀 Compilar MiniDart` - Compila o arquivo atual
- `▶️ Executar MiniDart` - Executa o programa
- `🐛 Debug MiniDart` - Inicia sessão de debug

#### 🔍 Análise
- `🌳 Gerar AST` - Gera árvore sintática abstrata
- `👁️ Visualizar AST` - Abre visualização do AST
- `✅ Verificar Sintaxe` - Verifica erros de sintaxe
- `🔍 Analisar Código` - Análise avançada de código

#### 💫 Formatação
- `💫 Formatar Código` - Formata o código automaticamente

#### 📚 Documentação
- `📚 Documentação` - Abre documentação da linguagem
- `📄 Novo Arquivo MiniDart` - Cria novo arquivo .mdart

### 🎨 **Configurações Disponíveis**

#### ⚙️ Compilação
- `minidart.compilerPath` - Caminho para o compilador
- `minidart.autoCompile` - Compilação automática ao salvar
- `minidart.showAST` - Gerar AST automaticamente

#### 🎯 Editor
- `minidart.autoFormat` - Formatação automática
- `minidart.syntaxHighlighting` - Realce de sintaxe avançado
- `minidart.enableLinting` - Análise de código e avisos
- `minidart.enableSnippets` - Snippets de código
- `minidart.enableAutoCompletion` - Autocompletar inteligente

#### 📖 Documentação
- `minidart.showDocumentationOnHover` - Documentação ao passar o mouse

#### 🎨 Aparência
- `minidart.theme` - Tema para realce de sintaxe (default/dark/light)

### 🔧 **Funcionalidades do Editor**

#### 📝 Edição Inteligente
- **Auto-fechamento**: Parênteses, colchetes, chaves e aspas
- **Indentação automática**: Baseada em estruturas de controle
- **Seleção de palavras**: Pattern otimizado para MiniDart
- **Dobramento de código**: Suporte para regiões

#### 🎯 Navegação
- **Busca de símbolos**: Funções, variáveis e tipos
- **Ir para definição**: Navegação rápida no código
- **Referências**: Encontrar todas as referências
- **Breadcrumbs**: Navegação por estrutura

#### 🐛 Debug Integrado
- **Breakpoints**: Pontos de interrupção visuais
- **Watch**: Observar variáveis durante execução
- **Call Stack**: Pilha de chamadas
- **Variables**: Inspeção de variáveis locais

### 📋 **Tipos de Arquivo Suportados**

- **Extensão**: `.mdart`
- **Ícone personalizado**: Ícone específico para arquivos MiniDart
- **Associação automática**: Detecção automática do tipo de arquivo

### 🔄 **Integração com Compilador**

#### 🎯 Execução Direta
- Execução com um clique
- Output integrado no terminal
- Captura de erros em tempo real

#### 🌳 Visualização AST
- Geração automática da árvore sintática
- Visualização gráfica (quando disponível)
- Export para formatos múltiplos

#### 📊 Análise de Código
- Verificação sintática em tempo real
- Avisos de melhores práticas
- Sugestões de otimização

### 🚀 **Novidades v2.1.0**

#### ✨ Recursos Adicionados
- **Suporte completo para listas tipadas**: `lista<tipo>`
- **Novos snippets para operações com listas**
- **Realce de sintaxe para métodos de lista**
- **Sistema de imports com alias**
- **Operador typeof (`tipode`)**
- **Função de conversão `paraTexto()`**
- **Estruturas switch/case (`escolha/caso/contrario`)**
- **Loops do-while (`faca...enquanto`)**
- **Comandos de debug (`debug`, `info_debug`)**

#### 🎨 Melhorias de Interface
- **Novos ícones para comandos**
- **Organização de menus por categoria**
- **Mais atalhos de teclado**
- **Configurações expandidas**

#### 🔧 Funcionalidades Técnicas
- **Auto-fechamento para colchetes angulares (`<>`)**
- **Melhor suporte para indentação**
- **Padrões de palavras otimizados**
- **Suporte para dobramento de código**

### 📚 **Bibliotecas Padrão Suportadas**

#### 🧮 Math
```minidart
importar math;
math.sqrt(16);    // raiz quadrada
math.pow(2, 3);   // potência
math.sin(1.57);   // seno
```

#### 📝 String
```minidart
importar string como str;
str.maiuscula("texto");     // TEXTO
str.tamanho("palavra");     // 7
str.contem("teste", "es");  // verdadeiro
```

#### 📅 Data
```minidart
importar data;
data.hoje();        // data atual
data.horaAtual();   // hora atual
```

#### 💾 I/O
```minidart
importar io;
io.imprimir("mensagem");  // output
io.escrever("texto");     // sem quebra de linha
```

### 🎯 **Roadmap Futuro**

#### 🔄 Próximas Funcionalidades
- **IntelliSense avançado**: Autocompletar contextual
- **Refactoring**: Renomear símbolos, extrair funções
- **Teste unitário**: Framework de testes integrado
- **Profiling**: Análise de performance
- **Formatter avançado**: Estilo de código configurável

#### 🎨 Melhorias de UX
- **Temas personalizados**: Múltiplos esquemas de cores
- **Minimap personalizado**: Visão geral do código
- **Breadcrumbs detalhados**: Navegação hierárquica
- **Quick fixes**: Correções automáticas de código

---

## 📖 **Como Usar**

### 1️⃣ **Instalação**
```bash
# Instalar extensão no VS Code
code --install-extension minidart-2.1.0.vsix
```

### 2️⃣ **Criar Novo Arquivo**
- Criar arquivo com extensão `.mdart`
- Ou usar `Ctrl+Shift+P` → "Novo Arquivo MiniDart"

### 3️⃣ **Primeiro Programa**
```minidart
inteiro principal() {
    imprima "Olá, MiniDart!";
    retorne 0;
}
```

### 4️⃣ **Executar**
- Pressionar `Ctrl+F5` ou
- Clicar no ícone ▶️ na barra de título

---

**Extensão VS Code MiniDart v2.1.0 - Completa e Atualizada!** 🚀✨
