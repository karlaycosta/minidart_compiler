# Operador `typeof` - MiniDart

## Visão Geral

O operador `typeof` (palavra-chave `tipode`) foi implementado no MiniDart para permitir introspecção de tipos em tempo de execução. Este operador retorna uma string representando o tipo do valor ou expressão fornecida.

## Sintaxe

```minidart
tipode <expressão>
```

## Tipos Retornados

| Tipo do Valor | String Retornada |
|---------------|------------------|
| Números inteiros | `"inteiro"` |
| Números decimais | `"real"` |
| Strings | `"texto"` |
| Booleanos | `"logico"` |
| Valor nulo | `"nulo"` |
| Funções | `"funcao"` |
| Outros | `"desconhecido"` |

## Exemplos de Uso

### Literais

```minidart
imprima tipode 42;          // Saída: inteiro
imprima tipode 3.14;        // Saída: real
imprima tipode "MiniDart";  // Saída: texto
imprima tipode verdadeiro;  // Saída: logico
imprima tipode falso;       // Saída: logico
imprima tipode nulo;        // Saída: nulo
```

### Variáveis

```minidart
var numero = 100;
var nome = "João";
var ativo = verdadeiro;

imprima tipode numero;      // Saída: inteiro
imprima tipode nome;        // Saída: texto
imprima tipode ativo;       // Saída: logico
```

### Expressões

```minidart
imprima tipode (10 + 20);           // Saída: inteiro
imprima tipode (5.5 * 2.0);         // Saída: real
imprima tipode (verdadeiro e falso); // Saída: logico
imprima tipode ("Olá" + " Mundo");  // Saída: texto
```

### Uso Prático - Validação de Tipos

```minidart
vazio verificarTipo(var valor) {
    var tipo = tipode valor;
    
    se (tipo == "inteiro") {
        imprima "É um número inteiro: " + valor;
    } senao se (tipo == "real") {
        imprima "É um número real: " + valor;
    } senao se (tipo == "texto") {
        imprima "É uma string: " + valor;
    } senao se (tipo == "logico") {
        imprima "É um booleano: " + valor;
    } senao {
        imprima "Tipo desconhecido: " + tipo;
    }
}

// Testando a função
verificarTipo(42);
verificarTipo(3.14);
verificarTipo("MiniDart");
verificarTipo(verdadeiro);
```

### Uso em Condicionais

```minidart
vazio processarValor(var valor) {
    se (tipode valor == "inteiro") {
        imprima "Processando número inteiro...";
        // Lógica específica para inteiros
    } senao se (tipode valor == "texto") {
        imprima "Processando string...";
        // Lógica específica para strings
    } senao {
        imprima "Tipo não suportado: " + tipode valor;
    }
}
```

## Detalhes da Implementação

### Arquivos Modificados

1. **`lib/src/token.dart`**
   - Adicionado `TokenType.typeof_`
   - Atualizado switches para incluir o novo token

2. **`lib/src/lexer.dart`**
   - Adicionada palavra-chave `'tipode': TokenType.typeof_`

3. **`lib/src/parser.dart`**
   - Incluído `TokenType.typeof_` como operador unário

4. **`lib/src/bytecode.dart`**
   - Adicionada instrução `OpCode.typeof_`

5. **`lib/src/code_generator.dart`**
   - Implementada geração de bytecode para `typeof_`

6. **`lib/src/vm.dart`**
   - Implementada execução da instrução `typeof_`
   - Adicionado método `_getTypeName()` para determinação de tipos

7. **`vscode-extension/syntaxes/minidart.tmLanguage.json`**
   - Atualizada para destacar a palavra-chave `tipode`

### Precedência do Operador

O `typeof` é um operador unário com a mesma precedência de outros operadores unários como `-` (negação) e `!` (negação lógica).

### Associatividade

O operador é associativo à direita, permitindo construções como:
```minidart
tipode tipode valor  // Retorna "texto" (tipo do resultado de typeof)
```

## Considerações de Design

1. **Nomenclatura**: Escolheu-se `tipode` para manter consistência com a filosofia do MiniDart de usar palavras em português.

2. **Retorno de String**: O operador retorna strings descritivas em português, facilitando a compreensão e debug.

3. **Simplicidade**: A implementação mantém a simplicidade característica do MiniDart, sem sobrecarga desnecessária.

4. **Compatibilidade**: A adição não quebra código existente, sendo totalmente compatível com versões anteriores.

## Casos de Teste

```minidart
// Arquivo: teste_typeof_completo.mdart

imprima "=== TESTE COMPLETO DO OPERADOR TYPEOF ===";

// Tipos básicos
imprima "Literais:";
imprima "tipode 42 = " + tipode 42;
imprima "tipode 3.14 = " + tipode 3.14;
imprima "tipode \"texto\" = " + tipode "texto";
imprima "tipode verdadeiro = " + tipode verdadeiro;
imprima "tipode nulo = " + tipode nulo;

// Variáveis
var intVar = 100;
var realVar = 2.71;
var textoVar = "MiniDart";
var logicoVar = falso;

imprima "\nVariáveis:";
imprima "tipode intVar = " + tipode intVar;
imprima "tipode realVar = " + tipode realVar;
imprima "tipode textoVar = " + tipode textoVar;
imprima "tipode logicoVar = " + tipode logicoVar;

// Expressões
imprima "\nExpressões:";
imprima "tipode (10 + 5) = " + tipode (10 + 5);
imprima "tipode (3.0 * 2.5) = " + tipode (3.0 * 2.5);
imprima "tipode (verdadeiro ou falso) = " + tipode (verdadeiro ou falso);

// Casos especiais
imprima "\nCasos especiais:";
imprima "tipode (tipode 42) = " + tipode (tipode 42);

imprima "\n=== TESTE CONCLUÍDO ===";
```

## Versão

- **Implementado em**: MiniDart v1.13.0
- **Data**: 27 de julho de 2025
- **Compatibilidade**: Totalmente compatível com versões anteriores

## Notas para Desenvolvedores

1. O método `_getTypeName()` na VM pode ser estendido para suportar tipos adicionais no futuro.

2. A implementação usa o padrão Visitor para manter consistência com o resto do compilador.

3. O operador é totalmente integrado ao sistema de análise semântica e geração de código.

4. Testes automatizados devem ser adicionados para garantir a robustez da implementação.
