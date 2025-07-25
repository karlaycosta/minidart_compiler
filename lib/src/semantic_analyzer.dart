import 'ast.dart';
import 'error.dart';
import 'symbol_table.dart';
import 'token.dart';

/// O Analisador Semântico percorre a AST para verificar erros de tipo,
/// declarações de variáveis e gerenciamento de escopo.
class SemanticAnalyzer implements AstVisitor<void> {
  final ErrorReporter _errorReporter;
  SymbolTable _currentScope = SymbolTable();
  
  // Conjunto para rastrear nomes de constantes (não podem ser reatribuídas)
  final Set<String> _constants = <String>{};
  
  // Mapa para rastrear imports e seus aliases
  // Chave: nome usado no código (alias ou nome original)
  // Valor: nome da biblioteca original
  final Map<String, String> _importedLibraries = <String, String>{};

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
  void visitTypedVarDeclStmt(TypedVarDeclStmt stmt) {
    // Declara a variável tipada no escopo atual.
    _declare(stmt.name);
    // Se houver um inicializador, resolve-o.
    if (stmt.initializer != null) {
      _resolveExpr(stmt.initializer!);
    }
    // Define a variável como inicializada.
    _define(stmt.name);
    // TODO: Futuramente, adicionar verificação de compatibilidade de tipos
    // entre o tipo declarado (stmt.type) e o tipo do inicializador
  }

  @override
  void visitConstDeclStmt(ConstDeclStmt stmt) {
    // Verificar se já existe uma variável/constante com este nome
    if (_currentScope.get(stmt.name) != null) {
      _errorReporter.error(stmt.name.line, 
          "Constante '${stmt.name.lexeme}' já foi declarada neste escopo.");
      return;
    }
    
    // Declara a constante no escopo atual
    _declare(stmt.name);
    
    // Resolve o inicializador (obrigatório para constantes)
    _resolveExpr(stmt.initializer);
    
    // Registra como constante (não pode ser reatribuída)
    _constants.add(stmt.name.lexeme);
    
    // Define a constante como inicializada
    _define(stmt.name);
    
    // TODO: Futuramente, adicionar verificação de compatibilidade de tipos
    // e verificar se o inicializador é uma expressão constante
  }

  @override
  void visitWhileStmt(WhileStmt stmt) {
    _resolveExpr(stmt.condition);
    _resolveStmt(stmt.body);
  }
  
  @override
  void visitDoWhileStmt(DoWhileStmt stmt) {
    _resolveStmt(stmt.body);
    _resolveExpr(stmt.condition);
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
  void visitForCStmt(ForCStmt stmt) {
    // Cria um escopo para o loop (inicialização pode declarar variáveis)
    _beginScope();
    
    // Resolve inicialização (se presente)
    if (stmt.initializer != null) {
      _resolveStmt(stmt.initializer!);
    }
    
    // Resolve condição (se presente)
    if (stmt.condition != null) {
      _resolveExpr(stmt.condition!);
    }
    
    // Resolve incremento (se presente)
    if (stmt.increment != null) {
      _resolveExpr(stmt.increment!);
    }
    
    // Resolve o corpo dentro do escopo
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
    
    // Verificar se é uma biblioteca padrão ou importada
    if (['math', 'string', 'io'].contains(expr.name.lexeme) || 
        _importedLibraries.containsKey(expr.name.lexeme)) {
      // É uma biblioteca padrão ou importada, sempre válida
      return;
    }
    
    if (symbol == null) {
      _errorReporter.error(expr.name.line, "Variável '${expr.name.lexeme}' não declarada.");
    } else if (!symbol.isInitialized) {
      _errorReporter.error(expr.name.line, "Variável '${expr.name.lexeme}' usada antes de ser inicializada.");
    }
  }

  @override
  void visitCompoundAssignExpr(CompoundAssignExpr expr) {
    // Verificar se é tentativa de atribuição composta a uma constante
    if (_constants.contains(expr.name.lexeme)) {
      _errorReporter.error(expr.name.line,
          "Não é possível aplicar operação '${expr.operator.lexeme}' à constante '${expr.name.lexeme}'.");
      return;
    }
    
    // Resolve o valor que está sendo aplicado
    _resolveExpr(expr.value);
    // Verifica se a variável de destino existe
    if (!_currentScope.assign(expr.name)) {
      _errorReporter.error(expr.name.line, "Tentativa de operação '${expr.operator.lexeme}' em variável '${expr.name.lexeme}' não declarada.");
    }
  }

  @override
  void visitDecrementExpr(DecrementExpr expr) {
    // Verificar se é tentativa de decrementar uma constante
    if (_constants.contains(expr.name.lexeme)) {
      _errorReporter.error(expr.name.line,
          "Não é possível decrementar constante '${expr.name.lexeme}'.");
      return;
    }
    
    // Verifica se a variável existe
    if (!_currentScope.assign(expr.name)) {
      _errorReporter.error(expr.name.line, 
          "Tentativa de decrementar variável '${expr.name.lexeme}' não declarada.");
    }
  }

  @override
  void visitIncrementExpr(IncrementExpr expr) {
    // Verificar se é tentativa de incrementar uma constante
    if (_constants.contains(expr.name.lexeme)) {
      _errorReporter.error(expr.name.line,
          "Não é possível incrementar constante '${expr.name.lexeme}'.");
      return;
    }
    
    // Verifica se a variável existe
    if (!_currentScope.assign(expr.name)) {
      _errorReporter.error(expr.name.line, 
          "Tentativa de incrementar variável '${expr.name.lexeme}' não declarada.");
    }
  }

  @override
  void visitAssignExpr(AssignExpr expr) {
    // Verificar se é tentativa de atribuição a uma constante
    if (_constants.contains(expr.name.lexeme)) {
      _errorReporter.error(expr.name.line,
          "Não é possível atribuir valor à constante '${expr.name.lexeme}'.");
      return;
    }
    
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
  void visitTernaryExpr(TernaryExpr expr) {
    _resolveExpr(expr.condition);
    _resolveExpr(expr.thenBranch);
    _resolveExpr(expr.elseBranch);
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
  void visitImportStmt(ImportStmt stmt) {
    // Validar se a biblioteca existe
    final libraryName = stmt.library.lexeme;
    final validLibraries = ['math', 'string', 'io', 'data'];
    
    if (!validLibraries.contains(libraryName)) {
      _errorReporter.error(stmt.library.line, "Biblioteca '$libraryName' não reconhecida. Bibliotecas disponíveis: ${validLibraries.join(', ')}");
      return;
    }
    
    // Determinar o nome usado (alias ou nome original)
    final usedName = stmt.alias?.lexeme ?? libraryName;
    
    // Verificar conflitos com variáveis existentes
    final existingSymbol = _currentScope.get(Token(
      type: TokenType.identifier,
      lexeme: usedName,
      line: stmt.alias?.line ?? stmt.library.line,
      column: stmt.alias?.column ?? stmt.library.column,
    ));
    
    if (existingSymbol != null) {
      _errorReporter.error(stmt.alias?.line ?? stmt.library.line, 
        "O nome '$usedName' conflita com uma variável já declarada.");
      return;
    }
    
    // Verificar se já foi importado com nome diferente
    if (_importedLibraries.containsKey(usedName)) {
      _errorReporter.error(stmt.alias?.line ?? stmt.library.line,
        "O nome '$usedName' já está sendo usado para a biblioteca '${_importedLibraries[usedName]}'.");
      return;
    }
    
    // Registrar o import
    _importedLibraries[usedName] = libraryName;
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

  @override
  void visitMemberAccessExpr(MemberAccessExpr expr) {
    // Resolve a expressão do objeto
    _resolveExpr(expr.object);
    
    // Para acesso a membro, verificamos se é uma biblioteca conhecida
    if (expr.object is VariableExpr) {
      final objectName = (expr.object as VariableExpr).name.lexeme;
      
      // Verificar se é uma biblioteca importada (com ou sem alias)
      final libraryName = _importedLibraries[objectName];
      if (libraryName != null) {
        // É uma biblioteca importada, válida
        return;
      }
      
      // Verificar se é uma biblioteca padrão usada sem import (compatibilidade)
      if (['math', 'string', 'io'].contains(objectName)) {
        // É uma biblioteca padrão, sempre válida (compatibilidade retroativa)
        return;
      }
    }
    
    // Se não é uma biblioteca conhecida, trata como acesso normal
    // (para futuras extensões como objetos customizados)
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
