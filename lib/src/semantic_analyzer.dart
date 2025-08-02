import 'ast.dart';
import 'error.dart';
import 'symbol_table.dart';
import 'token.dart';
import 'standard_library.dart';

// Visitor para obter linha de uma expressão
class LineVisitor implements AstVisitor<int> {
  @override
  int visitLiteralExpr(LiteralExpr expr) => 1; // Fallback

  @override
  int visitVariableExpr(VariableExpr expr) => expr.name.line;

  @override
  int visitBinaryExpr(BinaryExpr expr) => expr.operator.line;

  @override
  int visitUnaryExpr(UnaryExpr expr) => expr.operator.line;

  @override
  int visitGroupingExpr(GroupingExpr expr) => expr.expression.accept(this);

  @override
  int visitLogicalExpr(LogicalExpr expr) => expr.operator.line;

  @override
  int visitTernaryExpr(TernaryExpr expr) => expr.condition.accept(this);

  @override
  int visitCallExpr(CallExpr expr) => expr.callee.accept(this);

  @override
  int visitAssignExpr(AssignExpr expr) => expr.name.line;

  @override
  int visitCompoundAssignExpr(CompoundAssignExpr expr) => expr.name.line;

  @override
  int visitIncrementExpr(IncrementExpr expr) => expr.name.line;

  @override
  int visitDecrementExpr(DecrementExpr expr) => expr.name.line;

  @override
  int visitMemberAccessExpr(MemberAccessExpr expr) => expr.dot.line;

  // Métodos para statements
  @override
  int visitExpressionStmt(ExpressionStmt stmt) => 1;

  @override
  int visitPrintStmt(PrintStmt stmt) => 1;

  @override
  int visitVarDeclStmt(VarDeclStmt stmt) => 1;

  @override
  int visitTypedVarDeclStmt(TypedVarDeclStmt stmt) => 1;

  @override
  int visitConstDeclStmt(ConstDeclStmt stmt) => 1;

  @override
  int visitBlockStmt(BlockStmt stmt) => 1;

  @override
  int visitIfStmt(IfStmt stmt) => 1;

  @override
  int visitWhileStmt(WhileStmt stmt) => 1;

  @override
  int visitDoWhileStmt(DoWhileStmt stmt) => 1;

  @override
  int visitForStmt(ForStmt stmt) => 1;

  @override
  int visitForStepStmt(ForStepStmt stmt) => 1;

  @override
  int visitForCStmt(ForCStmt stmt) => 1;

  @override
  int visitFunctionStmt(FunctionStmt stmt) => 1;

  @override
  int visitReturnStmt(ReturnStmt stmt) => 1;

  @override
  int visitBreakStmt(BreakStmt stmt) => stmt.keyword.line;

  @override
  int visitContinueStmt(ContinueStmt stmt) => stmt.keyword.line;

  @override
  int visitSwitchStmt(SwitchStmt stmt) => stmt.keyword.line;

  @override
  int visitImportStmt(ImportStmt stmt) => 1;

  @override
  int visitListDeclStmt(ListDeclStmt stmt) => stmt.name.line;

  @override
  int visitListLiteralExpr(ListLiteralExpr expr) => expr.leftBracket.line;

  @override
  int visitIndexAccessExpr(IndexAccessExpr expr) => expr.bracket.line;

  @override
  int visitIndexAssignExpr(IndexAssignExpr expr) => expr.bracket.line;

  @override
  int visitMethodCallExpr(MethodCallExpr expr) => expr.dot.line;
}

/// O Analisador Semântico percorre a AST para verificar erros de tipo,
/// declarações de variáveis e gerenciamento de escopo.
class SemanticAnalyzer implements AstVisitor<void> {
  final ErrorReporter _errorReporter;
  SymbolTable _currentScope = SymbolTable();

  // Biblioteca padrão para verificar funções nativas
  final StandardLibrary _standardLibrary = StandardLibrary();

  // Conjunto para rastrear nomes de constantes (não podem ser reatribuídas)
  final Set<String> _constants = <String>{};

  // Mapa para rastrear imports e seus aliases
  // Chave: nome usado no código (alias ou nome original)
  // Valor: nome da biblioteca original
  final Map<String, String> _importedLibraries = <String, String>{};

  // Tipo de retorno da função atual (para validação de return)
  TypeInfo? _currentFunctionReturnType;

  // Controle de loops para validação de break/continue
  int _loopNestingLevel = 0;
  
  // Controle de switches para validação de break
  int _switchNestingLevel = 0;

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
    // Declara a variável tipada no escopo atual com o tipo especificado
    _currentScope.defineTyped(stmt.name, stmt.type.type.type);
    
    // Se houver um inicializador, resolve-o.
    if (stmt.initializer != null) {
      _resolveExpr(stmt.initializer!);
      
      // Verificação de compatibilidade de tipos
      final expectedType = stmt.type.type.type;
      final actualType = _inferExpressionType(stmt.initializer!);
      
      if (!_areTypesCompatible(actualType, expectedType)) {
        _errorReporter.error(
          stmt.name.line,
          "Tipo incompatível na declaração. Variável '${stmt.name.lexeme}' é do tipo '${_tokenTypeToString(expectedType)}', mas inicializador é do tipo '${_tokenTypeToString(actualType)}'.",
        );
      }
    }
    // Define a variável como inicializada.
    _define(stmt.name);
  }

  @override
  void visitConstDeclStmt(ConstDeclStmt stmt) {
    // Verificar se já existe uma variável/constante com este nome
    if (_currentScope.get(stmt.name) != null) {
      _errorReporter.error(
        stmt.name.line,
        "Constante '${stmt.name.lexeme}' já foi declarada neste escopo.",
      );
      return;
    }

    // Declara a constante no escopo atual
    _declare(stmt.name);

    // Resolve o inicializador (obrigatório para constantes)
    _resolveExpr(stmt.initializer);

    // Verificação de compatibilidade de tipos
    final expectedType = stmt.type.type.type;
    final actualType = _inferExpressionType(stmt.initializer);
    
    if (!_areTypesCompatible(actualType, expectedType)) {
      _errorReporter.error(
        stmt.name.line,
        "Tipo incompatível na declaração da constante. '${stmt.name.lexeme}' é do tipo '${_tokenTypeToString(expectedType)}', mas inicializador é do tipo '${_tokenTypeToString(actualType)}'.",
      );
    }

    // Registra como constante (não pode ser reatribuída)
    _constants.add(stmt.name.lexeme);

    // Define a constante como inicializada
    _define(stmt.name);
  }

  @override
  void visitWhileStmt(WhileStmt stmt) {
    _resolveExpr(stmt.condition);
    
    _loopNestingLevel++;
    _resolveStmt(stmt.body);
    _loopNestingLevel--;
  }

  @override
  void visitDoWhileStmt(DoWhileStmt stmt) {
    _loopNestingLevel++;
    _resolveStmt(stmt.body);
    _loopNestingLevel--;
    
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
    _loopNestingLevel++;
    _resolveStmt(stmt.body);
    _loopNestingLevel--;

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
    _loopNestingLevel++;
    _resolveStmt(stmt.body);
    _loopNestingLevel--;

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
    _loopNestingLevel++;
    _resolveStmt(stmt.body);
    _loopNestingLevel--;

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

    // Verificar se é uma função nativa
    if (_standardLibrary.hasFunction(expr.name.lexeme)) {
      // É uma função nativa, sempre válida
      return;
    }

    if (symbol == null) {
      _errorReporter.error(
        expr.name.line,
        "Variável '${expr.name.lexeme}' não declarada.",
      );
    } else if (!symbol.isInitialized) {
      _errorReporter.error(
        expr.name.line,
        "Variável '${expr.name.lexeme}' usada antes de ser inicializada.",
      );
    }
  }

  @override
  void visitCompoundAssignExpr(CompoundAssignExpr expr) {
    // Verificar se é tentativa de atribuição composta a uma constante
    if (_constants.contains(expr.name.lexeme)) {
      _errorReporter.error(
        expr.name.line,
        "Não é possível aplicar operação '${expr.operator.lexeme}' à constante '${expr.name.lexeme}'.",
      );
      return;
    }

    // Resolve o valor que está sendo aplicado
    _resolveExpr(expr.value);
    // Verifica se a variável de destino existe
    if (!_currentScope.assign(expr.name)) {
      _errorReporter.error(
        expr.name.line,
        "Tentativa de operação '${expr.operator.lexeme}' em variável '${expr.name.lexeme}' não declarada.",
      );
    }
  }

  @override
  void visitDecrementExpr(DecrementExpr expr) {
    // Verificar se é tentativa de decrementar uma constante
    if (_constants.contains(expr.name.lexeme)) {
      _errorReporter.error(
        expr.name.line,
        "Não é possível decrementar constante '${expr.name.lexeme}'.",
      );
      return;
    }

    // Verifica se a variável existe
    if (!_currentScope.assign(expr.name)) {
      _errorReporter.error(
        expr.name.line,
        "Tentativa de decrementar variável '${expr.name.lexeme}' não declarada.",
      );
    }
  }

  @override
  void visitIncrementExpr(IncrementExpr expr) {
    // Verificar se é tentativa de incrementar uma constante
    if (_constants.contains(expr.name.lexeme)) {
      _errorReporter.error(
        expr.name.line,
        "Não é possível incrementar constante '${expr.name.lexeme}'.",
      );
      return;
    }

    // Verifica se a variável existe
    if (!_currentScope.assign(expr.name)) {
      _errorReporter.error(
        expr.name.line,
        "Tentativa de incrementar variável '${expr.name.lexeme}' não declarada.",
      );
    }
  }

  @override
  void visitAssignExpr(AssignExpr expr) {
    // Verificar se é tentativa de atribuição a uma constante
    if (_constants.contains(expr.name.lexeme)) {
      _errorReporter.error(
        expr.name.line,
        "Não é possível atribuir valor à constante '${expr.name.lexeme}'.",
      );
      return;
    }

    // Resolve o valor que está sendo atribuído.
    _resolveExpr(expr.value);
    
    // Verifica se a variável de destino existe.
    if (!_currentScope.assign(expr.name)) {
      _errorReporter.error(
        expr.name.line,
        "Tentativa de atribuir a uma variável '${expr.name.lexeme}' não declarada.",
      );
      return;
    }

    // Verificação de compatibilidade de tipos
    final symbol = _currentScope.get(expr.name);
    if (symbol != null && symbol.type != null) {
      final expectedType = symbol.type!;
      final actualType = _inferExpressionType(expr.value);
      
      if (!_areTypesCompatible(actualType, expectedType)) {
        _errorReporter.error(
          expr.name.line,
          "Tipo incompatível na atribuição. Variável '${expr.name.lexeme}' é do tipo '${_tokenTypeToString(expectedType)}', mas valor é do tipo '${_tokenTypeToString(actualType)}'.",
        );
      }
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
    // Declara a função no escopo atual com o tipo de retorno
    _declare(stmt.name);
    if (stmt.returnType != null) {
      _currentScope.defineFunction(stmt.name, stmt.returnType!.type.type);
    }
    _define(stmt.name);

    // Salva o tipo de retorno atual e define o novo
    final previousReturnType = _currentFunctionReturnType;
    _currentFunctionReturnType = stmt.returnType;

    // Cria um novo escopo para a função
    _beginScope();

    // Declara os parâmetros no escopo da função
    for (final param in stmt.params) {
      _declare(param.name);
      
      // Verifica se é uma lista para extrair o tipo do elemento
      if (param.type.type.type == TokenType.lista) {
        final elementType = _extractElementTypeFromListParam(param.type.type.lexeme);
        if (elementType != null) {
          _currentScope.defineList(param.name, elementType);
        } else {
          _currentScope.defineTyped(param.name, param.type.type.type);
        }
      } else {
        _currentScope.defineTyped(param.name, param.type.type.type);
      }
      
      // Marca o parâmetro como inicializado (parâmetros sempre são válidos)
      _currentScope.assign(param.name);
    }

    // Resolve o corpo da função
    _resolveStmt(stmt.body);

    // Encerra o escopo da função
    _endScope();

    // Restaura o tipo de retorno anterior
    _currentFunctionReturnType = previousReturnType;
  }

  @override
  void visitReturnStmt(ReturnStmt stmt) {
    // Se há um valor de retorno, resolve a expressão
    if (stmt.value != null) {
      _resolveExpr(stmt.value!);

      // Validar tipo de retorno se estamos em uma função
      if (_currentFunctionReturnType != null) {
        final returnExprType = _inferExpressionType(stmt.value!);
        final expectedType = _currentFunctionReturnType!.type.type;

        if (!_areTypesCompatible(returnExprType, expectedType)) {
          _errorReporter.error(
            stmt.keyword.line,
            "Tipo de retorno incompatível. Esperado '${_tokenTypeToString(expectedType)}', mas encontrado '${_tokenTypeToString(returnExprType)}'.",
          );
        }
      }
    }
  }

  @override
  void visitBreakStmt(BreakStmt stmt) {
    if (_loopNestingLevel == 0 && _switchNestingLevel == 0) {
      _errorReporter.error(
        stmt.keyword.line,
        "Comando 'pare' só pode ser usado dentro de loops ou switches.",
      );
    }
  }

  @override
  void visitContinueStmt(ContinueStmt stmt) {
    if (_loopNestingLevel == 0) {
      _errorReporter.error(
        stmt.keyword.line,
        "Comando 'continuar' só pode ser usado dentro de loops.",
      );
    }
  }

  @override
  void visitSwitchStmt(SwitchStmt stmt) {
    // Analisa a expressão do switch
    stmt.expression.accept(this);
    
    _switchNestingLevel++; // Entrando no switch
    
    bool hasDefault = false;
    final caseValues = <Object?>{}; // Para detectar casos duplicados
    
    // Analisa cada caso
    for (final caseStmt in stmt.cases) {
      if (caseStmt.value == null) {
        // Caso default/contrario
        if (hasDefault) {
          _errorReporter.error(
            caseStmt.keyword.line,
            "Apenas um caso 'contrario' é permitido no switch.",
          );
        }
        hasDefault = true;
      } else {
        // Caso com valor específico
        caseStmt.value!.accept(this);
        
        // Verifica se o valor do caso é uma constante
        if (caseStmt.value is! LiteralExpr) {
          _errorReporter.error(
            caseStmt.keyword.line,
            "Valores de caso devem ser constantes literais.",
          );
        } else {
          final literal = (caseStmt.value as LiteralExpr).value;
          if (caseValues.contains(literal)) {
            _errorReporter.error(
              caseStmt.keyword.line,
              "Caso duplicado: valor já foi usado em outro caso.",
            );
          }
          caseValues.add(literal);
        }
      }
      
      // Analisa os statements do caso
      for (final statement in caseStmt.statements) {
        statement.accept(this);
      }
    }
    
    _switchNestingLevel--; // Saindo do switch
  }

  @override
  void visitImportStmt(ImportStmt stmt) {
    // Validar se a biblioteca existe
    final libraryName = stmt.library.lexeme;
    final validLibraries = ['math', 'string', 'io', 'data'];

    if (!validLibraries.contains(libraryName)) {
      _errorReporter.error(
        stmt.library.line,
        "Biblioteca '$libraryName' não reconhecida. Bibliotecas disponíveis: ${validLibraries.join(', ')}",
      );
      return;
    }

    // Determinar o nome usado (alias ou nome original)
    final usedName = stmt.alias?.lexeme ?? libraryName;

    // Verificar conflitos com variáveis existentes
    final existingSymbol = _currentScope.get(
      Token(
        type: TokenType.identifier,
        lexeme: usedName,
        line: stmt.alias?.line ?? stmt.library.line,
        column: stmt.alias?.column ?? stmt.library.column,
      ),
    );

    if (existingSymbol != null) {
      _errorReporter.error(
        stmt.alias?.line ?? stmt.library.line,
        "O nome '$usedName' conflita com uma variável já declarada.",
      );
      return;
    }

    // Verificar se já foi importado com nome diferente
    if (_importedLibraries.containsKey(usedName)) {
      _errorReporter.error(
        stmt.alias?.line ?? stmt.library.line,
        "O nome '$usedName' já está sendo usado para a biblioteca '${_importedLibraries[usedName]}'.",
      );
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

  // ===== MÉTODOS AUXILIARES PARA VALIDAÇÃO DE TIPOS =====

  /// Infere o tipo de uma expressão
  TokenType _inferExpressionType(Expr expr) {
    if (expr is LiteralExpr) {
      final value = expr.value;
      if (value is int) return TokenType.inteiro;
      if (value is double) return TokenType.real;
      if (value is String) return TokenType.texto;
      if (value is bool) return TokenType.logico;
      return TokenType.real; // fallback
    } else if (expr is BinaryExpr) {
      final leftType = _inferExpressionType(expr.left);
      final rightType = _inferExpressionType(expr.right);

      // Para operações aritméticas
      if (expr.operator.type == TokenType.plus ||
          expr.operator.type == TokenType.minus ||
          expr.operator.type == TokenType.star ||
          expr.operator.type == TokenType.slash) {
        // Se qualquer operando é real, resultado é real
        if (leftType == TokenType.real || rightType == TokenType.real) {
          return TokenType.real;
        }
        // Se ambos são inteiros, resultado é inteiro
        return TokenType.inteiro;
      }

      // Para comparações
      if (expr.operator.type == TokenType.greater ||
          expr.operator.type == TokenType.greaterEqual ||
          expr.operator.type == TokenType.less ||
          expr.operator.type == TokenType.lessEqual ||
          expr.operator.type == TokenType.bangEqual ||
          expr.operator.type == TokenType.equalEqual) {
        return TokenType.logico;
      }

      // Para operadores lógicos (tratados como BinaryExpr pelo parser)
      if (expr.operator.type == TokenType.and ||
          expr.operator.type == TokenType.or) {
        return TokenType.logico;
      }
    } else if (expr is LogicalExpr) {
      // Para operadores lógicos (e, ou)
      return TokenType.logico;
    } else if (expr is UnaryExpr) {
      // Para operadores unários
      if (expr.operator.type == TokenType.bang) {
        return TokenType.logico; // ! sempre retorna lógico
      } else if (expr.operator.type == TokenType.minus) {
        // - retorna o mesmo tipo do operando
        return _inferExpressionType(expr.right);
      } else if (expr.operator.type == TokenType.typeof_) {
        return TokenType.texto; // typeof sempre retorna texto
      }
      return TokenType.real; // fallback para outros unários
    } else if (expr is VariableExpr) {
      // Consulta o tipo da variável na tabela de símbolos
      final symbol = _currentScope.get(expr.name);
      if (symbol != null && symbol.type != null) {
        return symbol.type!;
      }
      // Fallback para real se não encontrar o símbolo
      return TokenType.real;
    } else if (expr is IndexAccessExpr) {
      // Para acesso por índice, retorna o tipo dos elementos da lista
      if (expr.object is VariableExpr) {
        final listSymbol = _currentScope.get((expr.object as VariableExpr).name);
        if (listSymbol != null && listSymbol.elementType != null) {
          return listSymbol.elementType!;
        }
      }
      return TokenType.real; // fallback
    } else if (expr is ListLiteralExpr) {
      // Para literal de lista, infere do primeiro elemento se houver
      if (expr.elements.isNotEmpty) {
        return _inferExpressionType(expr.elements.first);
      }
      return TokenType.real; // fallback para lista vazia
    } else if (expr is MethodCallExpr) {
      // Para chamadas de método, infere baseado no método específico
      final methodName = expr.name.lexeme;
      switch (methodName) {
        case 'tamanho':
          return TokenType.inteiro; // tamanho() retorna inteiro
        case 'adicionar':
          return TokenType.nil; // adicionar() não retorna valor
        case 'remover':
          // remover() retorna o tipo dos elementos da lista
          if (expr.object is VariableExpr) {
            final listSymbol = _currentScope.get((expr.object as VariableExpr).name);
            if (listSymbol != null && listSymbol.elementType != null) {
              return listSymbol.elementType!;
            }
          }
          return TokenType.real; // fallback
        case 'vazio':
          return TokenType.logico; // vazio() retorna booleano
        default:
          return TokenType.real; // fallback para métodos desconhecidos
      }
    } else if (expr is CallExpr) {
      // Para chamadas de função, tenta obter o tipo de retorno da função
      if (expr.callee is VariableExpr) {
        final functionName = (expr.callee as VariableExpr).name.lexeme;
        
        // Primeiro verifica se é uma função nativa da biblioteca padrão
        final nativeReturnType = _getNativeFunctionReturnType(functionName);
        if (nativeReturnType != null) {
          return nativeReturnType;
        }
        
        // Se não é nativa, tenta encontrar função definida pelo usuário
        final functionToken = Token(
          type: TokenType.identifier,
          lexeme: functionName,
          line: 0,
          column: 0,
        );
        final functionSymbol = _currentScope.get(functionToken);
        if (functionSymbol != null && functionSymbol.functionReturnType != null) {
          return functionSymbol.functionReturnType!;
        }
      }
      return TokenType.real; // fallback para funções desconhecidas
    } else if (expr is TernaryExpr) {
      // Para operador ternário, infere do tipo dos ramos then/else
      final thenType = _inferExpressionType(expr.thenBranch);
      final elseType = _inferExpressionType(expr.elseBranch);
      
      // Se ambos os ramos têm o mesmo tipo, retorna esse tipo
      if (thenType == elseType) {
        return thenType;
      }
      
      // Se um é inteiro e outro é real, retorna real (widening)
      if ((thenType == TokenType.inteiro && elseType == TokenType.real) ||
          (thenType == TokenType.real && elseType == TokenType.inteiro)) {
        return TokenType.real;
      }
      
      // Para outros casos incompatíveis, retorna o tipo do primeiro ramo
      return thenType;
    } else if (expr is GroupingExpr) {
      // Para expressões agrupadas (parênteses), retorna o tipo da expressão interna
      return _inferExpressionType(expr.expression);
    }

    return TokenType.real; // fallback
  }

  /// Extrai o tipo do elemento de um parâmetro de lista baseado no lexeme
  /// Ex: "lista`<inteiro>`" -> TokenType.inteiro
  TokenType? _extractElementTypeFromListParam(String lexeme) {
    // Verifica se tem o formato lista<tipo>
    final match = RegExp(r'lista<(\w+)>').firstMatch(lexeme);
    if (match != null) {
      final elementTypeName = match.group(1)!;
      switch (elementTypeName) {
        case 'inteiro':
          return TokenType.inteiro;
        case 'real':
          return TokenType.real;
        case 'texto':
          return TokenType.texto;
        case 'logico':
          return TokenType.logico;
        default:
          return null;
      }
    }
    return null;
  }

  /// Verifica se dois tipos são compatíveis
  bool _areTypesCompatible(TokenType actual, TokenType expected) {
    // Tipos exatamente iguais
    if (actual == expected) return true;

    // NOVA REGRA: Inteiro pode ser convertido implicitamente para real
    // (widening conversion - sempre segura)
    if (actual == TokenType.inteiro && expected == TokenType.real) {
      return true;
    }

    // Real NÃO pode ser convertido implicitamente para inteiro
    // (narrowing conversion - deve ser explícita)
    return false;
  }

  /// Converte TokenType para string legível
  String _tokenTypeToString(TokenType type) {
    switch (type) {
      case TokenType.inteiro:
        return 'inteiro';
      case TokenType.real:
        return 'real';
      case TokenType.texto:
        return 'texto';
      case TokenType.logico:
        return 'lógico';
      case TokenType.vazio:
        return 'vazio';
      default:
        return type.toString();
    }
  }

  @override
  void visitListDeclStmt(ListDeclStmt stmt) {
    // Declarar a variável da lista com tipo dos elementos
    _currentScope.defineList(stmt.name, stmt.elementType.type.type);

    // Se há inicializador, resolva a expressão
    if (stmt.initializer != null) {
      _resolveExpr(stmt.initializer!);
    }

    // Definir a variável como inicializada
    _define(stmt.name);
  }

  @override
  void visitListLiteralExpr(ListLiteralExpr expr) {
    // Resolver todos os elementos da lista
    for (final element in expr.elements) {
      _resolveExpr(element);
    }
  }

  @override
  void visitIndexAccessExpr(IndexAccessExpr expr) {
    // Resolver a expressão que representa a lista
    _resolveExpr(expr.object);
    
    // Resolver a expressão do índice
    _resolveExpr(expr.index);
  }

  @override
  void visitIndexAssignExpr(IndexAssignExpr expr) {
    // Resolver a expressão que representa a lista
    _resolveExpr(expr.object);
    
    // Resolver a expressão do índice
    _resolveExpr(expr.index);
    
    // Resolver a expressão do valor a ser atribuído
    _resolveExpr(expr.value);
  }

  @override
  void visitMethodCallExpr(MethodCallExpr expr) {
    // Resolver o objeto sobre o qual o método está sendo chamado
    _resolveExpr(expr.object);
    
    // Resolver todos os argumentos do método
    for (final argument in expr.arguments) {
      _resolveExpr(argument);
    }
    
    final methodName = expr.name.lexeme;
    
    // Verificar se é um método de módulo importado
    if (expr.object is VariableExpr) {
      final objectName = (expr.object as VariableExpr).name.lexeme;
      final libraryName = _importedLibraries[objectName];
      
      if (libraryName != null) {
        // É um método de biblioteca importada
        _validateLibraryMethod(libraryName, methodName, expr.arguments, expr.name.line);
        return;
      }
      
      // Verificar se é uma biblioteca padrão usada sem import (compatibilidade)
      if (['math', 'string', 'io', 'data'].contains(objectName)) {
        _validateLibraryMethod(objectName, methodName, expr.arguments, expr.name.line);
        return;
      }
    }
    
    // Verificar se é um método de lista válido
    if (!['tamanho', 'adicionar', 'remover', 'vazio'].contains(methodName)) {
      _errorReporter.error(expr.name.line, "Método '$methodName' não reconhecido.");
      return;
    }
    
    // Validar número de argumentos para cada método
    switch (methodName) {
      case 'tamanho':
        if (expr.arguments.isNotEmpty) {
          _errorReporter.error(expr.name.line, "Método 'tamanho' não aceita argumentos.");
        }
        break;
      case 'adicionar':
        if (expr.arguments.length != 1) {
          _errorReporter.error(expr.name.line, "Método 'adicionar' requer exatamente um argumento.");
        }
        break;
      case 'remover':
        if (expr.arguments.isNotEmpty) {
          _errorReporter.error(expr.name.line, "Método 'remover' não aceita argumentos.");
        }
        break;
      case 'vazio':
        if (expr.arguments.isNotEmpty) {
          _errorReporter.error(expr.name.line, "Método 'vazio' não aceita argumentos.");
        }
        break;
    }
  }

  /// Valida métodos de bibliotecas importadas
  void _validateLibraryMethod(String libraryName, String methodName, List<Expr> arguments, int line) {
    switch (libraryName) {
      case 'math':
        _validateMathMethod(methodName, arguments, line);
        break;
      case 'string':
        _validateStringMethod(methodName, arguments, line);
        break;
      case 'data':
        _validateDataMethod(methodName, arguments, line);
        break;
      case 'io':
        _validateIoMethod(methodName, arguments, line);
        break;
      default:
        _errorReporter.error(line, "Biblioteca '$libraryName' não suportada.");
    }
  }

  /// Valida métodos da biblioteca math
  void _validateMathMethod(String methodName, List<Expr> arguments, int line) {
    switch (methodName) {
      case 'raiz':
        if (arguments.length != 1) {
          _errorReporter.error(line, "Método 'math.raiz' requer exatamente um argumento.");
        }
        break;
      case 'pi':
        if (arguments.isNotEmpty) {
          _errorReporter.error(line, "Propriedade 'math.pi' não aceita argumentos.");
        }
        break;
      case 'abs':
        if (arguments.length != 1) {
          _errorReporter.error(line, "Método 'math.abs' requer exatamente um argumento.");
        }
        break;
      case 'pow':
        if (arguments.length != 2) {
          _errorReporter.error(line, "Método 'math.pow' requer exatamente dois argumentos.");
        }
        break;
      default:
        _errorReporter.error(line, "Método 'math.$methodName' não reconhecido.");
    }
  }

  /// Valida métodos da biblioteca string
  void _validateStringMethod(String methodName, List<Expr> arguments, int line) {
    switch (methodName) {
      case 'maiuscula':
        if (arguments.length != 1) {
          _errorReporter.error(line, "Método 'string.maiuscula' requer exatamente um argumento.");
        }
        break;
      case 'minuscula':
        if (arguments.length != 1) {
          _errorReporter.error(line, "Método 'string.minuscula' requer exatamente um argumento.");
        }
        break;
      case 'tamanho':
        if (arguments.length != 1) {
          _errorReporter.error(line, "Método 'string.tamanho' requer exatamente um argumento.");
        }
        break;
      default:
        _errorReporter.error(line, "Método 'string.$methodName' não reconhecido.");
    }
  }

  /// Valida métodos da biblioteca data
  void _validateDataMethod(String methodName, List<Expr> arguments, int line) {
    switch (methodName) {
      case 'dataAtual':
        if (arguments.isNotEmpty) {
          _errorReporter.error(line, "Método 'data.dataAtual' não aceita argumentos.");
        }
        break;
      case 'diaSemana':
        if (arguments.length != 1) {
          _errorReporter.error(line, "Método 'data.diaSemana' requer exatamente um argumento.");
        }
        break;
      default:
        _errorReporter.error(line, "Método 'data.$methodName' não reconhecido.");
    }
  }

  /// Valida métodos da biblioteca io
  void _validateIoMethod(String methodName, List<Expr> arguments, int line) {
    switch (methodName) {
      case 'lerTexto':
        if (arguments.isNotEmpty) {
          _errorReporter.error(line, "Método 'io.lerTexto' não aceita argumentos.");
        }
        break;
      case 'lerInteiro':
        if (arguments.isNotEmpty) {
          _errorReporter.error(line, "Método 'io.lerInteiro' não aceita argumentos.");
        }
        break;
      default:
        _errorReporter.error(line, "Método 'io.$methodName' não reconhecido.");
    }
  }

  // Funções auxiliares para declaração e definição de variáveis
  void _declare(Token name) {
    _currentScope.define(name);
  }

  void _define(Token name) {
    _currentScope.assign(name);
  }

  /// Retorna o tipo de retorno de uma função nativa da biblioteca padrão
  TokenType? _getNativeFunctionReturnType(String functionName) {
    switch (functionName) {
      // Funções de conversão existentes
      case 'paraTexto':
        return TokenType.texto;
      
      // Função de tipo existente  
      case 'tipo':
        return TokenType.texto;
      
      // Funções de debug existentes
      case 'debug':
        return TokenType.nil; // não retorna valor
      case 'info_debug':
        return TokenType.nil; // não retorna valor
      
      // Função de impressão (existe através do OpCode.print)
      case 'imprima':
        return TokenType.nil;
        
      // Funções internas de operadores lógicos
      case '__or__':
      case '__and__':
        return TokenType.logico;
        
      // Outras funções nativas podem ser adicionadas aqui conforme implementadas
      default:
        return null; // Função não é nativa conhecida
    }
  }
}
