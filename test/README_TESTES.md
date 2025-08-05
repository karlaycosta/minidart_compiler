# 🧪 Suite de Testes - LiPo Compiler

Esta pasta contém a suite completa de testes automatizados para o compilador LiPo.

## 📁 Estrutura

```
test/
├── unit/                      # Testes unitários
│   ├── lexer_test.dart       # Testes do analisador léxico
│   ├── parser_test.dart      # Testes do analisador sintático
│   ├── semantic_analyzer_test.dart # Testes do analisador semântico
│   ├── vm_test.dart          # Testes da máquina virtual
│   └── standard_library_test.dart # Testes da biblioteca padrão
├── integration/               # Testes de integração
│   ├── compiler_integration_test.dart # Testes do pipeline completo
│   └── examples_test.dart    # Testes com exemplos reais
├── fixtures/                 # Arquivos de teste
│   ├── valid_programs/       # Programas válidos para teste
│   └── invalid_programs/     # Programas inválidos para teste
├── test_helper.dart          # Funções auxiliares para testes
├── all_tests.dart            # Executor de todos os testes
└── README.md                 # Este arquivo
```

## 🚀 Como Executar

### Todos os testes

```bash
dart test
```

### Todos os testes organizados

```bash
dart test test/all_tests.dart
```

### Testes unitários específicos

```bash
dart test test/unit/lexer_test.dart
dart test test/unit/parser_test.dart
dart test test/unit/semantic_analyzer_test.dart
dart test test/unit/vm_test.dart
dart test test/unit/standard_library_test.dart
```

### Testes de integração

```bash
dart test test/integration/compiler_integration_test.dart
dart test test/integration/examples_test.dart
```

### Com output detalhado

```bash
dart test --reporter=expanded
```

## 📋 Categorias de Teste

### 🔍 Testes Unitários

#### **Lexer Tests** (`lexer_test.dart`)

- Tokenização de números (inteiros e decimais)
- Reconhecimento de palavras-chave em português
- Tokenização de strings e escape sequences
- Operadores aritméticos e de comparação
- Delimitadores e pontuação
- Identificadores válidos
- Comentários (linha e bloco)
- Tratamento de caracteres inválidos
- Contagem correta de linhas

#### **Parser Tests** (`parser_test.dart`)

- Declarações de variáveis (var, tipadas, constantes)
- Estruturas de controle (se/senao, enquanto)
- Declarações de função com parâmetros tipados
- Expressões (binárias, atribuição, chamadas)
- Blocos e agrupamentos
- Detecção de erros sintáticos
- Balanceamento de parênteses e chaves

#### **Semantic Analyzer Tests** (`semantic_analyzer_test.dart`)

- Detecção de variáveis não declaradas
- Verificação de redeclarações
- Controle de escopo (variáveis locais/globais)
- Validação de constantes (não reatribuição)
- Verificação de chamadas de função
- Contagem correta de argumentos
- Retorno fora de função

#### **VM Tests** (`vm_test.dart`)

- Execução de operações aritméticas
- Estruturas de controle (loops, condicionais)
- Chamadas de função e recursão
- Impressão de valores
- Detecção de erros de runtime
- Gerenciamento de stack

#### **Standard Library Tests** (`stdlib_test.dart`)

- Funções matemáticas (sqrt, pow, abs, etc.)
- Funções de string (tamanho, maiúscula, etc.)
- Funções de conversão de tipo
- Funções de I/O
- Funções utilitárias
- Tratamento de erros

### 🔗 Testes de Integração

#### **Compiler Integration Tests** (`compiler_integration_test.dart`)

- Pipeline completo de compilação (lexer → parser → semantic → codegen → vm)
- Detecção de erros em cada fase
- Programas complexos com múltiplas funcionalidades
- Recursão e estruturas de controle aninhadas
- Constantes e operações aritméticas

#### **Examples Tests** (`examples_test.dart`)

- Validação de arquivos de exemplo existentes
- Criação automática de fixtures de teste
- Programas válidos e inválidos
- Casos edge de sintaxe

## 🎯 Objetivos dos Testes

1. **Garantir Qualidade**: Verificar que todas as funcionalidades funcionam corretamente
2. **Detectar Regressões**: Identificar quando mudanças quebram funcionalidades existentes
3. **Documentar Comportamento**: Servir como documentação viva do sistema
4. **Facilitar Manutenção**: Permitir refatorações com segurança
5. **Validar Casos Edge**: Testar cenários limites e de erro

---

**Implementado em:** 5 de agosto de 2025  
**Versão:** 1.0  
**Última atualização:** 5 de agosto de 2025

> 💡 **Dica**: Execute `dart test` regularmente durante o desenvolvimento para detectar problemas cedo!
> dart run bin/compile.dart test/fixtures/basic_test.lip

```

## Estrutura de Testes

- `test/lipo_test.dart` - Testes unitários principais
- `test/fixtures/` - Arquivos de teste .lip para validação
- `test/run_tests.dart` - Script para executar todos os testes
- `exemplos/` - Testes de regressão (arquivos existentes)

## Tipos de Testes

### 1. Testes de Unidade
- **Lexer**: Tokenização correta
- **Parser**: Análise sintática
- **Semantic Analyzer**: Verificação de tipos e escopos
- **Code Generator**: Geração de bytecode
- **VM**: Execução de programas

### 2. Testes de Integração
- Execução end-to-end de programas completos
- Validação de saída esperada

### 3. Testes de Regressão
- Garantia de que bugs corrigidos não retornem
- Validação de funcionalidades existentes

### 4. Testes de Fixtures
- Arquivos .lip específicos para cenários de teste
- Validação rápida de funcionalidades isoladas

## Cobertura de Testes

- ✅ Tipos básicos (inteiro, real, texto, logico)
- ✅ Variáveis e constantes
- ✅ Operadores (aritméticos, lógicos, comparação)
- ✅ Listas tipadas
- ✅ Funções (com/sem retorno, recursivas)
- ✅ Estruturas de controle (if/else, loops, switch)
- ✅ Sistema de imports/módulos
- ✅ Bibliotecas padrão (math, string, data, io)
- ✅ Operador ternário
- ✅ Operadores de incremento/decremento
- ✅ Tratamento de erros

## Adicionando Novos Testes

### Para novo teste unitário:
1. Adicione o teste em `test/lipo_test.dart`
2. Execute `dart test` para validar

### Para novo fixture:
1. Crie arquivo `.lip` em `test/fixtures/`
2. Execute `dart run test/run_tests.dart`

### Para teste de regressão:
1. Adicione o arquivo à lista `expectedToPass` em `run_tests.dart`
2. Execute os testes completos

## Integração Contínua

Estes testes devem ser executados:
- Antes de commits importantes
- Após correções de bugs
- Antes de releases
- Ao implementar novas funcionalidades

## Debugging de Testes

Para debugar um teste que falha:
1. Execute o teste isoladamente
2. Use `dart run bin/compile.dart --debug arquivo.lip`
3. Verifique os logs de erro
4. Adicione prints temporários se necessário
```
