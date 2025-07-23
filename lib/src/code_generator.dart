import 'ast.dart';
import 'bytecode.dart';
import 'token.dart';

/// O CodeGenerator percorre a AST (validada semanticamente)
/// e a traduz para um BytecodeChunk executável.
class CodeGenerator implements AstVisitor<void> {
  final BytecodeChunk _chunk = BytecodeChunk();

  BytecodeChunk compile(List<Stmt> statements) {
    for (final stmt in statements) {
      _generateStmt(stmt);
    }
    // Adiciona uma instrução de retorno no final do script.
    _chunk.write(OpCode.return_, -1); // Linha -1 indica fim do script
    return _chunk;
  }

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
    switch (expr.operator.type) {
      case TokenType.plus:         _chunk.write(OpCode.add, expr.operator.line); break;
      case TokenType.minus:        _chunk.write(OpCode.subtract, expr.operator.line); break;
      case TokenType.star:         _chunk.write(OpCode.multiply, expr.operator.line); break;
      case TokenType.slash:        _chunk.write(OpCode.divide, expr.operator.line); break;
      case TokenType.equalEqual:   _chunk.write(OpCode.equal, expr.operator.line); break;
      case TokenType.bangEqual:    _chunk.write(OpCode.equal, expr.operator.line); _chunk.write(OpCode.not, expr.operator.line); break;
      case TokenType.greater:      _chunk.write(OpCode.greater, expr.operator.line); break;
      case TokenType.greaterEqual: _chunk.write(OpCode.less, expr.operator.line); _chunk.write(OpCode.not, expr.operator.line); break;
      case TokenType.less:         _chunk.write(OpCode.less, expr.operator.line); break;
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
    final offset = _chunk.code.length - loopStart;
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
}
