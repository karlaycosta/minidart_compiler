# Changelog

Todas as alterações notáveis deste projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/),
e este projeto adere ao [Versionamento Semântico](https://semver.org/lang/pt-BR/).

## 🚀 Resumo das Principais Funcionalidades

**MiniDart Compiler** é um compilador completo para uma linguagem de programação em português, com:

- 🏗️ **Pipeline completo**: Lexer → Parser → Análise Semântica → Geração de Código → VM
- 🇧🇷 **Sintaxe em português**: `var`, `se`, `senao`, `enquanto`, `para`, `imprimir`, `funcao`
- 🔄 **Loops avançados**: Loop `para` com incremento automático e personalizado
- � **Funções completas**: Declaração, chamada, parâmetros e valores de retorno
- �🎨 **Extensão VS Code**: Suporte completo com syntax highlighting e snippets
- 📊 **Visualização AST**: Geração automática de gráficos da árvore sintática
- ⚡ **VM Stack-based**: Execução eficiente de bytecode com call stack

---

## [1.4.1] - 2025-07-24

### 🐛 Corrigido
- **Crítico: Mapeamento incorreto de linhas em erros de runtime**:
  - Resolvido problema onde erros mostravam linha de bytecode (ex: linha 78) em vez da linha correta do código fonte (ex: linha 3)
  - **Causa identificada**: Switch case no lexer sem `break` statements causava fall-through incorreto
  - Caracteres de whitespace (espaço, tab, `\r`) incrementavam incorretamente o contador de linhas
  - Adicionados `break` statements nos cases de whitespace no método `_scanToken()` do lexer
  - Todos os erros de runtime agora mostram a linha correta do código fonte

### ✨ Adicionado
- **🎯 Informação de coluna em erros de runtime**: Localização precisa de erros
  - Campo `column` adicionado à classe `Token` para rastreamento de posição horizontal
  - Contadores `_column` e `_tokenStartColumn` implementados no lexer
  - Classe `SourceLocation` expandida com suporte a linha e coluna
  - Método `writeWithLocation()` no `BytecodeChunk` para mapeamento completo
  - Método `getSourceLocation()` para recuperar localização completa de instruções
  - **LocationVisitor**: Novo visitor para extrair informações de localização da AST
  - VM atualizada para reportar "[linha X, coluna Y]" em vez de apenas "[linha X]"

### 🔧 Melhorado
- **Precisão de debugging**: Erros agora mostram localização exata do problema
  - Exemplo: `"Operandos devem ser dois números ou duas strings [linha 3, coluna 15]"`
  - Facilita identificação imediata da posição do erro no código fonte
- **Rastreamento de posição aprimorado**:
  - Reset automático de coluna em quebras de linha (`\n`)
  - Tratamento correto de line endings Windows (`\r\n`)
  - Rastreamento de coluna em strings multi-linha
- **Compatibilidade mantida**: 
  - Métodos antigos de mapeamento de linha continuam funcionando
  - Adição de funcionalidades sem quebrar código existente

### ✅ Validado
- **Arquivo de linha única**: `imprimir "x"+2;` → "[linha 1, coluna 13]" ✓
- **Arquivo de múltiplas linhas**: erro na linha 3 → "[linha 3, coluna 15]" ✓  
- **Precisão verificada**: Contagem manual de caracteres confirma localização exata
- **Compatibilidade**: Todos os exemplos existentes continuam funcionando

### 🚀 Impacto
- **Experiência de desenvolvimento significativamente melhorada**
- **Debugging mais eficiente** com localização precisa de erros
- **Base sólida** para futuras melhorias no sistema de relatório de erros

---

## [1.4.0] - 2025-07-24

### ✨ Adicionado
- **🎯 Suporte Completo a Funções**: Implementação completa do sistema de funções
  - **Declaração de funções**: `funcao nome(parametros) { ... retornar valor; }`
  - **Chamadas de função**: `resultado = nome(argumentos);`
  - **Parâmetros tipados**: Suporte a múltiplos parâmetros com tipos
  - **Valores de retorno**: Palavra-chave `retornar` para retorno de valores
  - **Call stack**: Sistema completo de pilha de chamadas com `CallFrame`
  - **Escopo de função**: Isolamento de variáveis entre contextos de execução
- **Novos tokens e palavras-chave**:
  - `funcao` - Declaração de função
  - `retornar` - Retorno de valor
  - Parênteses e vírgulas para listas de parâmetros
- **Classes AST para funções**:
  - `FunctionStmt`: Declaração de função
  - `CallExpr`: Chamada de função
  - `ReturnStmt`: Comando de retorno
- **Bytecode para funções**:
  - `OpCode.call`: Instrução de chamada de função
  - `CompiledFunction`: Representação compilada de funções
  - Geração de bytecode separado para cada função
- **Exemplos funcionais**:
  - `demonstracao_funcoes_completa.mdart`: Demonstração completa
  - Funções matemáticas: `area_retangulo`, `quadrado`, `eh_par`
  - Chamadas aninhadas e expressões complexas

### 🔧 Arquitetura Avançada
- **Máquina Virtual aprimorada**:
  - `CallFrame`: Gerenciamento de contexto de execução
  - `_callValue()`: Validação e preparação de chamadas
  - `_call()`: Execução de chamadas de função
  - `_executeFunction()`: Execução isolada de bytecode de função
  - Passagem de parâmetros via variáveis globais temporárias
- **Gerador de código expandido**:
  - `visitFunctionStmt()`: Compilação de declarações de função
  - `visitCallExpr()`: Geração de instruções de chamada
  - `visitReturnStmt()`: Geração de instruções de retorno
  - Armazenamento de funções compiladas em `codeGenerator.functions`
- **Parser de funções**:
  - Parsing de declaração com lista de parâmetros
  - Parsing de chamadas com lista de argumentos
  - Parsing de comandos de retorno com expressões

### ✅ Funcionalidades Validadas
- **Funções com múltiplos parâmetros**: `area_retangulo(8, 6)` → 48.0
- **Funções com um parâmetro**: `quadrado(7)` → 49.0
- **Chamadas aninhadas**: `quadrado(area_retangulo(3, 4))` → 144.0
- **Loops com funções**: Iteração calculando quadrados de 1 a 5
- **Expressões complexas**: Integração perfeita com operadores aritméticos

### 🚀 Impacto
- MiniDart agora é uma linguagem **funcionalmente completa**
- Suporte total a **programação procedural** com funções
- Base sólida para futuras funcionalidades (recursão, closures)
- Compatibilidade mantida com todas as funcionalidades anteriores

---

## [1.3.0] - 2025-07-23

### ✨ Adicionado
- **Loop `para` com incremento personalizado**: Nova sintaxe `para variavel = inicio ate fim passo incremento faca`
  - Mantida compatibilidade total com sintaxe anterior (`para variavel = inicio ate fim faca`)
  - Suporte a incrementos customizados (2, 3, 5, etc.)
  - Duas classes AST: `ForStmt` (incremento 1) e `ForStepStmt` (incremento personalizado)
  - Parser inteligente que detecta automaticamente qual sintaxe está sendo usada
  - Escopo local da variável de controle em ambas as sintaxes
- **Palavra-chave `passo`**: Nova palavra-chave para especificar incremento
  - Token `TokenType.step_` adicionado ao lexer
  - Integração completa no sistema de tokens
- **Exemplos de uso do loop `para` com incremento**:
  - `exemplo_para_com_passo.mdart`: Demonstrações variadas de incrementos
  - `demo_para_simples.mdart`: Comparação das duas sintaxes
  - `demo_completa_para.mdart`: Demonstração abrangente com cálculos

### 🎨 Melhorado
- **Extensão VS Code atualizada para v1.3.0**:
  - Syntax highlighting para palavra-chave "passo"
  - 4 novos snippets: `parapasso`, `parapasso2`, `parapasso5`, `parapasso`
  - README.md e USAGE.md atualizados com exemplos das duas sintaxes
  - Documentação completa dos novos recursos
- **Gerador de código**: Lógica otimizada para ambos os tipos de loop
- **Analisador semântico**: Validação de expressões de incremento
- **Visualização AST**: Suporte para `ForStepStmt` no Graphviz com label "🔄 para+passo"

### 🔧 Arquitetura
- **AST expandida**: Interface `AstVisitor` atualizada com `visitForStepStmt`
- **Parser aprimorado**: Detecção condicional da sintaxe `passo`
- **Bytecode**: Geração específica para incrementos personalizados
- **VM**: Execução eficiente de loops com qualquer incremento

### 📊 Validado
- **Incremento 1**: `para i = 1 ate 5 faca` → 1, 2, 3, 4, 5
- **Incremento 2**: `para x = 0 ate 10 passo 2 faca` → 0, 2, 4, 6, 8, 10
- **Incremento 3**: `para y = 1 ate 15 passo 3 faca` → 1, 4, 7, 10, 13
- **Incremento 5**: `para z = 5 ate 25 passo 5 faca` → 5, 10, 15, 20, 25
- **Compatibilidade**: Ambas sintaxes funcionam no mesmo arquivo

## [1.2.0] - 2025-07-23

### ✨ Adicionado
- **Extensão VS Code MiniDart**: Suporte completo para desenvolvimento MiniDart no Visual Studio Code
  - Syntax highlighting específico para palavras-chave em português
  - Snippets e templates para estruturas básicas (algoritmo, função, se, enquanto, para)
  - Comandos integrados para compilar, executar e gerar AST
  - Atalhos de teclado (Ctrl+F5 para executar, Ctrl+Shift+B para compilar, Ctrl+Shift+A para AST)
  - Configurações personalizáveis (caminho do compilador, auto-compilação)
  - Criação automática de novos arquivos MiniDart com template
  - Detecção automática de arquivos .mdart
  - Integração completa com o terminal do VS Code
- **Loop `para` básico**: Nova estrutura de repetição com contador automático
  - Sintaxe: `para variavel = inicio ate fim faca { ... }`
  - Incremento automático de 1 a cada iteração
  - Escopo local para variável de controle
  - Palavras-chave `para`, `ate`, `faca` adicionadas ao lexer
  - Classe `ForStmt` na AST para representar loops for
  - Exemplos: `exemplo_loop_para.mdart`, `teste_para_simples.mdart`

### 🐛 Corrigido
- **Crítico: Loop `enquanto` com erro de execução**: 
  - Resolvido erro "Operandos devem ser números" em loops while
  - Corrigida operação `jumpIfFalse` na VM que não fazia pop da condição da pilha
  - Pilha da VM agora permanece equilibrada durante execução de loops
  - Cálculo de offset do loop corrigido para voltar à posição correta
  - Todos os loops `enquanto` agora funcionam perfeitamente
- **Escape de aspas duplas no gerador AST Graphviz**:
  - Corrigido erro de sintaxe nas linhas 24 e 40 do arquivo DOT gerado
  - Removidas aspas duplas extras em strings literais
  - Melhorada função `_escapeLabel()` com ordem correta de escape
  - Garantida compatibilidade total com Graphviz

### 🔧 Melhorado
- **Máquina Virtual**: Estabilidade e confiabilidade aprimoradas
- **Extensão VS Code**: Interface moderna e intuitiva para desenvolvimento MiniDart
- **Debugging**: Melhor tratamento de erros de execução

## [1.1.1] - 2025-07-23

### 🐛 Corrigido
- **Escape de aspas duplas no gerador AST Graphviz**:
  - Corrigido erro de sintaxe nas linhas 24 e 40 do arquivo DOT gerado
  - Removidas aspas duplas extras em strings literais que causavam falha na geração de imagens
  - Melhorada função `_escapeLabel()` com ordem correta de escape de caracteres especiais
  - Resolvido erro "syntax error in line X" ao executar comando `dot -Tpng`
  - Garantida compatibilidade total com Graphviz para geração de PNG, SVG e PDF

## [1.1.0] - 2025-07-23

### ✨ Adicionado
- **Gerador de AST em Graphviz**: Nova funcionalidade para visualização gráfica da Árvore Sintática Abstrata
  - Classe `ASTGraphvizGenerator` implementando o padrão Visitor
  - Geração automática de arquivo DOT durante a compilação
  - Suporte a visualização em PNG, SVG e PDF
  - Cores e emojis diferenciados para cada tipo de nó da AST
- **Interface CLI melhorada**:
  - Nova opção `--ast-only` para gerar apenas a AST sem executar o código
  - Instruções detalhadas de uso com exemplos
  - Detecção automática do Graphviz e instruções de instalação
- **Novo exemplo**: `exemplos/exemplo_ast.mdart` para demonstração da visualização AST
- **Documentação expandida**:
  - Seção completa sobre visualização de AST no README.md
  - Guia de cores e símbolos da AST
  - Instruções de instalação do Graphviz para diferentes sistemas operacionais
  - Seção de debugging e análise melhorada

### 🔧 Melhorado
- README.md atualizado com informações do autor **Deriks Karlay Dias Costa**
- Documentação mais detalhada sobre uso do compilador
- Interface de linha de comando mais informativa

### 🐛 Corrigido
- Diagrama Mermaid no `parser.md` corrigido para compatibilidade com GitHub
  - Removidos caracteres problemáticos que causavam erros de renderização
  - Sintaxe simplificada para melhor compatibilidade

### 📚 Documentação
- Adicionadas instruções detalhadas para visualização da AST
- Documentação em português para todas as novas funcionalidades
- Exemplos práticos de uso da geração de AST

## [1.0.0] - 2025-07-23

### ✨ Inicial
- **Compilador MiniDart completo** com pipeline de 5 estágios:
  - 🔍 **Lexer**: Análise léxica com suporte a português
  - 🌳 **Parser**: Parser de descida recursiva gerando AST
  - 🧠 **Semantic Analyzer**: Análise semântica com verificação de tipos e escopo
  - ⚙️ **Code Generator**: Geração de bytecode otimizado
  - 🚀 **Virtual Machine**: VM stack-based para execução
- **Sintaxe em português**:
  - Palavras-chave: `var`, `se`, `senao`, `enquanto`, `imprimir`
  - Tipos: números, strings, booleanos, `nulo`
  - Operadores: aritméticos, comparação, lógicos (`e`, `ou`)
- **Funcionalidades implementadas**:
  - ✅ Declaração e atribuição de variáveis
  - ✅ Estruturas condicionais (`se`/`senao`)
  - ✅ Loops (`enquanto`, `para`)
  - ✅ Blocos de código
  - ✅ Expressões aritméticas e lógicas
  - ✅ Comandos de impressão
  - ✅ Precedência de operadores
- **Arquitetura robusta**:
  - Padrão Visitor para processamento da AST
  - Sistema de tratamento de erros integrado
  - Tabela de símbolos para gerenciamento de escopo
  - Geração de bytecode otimizada
- **Exemplos incluídos**:
  - `exemplo_basico.mdart`: Demonstração básica
  - `exemplo_completo.mdart`: Todas as funcionalidades
  - `calculadora_notas.mdart`: Calculadora de notas
  - `exemplo_funcional.mdart`: Programação funcional
- **Documentação completa**:
  - README.md detalhado em português
  - `parser.md`: Análise técnica completa do parser
  - Código fonte totalmente documentado
  - Exemplos práticos de uso
