import 'ast.dart';
import 'error.dart';
import 'symbol_table.dart';
import 'token.dart';

/// O Analisador Semântico percorre a AST para verificar erros de tipo,
/// declarações de variáveis e gerenciamento de escopo.
class SemanticAnalyzer implements AstVisitor<void> {
  final ErrorReporter _errorReporter;
  SymbolTable _currentScope = SymbolTable();

  SemanticAnalyzer(this._errorReporter);

  void analyze(List<Stmt> statements) {
    for (final statement in statements) {
      _resolveStmt(statement);
    }
  }

  // Funções de utilidade para gerenciamento de escopo
  void _beginScope() {
    _currentScope = SymbolTable(enclosing: _currentScope);
  }

  void _endScope() {
    _currentScope = _currentScope.enclosing!;
  }

  void _resolveStmt(Stmt stmt) => stmt.accept(this);
  void _resolveExpr(Expr expr) => expr.accept(this);

  // Visitantes para Statements
  @override
  void visitBlockStmt(BlockStmt stmt) {
    _beginScope();
    for (final statement in stmt.statements) {
      _resolveStmt(statement);
    }
    _endScope();
  }

  @override
  void visitVarDeclStmt(VarDeclStmt stmt) {
    // Declara a variável no escopo atual.
    _declare(stmt.name);
    // Se houver um inicializador, resolve-o.
    if (stmt.initializer != null) {
      _resolveExpr(stmt.initializer!);
    }
    // Define a variável como inicializada.
    _define(stmt.name);
  }

  @override
  void visitWhileStmt(WhileStmt stmt) {
    _resolveExpr(stmt.condition);
    _resolveStmt(stmt.body);
  }
  
  @override
  void visitForStmt(ForStmt stmt) {
    // Resolve as expressões inicializador e condição
    _resolveExpr(stmt.initializer);
    _resolveExpr(stmt.condition);
    
    // Cria um escopo para a variável do loop
    _beginScope();
    // Declara e define a variável de controle
    _declare(stmt.variable);
    _define(stmt.variable);
    
    // Resolve o corpo dentro do escopo da variável
    _resolveStmt(stmt.body);
    
    // Encerra o escopo
    _endScope();
  }
  
  @override
  void visitForStepStmt(ForStepStmt stmt) {
    // Resolve as expressões inicializador, condição e incremento
    _resolveExpr(stmt.initializer);
    _resolveExpr(stmt.condition);
    _resolveExpr(stmt.step);
    
    // Cria um escopo para a variável do loop
    _beginScope();
    // Declara e define a variável de controle
    _declare(stmt.variable);
    _define(stmt.variable);
    
    // Resolve o corpo dentro do escopo da variável
    _resolveStmt(stmt.body);
    
    // Encerra o escopo
    _endScope();
  }

  @override
  void visitIfStmt(IfStmt stmt) {
    _resolveExpr(stmt.condition);
    _resolveStmt(stmt.thenBranch);
    if (stmt.elseBranch != null) {
      _resolveStmt(stmt.elseBranch!);
    }
  }

  @override
  void visitExpressionStmt(ExpressionStmt stmt) {
    _resolveExpr(stmt.expression);
  }

  @override
  void visitPrintStmt(PrintStmt stmt) {
    _resolveExpr(stmt.expression);
  }

  // Visitantes para Expressions
  @override
  void visitVariableExpr(VariableExpr expr) {
    final symbol = _currentScope.get(expr.name);
    if (symbol == null) {
      _errorReporter.error(expr.name.line, "Variável '${expr.name.lexeme}' não declarada.");
    } else if (!symbol.isInitialized) {
      _errorReporter.error(expr.name.line, "Variável '${expr.name.lexeme}' usada antes de ser inicializada.");
    }
  }

  @override
  void visitAssignExpr(AssignExpr expr) {
    // Resolve o valor que está sendo atribuído.
    _resolveExpr(expr.value);
    // Verifica se a variável de destino existe.
    if (!_currentScope.assign(expr.name)) {
      _errorReporter.error(expr.name.line, "Tentativa de atribuir a uma variável '${expr.name.lexeme}' não declarada.");
    }
  }

  @override
  void visitBinaryExpr(BinaryExpr expr) {
    _resolveExpr(expr.left);
    _resolveExpr(expr.right);
  }
  
  @override
  void visitLogicalExpr(LogicalExpr expr) {
    _resolveExpr(expr.left);
    _resolveExpr(expr.right);
  }

  @override
  void visitUnaryExpr(UnaryExpr expr) {
    _resolveExpr(expr.right);
  }

  @override
  void visitGroupingExpr(GroupingExpr expr) {
    _resolveExpr(expr.expression);
  }

  @override
  void visitLiteralExpr(LiteralExpr expr) {
    // Literais não precisam de resolução.
  }

  // ===== NOVOS VISITANTES PARA FUNÇÕES =====
  
  @override
  void visitFunctionStmt(FunctionStmt stmt) {
    // Declara a função no escopo atual
    _declare(stmt.name);
    _define(stmt.name);
    
    // Cria um novo escopo para a função
    _beginScope();
    
    // Declara os parâmetros no escopo da função
    for (final param in stmt.params) {
      _declare(param.name);
      _define(param.name);
    }
    
    // Resolve o corpo da função
    _resolveStmt(stmt.body);
    
    // Encerra o escopo da função
    _endScope();
  }
  
  @override
  void visitReturnStmt(ReturnStmt stmt) {
    // Se há um valor de retorno, resolve a expressão
    if (stmt.value != null) {
      _resolveExpr(stmt.value!);
    }
  }
  
  @override
  void visitCallExpr(CallExpr expr) {
    // Resolve a expressão que representa a função
    _resolveExpr(expr.callee);
    
    // Resolve todos os argumentos
    for (final argument in expr.arguments) {
      _resolveExpr(argument);
    }
  }

  // ===== FIM DOS NOVOS VISITANTES =====

  // Funções auxiliares para declaração e definição de variáveis
  void _declare(Token name) {
    _currentScope.define(name);
  }

  void _define(Token name) {
    _currentScope.assign(name);
  }
}
