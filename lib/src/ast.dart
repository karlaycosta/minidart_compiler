import 'token.dart';

/// **Árvore Sintática Abstrata (AST) do MiniDart**
///
/// Este arquivo define a estrutura hierárquica que representa o código fonte
/// após a análise sintática. A AST é composta por nós que representam
/// diferentes construções da linguagem MiniDart.
///
/// **Arquitetura:**
/// - Implementa o padrão Visitor para percorrer e processar a árvore
/// - Separação clara entre Statements (declarações) e Expressions (expressões)
/// - Type safety através de generics
///
/// **Padrão Visitor:**
/// Permite adicionar novas operações sobre a AST sem modificar as classes dos nós.
/// Cada visitor implementa uma funcionalidade específica:
/// - SemanticAnalyzer: Verificação de tipos e escopos
/// - CodeGenerator: Geração de bytecode
/// - LineVisitor: Extração de informações de linha

/// **Interface do Padrão Visitor**
///
/// Define um contrato para percorrer e processar todos os tipos de nós da AST.
/// O tipo genérico T permite que diferentes visitors retornem tipos específicos:
/// - `AstVisitor<void>`: Para análises que não retornam valores
/// - `AstVisitor<int>`: Para extrair informações numéricas
/// - `AstVisitor<String>`: Para gerar representações textuais
abstract interface class AstVisitor<T> {
  // === Visitantes para Statements (Declarações) ===

  /// Visita um bloco de statements delimitado por chaves { }
  T visitBlockStmt(BlockStmt stmt);

  /// Visita uma expressão que é usada como statement (ex: a + b;)
  T visitExpressionStmt(ExpressionStmt stmt);

  /// Visita uma estrutura condicional (se/senao)
  T visitIfStmt(IfStmt stmt);

  /// Visita um comando de impressão (imprimir)
  T visitPrintStmt(PrintStmt stmt);

  /// Visita uma declaração de variável (var nome = valor;)
  T visitVarDeclStmt(VarDeclStmt stmt);

  /// Visita uma declaração de variável tipada (tipo nome = valor;)
  T visitTypedVarDeclStmt(TypedVarDeclStmt stmt);

  /// Visita uma declaração de constante (constante tipo nome = valor;)
  T visitConstDeclStmt(ConstDeclStmt stmt);

  /// Visita um loop while (enquanto)
  T visitWhileStmt(WhileStmt stmt);

  /// Visita um loop do-while (faca...enquanto)
  T visitDoWhileStmt(DoWhileStmt stmt);

  /// Visita um loop for (para)
  T visitForStmt(ForStmt stmt);

  /// Visita um loop for estilo C (para (init; condition; increment))
  T visitForCStmt(ForCStmt stmt);

  /// Visita um loop for com incremento personalizado (para...incremente/decremente)
  T visitForStepStmt(ForStepStmt stmt);

  /// Visita uma declaração de função
  T visitFunctionStmt(FunctionStmt stmt);

  /// Visita um comando de retorno
  T visitReturnStmt(ReturnStmt stmt);

  /// Visita um comando break (parar)
  T visitBreakStmt(BreakStmt stmt);

  /// Visita um comando continue (continuar)
  T visitContinueStmt(ContinueStmt stmt);

  /// Visita uma estrutura switch (escolha)
  T visitSwitchStmt(SwitchStmt stmt);

  /// Visita uma declaração de import
  T visitImportStmt(ImportStmt stmt);
  
  /// Visita uma declaração de lista (lista<tipo> nome = [elementos];)
  T visitListDeclStmt(ListDeclStmt stmt);

  // === Visitantes para Expressions (Expressões) ===

  /// Visita uma atribuição de valor a variável (nome = valor)
  T visitAssignExpr(AssignExpr expr);

  /// Visita uma atribuição composta (nome += valor, nome -= valor, etc.)
  T visitCompoundAssignExpr(CompoundAssignExpr expr);

  /// Visita uma expressão de incremento (variavel++)
  T visitIncrementExpr(IncrementExpr expr);

  /// Visita uma expressão de decremento (variavel--)
  T visitDecrementExpr(DecrementExpr expr);

  /// Visita uma operação binária (a + b, x > y, etc.)
  T visitBinaryExpr(BinaryExpr expr);

  /// Visita uma expressão agrupada por parênteses ((expressão))
  T visitGroupingExpr(GroupingExpr expr);

  /// Visita uma expressão ternária (condição ? verdadeiro : falso)
  T visitTernaryExpr(TernaryExpr expr);

  /// Visita um valor literal (números, strings, booleanos, nulo)
  T visitLiteralExpr(LiteralExpr expr);

  /// Visita uma operação lógica (e, ou)
  T visitLogicalExpr(LogicalExpr expr);

  /// Visita uma operação unária (-, !)
  T visitUnaryExpr(UnaryExpr expr);

  /// Visita o uso de uma variável (referência pelo nome)
  T visitVariableExpr(VariableExpr expr);

  /// Visita uma chamada de função
  T visitCallExpr(CallExpr expr);

  /// Visita um acesso a membro (objeto.propriedade)
  T visitMemberAccessExpr(MemberAccessExpr expr);
  
  /// Visita um literal de lista ([elemento1, elemento2, ...])
  T visitListLiteralExpr(ListLiteralExpr expr);
  
  /// Visita um acesso por índice (lista[indice])
  T visitIndexAccessExpr(IndexAccessExpr expr);
  
  /// Visita uma atribuição por índice (lista[indice] = valor)
  T visitIndexAssignExpr(IndexAssignExpr expr);
  
  /// Visita uma chamada de método (objeto.metodo(argumentos))
  T visitMethodCallExpr(MethodCallExpr expr);
}

// ============================================================================
// HIERARQUIA DE STATEMENTS (DECLARAÇÕES)
// ============================================================================

/// **Classe base abstrata para todos os Statements**
///
/// Statements representam declarações e comandos que não produzem valores:
/// - Declarações de variáveis
/// - Estruturas de controle (if, while)
/// - Comandos (print)
/// - Blocos de código
///
/// **Padrão Visitor:** Cada statement implementa `accept()` para permitir
/// que diferentes visitors processem o nó de forma polimórfica.
abstract final class Stmt {
  /// Aceita um visitor e delega o processamento para o método específico
  T accept<T>(AstVisitor<T> visitor);
}

/// **Statement de Bloco: { statement1; statement2; ... }**
///
/// Representa um conjunto de statements agrupados por chaves.
/// Usado em:
/// - Corpo de estruturas condicionais
/// - Corpo de loops
/// - Definição de escopo local
///
/// **Exemplo:** `{ var a = 10; imprimir a; }`
final class BlockStmt extends Stmt {
  /// Lista de statements contidos no bloco
  final List<Stmt> statements;

  BlockStmt(this.statements);

  @override
  T accept<T>(AstVisitor<T> visitor) => visitor.visitBlockStmt(this);
}

/// **Statement de Expressão: expressão;**
///
/// Permite que uma expressão seja usada como statement.
/// Útil para:
/// - Chamadas de função com efeitos colaterais
/// - Atribuições de variáveis
/// - Expressões que devem ser avaliadas mas descartadas
///
/// **Exemplo:** `a + b;` (calcula mas descarta o resultado)
final class ExpressionStmt extends Stmt {
  /// A expressão a ser avaliada
  final Expr expression;

  ExpressionStmt(this.expression);

  @override
  T accept<T>(AstVisitor<T> visitor) => visitor.visitExpressionStmt(this);
}

/// **Statement Condicional: se (condição) statement [senao statement]**
///
/// Implementa estruturas condicionais da linguagem MiniDart.
/// Permite execução condicional baseada em uma expressão booleana.
///
/// **Exemplo:** `se (idade >= 18) { imprimir "Adulto"; } senao { imprimir "Menor"; }`
final class IfStmt extends Stmt {
  /// Expressão que determina qual branch executar
  final Expr condition;

  /// Statement executado se a condição for verdadeira
  final Stmt thenBranch;

  /// Statement executado se a condição for falsa (opcional)
  final Stmt? elseBranch;

  IfStmt(this.condition, this.thenBranch, this.elseBranch);

  @override
  T accept<T>(AstVisitor<T> visitor) => visitor.visitIfStmt(this);
}

/// **Statement de Impressão: imprimir expressão;**
///
/// Comando built-in para exibir valores na saída padrão.
/// Aceita qualquer expressão que possa ser convertida para string.
///
/// **Exemplo:** `imprimir "Olá " + nome;`
final class PrintStmt extends Stmt {
  /// Expressão cujo valor será impresso
  final Expr expression;

  PrintStmt(this.expression);

  @override
  T accept<T>(AstVisitor<T> visitor) => visitor.visitPrintStmt(this);
}

/// **Statement de Declaração de Variável: var nome [= inicializador];**
///
/// Declara uma nova variável no escopo atual, opcionalmente com valor inicial.
/// Se não houver inicializador, a variável recebe valor `nulo`.
///
/// **Exemplos:**
/// - `var nome;` (valor inicial: nulo)
/// - `var idade = 25;` (valor inicial: 25)
final class VarDeclStmt extends Stmt {
  /// Token que representa o nome da variável
  final Token name;

  /// Expressão para calcular o valor inicial (opcional)
  final Expr? initializer;

  VarDeclStmt(this.name, this.initializer);

  @override
  T accept<T>(AstVisitor<T> visitor) => visitor.visitVarDeclStmt(this);
}

/// **Statement de Declaração de Variável Tipada: tipo nome = valor**
///
/// Implementa declarações de variáveis com tipos explícitos na linguagem MiniDart.
/// Permite especificar o tipo da variável na declaração.
///
/// **Exemplos:**
/// - `inteiro idade = 25;`
/// - `texto nome = "João";`
/// - `real altura = 1.75;`
/// - `logico ativo = verdadeiro;`
final class TypedVarDeclStmt extends Stmt {
  /// Informação sobre o tipo da variável
  final TypeInfo type;

  /// Token que representa o nome da variável
  final Token name;

  /// Expressão para calcular o valor inicial (opcional)
  final Expr? initializer;

  TypedVarDeclStmt(this.type, this.name, this.initializer);

  @override
  T accept<T>(AstVisitor<T> visitor) => visitor.visitTypedVarDeclStmt(this);
}

/// **Statement de Declaração de Constante: constante tipo nome = valor;**
///
/// Declara uma constante com tipo explícito que não pode ser alterada
/// após sua inicialização. Todas as constantes DEVEM ser inicializadas.
///
/// **Exemplos:**
/// - `constante inteiro MAXIMO = 100;`
/// - `constante texto VERSAO = "v1.5.0";`
/// - `constante real PI = 3.14159;`
/// - `constante logico DEBUG = verdadeiro;`
final class ConstDeclStmt extends Stmt {
  /// Informação sobre o tipo da constante
  final TypeInfo type;

  /// Token que representa o nome da constante
  final Token name;

  /// Expressão para calcular o valor inicial (obrigatório)
  final Expr initializer;

  ConstDeclStmt(this.type, this.name, this.initializer);

  @override
  T accept<T>(AstVisitor<T> visitor) => visitor.visitConstDeclStmt(this);
}

/// **Statement de Declaração de Lista: lista<tipo> nome = [elementos];**
///
/// Declara uma lista homogênea com tipo explícito dos elementos.
/// Todas as listas devem especificar o tipo dos elementos que contêm.
///
/// **Exemplos:**
/// - `lista<inteiro> numeros = [1, 2, 3, 4, 5];`
/// - `lista<texto> nomes = ["João", "Maria", "Pedro"];`
/// - `lista<real> valores = [1.5, 2.7, 3.14];`
/// - `lista<logico> flags = [verdadeiro, falso, verdadeiro];`
/// - `lista<inteiro> vazia = [];`
final class ListDeclStmt extends Stmt {
  /// Tipo dos elementos da lista
  final TypeInfo elementType;

  /// Token que representa o nome da lista
  final Token name;

  /// Expressão de inicialização da lista (opcional)
  final Expr? initializer;

  ListDeclStmt(this.elementType, this.name, this.initializer);

  @override
  T accept<T>(AstVisitor<T> visitor) => visitor.visitListDeclStmt(this);
}

/// **Statement de Loop While: enquanto (condição) statement**
///
/// Implementa loops condicionais na linguagem MiniDart.
/// Executa o corpo repetidamente enquanto a condição for verdadeira.
///
/// **Exemplo:** `enquanto (contador < 10) { contador = contador + 1; }`
final class WhileStmt extends Stmt {
  /// Expressão avaliada a cada iteração
  final Expr condition;

  /// Statement executado repetidamente
  final Stmt body;

  WhileStmt(this.condition, this.body);

  @override
  T accept<T>(AstVisitor<T> visitor) => visitor.visitWhileStmt(this);
}

/// **Statement de Loop Do-While: faca statement enquanto (condição);**
///
/// Implementa loops do-while na linguagem MiniDart.
/// Executa o corpo pelo menos uma vez, depois repete enquanto a condição for verdadeira.
/// A diferença para o while é que a condição é testada após a execução do corpo.
///
/// **Exemplo:** `faca { contador = contador + 1; } enquanto (contador < 10);`
final class DoWhileStmt extends Stmt {
  /// Statement executado repetidamente
  final Stmt body;

  /// Expressão avaliada após cada iteração
  final Expr condition;

  DoWhileStmt(this.body, this.condition);

  @override
  T accept<T>(AstVisitor<T> visitor) => visitor.visitDoWhileStmt(this);
}

/// **Statement de Loop For: para variavel = inicio ate fim faca statement**
///
/// Implementa loops com contador automático na linguagem MiniDart.
/// Executa o corpo com variável incrementada automaticamente.
///
/// **Exemplo:** `para i = 1 ate 5 faca { imprimir i; }`
final class ForStmt extends Stmt {
  /// Nome da variável de controle
  final Token variable;

  /// Expressão para valor inicial
  final Expr initializer;

  /// Expressão para valor final
  final Expr condition;

  /// Statement executado repetidamente
  final Stmt body;

  ForStmt(this.variable, this.initializer, this.condition, this.body);

  @override
  T accept<T>(AstVisitor<T> visitor) => visitor.visitForStmt(this);
}

/// **Statement de Loop For com Incremento/Decremento: para variavel = inicio ate fim incremente/decremente valor faca statement**
///
/// Implementa loops com contador e incremento/decremento personalizável na linguagem MiniDart.
/// Permite especificar quanto a variável deve ser incrementada ou decrementada a cada iteração.
///
/// **Exemplos:**
/// - `para i = 0 ate 10 incremente 2 faca { imprimir i; }` (0, 2, 4, 6, 8, 10)
/// - `para i = 10 ate 0 decremente 2 faca { imprimir i; }` (10, 8, 6, 4, 2, 0)
final class ForStepStmt extends Stmt {
  /// Nome da variável de controle
  final Token variable;

  /// Expressão para valor inicial
  final Expr initializer;

  /// Expressão para valor final
  final Expr condition;

  /// Expressão para incremento por iteração
  final Expr step;

  /// Indica se é incremento (true) ou decremento (false)
  final bool isIncrement;

  /// Statement executado repetidamente
  final Stmt body;

  ForStepStmt(
    this.variable,
    this.initializer,
    this.condition,
    this.step,
    this.isIncrement,
    this.body,
  );

  @override
  T accept<T>(AstVisitor<T> visitor) => visitor.visitForStepStmt(this);
}

/// **Loop For Estilo C**
///
/// Representa um loop for com sintaxe estilo C: `para (init; condition; increment)`.
/// Mais flexível que o ForStmt tradicional, permitindo qualquer tipo de inicialização
/// e incremento.
///
/// **Exemplo:**
/// ```dart
/// para (inteiro i = 0; i < 10; i++) {
///   imprimir i;
/// }
/// ```
final class ForCStmt extends Stmt {
  /// Declaração de inicialização (pode ser null)
  final Stmt? initializer;

  /// Condição de continuação do loop (pode ser null)
  final Expr? condition;

  /// Expressão de incremento (pode ser null)
  final Expr? increment;

  /// Corpo do loop
  final Stmt body;

  ForCStmt(this.initializer, this.condition, this.increment, this.body);

  @override
  T accept<T>(AstVisitor<T> visitor) => visitor.visitForCStmt(this);
}

// ============================================================================
// CLASSES DE SUPORTE PARA FUNÇÕES
// ============================================================================

/// **Informação de Tipo**
///
/// Representa um tipo de dados na linguagem MiniDart com informações
/// sobre a localização no código fonte para relatórios de erro.
final class TypeInfo {
  /// Token que representa o tipo (inteiro, real, texto, logico, vazio)
  final Token type;

  TypeInfo(this.type);

  /// Retorna o nome do tipo como string
  String get name => type.lexeme;

  @override
  String toString() => name;
}

/// **Parâmetro de Função**
///
/// Representa um parâmetro formal de uma função, incluindo seu tipo e nome.
final class Parameter {
  /// Tipo do parâmetro
  final TypeInfo type;

  /// Nome do parâmetro
  final Token name;

  Parameter(this.type, this.name);

  @override
  String toString() => '${type.name} ${name.lexeme}';
}

/// **Statement de Declaração de Função: `<tipo>` nome(params) { body }**
///
/// Declara uma função com tipo de retorno, nome, parâmetros e corpo.
///
/// **Exemplo:** `inteiro somar(inteiro a, inteiro b) { retornar a + b; }`
final class FunctionStmt extends Stmt {
  /// Tipo de retorno da função
  final TypeInfo? returnType;

  /// Nome da função
  final Token name;

  /// Lista de parâmetros formais
  final List<Parameter> params;

  /// Corpo da função (geralmente um BlockStmt)
  final Stmt body;

  FunctionStmt(this.returnType, this.name, this.params, this.body);

  @override
  T accept<T>(AstVisitor<T> visitor) => visitor.visitFunctionStmt(this);
}

/// **Statement de Retorno: retornar [expressão];**
///
/// Comando para retornar um valor de uma função e encerrar sua execução.
///
/// **Exemplos:**
/// - `retornar;` (retorno vazio)
/// - `retornar 42;` (retorna valor)
final class ReturnStmt extends Stmt {
  /// Token do comando retornar (para localização de erros)
  final Token keyword;

  /// Expressão a ser retornada (pode ser null para retorno vazio)
  final Expr? value;

  ReturnStmt(this.keyword, this.value);

  @override
  T accept<T>(AstVisitor<T> visitor) => visitor.visitReturnStmt(this);
}

/// **Comando Break (Parar)**
///
/// Interrompe a execução do loop atual e salta para a próxima instrução
/// após o loop.
///
/// **Sintaxe:** `parar;`
///
/// **Uso válido apenas dentro de:**
/// - Loops `enquanto`
/// - Loops `para`
/// - Loops `faca-enquanto`
final class BreakStmt extends Stmt {
  /// Token do comando 'parar' (para localização de erros)
  final Token keyword;

  BreakStmt(this.keyword);

  @override
  T accept<T>(AstVisitor<T> visitor) => visitor.visitBreakStmt(this);
}

/// **Comando Continue (Continuar)**
///
/// Pula o restante da iteração atual do loop e prossegue
/// para a próxima iteração.
///
/// **Sintaxe:** `continuar;`
///
/// **Uso válido apenas dentro de:**
/// - Loops `enquanto`
/// - Loops `para`
/// - Loops `faca-enquanto`
final class ContinueStmt extends Stmt {
  /// Token do comando 'continuar' (para localização de erros)
  final Token keyword;

  ContinueStmt(this.keyword);

  @override
  T accept<T>(AstVisitor<T> visitor) => visitor.visitContinueStmt(this);
}

/// **Declaração de Import**
///
/// Representa a importação de uma biblioteca padrão, com suporte opcional a alias.
///
/// **Sintaxe:** `importar biblioteca [como alias];`
///
/// **Exemplos:**
/// ```dart
/// importar math;              // import simples
/// importar string como texto; // import com alias
/// ```
final class ImportStmt extends Stmt {
  /// Token do comando 'importar'
  final Token keyword;

  /// Nome da biblioteca sendo importada
  final Token library;

  /// Alias opcional (se usar 'como')
  final Token? alias;

  ImportStmt(this.keyword, this.library, this.alias);

  @override
  T accept<T>(AstVisitor<T> visitor) => visitor.visitImportStmt(this);
}

/// **Switch Statement**
///
/// Representa uma estrutura switch/case para controle de fluxo baseado em múltiplas condições.
/// 
/// ### Sintaxe MiniDart:
/// ```dart
/// escolha (numero) {
///     caso 1:
///         imprima "Um";
///         parar;
///     caso 2:
///         imprima "Dois"; 
///         parar;
///     caso contrario:
///         imprima "Outro";
/// }
/// ```
final class SwitchStmt extends Stmt {
  /// Token da palavra-chave 'escolha'
  final Token keyword;
  
  /// Expressão a ser avaliada
  final Expr expression;
  
  /// Lista de casos (case e default)
  final List<CaseStmt> cases;
  
  SwitchStmt(this.keyword, this.expression, this.cases);
  
  @override
  T accept<T>(AstVisitor<T> visitor) => visitor.visitSwitchStmt(this);
}

/// **Case Statement**
///
/// Representa um caso individual dentro de um switch statement.
final class CaseStmt {
  /// Token da palavra-chave 'caso' ou 'contrario'
  final Token keyword;
  
  /// Valor do caso (null para default/contrario)
  final Expr? value;
  
  /// Lista de statements a executar neste caso
  final List<Stmt> statements;
  
  CaseStmt(this.keyword, this.value, this.statements);
}

// ============================================================================
// HIERARQUIA DE EXPRESSIONS (EXPRESSÕES)
// ============================================================================

/// **Classe base abstrata para todas as Expressions**
///
/// Expressions representam construções que produzem valores:
/// - Operações aritméticas e lógicas
/// - Literais (números, strings, booleanos)
/// - Referências a variáveis
/// - Atribuições
///
/// **Diferença de Statements:** Expressions sempre retornam um valor,
/// enquanto Statements executam ações sem retornar valores.
abstract final class Expr {
  /// Aceita um visitor e delega o processamento para o método específico
  T accept<T>(AstVisitor<T> visitor);
}

/// **Expressão de Atribuição: variável = valor**
///
/// Atribui um novo valor a uma variável existente.
/// A expressão retorna o valor atribuído, permitindo atribuições em cadeia.
///
/// **Exemplo:** `idade = 30` (retorna 30)
/// **Cadeia:** `a = b = 10` (ambas recebem 10)
final class AssignExpr extends Expr {
  /// Token que identifica a variável de destino
  final Token name;

  /// Expressão que calcula o novo valor
  final Expr value;

  AssignExpr(this.name, this.value);

  @override
  T accept<T>(AstVisitor<T> visitor) => visitor.visitAssignExpr(this);
}

/// **Expressão de Atribuição Composta: variavel operador= valor**
///
/// Representa atribuições que combinam uma operação com atribuição:
/// - `+=`: soma e atribui
/// - `-=`: subtrai e atribui
/// - `*=`: multiplica e atribui
/// - `/=`: divide e atribui
///
/// **Exemplos:**
/// ```dart
/// inteiro x = 10;
/// x += 5;  // equivale a x = x + 5 (x vira 15)
/// x *= 2;  // equivale a x = x * 2 (x vira 30)
/// ```
final class CompoundAssignExpr extends Expr {
  /// Token que identifica a variável de destino
  final Token name;

  /// Operador de atribuição composta (+=, -=, *=, /=)
  final Token operator;

  /// Expressão que calcula o valor a ser aplicado
  final Expr value;

  CompoundAssignExpr(this.name, this.operator, this.value);

  @override
  T accept<T>(AstVisitor<T> visitor) => visitor.visitCompoundAssignExpr(this);
}

/// **Expressão de Atribuição por Índice: lista[indice] = valor**
///
/// Representa atribuição de valor a um elemento específico de uma lista.
/// Permite modificar elementos existentes nas listas.
///
/// **Exemplos:**
/// - `numeros[0] = 100;` - atribui 100 ao primeiro elemento
/// - `nomes[i] = "Novo";` - atribui usando índice variável
/// - `matriz[2] = valor;` - atribui valor de variável
final class IndexAssignExpr extends Expr {
  /// Expressão que representa a lista
  final Expr object;

  /// Token do colchete esquerdo
  final Token bracket;

  /// Expressão do índice
  final Expr index;

  /// Valor a ser atribuído
  final Expr value;

  IndexAssignExpr(this.object, this.bracket, this.index, this.value);

  @override
  T accept<T>(AstVisitor<T> visitor) => visitor.visitIndexAssignExpr(this);
}

/// **Expressão de Chamada de Método: objeto.metodo(argumentos)**
///
/// Representa a chamada de métodos integrados de listas e outros objetos.
/// Suporta diferentes tipos de métodos:
/// - `lista.tamanho()` - retorna o tamanho da lista
/// - `lista.adicionar(valor)` - adiciona um elemento ao final
/// - `lista.remover()` - remove e retorna o último elemento
final class MethodCallExpr extends Expr {
  /// Expressão que representa o objeto
  final Expr object;

  /// Token do ponto
  final Token dot;

  /// Nome do método
  final Token name;

  /// Token do parêntese esquerdo
  final Token paren;

  /// Lista de argumentos do método
  final List<Expr> arguments;

  MethodCallExpr(this.object, this.dot, this.name, this.paren, this.arguments);

  @override
  T accept<T>(AstVisitor<T> visitor) => visitor.visitMethodCallExpr(this);
}

/// **Expressão de Incremento: ++variavel ou variavel++**
///
/// Representa o operador de incremento que aumenta o valor
/// de uma variável numérica em 1:
/// - Pré-fixo: ++variavel (incrementa e retorna novo valor)
/// - Pós-fixo: variavel++ (retorna valor original e incrementa)
///
/// **Exemplo:**
/// ```dart
/// inteiro i = 5;
/// inteiro antigo = i++;  // antigo = 5, i = 6
/// inteiro novo = ++i;    // novo = 7, i = 7
/// ```
final class IncrementExpr extends Expr {
  /// Token que identifica a variável a ser incrementada
  final Token name;

  /// Se true, é pré-fixo (++var); se false, é pós-fixo (var++)
  final bool isPrefix;

  IncrementExpr(this.name, {this.isPrefix = false});

  @override
  T accept<T>(AstVisitor<T> visitor) => visitor.visitIncrementExpr(this);
}

/// **Expressão de Decremento: --variavel ou variavel--**
///
/// Representa o operador de decremento que diminui o valor
/// de uma variável numérica em 1:
/// - Pré-fixo: --variavel (decrementa e retorna novo valor)
/// - Pós-fixo: variavel-- (retorna valor original e decrementa)
///
/// **Exemplo:**
/// ```dart
/// inteiro i = 5;
/// inteiro antigo = i--;  // antigo = 5, i = 4
/// inteiro novo = --i;    // novo = 3, i = 3
/// ```
final class DecrementExpr extends Expr {
  /// Token que identifica a variável a ser decrementada
  final Token name;

  /// Se true, é pré-fixo (--var); se false, é pós-fixo (var--)
  final bool isPrefix;

  DecrementExpr(this.name, {this.isPrefix = false});

  @override
  T accept<T>(AstVisitor<T> visitor) => visitor.visitDecrementExpr(this);
}

/// **Expressão Binária: esquerda operador direita**
///
/// Representa operações que envolvem dois operandos:
/// - Aritméticas: +, -, *, /
/// - Relacionais: <, <=, >, >=, ==, !=
///
/// **Exemplos:**
/// - `10 + 5` (aritmética)
/// - `idade >= 18` (relacional)
/// - `nome == "João"` (igualdade)
final class BinaryExpr extends Expr {
  /// Operando da esquerda
  final Expr left;

  /// Token que representa o operador
  final Token operator;

  /// Operando da direita
  final Expr right;

  BinaryExpr(this.left, this.operator, this.right);

  @override
  T accept<T>(AstVisitor<T> visitor) => visitor.visitBinaryExpr(this);
}

/// **Expressão de Acesso por Índice: expr[index]**
///
/// Acessa um elemento específico de uma lista usando um índice inteiro.
/// O índice deve ser uma expressão que avalia para um valor inteiro.
///
/// **Exemplos:**
/// - `numeros[0]` - primeiro elemento
/// - `nomes[i]` - elemento no índice i
/// - `matriz[2]` - terceiro elemento
/// - `lista[tamanho - 1]` - último elemento
final class IndexAccessExpr extends Expr {
  /// Expressão que representa a lista
  final Expr object;

  /// Token do colchete esquerdo
  final Token bracket;

  /// Expressão do índice
  final Expr index;

  IndexAccessExpr(this.object, this.bracket, this.index);

  @override
  T accept<T>(AstVisitor<T> visitor) => visitor.visitIndexAccessExpr(this);
}

/// **Expressão de Agrupamento: (expressão)**
///
/// Agrupa uma expressão com parênteses para alterar a precedência
/// ou tornar a intenção mais clara.
///
/// **Exemplos:**
/// - `(a + b) * c` (força a soma antes da multiplicação)
/// - `(idade >= 18)` (clareza visual)
final class GroupingExpr extends Expr {
  /// A expressão agrupada pelos parênteses
  final Expr expression;

  GroupingExpr(this.expression);

  @override
  T accept<T>(AstVisitor<T> visitor) => visitor.visitGroupingExpr(this);
}

/// **Expressão Ternária: condição ? valor_se_verdadeiro : valor_se_falso**
///
/// Representa uma expressão condicional que avalia uma condição
/// e retorna um de dois valores dependendo do resultado.
///
/// **Sintaxe:**
/// ```
/// condição ? valor_verdadeiro : valor_falso
/// ```
///
/// **Exemplos:**
/// ```dart
/// var status = idade >= 18 ? "maior" : "menor";
/// var sinal = x > 0 ? "positivo" : x < 0 ? "negativo" : "zero";
/// ```
final class TernaryExpr extends Expr {
  /// A condição a ser avaliada
  final Expr condition;

  /// Valor retornado se a condição for verdadeira
  final Expr thenBranch;

  /// Valor retornado se a condição for falsa
  final Expr elseBranch;

  TernaryExpr(this.condition, this.thenBranch, this.elseBranch);

  @override
  T accept<T>(AstVisitor<T> visitor) => visitor.visitTernaryExpr(this);
}

/// **Expressão Literal: valores constantes**
///
/// Representa valores literais definidos diretamente no código:
/// - Números: 42, 3.14
/// - Strings: "Olá mundo"
/// - Booleanos: verdadeiro, falso
/// - Nulo: nulo
///
/// **Tipos suportados:**
/// - `double`: Números com ou sem casas decimais
/// - `String`: Texto entre aspas duplas
/// - `bool`: true/false (verdadeiro/falso)
/// - `null`: Ausência de valor (nulo)
final class LiteralExpr extends Expr {
  /// O valor literal (pode ser qualquer tipo suportado)
  final Object? value;

  LiteralExpr(this.value);

  @override
  T accept<T>(AstVisitor<T> visitor) => visitor.visitLiteralExpr(this);
}

/// **Expressão de Lista Literal: [elemento1, elemento2, ...]**
///
/// Representa uma lista de elementos literais homogêneos.
/// Todos os elementos devem ser do mesmo tipo.
///
/// **Exemplos:**
/// - `[1, 2, 3, 4, 5]` - lista de inteiros
/// - `["João", "Maria", "Pedro"]` - lista de textos
/// - `[1.5, 2.7, 3.14]` - lista de reais
/// - `[verdadeiro, falso, verdadeiro]` - lista de lógicos
/// - `[]` - lista vazia
final class ListLiteralExpr extends Expr {
  /// Token do colchete esquerdo
  final Token leftBracket;

  /// Lista de expressões que representam os elementos
  final List<Expr> elements;

  /// Token do colchete direito
  final Token rightBracket;

  ListLiteralExpr(this.leftBracket, this.elements, this.rightBracket);

  @override
  T accept<T>(AstVisitor<T> visitor) => visitor.visitListLiteralExpr(this);
}

/// **Expressão Lógica: esquerda operador_lógico direita**
///
/// Representa operações lógicas com avaliação de curto-circuito:
/// - AND (e): Retorna true se ambos operandos forem true
/// - OR (ou): Retorna true se pelo menos um operando for true
///
/// **Curto-circuito:**
/// - `false e qualquer_coisa` → false (não avalia o segundo operando)
/// - `true ou qualquer_coisa` → true (não avalia o segundo operando)
///
/// **Exemplos:**
/// - `idade >= 18 e tem_documento` (ambas condições devem ser verdadeiras)
/// - `é_admin ou é_moderador` (pelo menos uma deve ser verdadeira)
final class LogicalExpr extends Expr {
  /// Operando da esquerda
  final Expr left;

  /// Token que representa o operador lógico (e/ou)
  final Token operator;

  /// Operando da direita
  final Expr right;

  LogicalExpr(this.left, this.operator, this.right);

  @override
  T accept<T>(AstVisitor<T> visitor) => visitor.visitLogicalExpr(this);
}

/// **Expressão Unária: operador operando**
///
/// Representa operações que envolvem apenas um operando:
/// - Negação aritmética: -número
/// - Negação lógica: !booleano
///
/// **Exemplos:**
/// - `-42` (negativo de 42)
/// - `!verdadeiro` (negação lógica, resulta em false)
/// - `-(a + b)` (negativo do resultado da soma)
final class UnaryExpr extends Expr {
  /// Token que representa o operador unário
  final Token operator;

  /// Expressão que será operada
  final Expr right;

  UnaryExpr(this.operator, this.right);

  @override
  T accept<T>(AstVisitor<T> visitor) => visitor.visitUnaryExpr(this);
}

/// **Expressão de Variável: nome_da_variável**
///
/// Representa o uso de uma variável, retornando seu valor atual.
/// A variável deve ter sido declarada anteriormente no escopo acessível.
///
/// **Exemplo:** `idade` (retorna o valor armazenado na variável idade)
///
/// **Verificações semânticas:**
/// - Variável deve estar declarada
/// - Variável deve ter sido inicializada
/// - Variável deve estar no escopo acessível
final class VariableExpr extends Expr {
  /// Token que identifica a variável
  final Token name;

  VariableExpr(this.name);

  @override
  T accept<T>(AstVisitor<T> visitor) => visitor.visitVariableExpr(this);
}

/// **Expressão de Chamada de Função: função(argumentos)**
///
/// Representa uma chamada de função com argumentos.
///
/// **Exemplo:** `somar(10, 20)` ou `imprimir("Olá mundo")`
final class CallExpr extends Expr {
  /// Expressão que resolve para a função (geralmente VariableExpr)
  final Expr callee;

  /// Token do parêntese de fechamento (para localização de erros)
  final Token paren;

  /// Lista de argumentos passados para a função
  final List<Expr> arguments;

  CallExpr(this.callee, this.paren, this.arguments);

  @override
  T accept<T>(AstVisitor<T> visitor) => visitor.visitCallExpr(this);
}

/// **Expressão de Acesso a Membro**
///
/// Representa o acesso a uma propriedade ou método de um objeto através
/// do operador ponto (.).
///
/// **Sintaxe:** `objeto.propriedade` ou `biblioteca.funcao`
///
/// **Exemplos:**
/// ```dart
/// math.sin(x)      // Função de biblioteca
/// string.tamanho(s) // Método de string
/// ```
final class MemberAccessExpr extends Expr {
  /// Expressão que representa o objeto/biblioteca
  final Expr object;

  /// Token do ponto (para localização de erros)
  final Token dot;

  /// Nome da propriedade/método sendo acessado
  final Token property;

  MemberAccessExpr(this.object, this.dot, this.property);

  @override
  T accept<T>(AstVisitor<T> visitor) => visitor.visitMemberAccessExpr(this);
}

// ============================================================================
// GUIA DE USO DA AST
// ============================================================================

/// **Como usar esta AST:**
/// 
/// 1. **Construção da AST:** O Parser cria instâncias destas classes
///    conforme analisa o código fonte MiniDart.
/// 
/// 2. **Processamento:** Diferentes visitors percorrem a AST:
///    ```dart
///    // Análise semântica
///    final analyzer = SemanticAnalyzer(errorReporter);
///    analyzer.analyze(statements);
///    
///    // Geração de código
///    final generator = CodeGenerator();
///    final bytecode = generator.compile(statements);
///    ```
/// 
/// 3. **Implementação de novo Visitor:**
///    ```dart
///    class MeuVisitor implements AstVisitor<String> {
///      @override String visitLiteralExpr(LiteralExpr expr) {
///        return expr.value.toString();
///      }
///      // ... implementar outros métodos
///    }
///    ```
/// 
/// **Estrutura hierárquica:**
/// ```
/// AstNode
/// ├── Stmt (Statements)
/// │   ├── BlockStmt
/// │   ├── ExpressionStmt
/// │   ├── IfStmt
/// │   ├── PrintStmt
/// │   ├── VarDeclStmt
/// │   ├── WhileStmt
/// │   ├── ForStmt
/// │   ├── ForStepStmt
/// │   ├── FunctionStmt
/// │   ├── ReturnStmt
/// │   └── ImportStmt
/// └── Expr (Expressions)
///     ├── AssignExpr
///     ├── BinaryExpr
///     ├── GroupingExpr
///     ├── LiteralExpr
///     ├── LogicalExpr
///     ├── UnaryExpr
///     ├── VariableExpr
///     ├── CallExpr
///     └── MemberAccessExpr
/// ```
