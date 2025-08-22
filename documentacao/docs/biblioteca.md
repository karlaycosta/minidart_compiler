---
title: "bibliotecas do LiPO"
description: "Your documentation starts here."
---

## Criando Bibliotecas 

Estenda o poder do MiniDart criando suas próprias bibliotecas com funções nativas implementadas em Dart.

## Arquitetura do Sistema de Bibliotecas

1. **StandardLibrary**: Gerenciador central das bibliotecas
2. **NativeFunction**: Representação de uma função nativa
3. **Sistema de Imports**: Permite importar bibliotecas com ou sem alias
4. **VM Integration**: Execução das funções nativas durante runtime

## Fluxo de Funcionamento

```
MiniDart Code → Parser → Import Recognition → Semantic Analysis → Code Generation → VM Execution → Native Function Call
```

##  Estrutura de uma Biblioteca

### 1. Registro da Biblioteca

Todas as bibliotecas são registradas no arquivo `lib/src/standard_library.dart` através de métodos privados:

```dart
void _registerMinhaLibrary() {
  // Registrar funções da biblioteca aqui
}
```

### 2. Convenção de Nomes

- **Nome da biblioteca**: `nomebiblioteca.funcao`
- **Exemplo**: `math.sqrt`, `string.tamanho`, `io.imprimir`
- **Consistência**: Use nomes em português para manter o padrão da linguagem

### 3. Classe NativeFunction

```dart
class NativeFunction {
  final String name;        // Nome completo (biblioteca.funcao)
  final int arity;         // Número de parâmetros
  final Function implementation; // Implementação em Dart
}
```

## Processo de Criação de Nova Biblioteca

### Passo 1: Definir o Escopo da Biblioteca

Determine:
- **Nome da biblioteca** (ex: `data`, `arquivo`, `rede`)
- **Funcionalidades** que serão oferecidas
- **Tipos de dados** que serão manipulados
- **Dependências** externas necessárias

### Passo 2: Implementar as Funções

#### 2.1 Adicionar método de registro

No arquivo `standard_library.dart`, adicione um novo método:

```dart
/// Registra as funções da biblioteca de dados
void _registerDataLibrary() {
  // Suas funções aqui
}
```

#### 2.2 Chamar o método no construtor

```dart
StandardLibrary() {
  _registerMathLibrary();
  _registerStringLibrary();
  _registerIOLibrary();
  _registerDataLibrary(); // ← Adicionar aqui
}
```

#### 2.3 Implementar as funções

```dart
void _registerDataLibrary() {
  // Função com 1 parâmetro
  register('data.hoje', 0, (args) {
    return DateTime.now().toString().split(' ')[0];
  });
  
  // Função com 2 parâmetros
  register('data.diferenca', 2, (args) {
    final data1 = _parseDate(args[0]);
    final data2 = _parseDate(args[1]);
    return data1.difference(data2).inDays;
  });
}
```

### Passo 3: Implementar Funções Auxiliares

Adicione métodos de conversão específicos para sua biblioteca:

```dart
/// Converte valor para DateTime
DateTime _parseDate(Object? value) {
  if (value is String) {
    final parsed = DateTime.tryParse(value);
    if (parsed != null) return parsed;
  }
  throw Exception('Não é possível converter $value para data');
}
```

### Passo 4: Validação e Testes

Crie arquivos de teste para validar sua biblioteca:

```dart
// exemplos/teste_data.mdart
importar data;

imprima data.hoje();                    // Data atual
imprima data.diferenca("2024-01-01", "2024-12-31"); // Diferença em dias
```

## Exemplo Completo: Biblioteca de Arquivos

### 1. Definição da Biblioteca

```dart
/// Registra as funções da biblioteca de arquivos
void _registerArquivoLibrary() {
  // Verificação de existência
  register('arquivo.existe', 1, (args) {
    final caminho = _toString(args[0]);
    return File(caminho).existsSync();
  });
  
  // Leitura de arquivo
  register('arquivo.lerTexto', 1, (args) {
    final caminho = _toString(args[0]);
    try {
      return File(caminho).readAsStringSync();
    } catch (e) {
      throw Exception('Erro ao ler arquivo: $e');
    }
  });
  
  // Escrita de arquivo
  register('arquivo.escreverTexto', 2, (args) {
    final caminho = _toString(args[0]);
    final conteudo = _toString(args[1]);
    try {
      File(caminho).writeAsStringSync(conteudo);
      return true;
    } catch (e) {
      throw Exception('Erro ao escrever arquivo: $e');
    }
  });
  
  // Tamanho do arquivo
  register('arquivo.tamanho', 1, (args) {
    final caminho = _toString(args[0]);
    try {
      return File(caminho).lengthSync();
    } catch (e) {
      throw Exception('Erro ao obter tamanho: $e');
    }
  });
}
```

### 2. Uso da Biblioteca

```dart
// exemplo_arquivo.mdart
importar arquivo como arq;

// Verificar se arquivo existe
se (arq.existe("dados.txt")) {
    imprima "Arquivo encontrado!";
    
    // Ler conteúdo
    var conteudo = arq.lerTexto("dados.txt");
    imprima "Conteúdo: " + conteudo;
    
    // Verificar tamanho
    var bytes = arq.tamanho("dados.txt");
    imprima "Tamanho: " + bytes + " bytes";
} senao {
    imprima "Arquivo não encontrado!";
    
    // Criar arquivo
    arq.escreverTexto("dados.txt", "Olá, mundo!");
    imprima "Arquivo criado com sucesso!";
}
```

##  Boas Práticas

### 1. Tratamento de Erros

```dart
register('minhalib.funcao', 1, (args) {
  try {
    // Implementação
    return resultado;
  } catch (e) {
    throw Exception('Erro em minhalib.funcao: $e');
  }
});
```

### 2. Validação de Parâmetros

```dart
register('minhalib.dividir', 2, (args) {
  final a = _toDouble(args[0]);
  final b = _toDouble(args[1]);
  
  if (b == 0) {
    throw Exception('Divisão por zero não é permitida');
  }
  
  return a / b;
});
```

### 3. Documentação

```dart
/// Registra as funções da biblioteca matemática avançada
/// 
/// Funções disponíveis:
/// - matavancada.factorial(n): Calcula fatorial de n
/// - matavancada.fibonacci(n): Calcula n-ésimo número de Fibonacci
/// - matavancada.primo(n): Verifica se n é primo
void _registerMathAvancadaLibrary() {
  // Implementações...
}
```

### 4. Convenções de Nome

- **Biblioteca**: substantivo em minúsculas (`math`, `string`, `arquivo`)
- **Função**: verbo ou substantivo descritivo (`calcular`, `tamanho`, `existe`)
- **Parâmetros**: nomes claros e em português quando possível

##  Tipos de Dados Suportados

### Entrada (Parâmetros)
- `int` - Números inteiros
- `double` - Números reais
- `String` - Texto
- `bool` - Valores lógicos (true/false)
- `null` - Valor nulo

### Saída (Retorno)
- Mesmos tipos de entrada
- `void` - Para funções que não retornam valor (use `return null;`)

### Conversões Disponíveis

```dart
// Use as funções auxiliares existentes:
_toDouble(value)  // Converte para double
_toInt(value)     // Converte para int  
_toString(value)  // Converte para String
```

## Sistema de Imports

### Import Básico
```dart
importar minhalib;
var resultado = minhalib.funcao(parametros);
```

### Import com Alias
```dart
importar minhalib como ml;
var resultado = ml.funcao(parametros);
```

### Validação de Bibliotecas

No arquivo `semantic_analyzer.dart`, adicione sua biblioteca à lista de bibliotecas válidas:

```dart
// No método visitImportStmt
final validLibraries = {'math', 'string', 'io', 'minhalib'}; // ← Adicionar aqui
```

##  Debugging e Testes

### 1. Teste Individual de Funções

```dart
// teste_funcao.mdart
importar minhalib;

imprima minhalib.funcao1(10);
imprima minhalib.funcao2("teste", 5);
```

### 2. Verificação de Erros

```dart
// teste_erros.mdart
importar minhalib;

// Teste com parâmetros inválidos
imprima minhalib.funcao(-1); // Deve gerar erro apropriado
```

### 3. Execução

```bash
dart run bin/compile.dart exemplos/teste_minhalib.mdart
```

## Bibliotecas Existentes como Referência

### 1. Math Library (31 funções)
- Trigonometria: `sin`, `cos`, `tan`, `asin`, `acos`, `atan`
- Exponenciais: `exp`, `log`, `log10`, `pow`, `sqrt`
- Arredondamento: `abs`, `ceil`, `floor`, `round`
- Comparação: `max`, `min`
- Aleatórios: `random`
- Constantes: `PI`, `E`, `LN2`, etc.

### 2. String Library (17 funções)
- Propriedades: `tamanho`, `vazio`
- Transformações: `maiuscula`, `minuscula`, `inverter`, `limpar`
- Verificações: `contem`, `comecaCom`, `terminaCom`
- Manipulação: `encontrar`, `substituir`, `fatiar`, `caractereEm`
- Operações: `repetir`, `concatenar`, `dividir`

### 3. IO Library (5 funções)
- Saída: `imprimir`, `escrever`, `novaLinha`
- Entrada: `lerTexto`, `lerNumero` (simulados)

##  Próximos Passos

### Ideias para Novas Bibliotecas

1. **`data`** - Manipulação de datas e tempo
2. **`arquivo`** - Operações com arquivos e diretórios
3. **`rede`** - Requisições HTTP básicas
4. **`json`** - Parsing e geração de JSON
5. **`lista`** - Operações avançadas com arrays
6. **`crypto`** - Funções de hash e criptografia básica

### Recursos Avançados Futuros

- **Bibliotecas dinâmicas**: Carregamento de bibliotecas externas
- **Namespaces aninhados**: `biblioteca.modulo.funcao`
- **Tipos customizados**: Estruturas de dados complexas
- **Callbacks**: Funções como parâmetros


