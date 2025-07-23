# 📋 **Análise Completa da Classe Parser.dart**

## **🎯 Função Principal**

A classe `Parser` é o **segundo estágio** do compilador MiniDart, responsável por converter a sequência de tokens (produzida pelo lexer) em uma **Árvore Sintática Abstrata (AST)**. Ela implementa um **parser de descida recursiva** que reconhece a gramática da linguagem MiniDart.

---

## **🏗️ Arquitetura e Design**

### **📥 Entrada e Saída**
- **Entrada**: Lista de tokens (`List<Token>`) do lexer
- **Saída**: Lista de declarações (`List<Stmt>`) representando a AST
- **Tratamento de erros**: Integrado com `ErrorReporter`

### **🔄 Paradigma: Descida Recursiva**
O parser implementa **análise sintática descendente** onde cada regra gramatical corresponde a um método:

```
programa → declaração* EOF
declaração → varDecl | statement
statement → ifStmt | printStmt | whileStmt | block | expressionStmt
```

---

## **⚙️ Componentes Principais**

### **1. 🎬 Controle de Fluxo Principal**
```dart
List<Stmt> parse() {
  final statements = <Stmt>[];
  while (!_isAtEnd()) {
    statements.add(_declaration()); // Processa cada declaração
  }
  return statements;
}
```

**Explicação:**
- Ponto de entrada principal do parser
- Processa todas as declarações até encontrar EOF
- Retorna lista de statements que formam a AST

### **2. 📝 Processamento de Declarações**
```dart
Stmt _declaration() {
  try {
    if (_match([TokenType.var_])) return _varDeclaration(); // var x = 10;
    return _statement(); // Outros tipos de statement
  } on ParseError {
    _synchronize(); // Recuperação de erro
    return ExpressionStmt(LiteralExpr(null)); // Nó dummy
  }
}
```

**Explicação:**
- Diferencia entre declarações de variáveis e statements
- Implementa recuperação de erro com `_synchronize()`
- Retorna nó dummy em caso de erro para continuar parsing

### **3. 🔀 Tipos de Statements Suportados**

#### **📦 Declaração de Variável**
```dart
Stmt _varDeclaration() {
  final name = _consume(TokenType.identifier, "Esperado nome da variável.");
  Expr? initializer;
  if (_match([TokenType.equal])) {
    initializer = _expression();
  }
  _consume(TokenType.semicolon, "Esperado ';' após a declaração da variável.");
  return VarDeclStmt(name, initializer);
}
```
**Sintaxe:** `var nome = valor;` ou `var nome;`

#### **🔀 Condicional If**
```dart
Stmt _ifStatement() {
  _consume(TokenType.leftParen, "Esperado '(' após 'se'.");
  final condition = _expression();
  _consume(TokenType.rightParen, "Esperado ')' após a condição do 'se'.");
  
  final thenBranch = _statement();
  Stmt? elseBranch;
  if (_match([TokenType.else_])) {
    elseBranch = _statement();
  }
  return IfStmt(condition, thenBranch, elseBranch);
}
```
**Sintaxe:** `se (condição) statement` ou `se (condição) statement senao statement`

#### **🔄 Loop While**
```dart
Stmt _whileStatement() {
  _consume(TokenType.leftParen, "Esperado '(' após 'enquanto'.");
  final condition = _expression();
  _consume(TokenType.rightParen, "Esperado ')' após a condição do 'enquanto'.");
  final body = _statement();
  return WhileStmt(condition, body);
}
```
**Sintaxe:** `enquanto (condição) statement`

#### **📝 Impressão**
```dart
Stmt _printStatement() {
  final value = _expression();
  _consume(TokenType.semicolon, "Esperado ';' após o valor.");
  return PrintStmt(value);
}
```
**Sintaxe:** `imprimir expressão;`

#### **📦 Bloco**
```dart
List<Stmt> _block() {
  final statements = <Stmt>[];
  while (!_check(TokenType.rightBrace) && !_isAtEnd()) {
    statements.add(_declaration());
  }
  _consume(TokenType.rightBrace, "Esperado '}' após o bloco.");
  return statements;
}
```
**Sintaxe:** `{ declaração* }`

---

## **🧮 Hierarquia de Precedência de Expressões**

O parser implementa **precedência de operadores** através de métodos encadeados (do menor para o maior precedência):

```
_assignment()    // = (associativo à direita)
    ↓
_or()           // ou
    ↓
_and()          // e
    ↓
_equality()     // == !=
    ↓
_comparison()   // < > <= >=
    ↓
_term()         // + -
    ↓
_factor()       // * /
    ↓
_unary()        // ! -
    ↓
_primary()      // literais, variáveis, (expressão)
```

### **🎯 Implementação da Precedência**

#### **📊 Atribuição (Menor Precedência)**
```dart
Expr _assignment() {
  final expr = _or();
  if (_match([TokenType.equal])) {
    final equals = _previous();
    final value = _assignment(); // Recursão à direita para associatividade
    if (expr is VariableExpr) {
      return AssignExpr(expr.name, value);
    }
    _error(equals, "Alvo de atribuição inválido.");
  }
  return expr;
}
```
**Característica:** Associativo à direita (`a = b = c` → `a = (b = c)`)

#### **🔗 Operadores Binários**
```dart
Expr _or() => _binary(next: _and, types: [TokenType.or]);
Expr _and() => _binary(next: _equality, types: [TokenType.and]);
Expr _equality() => _binary(next: _comparison, types: [TokenType.bangEqual, TokenType.equalEqual]);
Expr _comparison() => _binary(next: _term, types: [TokenType.greater, TokenType.greaterEqual, TokenType.less, TokenType.lessEqual]);
Expr _term() => _binary(next: _factor, types: [TokenType.minus, TokenType.plus]);
Expr _factor() => _binary(next: _unary, types: [TokenType.slash, TokenType.star]);
```

#### **🔧 Método Helper para Binários**
```dart
Expr _binary({required Expr Function() next, required List<TokenType> types}) {
  var expr = next();
  while (_match(types)) {
    final operator = _previous();
    final right = next();
    expr = BinaryExpr(expr, operator, right);
  }
  return expr;
}
```
**Característica:** Associativo à esquerda para todos os operadores binários

#### **➖ Operadores Unários**
```dart
Expr _unary() {
  if (_match([TokenType.bang, TokenType.minus])) {
    final operator = _previous();
    final right = _unary(); // Recursão para suportar múltiplos unários
    return UnaryExpr(operator, right);
  }
  return _primary();
}
```
**Suporte:** `!`, `-` (negação lógica e aritmética)

#### **🎯 Expressões Primárias (Maior Precedência)**
```dart
Expr _primary() {
  if (_match([TokenType.false_])) return LiteralExpr(false);
  if (_match([TokenType.true_])) return LiteralExpr(true);
  if (_match([TokenType.nil])) return LiteralExpr(null);
  if (_match([TokenType.number, TokenType.string])) {
    return LiteralExpr(_previous().literal);
  }
  if (_match([TokenType.identifier])) {
    return VariableExpr(_previous());
  }
  if (_match([TokenType.leftParen])) {
    final expr = _expression();
    _consume(TokenType.rightParen, "Esperado ')' após a expressão.");
    return GroupingExpr(expr);
  }
  throw _error(_peek(), "Expressão esperada.");
}
```

**Suporte:**
- **Literais**: `verdadeiro`, `falso`, `nulo`, números, strings
- **Variáveis**: identificadores
- **Agrupamento**: `(expressão)`

### **🎪 Exemplo de Parsing de Expressão**

**Entrada:** `x = 2 + 3 * 4`

**Processo:**
1. `_assignment()` → detecta `=`
2. `_term()` → processa `2 +`
3. `_factor()` → processa `3 * 4` (maior precedência primeiro)
4. **Resultado:** `AssignExpr(x, BinaryExpr(2, +, BinaryExpr(3, *, 4)))`

**AST Gerada:**
```
AssignExpr
├── name: x
└── value: BinaryExpr
    ├── left: LiteralExpr(2)
    ├── operator: +
    └── right: BinaryExpr
        ├── left: LiteralExpr(3)
        ├── operator: *
        └── right: LiteralExpr(4)
```

---

## **🛠️ Métodos Utilitários Cruciais**

### **🔍 Navegação de Tokens**

#### **🎯 Correspondência Condicional**
```dart
bool _match(List<TokenType> types) {
  for (final type in types) {
    if (_check(type)) {
      _advance(); // Consome token se corresponder
      return true;
    }
  }
  return false;
}
```
**Uso:** Verificar e consumir tokens opcionais

#### **✅ Consumo Obrigatório**
```dart
Token _consume(TokenType type, String message) {
  if (_check(type)) return _advance();
  throw _error(_peek(), message); // Erro se não encontrar
}
```
**Uso:** Garantir tokens obrigatórios (como `;`, `)`, `}`)

#### **👁️ Verificação Sem Consumo**
```dart
bool _check(TokenType type) => !_isAtEnd() && _peek().type == type;
```
**Uso:** Lookahead sem alterar posição

#### **➡️ Navegação**
```dart
Token _advance() {
  if (!_isAtEnd()) _current++;
  return _previous();
}

Token _peek() => _tokens[_current];         // Token atual
Token _previous() => _tokens[_current - 1]; // Token anterior
bool _isAtEnd() => _peek().type == TokenType.eof; // Fim dos tokens
```

### **⚠️ Tratamento de Erros**

#### **🚨 Geração de Erro**
```dart
ParseError _error(Token token, String message) {
  _errorReporter.error(token.line, message); // Reporta ao sistema de erros
  return ParseError(); // Lança exceção customizada
}
```

#### **🔄 Sincronização de Erro**
```dart
void _synchronize() {
  _advance();
  while (!_isAtEnd()) {
    if (_previous().type == TokenType.semicolon) return; // Para em ';'
    
    // Para em início de novos statements
    switch (_peek().type) {
      case TokenType.class_:
      case TokenType.fun:
      case TokenType.var_:
      case TokenType.for_:
      case TokenType.if_:
      case TokenType.while_:
      case TokenType.print_:
      case TokenType.return_:
        return;
      default:
        break;
    }
    _advance();
  }
}
```

**Função:** Recuperar de erros e continuar parsing no próximo statement válido

---

## **🎯 Características Específicas do MiniDart**

### **🇧🇷 Suporte a Português**
- **Keywords**: `se`, `senao`, `enquanto`, `imprimir`, `var`
- **Mensagens de erro** em português
- **Mapeamento direto** para tokens português

### **🔧 Funcionalidades Implementadas**
- ✅ **Variáveis**: `var x = 10;`
- ✅ **Condicionais**: `se (x > 5) { imprimir x; }`
- ✅ **Loops**: `enquanto (x < 10) { x = x + 1; }`
- ✅ **Expressões aritméticas**: `(2 + 3) * 4`
- ✅ **Expressões lógicas**: `x > 5 e y < 10`
- ✅ **Atribuição**: `x = y + z`
- ✅ **Agrupamento**: `{ múltiplos statements }`

### **❌ Limitações Atuais**
- ❌ **Funções**: Não implementado
- ❌ **Classes**: Não implementado
- ❌ **Loop for**: Não implementado
- ❌ **Return**: Não implementado

---

## **🔄 Fluxo de Execução Típico**

```mermaid
graph TD
    A[Lista de Tokens] --> B[parse()]
    B --> C[_declaration()]
    C --> D{Token atual?}
    D -->|var| E[_varDeclaration()]
    D -->|se| F[_ifStatement()]
    D -->|enquanto| G[_whileStatement()]
    D -->|imprimir| H[_printStatement()]
    D -->|{| I[_block()]
    D -->|expressão| J[_expressionStatement()]
    E --> K[AST Node]
    F --> K
    G --> K
    H --> K
    I --> K
    J --> K
    K --> L[Lista de Statements]
```

---

## **🎪 Exemplo Prático de Parsing**

### **Código MiniDart:**
```dart
var x = 10;
se (x > 5) {
    imprimir x;
} senao {
    imprimir "pequeno";
}
```

### **Processo de Parsing:**

#### **1. Declaração de Variável:**
**Input:** `var x = 10;`
**Processo:**
1. `_declaration()` → detecta `var`
2. `_varDeclaration()` → consome `x`, `=`, `10`, `;`
3. **Output:** `VarDeclStmt(Token(x), LiteralExpr(10))`

#### **2. Statement If:**
**Input:** `se (x > 5) { ... } senao { ... }`
**Processo:**
1. `_statement()` → detecta `se`
2. `_ifStatement()` → processa condição e branches
3. Condition: `BinaryExpr(VariableExpr(x), >, LiteralExpr(5))`
4. Then: `BlockStmt([PrintStmt(VariableExpr(x))])`
5. Else: `BlockStmt([PrintStmt(LiteralExpr("pequeno"))])`

### **AST Resultante:**
```dart
[
  VarDeclStmt(
    name: Token(identifier, "x", null, 1),
    initializer: LiteralExpr(10)
  ),
  IfStmt(
    condition: BinaryExpr(
      left: VariableExpr(Token(identifier, "x", null, 2)),
      operator: Token(greater, ">", null, 2),
      right: LiteralExpr(5)
    ),
    thenBranch: BlockStmt([
      PrintStmt(VariableExpr(Token(identifier, "x", null, 3)))
    ]),
    elseBranch: BlockStmt([
      PrintStmt(LiteralExpr("pequeno"))
    ])
  )
]
```

---

## **📊 Gramática Formal MiniDart**

```bnf
programa     → declaração* EOF
declaração   → varDecl | statement
varDecl      → "var" IDENTIFIER ( "=" expressão )? ";"
statement    → exprStmt | ifStmt | printStmt | whileStmt | block
exprStmt     → expressão ";"
ifStmt       → "se" "(" expressão ")" statement ( "senao" statement )?
printStmt    → "imprimir" expressão ";"
whileStmt    → "enquanto" "(" expressão ")" statement
block        → "{" declaração* "}"

expressão    → atribuição
atribuição   → IDENTIFIER "=" atribuição | ou
ou           → e ( "ou" e )*
e            → igualdade ( "e" igualdade )*
igualdade    → comparação ( ( "!=" | "==" ) comparação )*
comparação   → termo ( ( ">" | ">=" | "<" | "<=" ) termo )*
termo        → fator ( ( "-" | "+" ) fator )*
fator        → unário ( ( "/" | "*" ) unário )*
unário       → ( "!" | "-" ) unário | primário
primário     → "verdadeiro" | "falso" | "nulo"
             | NÚMERO | STRING | IDENTIFIER
             | "(" expressão ")"
```

---

## **💡 Pontos Fortes do Design**

### **🎯 Vantagens**
1. **Modularidade**: Cada regra gramatical corresponde a um método
2. **Recursividade**: Suporte natural a estruturas aninhadas
3. **Recuperação de erro**: Continua parsing após erros
4. **Precedência clara**: Hierarquia bem definida
5. **Localização**: Mensagens em português
6. **Robustez**: Tratamento de casos edge
7. **Extensibilidade**: Fácil adicionar novas construções

### **🔧 Padrões de Design Utilizados**
- **Recursive Descent**: Cada método processa uma regra gramatical
- **Error Recovery**: Sincronização para continuar após erros
- **Precedence Climbing**: Hierarquia de métodos para precedência
- **Lookahead**: Verificação sem consumo para decisões

### **📈 Complexidade**
- **Temporal**: O(n) onde n = número de tokens
- **Espacial**: O(d) onde d = profundidade máxima da AST
- **Recursão**: Profundidade limitada pela gramática

---

## **🚀 Conclusão**

O Parser MiniDart é o **cérebro sintático** do compilador, transformando código linear em uma estrutura hierárquica que pode ser processada pelos estágios subsequentes (análise semântica e geração de código). 

Seu design modular, robusto sistema de recuperação de erros e suporte nativo ao português fazem dele uma excelente base para expansão e uma ferramenta educacional valiosa para entender como parsers funcionam na prática.

**Próximos estágios:** A AST gerada será processada pelo analisador semântico para verificação de tipos e escopo, seguido pela geração de bytecode e execução na máquina virtual MiniDart.
