# Configuração de testes para a Linguagem LiPo

## Como executar os testes

### 1. Testes Unitários
```bash
dart test
```

### 2. Testes Completos (incluindo fixtures e regressão)
```bash
dart run test/run_tests.dart
```

### 3. Testes Específicos
```bash
# Apenas testes unitários
dart test test/lipo_test.dart

# Teste de um arquivo específico
dart run bin/compile.dart test/fixtures/basic_test.lip
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
