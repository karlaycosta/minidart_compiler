# 📘 Documentação Sintática da Linguagem MiniDart

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [Estrutura Léxica](#estrutura-léxica)
3. [Tipos de Dados](#tipos-de-dados)
4. [Literais](#literais)
5. [Variáveis e Constantes](#variáveis-e-constantes)
6. [Operadores](#operadores)
7. [Estruturas de Controle](#estruturas-de-controle)
8. [Funções](#funções)
9. [Sistema de Imports](#sistema-de-imports)
10. [Comentários](#comentários)
11. [Gramática Formal](#gramática-formal)
12. [Exemplos Práticos](#exemplos-práticos)

---

## 🎯 Visão Geral

MiniDart é uma linguagem de programação educacional que utiliza palavras-chave em português para facilitar o aprendizado. Foi projetada para ser simples, expressiva e familiar aos falantes de português.

### Características Principais

- **Sintaxe em Português**: Palavras-chave em português brasileiro
- **Tipagem Estática**: Tipos são verificados em tempo de compilação
- **Inferência de Tipos**: O compilador pode inferir tipos automaticamente
- **Conversão Automática**: Inteiros são convertidos automaticamente para reais quando necessário

---

## 🔤 Estrutura Léxica

### Identificadores

```
identificador: [a-zA-Z_][a-zA-Z0-9_]*
```

**Exemplos válidos:**
- `nome`
- `idade`
- `_contador`
- `valorFinal`
- `numero2`

**Exemplos inválidos:**
- `2nome` (não pode começar com número)
- `meu-nome` (hífen não permitido)

### Palavras-Chave Reservadas

| Palavra-chave | Uso |
|---------------|-----|
| `se` | Estrutura condicional |
| `senao` | Cláusula else |
| `enquanto` | Loop while |
| `para` | Loop for |
| `faca` | Loop do-while |
| `ate` | Até (usado em for) |
| `incremente` | Incremento personalizado |
| `decremente` | Decremento personalizado |
| `escolha` | Switch statement |
| `caso` | Case clause |
| `contrario` | Default clause |
| `parar` | Break statement |
| `continuar` | Continue statement |
| `retorne` | Return statement |
| `imprima` | Print statement |
| `var` | Declaração de variável |
| `constante` | Declaração de constante |
| `verdadeiro` | Literal booleano true |
| `falso` | Literal booleano false |
| `nulo` | Literal null |
| `e` | Operador lógico AND |
| `ou` | Operador lógico OR |
| `importar` | Import statement |
| `como` | Alias em import |
| `tipode` | Operador typeof |

### Tipos de Dados

| Tipo | Palavra-chave | Descrição |
|------|---------------|-----------|
| `inteiro` | `inteiro` | Números inteiros |
| `real` | `real` | Números de ponto flutuante |
| `texto` | `texto` | Strings/texto |
| `logico` | `logico` | Valores booleanos |
| `vazio` | `vazio` | Tipo void (retorno de função) |

---

## 📊 Tipos de Dados

### Inteiro
```minidart
inteiro idade = 25;
inteiro numero = -42;
```

### Real
```minidart
real altura = 1.75;
real pi = 3.14159;
real negativo = -2.5;
```

### Texto
```minidart
texto nome = "João Silva";
texto vazio = "";
texto especial = "Olá, \"mundo\"!";
```

### Lógico
```minidart
logico ativo = verdadeiro;
logico desativado = falso;
```

### Conversão Automática de Tipos

⚠️ **Regra Importante**: Inteiros são automaticamente convertidos para reais quando necessário:

```minidart
real numero = 42;        // 42 (inteiro) → 42.0 (real)
inteiro a = 10;
real b = 3.5;
real resultado = a + b;  // 10 (int) + 3.5 (real) = 13.5 (real)
```

❌ **Conversão NÃO permitida**: Real para inteiro (deve ser explícita)

```minidart
inteiro numero = 3.14;   // ERRO: real não pode ser convertido para inteiro
```

---

## 💫 Literais

### Números Inteiros
```minidart
42
-17
0
```

### Números Reais
```minidart
3.14
-2.5
0.0
1.0
```

### Strings
```minidart
"Olá, mundo!"
"Nome: João"
""            // string vazia
"Aspas: \"texto\""
```

### Booleanos
```minidart
verdadeiro
falso
```

### Nulo
```minidart
nulo
```

---

## 📦 Variáveis e Constantes

### Declaração de Variáveis

#### Com Tipo Explícito
```minidart
inteiro idade = 25;
real altura = 1.75;
texto nome = "Maria";
logico ativo = verdadeiro;
```

#### Com Inferência de Tipo
```minidart
var idade = 25;        // inferido como inteiro
var altura = 1.75;     // inferido como real
var nome = "Maria";    // inferido como texto
var ativo = verdadeiro; // inferido como logico
```

#### Sem Inicialização
```minidart
inteiro contador;      // inicializado com valor padrão
real media;
texto resultado;
```

### Declaração de Constantes

#### Com Tipo Explícito
```minidart
constante inteiro MAXIMO = 100;
constante real PI = 3.14159;
constante texto VERSAO = "v1.0.0";
constante logico DEBUG = verdadeiro;
```

#### Com Inferência de Tipo
```minidart
constante var LIMITE = 50;        // inferido como inteiro
constante var TAXA = 0.15;        // inferido como real
constante var NOME = "Sistema";   // inferido como texto
```

---

## ⚙️ Operadores

### Operadores Aritméticos

| Operador | Descrição | Exemplo |
|----------|-----------|---------|
| `+` | Adição | `a + b` |
| `-` | Subtração | `a - b` |
| `*` | Multiplicação | `a * b` |
| `/` | Divisão | `a / b` |
| `%` | Módulo (resto) | `a % b` |

### Operadores de Atribuição

| Operador | Descrição | Exemplo |
|----------|-----------|---------|
| `=` | Atribuição | `a = 10` |
| `+=` | Adição e atribuição | `a += 5` |
| `-=` | Subtração e atribuição | `a -= 3` |
| `*=` | Multiplicação e atribuição | `a *= 2` |
| `/=` | Divisão e atribuição | `a /= 4` |
| `%=` | Módulo e atribuição | `a %= 3` |

### Operadores de Comparação

| Operador | Descrição | Exemplo |
|----------|-----------|---------|
| `==` | Igualdade | `a == b` |
| `!=` | Diferença | `a != b` |
| `<` | Menor que | `a < b` |
| `<=` | Menor ou igual | `a <= b` |
| `>` | Maior que | `a > b` |
| `>=` | Maior ou igual | `a >= b` |

### Operadores Lógicos

| Operador | Descrição | Exemplo |
|----------|-----------|---------|
| `e` | AND lógico | `a e b` |
| `ou` | OR lógico | `a ou b` |
| `!` | NOT lógico | `!a` |

### Operadores Unários

| Operador | Descrição | Exemplo |
|----------|-----------|---------|
| `-` | Negação aritmética | `-x` |
| `!` | Negação lógica | `!condicao` |
| `++` | Incremento (pré/pós) | `++i` ou `i++` |
| `--` | Decremento (pré/pós) | `--i` ou `i--` |

### Operador Ternário

```minidart
condicao ? valor_se_verdadeiro : valor_se_falso
```

**Exemplo:**
```minidart
texto status = idade >= 18 ? "adulto" : "menor";
```

### Operador Typeof

```minidart
tipode expressao
```

**Exemplos:**
```minidart
var numero = 42;
imprima tipode numero;    // "inteiro"
imprima tipode 3.14;      // "real"
imprima tipode "texto";   // "texto"
imprima tipode verdadeiro; // "logico"
```

### Precedência de Operadores

Da maior para a menor precedência:

1. **Operadores unários**: `!`, `-`, `tipode`, `++`, `--`
2. **Multiplicação/Divisão**: `*`, `/`, `%`
3. **Adição/Subtração**: `+`, `-`
4. **Comparação**: `<`, `<=`, `>`, `>=`
5. **Igualdade**: `==`, `!=`
6. **AND lógico**: `e`
7. **OR lógico**: `ou`
8. **Ternário**: `? :`
9. **Atribuição**: `=`, `+=`, `-=`, `*=`, `/=`, `%=`

---

## 🔀 Estruturas de Controle

### Estrutura Condicional (se/senao)

#### Sintaxe Básica
```minidart
se (condicao) {
    // código se verdadeiro
}
```

#### Com Cláusula Else
```minidart
se (condicao) {
    // código se verdadeiro
} senao {
    // código se falso
}
```

#### Estruturas Aninhadas
```minidart
se (idade < 13) {
    imprima "Criança";
} senao se (idade < 18) {
    imprima "Adolescente";
} senao se (idade < 60) {
    imprima "Adulto";
} senao {
    imprima "Idoso";
}
```

### Loop While (enquanto)

```minidart
enquanto (condicao) {
    // código a repetir
}
```

**Exemplo:**
```minidart
inteiro i = 0;
enquanto (i < 10) {
    imprima i;
    i = i + 1;
}
```

### Loop Do-While (faca...enquanto)

```minidart
faca {
    // código a repetir
} enquanto (condicao);
```

**Exemplo:**
```minidart
inteiro numero;
faca {
    numero = numero + 1;
    imprima numero;
} enquanto (numero < 5);
```

### Loop For Tradicional

#### Sintaxe: para variável = início até fim

```minidart
para variavel = inicio ate fim faca {
    // código a repetir
}
```

**Exemplo:**
```minidart
para i = 1 ate 10 faca {
    imprima i;
}
```

#### Com Incremento Personalizado

```minidart
para variavel = inicio ate fim incremente valor faca {
    // código
}

para variavel = inicio ate fim decremente valor faca {
    // código
}
```

**Exemplos:**
```minidart
// Incremento de 2 em 2
para i = 0 ate 20 incremente 2 faca {
    imprima i;  // 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20
}

// Decremento de 3 em 3
para i = 15 ate 0 decremente 3 faca {
    imprima i;  // 15, 12, 9, 6, 3, 0
}
```

### Loop For Estilo C

```minidart
para (inicializacao; condicao; incremento) {
    // código
}
```

**Exemplo:**
```minidart
para (inteiro i = 0; i < 10; i = i + 1) {
    imprima i;
}
```

### Switch/Case (escolha/caso)

```minidart
escolha (expressao) {
    caso valor1:
        // código para valor1
        parar;
    caso valor2:
        // código para valor2
        parar;
    contrario:
        // código padrão
}
```

**Exemplo:**
```minidart
inteiro dia = 3;
escolha (dia) {
    caso 1:
        imprima "Segunda-feira";
        parar;
    caso 2:
        imprima "Terça-feira";
        parar;
    caso 3:
        imprima "Quarta-feira";
        parar;
    contrario:
        imprima "Outro dia";
}
```

### Controle de Loop

#### Break (parar)
```minidart
enquanto (verdadeiro) {
    se (condicao) {
        parar;  // sai do loop
    }
}
```

#### Continue (continuar)
```minidart
para i = 1 ate 10 faca {
    se (i % 2 == 0) {
        continuar;  // pula para próxima iteração
    }
    imprima i;  // só imprime números ímpares
}
```

---

## 🔧 Funções

### Declaração de Função

```minidart
tipo_retorno nome_funcao(parametros) {
    // corpo da função
    retorne valor;  // opcional para tipo vazio
}
```

### Exemplos de Funções

#### Função com Retorno
```minidart
inteiro somar(inteiro a, inteiro b) {
    retorne a + b;
}
```

#### Função sem Retorno (void)
```minidart
vazio cumprimentar(texto nome) {
    imprima "Olá, " + nome + "!";
}
```

#### Função com Tipos Mistos
```minidart
real calcularMedia(inteiro a, inteiro b) {
    retorne (a + b) / 2.0;
}
```

### Chamada de Função

```minidart
// Função que retorna valor
inteiro resultado = somar(10, 20);

// Função void
cumprimentar("Maria");

// Em expressões
real media = calcularMedia(85, 92);
imprima "Média: " + media;
```

### Funções Recursivas

```minidart
inteiro fatorial(inteiro n) {
    se (n <= 1) {
        retorne 1;
    } senao {
        retorne n * fatorial(n - 1);
    }
}
```

---

## 📥 Sistema de Imports

### Import Básico

```minidart
importar nome_biblioteca;
```

### Import com Alias

```minidart
importar nome_biblioteca como alias;
```

### Exemplos de Uso

```minidart
// Import básico
importar math;
var resultado = math.sqrt(16);

// Import com alias
importar data como dt;
var hoje = dt.hoje();

// Múltiplos imports
importar io;
importar string como str;
importar math;

io.imprimir(str.maiuscula("texto"));
var potencia = math.pow(2, 3);
```

### Bibliotecas Disponíveis

| Biblioteca | Descrição | Funções Exemplo |
|------------|-----------|-----------------|
| `math` | Funções matemáticas | `sqrt()`, `pow()`, `sin()`, `cos()` |
| `string` | Manipulação de strings | `maiuscula()`, `minuscula()`, `tamanho()` |
| `io` | Entrada/saída | `imprimir()`, `escrever()`, `novaLinha()` |
| `data` | Data e tempo | `hoje()`, `horaAtual()`, `diferenca()` |

---

## 💬 Comentários

### Comentário de Linha

```minidart
// Este é um comentário de linha
var x = 10;  // Comentário no final da linha
```

⚠️ **Nota**: MiniDart atualmente suporta apenas comentários de linha (`//`). Comentários de bloco (`/* */`) não estão implementados.

---

## 📝 Gramática Formal

```bnf
programa        → declaracao* EOF

declaracao      → varDecl | constDecl | funcDecl | statement

varDecl         → "var" IDENTIFIER ("=" expression)? ";"
                | TIPO IDENTIFIER ("=" expression)? ";"

constDecl       → "constante" TIPO IDENTIFIER "=" expression ";"
                | "constante" "var" IDENTIFIER "=" expression ";"

funcDecl        → TIPO IDENTIFIER "(" parametros? ")" bloco

parametros      → TIPO IDENTIFIER ("," TIPO IDENTIFIER)*

statement       → exprStmt | printStmt | bloco | ifStmt 
                | whileStmt | doWhileStmt | forStmt | returnStmt
                | breakStmt | continueStmt | switchStmt | importStmt

exprStmt        → expression ";"
printStmt       → "imprima" expression ";"
bloco           → "{" declaracao* "}"
ifStmt          → "se" "(" expression ")" statement ("senao" statement)?
whileStmt       → "enquanto" "(" expression ")" statement
doWhileStmt     → "faca" statement "enquanto" "(" expression ")" ";"
forStmt         → "para" IDENTIFIER "=" expression "ate" expression 
                  ("incremente" | "decremente" expression)? "faca" statement
                | "para" "(" (varDecl | exprStmt | ";") expression? ";" 
                  expression? ")" statement
returnStmt      → "retorne" expression? ";"
breakStmt       → "parar" ";"
continueStmt    → "continuar" ";"
switchStmt      → "escolha" "(" expression ")" "{" caseStmt* "}"
caseStmt        → ("caso" expression | "contrario") ":" statement*
importStmt      → "importar" IDENTIFIER ("como" IDENTIFIER)? ";"

expression      → assignment
assignment      → ternary (("=" | "+=" | "-=" | "*=" | "/=" | "%=") assignment)?
ternary         → logical_or ("?" expression ":" ternary)?
logical_or      → logical_and ("ou" logical_and)*
logical_and     → equality ("e" equality)*
equality        → comparison (("!=" | "==") comparison)*
comparison      → term ((">" | ">=" | "<" | "<=") term)*
term            → factor (("-" | "+") factor)*
factor          → unary (("/" | "*" | "%") unary)*
unary           → ("!" | "-" | "tipode" | "++" | "--") unary | postfix
postfix         → call ("++" | "--")*
call            → primary ("(" arguments? ")" | "." IDENTIFIER)*
primary         → "verdadeiro" | "falso" | "nulo" | NUMBER | STRING 
                | IDENTIFIER | "(" expression ")"

arguments       → expression ("," expression)*

TIPO            → "inteiro" | "real" | "texto" | "logico" | "vazio"
NUMBER          → DIGIT+ ("." DIGIT+)?
STRING          → "\"" CHAR* "\""
IDENTIFIER      → ALPHA (ALPHA | DIGIT)*
ALPHA           → [a-zA-Z_]
DIGIT           → [0-9]
CHAR            → qualquer caractere exceto "\""
```

---

## 🎯 Exemplos Práticos

### Exemplo 1: Programa Básico

```minidart
// Programa simples de calculadora
var a = 10;
var b = 5;

imprima "Soma: " + (a + b);
imprima "Subtração: " + (a - b);
imprima "Multiplicação: " + (a * b);
imprima "Divisão: " + (a / b);
```

### Exemplo 2: Estruturas de Controle

```minidart
inteiro numero = 15;

// Verificar se é par ou ímpar
se (numero % 2 == 0) {
    imprima numero + " é par";
} senao {
    imprima numero + " é ímpar";
}

// Loop para calcular fatorial
inteiro fatorial = 1;
para i = 1 ate numero faca {
    fatorial *= i;
}
imprima "Fatorial de " + numero + " é " + fatorial;
```

### Exemplo 3: Funções

```minidart
// Função para verificar se número é primo
logico ehPrimo(inteiro num) {
    se (num <= 1) {
        retorne falso;
    }
    
    para i = 2 ate num / 2 faca {
        se (num % i == 0) {
            retorne falso;
        }
    }
    retorne verdadeiro;
}

// Teste da função
para i = 2 ate 20 faca {
    se (ehPrimo(i)) {
        imprima i + " é primo";
    }
}
```

### Exemplo 4: Switch/Case

```minidart
inteiro opcao = 2;

escolha (opcao) {
    caso 1:
        imprima "Opção 1 selecionada";
        parar;
    caso 2:
        imprima "Opção 2 selecionada";
        parar;
    caso 3:
        imprima "Opção 3 selecionada";
        parar;
    contrario:
        imprima "Opção inválida";
}
```

### Exemplo 5: Sistema de Imports

```minidart
importar math;
importar io como saida;

// Calculadora científica
real angulo = 1.5708;  // 90 graus em radianos

saida.imprimir("=== Calculadora Científica ===");
saida.imprimir("Ângulo: " + angulo);
saida.imprimir("Seno: " + math.sin(angulo));
saida.imprimir("Cosseno: " + math.cos(angulo));
saida.imprimir("Raiz quadrada de 16: " + math.sqrt(16));
saida.imprimir("2 elevado a 3: " + math.pow(2, 3));
```

### Exemplo 6: Recursividade

```minidart
// Sequência de Fibonacci
real fibonacci(inteiro n) {
    se (n <= 1) {
        retorne n;
    } senao {
        retorne fibonacci(n - 1) + fibonacci(n - 2);
    }
}

// Exibir os primeiros 10 números de Fibonacci
imprima "Sequência de Fibonacci:";
para i = 0 ate 9 faca {
    imprima "F(" + i + ") = " + fibonacci(i);
}
```

---

## 📚 Resumo de Características

### ✅ Recursos Implementados

- ✅ Tipos básicos: inteiro, real, texto, logico, vazio
- ✅ Variáveis com tipo explícito e inferência
- ✅ Constantes tipadas
- ✅ Operadores aritméticos, lógicos e de comparação
- ✅ Estruturas condicionais (se/senao)
- ✅ Loops (enquanto, para, faca-enquanto)
- ✅ Funções com parâmetros e retorno
- ✅ Recursividade
- ✅ Switch/case (escolha/caso)
- ✅ Break e continue
- ✅ Sistema de imports com alias
- ✅ Operador ternário
- ✅ Operador typeof
- ✅ Conversão automática inteiro → real
- ✅ Comentários de linha

### 🚧 Limitações Atuais

- ❌ Arrays/listas não implementados
- ❌ Objetos/classes não implementados
- ❌ Comentários de bloco (`/* */`)
- ❌ Operadores bitwise
- ❌ Tratamento de exceções
- ❌ Escopo de módulo avançado

---

## 🎓 Conclusão

MiniDart é uma linguagem simples e expressiva, ideal para ensino de programação em português. Sua sintaxe familiar e recursos fundamentais proporcionam uma base sólida para aprender conceitos de programação estruturada e funcional.

A documentação está em constante evolução junto com a linguagem. Para exemplos mais avançados e atualizações, consulte os arquivos na pasta `exemplos/` do projeto.

---

**Versão da Documentação**: 1.0  
**Data de Atualização**: Julho 2025  
**Autor**: Deriks Karlay Dias Costa
