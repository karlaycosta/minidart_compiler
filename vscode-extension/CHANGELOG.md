# 📋 Changelog - Extensão VS Code MiniDart

## [2.1.0] - 2025-07-30

### ✨ **Recursos Adicionados**

#### 🎯 **Sistema de Listas Completo**
- ✅ Suporte completo para listas tipadas: `lista<inteiro>`, `lista<real>`, `lista<texto>`, `lista<logico>`
- ✅ Syntax highlighting para declarações de lista: `lista<tipo> nome = [elementos];`
- ✅ Destaque para métodos de lista: `.tamanho()`, `.adicionar()`, `.remover()`, `.vazio()`
- ✅ Auto-fechamento para colchetes angulares (`<>`) em tipos de lista
- ✅ Snippets específicos para listas:
  - `listainteiro` - Lista de números inteiros
  - `listatexto` - Lista de strings
  - `listareal` - Lista de números reais
  - `listavazia` - Lista vazia com verificação
  - `listoperacoes` - Operações completas com listas

#### 📚 **Sistema de Imports e Bibliotecas**
- ✅ Palavras-chave para imports: `importar`, `como`
- ✅ Syntax highlighting para módulos e aliases
- ✅ Suporte para bibliotecas padrão: `math`, `string`, `data`, `io`
- ✅ Snippets para imports:
  - `importar` - Import básico de biblioteca
  - `importaralias` - Import com alias personalizado

#### 🔧 **Funcionalidades de Linguagem**
- ✅ Operador typeof: `tipode variavel`
- ✅ Função de conversão: `paraTexto(valor)`
- ✅ Switch/case: `escolha/caso/contrario` com syntax highlighting
- ✅ Loops do-while: `faca...enquanto`
- ✅ Comandos de debug: `debug()`, `info_debug()`
- ✅ Operador ternário: `condicao ? valor1 : valor2`
- ✅ Função principal: `inteiro principal() { ... }`

#### 🎯 **Novos Comandos**
- ✅ `✅ Verificar Sintaxe` (Ctrl+Shift+S) - Verificação de erros sintáticos
- ✅ `🔍 Analisar Código` - Análise avançada de código
- ✅ `💫 Formatar Código` (Ctrl+Shift+F) - Formatação automática
- ✅ `📚 Documentação` (F1) - Acesso rápido à documentação

#### 📋 **Novos Snippets**
- ✅ `principal` - Função principal do programa
- ✅ `escolha` - Estrutura switch/case completa
- ✅ `facaenquanto` - Loop do-while
- ✅ `ternario` - Operador ternário
- ✅ `tipode` - Operador typeof
- ✅ `paratexto` - Conversão para texto
- ✅ `recursiva` - Função recursiva com exemplo
- ✅ `funcaolista` - Função que trabalha com listas
- ✅ `constante` - Declaração de constante
- ✅ `debug` - Comandos de debug básicos

### 🎨 **Melhorias de Interface**

#### ⌨️ **Novos Atalhos de Teclado**
- ✅ `Ctrl+Shift+S` - Verificar sintaxe
- ✅ `Ctrl+Shift+F` - Formatar código
- ✅ `F1` - Abrir documentação

#### 🖱️ **Melhorias de Menu**
- ✅ Comandos organizados por categoria no menu de contexto
- ✅ Grupos separados: navegação, análise, formatação, ajuda
- ✅ Ícones atualizados para melhor visualização

#### ⚙️ **Novas Configurações**
- ✅ `minidart.autoFormat` - Formatação automática de código
- ✅ `minidart.syntaxHighlighting` - Controle de realce de sintaxe
- ✅ `minidart.enableLinting` - Análise de código e avisos
- ✅ `minidart.enableSnippets` - Controle de snippets
- ✅ `minidart.enableAutoCompletion` - Autocompletar inteligente
- ✅ `minidart.showDocumentationOnHover` - Documentação ao passar mouse
- ✅ `minidart.theme` - Seleção de tema (default/dark/light)

### 🔧 **Melhorias Técnicas**

#### 📝 **Syntax Highlighting Expandido**
- ✅ Cobertura 100% da sintaxe MiniDart v2.0
- ✅ Destaque para tipos de lista: `lista<tipo>`
- ✅ Realce para métodos de lista
- ✅ Suporte para imports com alias
- ✅ Highlighting para operadores ternários
- ✅ Destaque para comandos de debug

#### 🎯 **Editor Inteligente**
- ✅ Auto-fechamento para colchetes angulares (`<>`)
- ✅ Melhor suporte para indentação em estruturas aninhadas
- ✅ Padrões de palavras otimizados para MiniDart
- ✅ Suporte para dobramento de código (folding)
- ✅ Regras OnEnter para comentários de documentação

#### 📦 **Metadados da Extensão**
- ✅ Versão atualizada: v2.1.0
- ✅ Descrição expandida com novas funcionalidades
- ✅ Keywords adicionais: `lipo`, `listas`, `educacional`
- ✅ Categoria "Debuggers" adicionada
- ✅ Suporte para VS Code >= 1.102.0

### 🐛 **Correções**

#### 🔧 **Syntax Highlighting**
- 🔧 Removido suporte para strings com aspas simples (não suportado pela linguagem)
- 🔧 Removido highlighting para comentários de bloco (não implementado)
- 🔧 Melhorado reconhecimento de números negativos
- 🔧 Corrigido escape sequences em strings

#### 📋 **Snippets**
- 🔧 Removido snippet duplicado "Função void"
- 🔧 Atualizado snippet "minidart" para incluir função principal
- 🔧 Corrigidos templates para usar sintaxe v2.0 correta
- 🔧 Melhorada estrutura de snippets recursivos

#### ⚙️ **Configuração**
- 🔧 Removido suporte para aspas simples em auto-closing pairs
- 🔧 Adicionado suporte para colchetes angulares em brackets
- 🔧 Atualizado wordPattern para melhor reconhecimento de identificadores

### 📚 **Documentação**

#### 📖 **Arquivos Novos**
- ✅ `RECURSOS_EXTENSAO.md` - Documentação completa dos recursos
- ✅ `README.md` - Completamente reescrito para v2.1.0
- ✅ `CHANGELOG.md` - Histórico de versões detalhado

#### 🎯 **Conteúdo Atualizado**
- ✅ Exemplos de código usando sintaxe v2.0
- ✅ Documentação de todos os 50+ snippets
- ✅ Guia completo de instalação e uso
- ✅ Referência de todas as configurações
- ✅ Roadmap de funcionalidades futuras

---

## [2.0.1] - 2024-12-15

### 🐛 **Correções**
- 🔧 Corrigido problema de ativação da extensão
- 🔧 Melhorado debug adapter protocol
- 🔧 Ajustados caminhos de arquivos no debugger

### 📝 **Documentação**
- 📖 Atualizado README com exemplos mais claros
- 📖 Melhorada documentação do debugger

---

## [2.0.0] - 2024-12-01

### ✨ **Recursos Adicionados**
- ✅ Sistema de debug completo com breakpoints
- ✅ Debug Adapter Protocol (DAP) implementado
- ✅ Suporte para watch variables
- ✅ Call stack visualization
- ✅ Debug console interativo

### 🎨 **Melhorias**
- 💫 Interface de debug integrada
- 💫 Comandos de debug no menu
- 💫 Configuração de launch.json automática

---

## [1.5.0] - 2024-11-15

### ✨ **Recursos Adicionados**
- ✅ Suporte completo para funções `vazio`
- ✅ Snippets para funções tipadas
- ✅ Templates para operadores compostos (`+=`, `-=`, etc.)
- ✅ Snippets para incremento/decremento (`++`, `--`)
- ✅ Templates para loops for com incremento personalizado
- ✅ Snippet para concatenação de strings
- ✅ Template para tipos explícitos

### 🐛 **Correções**
- 🔧 Melhorado highlighting para operadores compostos
- 🔧 Corrigido autocomplete para palavras-chave
- 🔧 Ajustado indentação automática
- 🔧 Melhorado reconhecimento de tipos

---

## [1.4.0] - 2024-11-01

### ✨ **Recursos Adicionados**
- ✅ Geração automática de AST
- ✅ Visualização gráfica da árvore sintática
- ✅ Comando "Gerar AST" (Ctrl+Shift+A)
- ✅ Comando "Visualizar AST"

### 🎨 **Melhorias**
- 💫 Menu de contexto reorganizado
- 💫 Ícones atualizados para comandos
- 💫 Melhor integração com compilador

---

## [1.3.0] - 2024-10-15

### ✨ **Recursos Adicionados**
- ✅ Snippets para estruturas de controle
- ✅ Autocomplete para palavras-chave
- ✅ Templates para funções básicas
- ✅ Snippet para declaração de variáveis

### 🔧 **Melhorias Técnicas**
- 📝 Melhorado syntax highlighting
- 📝 Adicionado suporte para comentários
- 📝 Otimizado reconhecimento de tokens

---

## [1.2.0] - 2024-10-01

### ✨ **Recursos Adicionados**
- ✅ Comando "Executar MiniDart" (Ctrl+F5)
- ✅ Comando "Compilar MiniDart" (Ctrl+Shift+B)
- ✅ Integração com terminal para output
- ✅ Configurações da extensão

### ⚙️ **Configurações**
- ✅ `minidart.compilerPath` - Caminho do compilador
- ✅ `minidart.autoCompile` - Compilação automática
- ✅ `minidart.showAST` - Exibição de AST

---

## [1.1.0] - 2024-09-15

### ✨ **Recursos Adicionados**
- ✅ Syntax highlighting básico
- ✅ Reconhecimento de arquivo .mdart
- ✅ Palavras-chave em português
- ✅ Destaque para tipos de dados
- ✅ Suporte para strings e números

### 🎨 **Melhorias**
- 💫 Cores específicas para elementos da linguagem
- 💫 Configuração de linguagem básica
- 💫 Auto-closing pairs para parênteses e chaves

---

## [1.0.0] - 2024-09-01

### 🎉 **Versão Inicial**
- ✅ Extensão básica do VS Code
- ✅ Reconhecimento de arquivos .mdart
- ✅ Configuração inicial do projeto
- ✅ Estrutura base da extensão

---

## 🔮 **Roadmap Futuro**

### 📋 **v2.2.0 - Planejado**
- [ ] IntelliSense avançado com autocompletar contextual
- [ ] Refactoring automático (renomear símbolos)
- [ ] Quick fixes para erros comuns
- [ ] Hover information com documentação
- [ ] Go to definition/references

### 🎨 **v2.3.0 - Planejado**
- [ ] Temas personalizados para syntax highlighting
- [ ] Minimap personalizado para código MiniDart
- [ ] Breadcrumbs detalhados para navegação
- [ ] Formatter avançado com configuração de estilo

### 🧪 **v2.4.0 - Planejado**
- [ ] Framework de testes integrado
- [ ] Test runner no VS Code
- [ ] Code coverage visualization
- [ ] Profiling e análise de performance

### 🔧 **v2.5.0 - Planejado**
- [ ] Suporte para múltiplos arquivos/projetos
- [ ] Sistema de módulos avançado
- [ ] Workspace symbols
- [ ] Project templates

---

**Extensão VS Code MiniDart - Sempre Evoluindo!** 🚀📈
