# 📘 Documentação Sintática da Linguagem MiniDart v2.0

## 📋 Índice

1. [Visão Geral](#visão-geral)
2. [Estrutura Léxica](#estrutura-léxica)
3. [Tipos de Dados](#tipos-de-dados)
4. [Sistema de Listas](#sistema-de-listas)
5. [Literais](#literais)
6. [Variáveis e Constantes](#variáveis-e-constantes)
7. [Operadores](#operadores)
8. [Estruturas de Controle](#estruturas-de-controle)
9. [Funções](#funções)
10. [Sistema de Imports](#sistema-de-imports)
11. [Biblioteca Padrão](#biblioteca-padrão)
12. [Comentários](#comentários)
13. [Gramática Formal](#gramática-formal)
14. [Exemplos Práticos](#exemplos-práticos)

---

## 🎯 Visão Geral

MiniDart é uma linguagem de programação educacional que utiliza palavras-chave em português para facilitar o aprendizado. Foi projetada para ser simples, expressiva e familiar aos falantes de português.

### Características Principais

- **Sintaxe em Português**: Palavras-chave em português brasileiro
- **Tipagem Estática**: Tipos são verificados em tempo de compilação
- **Inferência de Tipos**: O compilador pode inferir tipos automaticamente
- **Conversão Automática**: Inteiros são convertidos automaticamente para reais quando necessário
- **Sistema de Listas**: Listas homogêneas com métodos integrados
- **Biblioteca Padrão**: Funções nativas para matemática, strings, I/O e mais

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
| `lista` | Tipo de dados lista |
| `tamanho` | Método de lista |
| `adicionar` | Método de lista |
| `remover` | Método de lista |
| `vazio` | Método de lista |

### Tipos de Dados

| Tipo | Palavra-chave | Descrição |
|------|---------------|-----------|
| `inteiro` | `inteiro` | Números inteiros |
| `real` | `real` | Números de ponto flutuante |
| `texto` | `texto` | Strings/texto |
| `logico` | `logico` | Valores booleanos |
| `vazio` | `vazio` | Tipo void (retorno de função) |
| `lista<tipo>` | `lista` | Listas homogêneas |

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

## 📋 Sistema de Listas

### Declaração de Listas

#### Lista Homogênea com Tipo Explícito
```minidart
lista<inteiro> numeros = [1, 2, 3, 4, 5];
lista<texto> nomes = ["Ana", "João", "Maria"];
lista<real> alturas = [1.75, 1.80, 1.65];
lista<logico> estados = [verdadeiro, falso, verdadeiro];
```

#### Lista Vazia
```minidart
lista<inteiro> vazia = [];
lista<texto> textos = [];
```

### Acesso por Índice

```minidart
lista<inteiro> numeros = [10, 20, 30];

// Acesso a elementos (índice baseado em 0)
inteiro primeiro = numeros[0];    // 10
inteiro segundo = numeros[1];     // 20
inteiro terceiro = numeros[2];    // 30
```

### Atribuição por Índice

```minidart
lista<inteiro> numeros = [1, 2, 3];

// Modificar elementos
numeros[0] = 100;    // lista agora é [100, 2, 3]
numeros[1] = 200;    // lista agora é [100, 200, 3]
numeros[2] = 300;    // lista agora é [100, 200, 300]
```

### Métodos Integrados de Lista

#### `tamanho()` - Retorna o número de elementos
```minidart
lista<inteiro> numeros = [1, 2, 3, 4];
inteiro quantidade = numeros.tamanho();  // 4
```

#### `vazio()` - Verifica se a lista está vazia
```minidart
lista<texto> palavras = [];
logico esta_vazia = palavras.vazio();    // verdadeiro

palavras.adicionar("olá");
logico ainda_vazia = palavras.vazio();   // falso
```

#### `adicionar(elemento)` - Adiciona elemento ao final
```minidart
lista<inteiro> numeros = [1, 2];
numeros.adicionar(3);    // lista agora é [1, 2, 3]
numeros.adicionar(4);    // lista agora é [1, 2, 3, 4]
```

#### `remover()` - Remove e retorna o último elemento
```minidart
lista<texto> frutas = ["maçã", "banana", "laranja"];
texto ultima = frutas.remover();    // "laranja"
// lista agora é ["maçã", "banana"]
```

### Verificação de Limites

```minidart
lista<inteiro> numeros = [1, 2, 3];

// Acesso válido
inteiro valor = numeros[1];    // OK: 2

// Acesso inválido (erro de execução)
inteiro erro = numeros[5];     // ERRO: índice fora dos limites
```

### Exemplos Completos com Listas

```minidart
// Exemplo: Sistema de notas
lista<real> notas = [8.5, 7.2, 9.1, 6.8];

// Calcular média
real soma = 0.0;
para i = 0 ate notas.tamanho() - 1 faca {
    soma += notas[i];
}
real media = soma / notas.tamanho();
imprima "Média: " + paraTexto(media);

// Adicionar nova nota
notas.adicionar(9.5);
imprima "Nova quantidade de notas: " + paraTexto(notas.tamanho());

// Remover última nota
real removida = notas.remover();
imprima "Nota removida: " + paraTexto(removida);
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

### Listas
```minidart
[1, 2, 3, 4]              // lista de inteiros
["a", "b", "c"]           // lista de strings
[verdadeiro, falso]       // lista de booleanos
[]                        // lista vazia
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
tipo_retorno nome_funcao(tipo parametro1, tipo parametro2, ...) {
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

## � Biblioteca Padrão

### Funções de Conversão de Tipos

#### `paraTexto(valor)` - Converte qualquer tipo para texto
```minidart
inteiro numero = 42;
texto resultado = paraTexto(numero);     // "42"

real decimal = 3.14;
texto real_texto = paraTexto(decimal);   // "3.14"

logico verdade = verdadeiro;
texto bool_texto = paraTexto(verdade);   // "verdadeiro"

lista<inteiro> numeros = [1, 2, 3];
texto lista_texto = paraTexto(numeros);  // "[1, 2, 3]"
```

#### `tipo(valor)` - Retorna o tipo de uma variável
```minidart
var numero = 42;
imprima tipo(numero);        // "inteiro"
imprima tipo(3.14);          // "real"
imprima tipo("texto");       // "texto"
imprima tipo(verdadeiro);    // "logico"

lista<inteiro> lista = [1, 2, 3];
imprima tipo(lista);         // "lista"
```

### Biblioteca Math

#### Funções Trigonométricas
```minidart
importar math;

real angulo = 1.5708;  // 90 graus em radianos
imprima math.sin(angulo);    // seno
imprima math.cos(angulo);    // cosseno
imprima math.tan(angulo);    // tangente
```

#### Funções Exponenciais e Logarítmicas
```minidart
importar math;

imprima math.exp(2);         // e^2
imprima math.log(10);        // logaritmo natural
imprima math.log10(100);     // logaritmo base 10
imprima math.pow(2, 3);      // 2^3 = 8
imprima math.sqrt(16);       // raiz quadrada = 4
```

#### Funções de Arredondamento
```minidart
importar math;

imprima math.abs(-5);        // valor absoluto = 5
imprima math.ceil(3.2);      // arredondar para cima = 4
imprima math.floor(3.8);     // arredondar para baixo = 3
imprima math.round(3.5);     // arredondar = 4
```

#### Funções de Comparação
```minidart
importar math;

imprima math.max(10, 20);    // máximo = 20
imprima math.min(10, 20);    // mínimo = 10
```

#### Constantes Matemáticas
```minidart
importar math;

imprima math.PI();           // π = 3.14159...
imprima math.E();            // e = 2.71828...
```

### Biblioteca String

#### Propriedades Básicas
```minidart
importar string;

texto palavra = "MiniDart";
imprima string.tamanho(palavra);     // 8
imprima string.vazio("");           // verdadeiro
```

#### Transformações
```minidart
importar string;

texto nome = "João Silva";
imprima string.maiuscula(nome);     // "JOÃO SILVA"
imprima string.minuscula(nome);     // "joão silva"
imprima string.inverter(nome);      // "avliS oãoJ"
imprima string.limpar("  texto  "); // "texto"
```

#### Verificações
```minidart
importar string;

texto frase = "Olá mundo";
imprima string.contem(frase, "mundo");      // verdadeiro
imprima string.comecaCom(frase, "Olá");     // verdadeiro
imprima string.terminaCom(frase, "mundo");  // verdadeiro
```

#### Busca e Manipulação
```minidart
importar string;

texto texto = "banana";
imprima string.encontrar(texto, "na");          // posição da primeira ocorrência
imprima string.encontrarUltimo(texto, "na");    // posição da última ocorrência
imprima string.substituir(texto, "na", "XY");   // "baXYXY"
imprima string.caractereEm(texto, 2);          // "n"
```

### Biblioteca Data

#### Data e Hora Atual
```minidart
importar data;

imprima data.hoje();         // "2025-07-30"
imprima data.horaAtual();    // "14:30:25"
```

#### Operações com Datas
```minidart
importar data;

inteiro diferenca = data.diferenca("2025-01-01", "2025-12-31");
imprima diferenca;           // diferença em dias

logico bissexto = data.ehBissexto(2024);
imprima bissexto;            // verdadeiro

texto formatada = data.formatar("2025-07-30", "dd/MM/yyyy");
imprima formatada;           // "30/07/2025"
```

#### Informações de Data
```minidart
importar data;

inteiro dia_semana = data.diaSemana("2025-07-30");
imprima dia_semana;          // 3 (quarta-feira)

texto nome_mes = data.nomeMes(7);
imprima nome_mes;            // "Julho"

texto nome_dia = data.nomeDiaSemana(3);
imprima nome_dia;            // "Quarta-feira"
```

### Biblioteca I/O

#### Saída
```minidart
importar io;

io.imprimir("Olá mundo");    // imprime com quebra de linha
io.escrever("Texto");        // imprime sem quebra de linha
io.novaLinha();              // imprime quebra de linha
```

### Funções de Debug

#### Debug e Informações
```minidart
debug(42);                   // mostra valor e tipo
info_debug();               // informações do compilador
```

---

## �💬 Comentários

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

declaracao      → varDecl | constDecl | funcDecl | statement | listDecl

varDecl         → "var" IDENTIFIER ("=" expression)? ";"
                | TIPO IDENTIFIER ("=" expression)? ";"

constDecl       → "constante" TIPO IDENTIFIER "=" expression ";"
                | "constante" "var" IDENTIFIER "=" expression ";"

listDecl        → "lista" "<" TIPO ">" IDENTIFIER ("=" listLiteral)? ";"

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
call            → primary ("(" arguments? ")" | "." IDENTIFIER ("(" arguments? ")")? | "[" expression "]")*
primary         → "verdadeiro" | "falso" | "nulo" | NUMBER | STRING 
                | IDENTIFIER | "(" expression ")" | listLiteral

listLiteral     → "[" (expression ("," expression)*)? "]"
arguments       → expression ("," expression)*

TIPO            → "inteiro" | "real" | "texto" | "logico" | "vazio" | "lista" "<" TIPO ">"
NUMBER          → DIGIT+ ("." DIGIT+)?
STRING          → "\"" CHAR* "\""
IDENTIFIER      → ALPHA (ALPHA | DIGIT)*
ALPHA           → [a-zA-Z_]
DIGIT           → [0-9]
CHAR            → qualquer caractere exceto "\""
```

---

## 🎯 Exemplos Práticos

### 🏃‍♂️ Exemplo 1: Olá Mundo
```minidart
inteiro principal() {
    imprima "Olá, Mundo!";
    retorne 0;
}
```

### 🔢 Exemplo 2: Calculadora Simples
```minidart
inteiro somar(inteiro a, inteiro b) {
    retorne a + b;
}

vazio principal() {
    inteiro x = 10;
    inteiro y = 20;
    inteiro resultado = somar(x, y);
    imprima "Resultado: " + paraTexto(resultado);
}
// Executa a funcão
principal();
```

### 🔄 Exemplo 3: Estruturas de Controle
```minidart
vazio principal() {
    inteiro numero = 15;
    
    // Condicional
    se (numero > 10) {
        imprima "Número é maior que 10";
    } senao {
        imprima "Número é menor ou igual a 10";
    }
    
    // Loop while
    inteiro contador = 0;
    enquanto (contador < 5) {
        imprima "Contador: " + paraTexto(contador);
        contador++;
    }
    
    // Loop for tradicional
    para (inteiro i = 0; i < 3; i++) {
        imprima "i = " + paraTexto(i);
    }
    
    // Loop for MiniDart
    para j = 1 ate 3 faca {
        imprima "j = " + paraTexto(j);
    }
}
// Executa a funcão
principal();
```

### 📋 Exemplo 4: Trabalhando com Listas
```minidart
inteiro principal() {
    // Declaração e inicialização de listas
    lista<inteiro> numeros = [1, 2, 3, 4, 5];
    lista<texto> nomes = ["Ana", "Bruno", "Carlos"];
    
    // Lista vazia
    lista<real> precos;
    
    // Acessando elementos
    imprima "Primeiro número: " + paraTexto(numeros[0]);
    imprima "Segundo nome: " + nomes[1];
    
    // Modificando elementos
    numeros[0] = 10;
    nomes[2] = "Carolina";
    
    // Usando métodos de lista
    numeros.adicionar(6);
    precos.adicionar(29.99);
    precos.adicionar(15.50);
    
    imprima "Tamanho da lista números: " + paraTexto(numeros.tamanho());
    imprima "Lista de preços vazia? " + paraTexto(precos.vazio());
    
    // Removendo elementos
    numeros.remover(2); // Remove o elemento no índice 2
    
    // Iterando sobre listas
    para i = 0 ate numeros.tamanho() - 1 faca {
        imprima "Número[" + paraTexto(i) + "] = " + paraTexto(numeros[i]);
    }
    
    retorne 0;
}
```

### 🏗️ Exemplo 5: Funções e Tipos
```minidart
// Função que trabalha com listas
lista<inteiro> criarSequencia(inteiro inicio, inteiro fim) {
    lista<inteiro> sequencia;
    
    para i = inicio ate fim faca {
        sequencia.adicionar(i);
    }
    
    retorne sequencia;
}

// Função que calcula média
real calcularMedia(lista<inteiro> valores) {
    se (valores.vazio()) {
        retorne 0.0;
    }
    
    inteiro soma = 0;
    para i = 0 ate valores.tamanho() - 1 faca {
        soma += valores[i];
    }
    
    retorne soma / valores.tamanho();
}

inteiro principal() {
    lista<inteiro> numeros = criarSequencia(1, 10);
    real media = calcularMedia(numeros);
    
    imprima "Média da sequência 1-10: " + paraTexto(media);
    
    // Usando operador typeof
    imprima "Tipo da variável media: " + tipode media;
    imprima "Tipo da lista números: " + tipode numeros;
    
    retorne 0;
}
```

### 🎯 Exemplo 6: Switch e Operador Ternário
```minidart
texto obterNomeDia(inteiro dia) {
    escolha (dia) {
        caso 1:
            retorne "Segunda-feira";
        caso 2:
            retorne "Terça-feira";
        caso 3:
            retorne "Quarta-feira";
        caso 4:
            retorne "Quinta-feira";
        caso 5:
            retorne "Sexta-feira";
        caso 6:
            retorne "Sábado";
        caso 7:
            retorne "Domingo";
        contrario:
            retorne "Dia inválido";
    }
}

inteiro principal() {
    inteiro dia = 3;
    texto nomeDia = obterNomeDia(dia);
    
    imprima "Hoje é: " + nomeDia;
    
    // Operador ternário
    texto periodo = (dia >= 6) ? "fim de semana" : "dia útil";
    imprima "Período: " + periodo;
    
    retorne 0;
}
```

### 📚 Exemplo 7: Usando Bibliotecas
```minidart
importar math;
importar string como str;
importar data;

inteiro principal() {
    // Usando funções matemáticas
    real numero = 16.0;
    imprima "Raiz quadrada de 16: " + paraTexto(math.raiz(numero));
    imprima "Seno de π/2: " + paraTexto(math.seno(math.pi / 2));
    
    // Usando funções de string
    texto frase = "  MiniDart é incrível!  ";
    imprima "Original: '" + frase + "'";
    imprima "Maiúscula: '" + str.maiuscula(frase) + "'";
    imprima "Sem espaços: '" + str.removerEspacos(frase) + "'";
    
    // Usando funções de data
    imprima "Data atual: " + data.dataAtual();
    imprima "Hora atual: " + data.horaAtual();
    
    // Conversões de tipo
    texto numeroTexto = "42";
    inteiro numeroConvertido = str.paraInteiro(numeroTexto);
    imprima "Número convertido: " + paraTexto(numeroConvertido * 2);
    
    retorne 0;
}
```

### 🔄 Exemplo 8: Recursividade com Listas
```minidart
// Função recursiva para calcular fatorial
inteiro fatorial(inteiro n) {
    se (n <= 1) {
        retorne 1;
    }
    retorne n * fatorial(n - 1);
}

// Função recursiva para somar elementos de uma lista
inteiro somarLista(lista<inteiro> nums, inteiro indice) {
    se (indice >= nums.tamanho()) {
        retorne 0;
    }
    retorne nums[indice] + somarLista(nums, indice + 1);
}

inteiro principal() {
    // Testando fatorial
    imprima "Fatorial de 5: " + paraTexto(fatorial(5));
    
    // Testando soma recursiva de lista
    lista<inteiro> valores = [1, 2, 3, 4, 5];
    inteiro somaTotal = somarLista(valores, 0);
    imprima "Soma dos valores: " + paraTexto(somaTotal);
    
    retorne 0;
}
```

---

## 📚 Resumo de Características v2.0

### ✅ Recursos Implementados

- ✅ **Tipos básicos**: inteiro, real, texto, logico, vazio
- ✅ **Sistema de Listas**: lista<tipo> com operações completas
  - Declaração e inicialização: `lista<inteiro> nums = [1, 2, 3];`
  - Acesso por índice: `nums[0]`
  - Atribuição por índice: `nums[0] = 10;`
  - Métodos: `.tamanho()`, `.adicionar()`, `.remover()`, `.vazio()`
- ✅ **Variáveis**: Declaração com tipo explícito e inferência (var)
- ✅ **Constantes**: Declaração tipada
- ✅ **Operadores**: Aritméticos, lógicos, comparação, atribuição
- ✅ **Estruturas condicionais**: se/senao
- ✅ **Loops**: enquanto, para (tradicional e MiniDart), faca-enquanto
- ✅ **Funções**: Com parâmetros e retorno tipado
- ✅ **Recursividade**: Suporte completo
- ✅ **Switch/case**: escolha/caso com contrario
- ✅ **Controle de fluxo**: parar e continuar
- ✅ **Sistema de imports**: Com alias opcional
- ✅ **Operador ternário**: condição ? valor1 : valor2
- ✅ **Operador typeof**: tipode variavel
- ✅ **Biblioteca padrão**: paraTexto(), tipo(), math, string, data, io
- ✅ **Conversão automática**: inteiro → real
- ✅ **Comentários**: De linha (//)

### 🎯 Recursos Avançados v2.0

- ✅ **Listas homogêneas tipadas**: Sistema completo de listas
- ✅ **Inferência de tipos**: var para listas e variáveis
- ✅ **Métodos de lista**: Operações integradas na linguagem
- ✅ **Conversão de tipos**: paraTexto() para qualquer tipo
- ✅ **Introspecção de tipos**: tipo() para obter tipo como string
- ✅ **Bibliotecas padrão**: math, string, data, io

### 🚧 Limitações Atuais

- ❌ **Listas multidimensionais**: Arrays bidimensionais
- ❌ **Objetos/classes**: Programação orientada a objetos
- ❌ **Comentários de bloco**: `/* */`
- ❌ **Operadores bitwise**: &, |, ^, <<, >>
- ✅ **Tratamento de exceções**: Estruturas try/catch
- ❌ **Escopo de módulo avançado**: Namespaces

---

## 🎓 Conclusão

MiniDart v2.0 é uma linguagem completa e expressiva, ideal para ensino de programação em português. Com seu sistema de listas homogêneas, biblioteca padrão abrangente e sintaxe familiar, proporciona uma base sólida para aprender conceitos de programação estruturada, funcional e manipulação de dados.

### 🔄 Evoluções da v2.0

1. **Sistema de Listas Completo**: Implementação de listas tipadas com todas as operações fundamentais
2. **Biblioteca Padrão Expandida**: Funções para conversão de tipos e operações essenciais
3. **Melhor Inferência de Tipos**: Suporte à palavra-chave `var` para listas
4. **Documentação Completa**: Cobertura de todos os recursos implementados

A documentação está em constante evolução junto com a linguagem. Para exemplos mais avançados e atualizações, consulte os arquivos na pasta `exemplos/` do projeto.

---

**Versão da Documentação**: 1.0  
**Data de Atualização**: Julho 2025  
**Autor**: Deriks Karlay Dias Costa
