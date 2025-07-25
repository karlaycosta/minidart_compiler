# Changelog

Todas as alterações notáveis deste projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/),
e este projeto adere ao [Versionamento Semântico](https://semver.org/lang/pt-BR/).

## [1.12.7] - 2025-07-25

### ✨ Adicionado
- **📅 Biblioteca Data/Tempo Implementada**: Nova biblioteca 'data' com 12 funções completas
  - **Funções básicas**: `hoje()`, `horaAtual()` - data/hora atual
  - **Cálculos**: `diferenca()`, `adicionarDias()` - operações matemáticas com datas
  - **Validação**: `ehBissexto()`, `ehDataValida()` - verificações de validade
  - **Formatação**: `formatar()`, `nomeMes()`, `nomeDiaSemana()` - conversões de exibição
  - **Informações**: `diaSemana()` - extração de dados de datas
  - **Timestamp**: `timestamp()`, `deTimestamp()` - conversões Unix
  - **Compatibilidade**: Funciona com sistema de imports (`importar data;` ou `importar data como dt;`)
  - **Validação integrada**: Biblioteca reconhecida pelo semantic analyzer
  - **Arquivos de teste**: 4 exemplos práticos incluídos

### 🧪 Exemplos Criados
- **`demo_biblioteca_data.mdart`** - Demonstração básica da biblioteca
- **`teste_completo_data.mdart`** - Teste de todas as 12 funções
- **`teste_validacao_data.mdart`** - Testes específicos de validação
- **`teste_biblioteca_data.mdart`** - Exemplo com alias

### 🔧 Melhorado
- **StandardLibrary**: Método `_registerDataLibrary()` com 12 funções implementadas
- **Semantic Analyzer**: Biblioteca 'data' adicionada à lista de bibliotecas válidas
- **Sistema de imports**: Suporte completo para `importar data` e `importar data como alias`

## [1.12.6] - 2025-07-25

### ✨ Adicionado
- **📦 Sistema de Imports com Alias**: Implementação completa do sistema de importação de bibliotecas
  - **Import básico**: `importar math;` - importação direta da biblioteca
  - **Import com alias**: `importar math como calc;` - importação com apelido personalizado
  - **Múltiplas bibliotecas**: Suporte a importar math, string, io simultaneamente
  - **Sintaxe portuguesa**: Palavras-chave `importar` e `como` integradas ao lexer
  - **Prevenção de conflitos**: Sistema detecta e previne alias duplicados
  - **31+ funções disponíveis**: Todas as funções das bibliotecas padrão acessíveis via imports
  - **Exemplos funcionais**:
    - `importar math; math.sqrt(16);` → `4.0`
    - `importar math como calc; calc.sqrt(16);` → `4.0`
    - `importar string como str; str.maiuscula("texto");` → `"TEXTO"`
    - `importar io como saida; saida.imprimir("Olá!");` → output direto

### 🏗️ Arquitetura do Sistema de Imports
- **Novos tokens**: `TokenType.import_` e `TokenType.as_` com suporte completo
- **AST expandida**: Classe `ImportStmt` para representar declarações de import
- **Parser inteligente**: Método `_importStatement()` com parsing de alias opcional
- **Análise semântica robusta**:
  - Validação de bibliotecas existentes (`math`, `string`, `io`)
  - Detecção de conflitos de alias: `"Alias 'x' já está em uso"`
  - Rastreamento de imports com mapeamento `_importedLibraries`
  - Verificação de redeclaração de alias no mesmo escopo
- **Geração de código otimizada**:
  - Resolução automática de alias para nomes reais de biblioteca
  - Mapeamento `_libraryAliases` para tradução durante compilação
  - Suporte completo a `MemberAccessExpr` com alias
- **VM atualizada**: Execução perfeita de chamadas de função via alias

### 🚀 Funcionalidades Validadas
- **Bibliotecas padrão completas**: math, string, io totalmente funcionais
- **Sintaxe flexível**: Import direto e com alias funcionam simultaneamente
- **Integração total**: Alias funcionam em qualquer contexto (expressões, loops, condicionais)
- **Compatibilidade**: Sistema funciona junto com todas as funcionalidades existentes
- **Performance**: Resolução de alias em tempo de compilação (zero overhead runtime)

## [1.12.5] - 2025-01-XX

### ✨ Adicionado
- **🔍 Inferência de Tipos para Constantes**: Nova sintaxe com inferência automática de tipos
  - **Nova sintaxe**: `constante var nome = valor;` - inferência automática baseada no valor inicial
  - **Sintaxe explícita mantida**: `constante tipo nome = valor;` - continua funcionando normalmente
  - **Inferência inteligente**:
    - Números inteiros (16) → inferidos como `inteiro` → imprimem `16`
    - Números reais (1.75) → inferidos como `real` → imprimem `1.75`
    - Strings ("texto") → inferidos como `texto`
    - Booleanos (verdadeiro/falso) → inferidos como `logico`
  - **Método `_inferTypeFromExpression()`**: Análise automática do valor para determinar tipo correto
  - **Tokens artificiais**: Criação de tokens de tipo com localização correta para debugging
  - **Compatibilidade total**: Ambas as sintaxes podem ser usadas no mesmo arquivo
  - **Exemplos funcionais**:
    - `constante var idade = 16;` → tipo `inteiro`, imprime `16`
    - `constante var altura = 1.75;` → tipo `real`, imprime `1.75`
    - `constante var nome = "João";` → tipo `texto`
    - `constante var ativo = verdadeiro;` → tipo `logico`

### 🔧 Melhorado
- **Parser expandido**: Método `_constDeclaration()` atualizado para suportar inferência
  - Detecção automática entre sintaxe explícita e inferência
  - Validação aprimorada de tipos inferidos
  - Mensagens de erro mais claras: "Esperado tipo ou 'var' após 'constante'"
- **Sistema de tipos aprimorado**: Lógica inteligente para preservar identidade de tipos
  - Números sem casa decimal inferidos como `inteiro`
  - Números com casa decimal inferidos como `real`
  - Fallback seguro para tipo `real` quando inferência falha

### 📚 Adicionado
- **📋 Documentação de Recursividade**: Documentação completa das capacidades recursivas já existentes
  - **Análise técnica**: Sistema de call stack com `CallFrame` e pilha `_frames`
  - **Arquitetura robusta**: Backup e restauração automática de contexto de execução
  - **Algoritmos clássicos**: Fatorial, Fibonacci, MDC, Torre de Hanói, Ackermann
  - **Exemplos funcionais**: `exemplo_recursividade.mdart` e `exemplo_recursividade_avancada.mdart`
  - **Capacidades validadas**:
    - ✅ Recursão simples: `fatorial(5)` → `120`
    - ✅ Recursão múltipla: `fibonacci(8)` → `21`
    - ✅ Recursão com parâmetros: `mdc(48, 18)` → `6`
    - ✅ Recursão de cauda: `contagemRegressiva(5)`
    - ✅ Recursão extrema: `ackermann(2, 2)` → `7`
  - **Arquivo de documentação**: `recursividade.md` com análise completa
  - **Descoberta importante**: Recursividade já estava completamente implementada na VM

## [1.12.4] - 2025-01-XX

### 🐛 Corrigido
- **Crítico: Impressão incorreta de tipos inteiros**: Correção da exibição de valores inteiros
  - **Problema**: Constantes e variáveis do tipo `inteiro` eram impressas como números decimais (ex: `16.0` em vez de `16`)
  - **Causa identificada**: Sistema de tipos sempre armazenava valores como `double` internamente, sem conversão para exibição
  - **Solução implementada**: 
    - Novo `OpCode.toInt` adicionado ao conjunto de instruções bytecode
    - Code generator emite instrução `toInt` para tipos inteiros em declarações e constantes
    - VM processa instrução `toInt` convertendo valores double para int antes da exibição
    - Formatação inteligente: números inteiros exibem sem casas decimais, reais mantêm formato original
  - **Arquivos modificados**: `bytecode.dart`, `code_generator.dart`, `vm.dart`
  - **Resultado**: `constante inteiro idade = 16` agora imprime corretamente `16` em vez de `16.0`

### ✨ Adicionado
- **📚 Documentação Completa**: Criação do arquivo `resumo.md` com todas as funcionalidades
  - **Conteúdo**: Mais de 50 funcionalidades documentadas com exemplos práticos
  - **Estrutura**: Tipos de dados, operadores, estruturas de controle, funções, loops
  - **Exemplos**: Código prático para cada funcionalidade da linguagem
  - **Guia de referência**: Manual completo para desenvolvedores MiniDart
- **📦 Publicação GitHub**: Repositório atualizado com todas as melhorias
  - **Commits organizados**: Histórico limpo com mensagens descritivas
  - **Documentação sincronizada**: README, CHANGELOG e código alinhados
  - **Versionamento**: Tags de versão para controle de releases

### 🔧 Melhorado
- **🎨 Extensão VS Code v1.5.1**: Atualização da extensão com correções importantes
  - **Snippets corrigidos**: Uso correto de `imprima` e `retorne` em todos os templates
  - **Comando de execução**: Correção do comando `--run` para execução direta
  - **Syntax highlighting**: Suporte aprimorado para palavras reservadas atualizadas
  - **Documentação**: README e USAGE.md atualizados com sintaxe correta
- **⚡ Sistema de tipos aprimorado**: Melhor handling de conversões numéricas
  - **Preservação de tipos**: Inteiros mantêm identidade visual sem perder precisão
  - **Compatibilidade**: Sistema continua suportando operações matemáticas mistas
  - **Performance**: Conversão eficiente sem overhead significativo

## [1.12.3] - 2025-01-XX

### 📝 Alterado
- **🔄 Palavra-Chave Void**: Reversão de `nada` para `vazio` para funções sem retorno
  - **🔤 Palavra-Chave**: `vazio` volta a ser a palavra reservada para funções void
  - **Sintaxe**: `vazio nome_funcao() { ... }` para funções que não retornam valores
  - **Tokens Atualizados**: Representação atualizada para "Tipo Vazio"
  - **Arquivos de Teste**: Atualizados todos os exemplos para usar `vazio`

## [1.12.2] - 2025-01-XX

### ✨ Adicionado
- **🚫 Suporte a Funções Void**: Implementação da palavra-chave `nada` para funções sem retorno
  - **🔤 Palavra-Chave**: `nada` substitui `vazio` para melhor compreensão
  - **Sintaxe**: `nada nome_funcao() { ... }` para funções que não retornam valores
  - **Exemplos**: Funções de relatório, impressão, e procedimentos gerais
  - **Tokens Atualizados**: Representação atualizada para "Tipo Nada"

### 📝 Alterado
- **Arquivos de Teste**: Atualizados `teste_simples.mdart` e `teste_complexo.mdart` com exemplos de funções void
- **Documentação**: Comentários e mensagens atualizadas para refletir `nada` em vez de `vazio`

## [1.12.1] - 2025-01-XX

### 🗑️ Removido
- **Compatibilidade com Sintaxe Antiga**: Remoção completa da compatibilidade com palavras-chave antigas
  - **❌ `imprimir`**: Removido suporte para sintaxe antiga, usar apenas `imprima`
  - **❌ `retornar`**: Removido suporte para sintaxe antiga, usar apenas `retorne`
  - **Sintaxe Modernizada**: Apenas as novas palavras-chave mais concisas são aceitas
  - **Breaking Change**: Códigos usando sintaxe antiga não compilarão mais

## [1.12.0] - 2025-01-XX

### ✨ Adicionado
- **🔄 Modernização de Palavras-Chave**: Substituição de comandos por versões mais concisas
  - **📝 `imprima`**: Substituição de `imprimir` por forma mais curta e direta
  - **↩️ `retorne`**: Substituição de `retornar` por forma mais imperativa
  - **Compatibilidade Temporária**: Ambas as sintaxes funcionam durante transição (removida em v1.12.1)
- **Tokens Atualizados**: Representação string atualizada para novos comandos
- **Parser Modernizado**: Documentação e comentários atualizados para refletir nova sintaxe

## [1.11.0] - 2025-01-XX

### ✨ Adicionado
- **🔄 Sintaxe Aprimorada para Loops For**: Substituição da palavra-chave `passo` por direcionais mais expressivos
  - **🔼 `incremente`**: Para incrementar a variável de controle do loop
  - **🔽 `decremente`**: Para decrementar a variável de controle do loop
  - **Sintaxe bidirecional**: Loops podem agora contar para cima ou para baixo explicitamente
  - **Lógica inteligente**: Operadores de comparação automáticos baseados na direção (`>` para incremento, `<` para decremento)
- **Novos Tokens**: `TokenType.increment_` e `TokenType.decrement_` substituindo `TokenType.step_`
- **AST Expandida**: Campo `bool isIncrement` na classe `ForStepStmt` para controle de direção
- **Geração de Código Inteligente**: Operações aritméticas automáticas (`add` para incremento, `subtract` para decremento)
- **Visualização AST Aprimorada**: Labels dinâmicos "para+incremente" ou "para+decremente" no gerador de gráficos

### 🔧 Melhorado
- **Parser**: Detecção condicional de `incremente` vs `decremente` para determinação automática da direção
- **Lexer**: Reconhecimento das novas palavras-chave portuguesas mais intuitivas
- **Code Generator**: Lógica de comparação e operação baseada na direção do loop
  - Incremento: `variavel > limite` (sai quando ultrapassar) + operação `add`
  - Decremento: `variavel < limite` (sai quando ficar abaixo) + operação `subtract`
- **Semantic Analyzer**: Análise apropriada para ambas as direções de loop

### 📝 Exemplos de Uso
```dart
// ✅ INCREMENTO - Contagem crescente
para i = 0 ate 10 incremente 2 faca {
    imprimir i; // Saída: 0, 2, 4, 6, 8, 10
}

// ✅ DECREMENTO - Contagem decrescente  
para j = 10 ate 0 decremente 2 faca {
    imprimir j; // Saída: 10, 8, 6, 4, 2, 0
}

// ✅ INCREMENTOS PERSONALIZADOS
para k = 1 ate 15 incremente 3 faca {
    imprimir k; // Saída: 1, 4, 7, 10, 13
}

// ✅ DECREMENTOS PERSONALIZADOS
para m = 25 ate 0 decremente 5 faca {
    imprimir m; // Saída: 25, 20, 15, 10, 5, 0
}
```

### 🚨 Breaking Changes
- **❌ Palavra-chave `passo` removida**: Não é mais suportada
- **✅ Migração necessária**: 
  - `para x = 0 ate 10 passo 2 faca` → `para x = 0 ate 10 incremente 2 faca`
  - Para loops decrescentes: usar `decremente` com lógica de limite apropriada

### 🎯 Benefícios da Nova Sintaxe
- **Clareza semântica**: Diferenciação explícita entre incremento e decremento
- **Intuitividade**: Palavras-chave que expressam claramente a intenção
- **Flexibilidade**: Suporte nativo a loops bidirecionais sem ambiguidade
- **Robustez**: Lógica de comparação automática evita erros de loop infinito

### 🚀 Compatibilidade
- **Retrocompatível**: Loops básicos (`para x = 1 ate 5 faca`) continuam funcionando
- **Coexistência**: Incremento, decremento e loops básicos podem ser usados no mesmo programa
- **Migração simples**: Substituição direta de `passo` por `incremente` na maioria dos casos

## [1.10.0] - 2025-01-XX

### ✨ Adicionado
- **🔄 Loop Do-While (faca...enquanto)**: Implementação completa do loop que executa pelo menos uma vez
  - **Sintaxe**: `faca { statements } enquanto (condição);`
  - **Semântica**: Executa o corpo primeiro, depois verifica a condição (diferente do while)
  - **Garantia de execução**: O corpo sempre executa pelo menos uma vez, mesmo com condição inicial falsa
  - **Casos de uso**: Ideal para menus interativos, validação de entrada, loops que precisam executar ao menos uma iteração
- **Novo Token**: `TokenType.dowhile_` para reconhecimento do construto
- **Nova AST**: Classe `DoWhileStmt` com visitor pattern completo
- **Sintaxe Portuguesa**: Mantém a consistência com `faca` e `enquanto` da linguagem
- **Geração de Bytecode**: Controle de fluxo otimizado com verificação da condição após execução do corpo
- **Visualização AST**: Suporte ao loop do-while no gerador de gráficos com ícone 🔄 e cor diferenciada

### 🔧 Melhorado
- **Parser**: Detecção automática de loops do-while vs while tradicional
- **Lexer**: Reutilização da palavra-chave `faca` já existente no sistema
- **Code Generator**: Geração eficiente de bytecode com `jumpIfFalse` e `_emitLoop`
- **Semantic Analyzer**: Análise do corpo primeiro, depois da condição (ordem correta para do-while)
- **Visitors**: Todos os visitors atualizados (`LineVisitor`, `LocationVisitor`, `ASTGraphvizGenerator`)

### 📝 Exemplos de Uso
```dart
// Execução garantida (pelo menos uma vez)
inteiro contador = 10;
faca {
    imprimir "Executa mesmo com condição falsa";
    contador = contador + 1;
} enquanto (contador < 5);

// Menu interativo
inteiro opcao = 0;
faca {
    imprimir "Menu - opcao: " + opcao;
    opcao = opcao + 1;
} enquanto (opcao < 3);

// Validação de entrada
inteiro valor = -1;
faca {
    valor = valor + 2;
    imprimir "Tentativa: " + valor;
} enquanto (valor < 5);
```

### 🎯 Diferenças entre While e Do-While
- **While**: `enquanto (condição) { corpo }` - testa condição **antes** de executar
- **Do-While**: `faca { corpo } enquanto (condição);` - testa condição **depois** de executar
- **Garantia**: Do-while sempre executa o corpo pelo menos uma vez

### 🚀 Compatibilidade
- **Retrocompatível**: Todos os loops `enquanto` existentes continuam funcionando
- **Coexistência**: While e do-while podem ser usados no mesmo programa
- **Sintaxe consistente**: Usa palavras-chave portuguesas já estabelecidas

## [1.9.0] - 2024-01-XX

### ✨ Adicionado
- **Operador Ternário (? :)**: Implementação completa do operador condicional ternário
  - Sintaxe: `condição ? valor_verdadeiro : valor_falso`
  - Suporte a aninhamento: `x > 15 ? "grande" : x > 5 ? "médio" : "pequeno"`
  - Associatividade à direita para múltiplos ternários
- **Novos Tokens**: `TokenType.question` (?) e `TokenType.colon` (:)
- **Nova AST**: Classe `TernaryExpr` com visitor pattern completo
- **Precedência Correta**: Ternário entre atribuição e operadores lógicos
- **Geração de Bytecode**: Controle de fluxo eficiente com saltos condicionais
- **Visualização AST**: Suporte ao operador ternário no gerador de gráficos

### 🔧 Melhorado
- **Parser**: Hierarquia de precedência atualizada para incluir expressões ternárias
- **Lexer**: Reconhecimento de caracteres `?` e `:` como tokens individuais
- **Code Generator**: Geração otimizada de saltos condicionais para ternário
- **Semantic Analyzer**: Análise de todas as três expressões do ternário

### 📝 Exemplos de Uso
```dart
// Básico
var status = idade >= 18 ? "adulto" : "menor";

// Aninhado
var categoria = nota >= 90 ? "A" : nota >= 80 ? "B" : "C";

// Com expressões
var resultado = (x + y) > 10 ? x * y : x - y;
```

## [1.8.0] - 2024-01-XX

### ✨ Adicionado
- **Operador Módulo (%)**: Implementação completa do operador módulo para operações matemáticas
- **Operadores de Atribuição Composta**: Implementação de `+=`, `-=`, `*=`, `/=`, `%=`
- **Operador de Decremento**: Implementação completa de `--` (pré-fixo e pós-fixo)
- **Melhorias no Lexer**: Reconhecimento aprimorado de operadores compostos
- **Melhorias no Parser**: Precedência correta para novos operadores
- **Melhorias na AST**: Novas classes `CompoundAssignExpr` e `DecrementExpr` com suporte a pré/pós-fixo
- **Melhorias no Code Generator**: Geração de bytecode para todos os novos operadores
- **Melhorias na VM**: Suporte completo para operações módulo

### 🔧 Corrigido
- **Recursão infinita**: Corrigido bug em `LineVisitor.visitGroupingExpr` que causava stack overflow
- **Operadores pós-fixo**: Corrigida implementação de incremento/decremento pós-fixo para retornar valor original
- **Palavras reservadas**: Evitado conflito com palavra reservada 'e' (operador lógico AND)

### 📝 Atualizado
- **Testes abrangentes**: Novos arquivos de teste para todos os operadores implementados
- **Documentação**: Atualizada documentação da AST com novos tipos de expressão

## 🚀 Resumo das Principais Funcionalidades

**MiniDart Compiler** é um compilador completo para uma linguagem de programação em português, com:

- 🏗️ **Pipeline completo**: Lexer → Parser → Análise Semântica → Geração de Código → VM
- 🇧🇷 **Sintaxe em português**: `var`, `se`, `senao`, `enquanto`, `faca`, `para`, `imprimir`, `funcao`, `constante`
- 🔒 **Constantes tipadas**: Declaração de valores imutáveis com proteção contra reatribuição
- 🔄 **Loops avançados**: While (`enquanto`), do-while (`faca...enquanto`), for tradicional, for estilo C, e for com `incremente`/`decremente`
- 🎯 **Operador ternário**: Expressões condicionais (`condição ? verdadeiro : falso`)
- 🎭 **Funções completas**: Declaração, chamada, parâmetros e valores de retorno
- 🧮 **Operadores completos**: Aritméticos (+, -, *, /, %), atribuição composta (+=, -=, *=, /=, %=), incremento/decremento (++, --)
- 🎨 **Extensão VS Code**: Suporte completo com syntax highlighting e snippets
- 📊 **Visualização AST**: Geração automática de gráficos da árvore sintática
- ⚡ **VM Stack-based**: Execução eficiente de bytecode com call stack

---

## [1.7.0] - 2025-07-25

### ✨ Adicionado
- **🔄 Loop Para Estilo C**: Nova sintaxe de loop mais flexível inspirada em linguagens como C/Java
  - **Sintaxe**: `para (inicialização; condição; incremento) { corpo }`
  - **Partes opcionais**: Qualquer das três partes pode ser omitida (`para (;;)` para loop infinito)
  - **Exemplos**:
    - `para (inteiro i = 0; i < 10; i++) { imprimir i; }`
    - `para (; j < 5; j++) { ... }` (sem inicialização)
    - `para (inteiro k = 0; k < 3; ) { k++; ... }` (sem incremento automático)
- **⬆️ Operador de Incremento Pós-fixo**: Novo operador `++` para incrementar variáveis
  - **Sintaxe**: `variavel++` (incrementa e retorna valor original)
  - **Funcionamento**: Equivalente a `variavel = variavel + 1` mas como expressão
  - **Uso**: Pode ser usado em expressões (`imprimir i++`) ou statements (`i++;`)
- **🏗️ Expansão da AST**:
  - `ForCStmt`: Nova classe para loops estilo C com inicialização, condição e incremento opcionais
  - `IncrementExpr`: Nova classe para expressões de incremento pós-fixo
  - Métodos `visitForCStmt` e `visitIncrementExpr` em todos os visitadores
- **🔧 Melhorias no Parser**:
  - Detecção automática entre loop tradicional (`para x = 1 ate 10 faca`) e estilo C (`para (;;)`)
  - Parse de operadores pós-fixos na hierarquia de precedência
  - Suporte a partes opcionais no loop for estilo C
- **📊 Visualização AST Atualizada**:
  - Ícone distintivo "🔄 para(;;)" para loops estilo C (cor darkturquoise)
  - Ícone "⬆️ variavel++" para operadores de incremento (cor lightcoral)

### 🚀 Melhorado
- **Pipeline do compilador** expandida para suportar novos construtos
- **Análise semântica** com validação de incremento em constantes
- **Geração de código** otimizada para operadores pós-fixos
- **Máquina virtual** compatível com novos opcodes

### 📝 Exemplos Adicionados
- `exemplo_for_c.mdart`: Demonstração básica do loop estilo C
- `exemplo_for_c_simples.mdart`: Casos de uso variados incluindo loops aninhados
- `exemplo_for_c_completo.mdart`: Teste completo de todas as variações

### 🎯 Compatibilidade
- **Retrocompatível**: Loops tradicionais `para x = 1 ate 10 faca` continuam funcionando
- **Coexistência**: Ambos os estilos podem ser usados no mesmo programa
- **Sintaxe familiar**: Operador `++` funciona como esperado por programadores de outras linguagens

---

## [1.6.0] - 2025-07-24

### ✨ Adicionado
- **🔒 Suporte Completo a Constantes Tipadas**: Nova funcionalidade para declaração de valores imutáveis
  - **Sintaxe de constantes**: `constante tipo nome = valor;` (ex: `constante inteiro MAXIMO = 100;`)
  - **Tipos suportados**: `inteiro`, `real`, `texto`, `logico`, `vazio`
  - **Inicialização obrigatória**: Constantes devem sempre ser inicializadas na declaração
  - **Proteção contra reatribuição**: Tentativas de modificar constantes geram erro semântico
  - **Integração completa**: Suporte em toda a pipeline do compilador (lexer, parser, semantic analyzer, code generator, VM)
- **Nova palavra-chave**: `constante` adicionada ao conjunto de tokens reconhecidos
- **Classes AST expandidas**:
  - `ConstDeclStmt`: Nova classe para declarações de constantes
  - Método `visitConstDeclStmt` adicionado à interface `AstVisitor`
  - Visualização diferenciada na AST com ícone 🔒 e cor coral
- **Análise semântica aprimorada**:
  - Rastreamento de constantes declaradas para proteção contra reatribuição
  - Verificação de redeclaração no mesmo escopo
  - Validação específica para sintaxe de constantes
- **Parser expandido**:
  - Método `_constDeclaration()` para parsing da sintaxe `constante tipo nome = valor;`
  - Detecção automática de declarações de constantes
  - Validação de inicialização obrigatória
- **Geração de código**:
  - Tratamento de constantes como variáveis globais imutáveis
  - Compilação para bytecode compatível com VM existente
  - Integração com todos os visitadores auxiliares

### 🛡️ Segurança e Proteção
- **Imutabilidade garantida**: Constantes não podem ser reatribuídas após declaração
- **Erro semântico claro**: `"Não é possível atribuir valor à constante 'NOME'"`
- **Validação em tempo de compilação**: Problemas detectados antes da execução
- **Compatibilidade total**: Constantes funcionam junto com variáveis `var` e tipadas

### ✅ Funcionalidades Validadas
- **Declaração**: `constante inteiro VALOR = 42;` → Compila e executa perfeitamente
- **Leitura**: `imprimir VALOR;` → Acesso normal a constantes
- **Uso em expressões**: `var resultado = VALOR * 2;` → Integração total com operadores
- **Proteção**: `VALOR = 100;` → Erro: "Não é possível atribuir valor à constante"
- **Múltiplos tipos**: `constante real PI = 3.14159; constante texto VERSAO = "v1.6.0";`
- **Visualização AST**: Constantes aparecem com ícone distintivo na árvore sintática

### 🚀 Exemplos de Uso
```dart
// Declarações de constantes
constante inteiro MAXIMO = 100;
constante real PI = 3.14159;
constante texto MENSAGEM = "Olá, mundo das constantes!";
constante logico DEBUG = verdadeiro;

// Uso em expressões (permitido)
var resultado = MAXIMO * 2;
var area = PI * 25.0;
imprimir MENSAGEM;

// Tentativa de reatribuição (PROIBIDO)
// MAXIMO = 200;  // ❌ Erro semântico
```

### 🔧 Arquitetura Expandida
- **Lexer**: Palavra-chave `constante` reconhecida e tokenizada
- **AST**: Nova classe `ConstDeclStmt` representando declarações de constantes
- **Parser**: Parsing específico para sintaxe de constantes com validação
- **Semantic Analyzer**: 
  - Conjunto `_constants` para rastrear nomes de constantes
  - Validação em `visitAssignExpr` para prevenir reatribuição
  - Verificação de redeclaração no escopo atual
- **Code Generator**: Geração de bytecode tratando constantes como variáveis imutáveis
- **Visitadores atualizados**:
  - `LineVisitor`: Extração de linha para debugging
  - `LocationVisitor`: Informações de localização precisas
  - `ASTGraphvizGenerator`: Visualização com cor coral e ícone 🔒

### 🎯 Impacto
- **Linguagem mais robusta**: Constantes adicionam segurança de tipos e imutabilidade
- **Desenvolvimento facilitado**: Valores que não devem mudar são protegidos automaticamente
- **Melhor legibilidade**: Diferenciação clara entre valores mutáveis e imutáveis
- **Compatibilidade mantida**: Todas as funcionalidades anteriores continuam funcionando
- **Base para melhorias futuras**: Infraestrutura preparada para verificações de tipos mais avançadas

---

## [1.5.0] - 2025-07-24

### ✨ Adicionado
- **🎯 Suporte Completo a Declarações de Variáveis Tipadas**: Nova sintaxe para declaração explícita de tipos
  - **Sintaxe tipada**: `tipo nome = valor;` (ex: `inteiro a = 10;`, `real altura = 1.75;`)
  - **Tipos suportados**: `inteiro`, `real`, `texto`, `logico`, `vazio`
  - **Valores padrão automáticos**: Variáveis sem inicialização recebem valores padrão baseados no tipo
  - **Compatibilidade total**: Funciona junto com declarações `var` existentes
  - **Integração completa**: Suporte em toda a pipeline do compilador
- **Classes AST expandidas**:
  - `TypedVarDeclStmt`: Nova classe para declarações tipadas
  - `TypeInfo`: Representação de informações de tipo
  - Método `visitTypedVarDeclStmt` adicionado à interface `AstVisitor`
- **Parser aprimorado**:
  - Detecção automática de declarações tipadas vs declarações `var`
  - Método `_typedVarDeclaration()` para parsing de sintaxe tipada
  - Suporte a declarações com e sem inicialização
- **Geração de código**:
  - Método `_getDefaultValueForType()` para valores padrão por tipo
  - Geração de bytecode otimizada para variáveis tipadas
  - Tratamento especial para inicialização com valores padrão

### 🐛 Corrigido
- **Crítico: Perda de variáveis globais após chamadas de função**:
  - Resolvido problema onde variáveis globais eram perdidas quando tinham o mesmo nome de parâmetros de função
  - **Sintoma**: `Erro de Execução: Variável global indefinida 'a'` em múltiplas chamadas de função
  - **Causa identificada**: Método `_call()` na VM removia permanentemente variáveis globais ao limpar parâmetros temporários
  - **Cenário problemático**: `var a = 10; funcao soma(inteiro a) {...}; se (soma(a) >= 10) {...}` - segunda chamada falhava
  - **Solução implementada**: Backup e restauração de variáveis globais que são mascaradas por parâmetros
  - Sistema de funções agora completamente funcional e robusto
- **Crítico: Estruturas condicionais e loops dentro de funções**:
  - Resolvido problema onde condicionais (`se/senao`) e loops (`enquanto`, `para`) falhavam dentro de funções
  - **Sintoma**: `Erro de Execução: Operação não suportada: OpCode.jumpIfFalse` ao usar condicionais em funções
  - **Causa identificada**: Método `_executeInstruction()` na VM não tinha suporte para instruções de controle de fluxo
  - **Cenário problemático**: `funcao teste() { se (condicao) { ... } }` - qualquer lógica condicional em função falhava
  - **Solução implementada**: Adicionados cases para `jumpIfFalse`, `jump`, `loop` e `call` em `_executeInstruction()`
  - Funções agora suportam toda a gama de estruturas de controle internamente

### 🔧 Arquitetura Expandida
- **Análise semântica**: 
  - `visitTypedVarDeclStmt()` implementado no semantic analyzer
  - Registro de variáveis tipadas na tabela de símbolos
  - Validação de tipos durante a análise
- **Visitors atualizados**:
  - `CodeGenerator`: Geração de bytecode para declarações tipadas
  - `LineVisitor`: Extração de número da linha para debugging
  - `LocationVisitor`: Informações de localização para erros precisos
  - `ASTGraphvizGenerator`: Visualização diferenciada com cor azul claro

### 📊 Valores Padrão por Tipo
- **`inteiro`** → `0`: Números inteiros começam em zero
- **`real`** → `0.0`: Números reais começam em zero ponto zero  
- **`texto`** → `""`: Strings começam vazias
- **`logico`** → `false`: Booleanos começam como falso
- **`vazio`** → `null`: Tipo void é nulo por padrão

### ✅ Funcionalidades Validadas
- **Declaração com inicialização**: `inteiro a = 10;` → Compila e executa perfeitamente
- **Declaração sem inicialização**: `inteiro x;` → Usa valor padrão (0)
- **Múltiplos tipos**: `real pi = 3.14; texto nome = "João"; logico ativo = verdadeiro;`
- **Uso em expressões**: `inteiro resultado = a + 5;` → Integração total com operadores
- **Reassignação**: `a = 20;` → Modificação de variáveis tipadas funciona normalmente
- **Compatibilidade**: Declarações `var` e tipadas funcionam no mesmo arquivo
- **Bug de funções corrigido**: `var a = 10; se (soma(a) >= 10) {...}` → Múltiplas chamadas funcionam
- **Funções com condicionais**: `funcao classificar(inteiro x) { se (x > 0) { retornar "Positivo"; } }`
- **Funções com loops**: `funcao fatorial(inteiro n) { enquanto (i <= n) { ... } }` → Fatorial(5) = 120
- **Estruturas complexas**: Condicionais aninhados, loops e chamadas de função dentro de funções

### 🚀 Impacto
- **Linguagem mais robusta**: Declarações explícitas de tipo melhoram legibilidade
- **Desenvolvimento facilitado**: Valores padrão eliminam necessidade de inicialização manual
- **Sistema de funções estabilizado**: Dois bugs críticos de funções resolvidos completamente
- **Confiabilidade garantida**: Múltiplas chamadas de função e estruturas de controle funcionam perfeitamente
- **Funcionalidade completa**: Funções agora suportam toda a gama de estruturas da linguagem
- **Programação procedural avançada**: Condicionais, loops e lógica complexa dentro de funções
- **Base para futuras funcionalidades**: Infraestrutura preparada para verificação de tipos mais rigorosa
- **Experiência melhorada**: Sintaxe mais clara e próxima de linguagens convencionais

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
