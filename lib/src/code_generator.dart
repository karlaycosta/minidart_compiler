import 'ast.dart';
import 'bytecode.dart';
import 'token.dart';

/// O CodeGenerator percorre a AST (validada semanticamente)
/// e a traduz para um BytecodeChunk executável.
class CodeGenerator implements AstVisitor<void> {
  final BytecodeChunk _chunk = BytecodeChunk();
  final Map<String, CompiledFunction> _functions = {};

  BytecodeChunk compile(List<Stmt> statements) {
    for (final stmt in statements) {
      _generateStmt(stmt);
    }
    // Adiciona uma instrução de retorno no final do script.
    _chunk.write(OpCode.return_, -1); // Linha -1 indica fim do script
    return _chunk;
  }

  /// Retorna as funções compiladas
  Map<String, CompiledFunction> get functions => _functions;

  void _generateStmt(Stmt stmt) => stmt.accept(this);
  void _generateExpr(Expr expr) => expr.accept(this);

  // --- Visitantes para Statements ---

  @override
  void visitBlockStmt(BlockStmt stmt) {
    for (final statement in stmt.statements) {
      _generateStmt(statement);
    }
  }

  @override
  void visitExpressionStmt(ExpressionStmt stmt) {
    _generateExpr(stmt.expression);
    _chunk.write(OpCode.pop, -1); // Descarta o resultado da expressão
  }

  @override
  void visitIfStmt(IfStmt stmt) {
    _generateExpr(stmt.condition);

    final thenJump = _emitJump(OpCode.jumpIfFalse);
    _generateStmt(stmt.thenBranch);
    
    final elseJump = _emitJump(OpCode.jump);

    _patchJump(thenJump);
    if (stmt.elseBranch != null) {
      _generateStmt(stmt.elseBranch!);
    }
    _patchJump(elseJump);
  }

  @override
  void visitPrintStmt(PrintStmt stmt) {
    _generateExpr(stmt.expression);
    _chunk.write(OpCode.print, stmt.expression.accept(LineVisitor()));
  }

  @override
  void visitVarDeclStmt(VarDeclStmt stmt) {
    if (stmt.initializer != null) {
      _generateExpr(stmt.initializer!);
    } else {
      _emitConstant(null, stmt.name.line); // Valor padrão nulo
    }
    final globalIndex = _chunk.addConstant(stmt.name.lexeme);
    _chunk.write(OpCode.defineGlobal, stmt.name.line, globalIndex);
  }
  
  @override
  void visitWhileStmt(WhileStmt stmt) {
    final loopStart = _chunk.code.length;
    _generateExpr(stmt.condition);
    
    final exitJump = _emitJump(OpCode.jumpIfFalse);
    _generateStmt(stmt.body);
    _emitLoop(loopStart);

    _patchJump(exitJump);
  }
  
  @override
  void visitForStmt(ForStmt stmt) {
    // Declara e inicializa a variável do loop
    _generateExpr(stmt.initializer);
    final varIndex = _chunk.addConstant(stmt.variable.lexeme);
    _chunk.write(OpCode.defineGlobal, stmt.variable.line, varIndex);
    
    // Loop principal
    final loopStart = _chunk.code.length;
    
    // Carrega variável atual e valor final para comparação (variavel > limite?)
    _chunk.write(OpCode.getGlobal, stmt.variable.line, varIndex);
    _generateExpr(stmt.condition);
    _chunk.write(OpCode.greater, stmt.variable.line);
    
    // Se variavel > limite, sai do loop
    final exitJump = _emitJump(OpCode.jumpIfFalse);
    final realExitJump = _emitJump(OpCode.jump); // pula para fora
    
    _patchJump(exitJump); // se variavel <= limite, continua aqui
    
    // Executa o corpo do loop
    _generateStmt(stmt.body);
    
    // Incrementa a variável: variavel = variavel + 1
    _chunk.write(OpCode.getGlobal, stmt.variable.line, varIndex);
    _emitConstant(1, stmt.variable.line);
    _chunk.write(OpCode.add, stmt.variable.line);
    _chunk.write(OpCode.setGlobal, stmt.variable.line, varIndex);
    
    // Volta para o início do loop
    _emitLoop(loopStart);
    
    _patchJump(realExitJump);
  }
  
  @override
  void visitForStepStmt(ForStepStmt stmt) {
    // Declara e inicializa a variável do loop
    _generateExpr(stmt.initializer);
    final varIndex = _chunk.addConstant(stmt.variable.lexeme);
    _chunk.write(OpCode.defineGlobal, stmt.variable.line, varIndex);
    
    // Loop principal
    final loopStart = _chunk.code.length;
    
    // Carrega variável atual e valor final para comparação (variavel > limite?)
    _chunk.write(OpCode.getGlobal, stmt.variable.line, varIndex);
    _generateExpr(stmt.condition);
    _chunk.write(OpCode.greater, stmt.variable.line);
    
    // Se variavel > limite, sai do loop
    final exitJump = _emitJump(OpCode.jumpIfFalse);
    final realExitJump = _emitJump(OpCode.jump); // pula para fora
    
    _patchJump(exitJump); // se variavel <= limite, continua aqui
    
    // Executa o corpo do loop
    _generateStmt(stmt.body);
    
    // Incrementa a variável: variavel = variavel + step
    _chunk.write(OpCode.getGlobal, stmt.variable.line, varIndex);
    _generateExpr(stmt.step); // usa incremento personalizado
    _chunk.write(OpCode.add, stmt.variable.line);
    _chunk.write(OpCode.setGlobal, stmt.variable.line, varIndex);
    
    // Volta para o início do loop
    _emitLoop(loopStart);
    
    _patchJump(realExitJump);
  }

  // --- Visitantes para Expressions ---

  @override
  void visitAssignExpr(AssignExpr expr) {
    _generateExpr(expr.value);
    final globalIndex = _chunk.addConstant(expr.name.lexeme);
    _chunk.write(OpCode.setGlobal, expr.name.line, globalIndex);
  }

  @override
  void visitBinaryExpr(BinaryExpr expr) {
    _generateExpr(expr.left);
    _generateExpr(expr.right);
    final location = SourceLocation(expr.operator.line, expr.operator.column);
    switch (expr.operator.type) {
      case TokenType.plus:         _chunk.writeWithLocation(OpCode.add, location); break;
      case TokenType.minus:        _chunk.writeWithLocation(OpCode.subtract, location); break;
      case TokenType.star:         _chunk.writeWithLocation(OpCode.multiply, location); break;
      case TokenType.slash:        _chunk.writeWithLocation(OpCode.divide, location); break;
      case TokenType.equalEqual:   _chunk.writeWithLocation(OpCode.equal, location); break;
      case TokenType.bangEqual:    _chunk.writeWithLocation(OpCode.equal, location); _chunk.writeWithLocation(OpCode.not, location); break;
      case TokenType.greater:      _chunk.writeWithLocation(OpCode.greater, location); break;
      case TokenType.greaterEqual: _chunk.writeWithLocation(OpCode.less, location); _chunk.writeWithLocation(OpCode.not, location); break;
      case TokenType.less:         _chunk.writeWithLocation(OpCode.less, location); break;
      case TokenType.lessEqual:    _chunk.write(OpCode.greater, expr.operator.line); _chunk.write(OpCode.not, expr.operator.line); break;
      default: break; // Inalcançável
    }
  }
  
  @override
  void visitLogicalExpr(LogicalExpr expr) {
    // Implementação de curto-circuito
    if (expr.operator.type == TokenType.or) {
      _generateExpr(expr.left);
      final elseJump = _emitJump(OpCode.jumpIfFalse);
      final endJump = _emitJump(OpCode.jump);
      _patchJump(elseJump);
      _generateExpr(expr.right);
      _patchJump(endJump);
    } else { // and
      _generateExpr(expr.left);
      final endJump = _emitJump(OpCode.jumpIfFalse);
      _generateExpr(expr.right);
      _patchJump(endJump);
    }
  }

  @override
  void visitUnaryExpr(UnaryExpr expr) {
    _generateExpr(expr.right);
    switch (expr.operator.type) {
      case TokenType.minus: _chunk.write(OpCode.negate, expr.operator.line); break;
      case TokenType.bang:  _chunk.write(OpCode.not, expr.operator.line); break;
      default: break; // Inalcançável
    }
  }

  @override
  void visitVariableExpr(VariableExpr expr) {
    final globalIndex = _chunk.addConstant(expr.name.lexeme);
    _chunk.write(OpCode.getGlobal, expr.name.line, globalIndex);
  }

  @override
  void visitGroupingExpr(GroupingExpr expr) {
    _generateExpr(expr.expression);
  }

  @override
  void visitLiteralExpr(LiteralExpr expr) {
    _emitConstant(expr.value, -1); // Linha não é relevante para literais puros
  }

  // ===== NOVOS VISITANTES PARA FUNÇÕES =====
  
  @override
  void visitFunctionStmt(FunctionStmt stmt) {
    // Compila o corpo da função em um chunk separado
    final funcGenerator = CodeGenerator();
    
    // Compila o corpo da função
    funcGenerator._generateStmt(stmt.body);
    
    // Se não há retorno explícito, adiciona um retorno com nil
    funcGenerator._emitConstant(null, stmt.name.line);
    funcGenerator._chunk.write(OpCode.return_, stmt.name.line);
    
    // Cria a função compilada
    final compiledFunc = CompiledFunction(
      name: stmt.name.lexeme,
      arity: stmt.params.length,
      chunk: funcGenerator._chunk,
      paramNames: stmt.params.map((p) => p.name.lexeme).toList(),
    );
    
    // Armazena a função compilada
    _functions[stmt.name.lexeme] = compiledFunc;
    
    // Coloca a função compilada na pilha e define como global
    final funcConstant = _chunk.addConstant(compiledFunc);
    _chunk.write(OpCode.pushConst, stmt.name.line, funcConstant);
    final nameConstant = _chunk.addConstant(stmt.name.lexeme);
    _chunk.write(OpCode.defineGlobal, stmt.name.line, nameConstant);
  }
  
  @override
  void visitReturnStmt(ReturnStmt stmt) {
    if (stmt.value != null) {
      _generateExpr(stmt.value!);
    } else {
      // Retorno vazio - coloca nil na pilha
      _emitConstant(null, stmt.keyword.line);
    }
    _chunk.write(OpCode.return_, stmt.keyword.line);
  }
  
  @override
  void visitCallExpr(CallExpr expr) {
    // Gera argumentos na pilha (ordem reversa para facilitar na VM)
    for (final argument in expr.arguments) {
      _generateExpr(argument);
    }
    
    // Gera a expressão que resolve para a função
    _generateExpr(expr.callee);
    
    // Emite instrução de chamada com número de argumentos
    _chunk.write(OpCode.call, expr.paren.line, expr.arguments.length);
  }

  // ===== FIM DOS NOVOS VISITANTES =====

  // --- Funções de Utilidade ---
  void _emitConstant(Object? value, int line) {
    final constIndex = _chunk.addConstant(value);
    _chunk.write(OpCode.pushConst, line, constIndex);
  }
  
  int _emitJump(OpCode opcode) {
    _chunk.write(opcode, -1, 9999); // 9999 é um placeholder
    return _chunk.code.length - 1;
  }

  void _patchJump(int offset) {
    final jump = _chunk.code.length - offset - 1;
    _chunk.code[offset] = Instruction(_chunk.code[offset].opcode, jump);
  }
  
  void _emitLoop(int loopStart) {
    final offset = _chunk.code.length - loopStart + 1;
    _chunk.write(OpCode.loop, -1, offset);
  }
}

/// Um visitor simples para extrair o número da linha de uma expressão.
class LineVisitor implements AstVisitor<int> {
  @override int visitAssignExpr(AssignExpr expr) => expr.name.line;
  @override int visitBinaryExpr(BinaryExpr expr) => expr.operator.line;
  @override int visitGroupingExpr(GroupingExpr expr) => expr.accept(this);
  @override int visitLiteralExpr(LiteralExpr expr) => -1; // Não tem linha específica
  @override int visitLogicalExpr(LogicalExpr expr) => expr.operator.line;
  @override int visitUnaryExpr(UnaryExpr expr) => expr.operator.line;
  @override int visitVariableExpr(VariableExpr expr) => expr.name.line;
  
  // Statements não são expressões, mas para completar a interface:
  @override int visitBlockStmt(BlockStmt stmt) => -1;
  @override int visitExpressionStmt(ExpressionStmt stmt) => stmt.expression.accept(this);
  @override int visitIfStmt(IfStmt stmt) => -1;
  @override int visitPrintStmt(PrintStmt stmt) => stmt.expression.accept(this);
  @override int visitVarDeclStmt(VarDeclStmt stmt) => stmt.name.line;
  @override int visitWhileStmt(WhileStmt stmt) => -1;
  @override int visitForStmt(ForStmt stmt) => stmt.variable.line;
  @override int visitForStepStmt(ForStepStmt stmt) => stmt.variable.line;
  @override int visitFunctionStmt(FunctionStmt stmt) => stmt.name.line;
  @override int visitReturnStmt(ReturnStmt stmt) => stmt.keyword.line;
  @override int visitCallExpr(CallExpr expr) => expr.paren.line;
}

/// Visitor que extrai informações de localização completa (linha e coluna) dos nós da AST
class LocationVisitor implements AstVisitor<SourceLocation> {
  @override SourceLocation visitAssignExpr(AssignExpr expr) => SourceLocation(expr.name.line, expr.name.column);
  @override SourceLocation visitBinaryExpr(BinaryExpr expr) => SourceLocation(expr.operator.line, expr.operator.column);
  @override SourceLocation visitGroupingExpr(GroupingExpr expr) => expr.accept(this);
  @override SourceLocation visitLiteralExpr(LiteralExpr expr) => SourceLocation(-1, -1); // Não tem localização específica
  @override SourceLocation visitLogicalExpr(LogicalExpr expr) => SourceLocation(expr.operator.line, expr.operator.column);
  @override SourceLocation visitUnaryExpr(UnaryExpr expr) => SourceLocation(expr.operator.line, expr.operator.column);
  @override SourceLocation visitVariableExpr(VariableExpr expr) => SourceLocation(expr.name.line, expr.name.column);
  
  // Statements não são expressões, mas para completar a interface:
  @override SourceLocation visitBlockStmt(BlockStmt stmt) => SourceLocation(-1, -1);
  @override SourceLocation visitExpressionStmt(ExpressionStmt stmt) => stmt.expression.accept(this);
  @override SourceLocation visitIfStmt(IfStmt stmt) => SourceLocation(-1, -1);
  @override SourceLocation visitPrintStmt(PrintStmt stmt) => stmt.expression.accept(this);
  @override SourceLocation visitVarDeclStmt(VarDeclStmt stmt) => SourceLocation(stmt.name.line, stmt.name.column);
  @override SourceLocation visitWhileStmt(WhileStmt stmt) => SourceLocation(-1, -1);
  @override SourceLocation visitForStmt(ForStmt stmt) => SourceLocation(stmt.variable.line, stmt.variable.column);
  @override SourceLocation visitForStepStmt(ForStepStmt stmt) => SourceLocation(stmt.variable.line, stmt.variable.column);
  @override SourceLocation visitFunctionStmt(FunctionStmt stmt) => SourceLocation(stmt.name.line, stmt.name.column);
  @override SourceLocation visitReturnStmt(ReturnStmt stmt) => SourceLocation(stmt.keyword.line, stmt.keyword.column);
  @override SourceLocation visitCallExpr(CallExpr expr) => SourceLocation(expr.paren.line, expr.paren.column);
}
