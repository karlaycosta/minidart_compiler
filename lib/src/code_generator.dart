import 'ast.dart';
import 'bytecode.dart';
import 'token.dart';

/// Contexto de loop para rastrear breaks e continues
class LoopContext {
  /// Posição onde o loop inicia (para continue)
  final int loopStart;
  
  /// Lista de endereços de jump para break (patchados no final do loop)
  final List<int> breakJumps = [];
  
  /// Lista de endereços de jump para continue (patchados no início do loop)
  final List<int> continueJumps = [];
  
  LoopContext(this.loopStart);
}

/// Contexto de switch para rastrear breaks
class SwitchContext {
  /// Lista de endereços de jump para break (patchados no final do switch)
  final List<int> breakJumps = [];
}

<<<<<<< HEAD
=======
/// Representa uma variável local
class Local {
  final String name;
  final int depth;
  
  Local(this.name, this.depth);
}

/// Contexto de função para rastreamento de escopo
class FunctionContext {
  final String name;
  final List<Local> locals = [];
  int scopeDepth = 0;
  
  FunctionContext(this.name);
}

>>>>>>> origin/dev
/// O CodeGenerator percorre a AST (validada semanticamente)
/// e a traduz para um BytecodeChunk executável.
class CodeGenerator implements AstVisitor<void> {
  final BytecodeChunk _chunk = BytecodeChunk();
  final Map<String, CompiledFunction> _functions = {};

  // Mapa para rastrear aliases de bibliotecas importadas
  // Chave: nome usado no código (alias ou nome original)
  // Valor: nome da biblioteca original
  final Map<String, String> _libraryAliases = <String, String>{};

  // Pilha para rastrear contexto de loops (para break/continue)
  final List<LoopContext> _loopStack = [];
  
  // Pilha para rastrear contexto de switches (para break)
  final List<SwitchContext> _switchStack = [];

<<<<<<< HEAD
=======
  // Contexto de função atual para variáveis locais
  FunctionContext? _currentFunction;

>>>>>>> origin/dev
  // Tipo de retorno da função atual (para conversões implícitas)
  TokenType? _currentFunctionReturnType;

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

<<<<<<< HEAD
=======
  // --- Métodos para gerenciamento de variáveis locais ---

  /// Inicia um novo escopo local
  void _beginScope() {
    _currentFunction?.scopeDepth++;
  }

  /// Termina o escopo local atual
  void _endScope() {
    if (_currentFunction != null) {
      _currentFunction!.scopeDepth--;
      
      // Remove variáveis locais que saíram de escopo
      while (_currentFunction!.locals.isNotEmpty && 
             _currentFunction!.locals.last.depth > _currentFunction!.scopeDepth) {
        _currentFunction!.locals.removeLast();
        _chunk.write(OpCode.pop, -1); // Remove da pilha
      }
    }
  }

  /// Adiciona uma variável local
  void _addLocal(String name) {
    if (_currentFunction != null) {
      _currentFunction!.locals.add(Local(name, _currentFunction!.scopeDepth));
    }
  }

  /// Resolve uma variável (local ou global)
  int? _resolveLocal(String name) {
    if (_currentFunction != null) {
      // Procura de trás para frente (variáveis mais recentes primeiro)
      for (int i = _currentFunction!.locals.length - 1; i >= 0; i--) {
        if (_currentFunction!.locals[i].name == name) {
          return i; // Retorna o slot da variável local
        }
      }
    }
    return null; // Não é uma variável local
  }

  /// Verifica se estamos dentro de uma função
  bool get _isInFunction => _currentFunction != null;

>>>>>>> origin/dev
  // --- Visitantes para Statements ---

  @override
  void visitBlockStmt(BlockStmt stmt) {
<<<<<<< HEAD
    for (final statement in stmt.statements) {
      _generateStmt(statement);
    }
=======
    _beginScope();
    for (final statement in stmt.statements) {
      _generateStmt(statement);
    }
    _endScope();
>>>>>>> origin/dev
  }

  @override
  void visitExpressionStmt(ExpressionStmt stmt) {
    _generateExpr(stmt.expression);
    _chunk.write(OpCode.pop, -1); // Descarta o resultado da expressão
  }

  Object? _getDefaultValueForType(TypeInfo type) {
    switch (type.name) {
      case 'inteiro':
        return 0;
      case 'real':
        return 0.0;
      case 'texto':
        return '';
      case 'logico':
        return false;
      case 'vazio':
        return null;
      default:
        return null;
    }
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
<<<<<<< HEAD
    final globalIndex = _chunk.addConstant(stmt.name.lexeme);
    _chunk.write(OpCode.defineGlobal, stmt.name.line, globalIndex);
=======
    
    if (_isInFunction) {
      // Variável local - apenas adiciona à lista de locais
      _addLocal(stmt.name.lexeme);
    } else {
      // Variável global
      final globalIndex = _chunk.addConstant(stmt.name.lexeme);
      _chunk.write(OpCode.defineGlobal, stmt.name.line, globalIndex);
    }
>>>>>>> origin/dev
  }

  @override
  void visitTypedVarDeclStmt(TypedVarDeclStmt stmt) {
    if (stmt.initializer != null) {
      _generateExpr(stmt.initializer!);

      // Conversões de tipo baseadas na declaração da variável
      if (stmt.type.type.type == TokenType.inteiro) {
        // Se é uma variável tipada de tipo inteiro e o valor é numérico, converter para int
        _chunk.write(OpCode.toInt, stmt.name.line);
      } else if (stmt.type.type.type == TokenType.real) {
        // Se é uma variável tipada de tipo real, converter para double (conversão implícita inteiro→real)
        _chunk.write(OpCode.toDouble, stmt.name.line);
      }
    } else {
      // Valor padrão baseado no tipo
      final defaultValue = _getDefaultValueForType(stmt.type);
      _emitConstant(defaultValue, stmt.name.line);
    }
<<<<<<< HEAD
    final globalIndex = _chunk.addConstant(stmt.name.lexeme);
    _chunk.write(OpCode.defineGlobal, stmt.name.line, globalIndex);
=======
    
    if (_isInFunction) {
      // Variável local - apenas adiciona à lista de locais
      _addLocal(stmt.name.lexeme);
    } else {
      // Variável global
      final globalIndex = _chunk.addConstant(stmt.name.lexeme);
      _chunk.write(OpCode.defineGlobal, stmt.name.line, globalIndex);
    }
>>>>>>> origin/dev
  }

  @override
  void visitConstDeclStmt(ConstDeclStmt stmt) {
    // Constantes sempre têm um inicializador
    _generateExpr(stmt.initializer);

    // Se é uma constante de tipo inteiro e o valor é numérico, converter para int
    if (stmt.type.type.type == TokenType.inteiro) {
      // Emitir bytecode para converter para inteiro se necessário
      _chunk.write(OpCode.toInt, stmt.name.line);
    }

    final globalIndex = _chunk.addConstant(stmt.name.lexeme);
    _chunk.write(OpCode.defineGlobal, stmt.name.line, globalIndex);
  }

  @override
  void visitWhileStmt(WhileStmt stmt) {
    final loopStart = _chunk.code.length;
    final loopContext = LoopContext(loopStart);
    _loopStack.add(loopContext);

    _generateExpr(stmt.condition);

    final exitJump = _emitJump(OpCode.jumpIfFalse);
    _generateStmt(stmt.body);
    _emitLoop(loopStart);

    _patchJump(exitJump);
    
    // Patcha todos os breaks para sair do loop
    for (final breakJump in loopContext.breakJumps) {
      _patchJump(breakJump);
    }
    
    // Patcha todos os continues para voltar ao início do loop
    for (final continueJump in loopContext.continueJumps) {
      final jump = loopStart - continueJump - 1;
      _chunk.code[continueJump] = Instruction(_chunk.code[continueJump].opcode, jump);
    }
    
    _loopStack.removeLast();
  }

  @override
  void visitDoWhileStmt(DoWhileStmt stmt) {
    final loopStart = _chunk.code.length;
    final loopContext = LoopContext(loopStart);
    _loopStack.add(loopContext);

    // Executa o corpo primeiro (sempre executa pelo menos uma vez)
    _generateStmt(stmt.body);

    // Avalia a condição
    _generateExpr(stmt.condition);

    // Se verdadeiro, volta para o início do loop; se falso, sai
    final exitJump = _emitJump(OpCode.jumpIfFalse);
    _emitLoop(loopStart);

    _patchJump(exitJump);
    
    // Patcha todos os breaks para sair do loop
    for (final breakJump in loopContext.breakJumps) {
      _patchJump(breakJump);
    }
    
    // Patcha todos os continues para voltar ao início do loop
    for (final continueJump in loopContext.continueJumps) {
      final jump = loopStart - continueJump - 1;
      _chunk.code[continueJump] = Instruction(_chunk.code[continueJump].opcode, jump);
    }
    
    _loopStack.removeLast();
  }

  @override
  void visitForStmt(ForStmt stmt) {
    // Declara e inicializa a variável do loop
    _generateExpr(stmt.initializer);
    final varIndex = _chunk.addConstant(stmt.variable.lexeme);
    _chunk.write(OpCode.defineGlobal, stmt.variable.line, varIndex);

    // Loop principal - início da verificação da condição
    final loopStart = _chunk.code.length;

    // Carrega variável atual e valor final para comparação (variavel > limite?)
    _chunk.write(OpCode.getGlobal, stmt.variable.line, varIndex);
    _generateExpr(stmt.condition);
    _chunk.write(OpCode.greater, stmt.variable.line);

    // Se variavel > limite, sai do loop
    final exitJump = _emitJump(OpCode.jumpIfFalse);
    final realExitJump = _emitJump(OpCode.jump); // pula para fora

    _patchJump(exitJump); // se variavel <= limite, continua aqui

    // Cria contexto do loop com incrementStart sendo o ponto de incremento
    final loopContext = LoopContext(loopStart);
    _loopStack.add(loopContext);

    // Executa o corpo do loop
    _generateStmt(stmt.body);

    // Ponto onde continue deve pular - incremento da variável
    final incrementStart = _chunk.code.length;
    
    // Patcha todos os continues para o incremento
    for (final continueJump in loopContext.continueJumps) {
      final jump = incrementStart - continueJump - 1;
      _chunk.code[continueJump] = Instruction(_chunk.code[continueJump].opcode, jump);
    }

    // Incrementa a variável: variavel = variavel + 1
    _chunk.write(OpCode.getGlobal, stmt.variable.line, varIndex);
    _emitConstant(1, stmt.variable.line);
    _chunk.write(OpCode.add, stmt.variable.line);
    _chunk.write(OpCode.setGlobal, stmt.variable.line, varIndex);

    // Volta para o início do loop (verificação da condição)
    _emitLoop(loopStart);

    _patchJump(realExitJump);
    
    // Patcha todos os breaks para sair do loop
    for (final breakJump in loopContext.breakJumps) {
      _patchJump(breakJump);
    }
    
    _loopStack.removeLast();
  }

  @override
  void visitForStepStmt(ForStepStmt stmt) {
    // Declara e inicializa a variável do loop
    _generateExpr(stmt.initializer);
    final varIndex = _chunk.addConstant(stmt.variable.lexeme);
    _chunk.write(OpCode.defineGlobal, stmt.variable.line, varIndex);

    // Loop principal
    final loopStart = _chunk.code.length;

    // Carrega variável atual e valor final para comparação
    _chunk.write(OpCode.getGlobal, stmt.variable.line, varIndex);
    _generateExpr(stmt.condition);

    // Usa operador de comparação apropriado baseado na direção
    if (stmt.isIncrement) {
      // Para incremento: variavel > limite? (sai se ultrapassar)
      _chunk.write(OpCode.greater, stmt.variable.line);
    } else {
      // Para decremento: variavel < limite? (sai se ficar abaixo)
      _chunk.write(OpCode.less, stmt.variable.line);
    }

    // Se condição de saída for verdadeira, sai do loop
    final exitJump = _emitJump(OpCode.jumpIfFalse);
    final realExitJump = _emitJump(OpCode.jump); // pula para fora

    _patchJump(exitJump); // se deve continuar, continua aqui

    final loopContext = LoopContext(loopStart);
    _loopStack.add(loopContext);

    // Executa o corpo do loop
    _generateStmt(stmt.body);

    // Ponto onde continue deve pular - incremento da variável
    final incrementStart = _chunk.code.length;
    
    // Patcha todos os continues para o incremento
    for (final continueJump in loopContext.continueJumps) {
      final jump = incrementStart - continueJump - 1;
      _chunk.code[continueJump] = Instruction(_chunk.code[continueJump].opcode, jump);
    }

    // Atualiza a variável: variavel = variavel +/- step
    _chunk.write(OpCode.getGlobal, stmt.variable.line, varIndex);
    _generateExpr(stmt.step);

    // Usa operação apropriada baseada na direção
    if (stmt.isIncrement) {
      _chunk.write(OpCode.add, stmt.variable.line); // incremento
    } else {
      _chunk.write(OpCode.subtract, stmt.variable.line); // decremento
    }

    _chunk.write(OpCode.setGlobal, stmt.variable.line, varIndex);

    // Volta para o início do loop
    _emitLoop(loopStart);

    _patchJump(realExitJump);
    
    // Patcha todos os breaks para sair do loop
    for (final breakJump in loopContext.breakJumps) {
      _patchJump(breakJump);
    }
    
    _loopStack.removeLast();
  }

  @override
  void visitForCStmt(ForCStmt stmt) {
    // Executar inicialização (se presente)
    if (stmt.initializer != null) {
      _generateStmt(stmt.initializer!);
    }

    final loopStart = _chunk.code.length;
    final loopContext = LoopContext(loopStart);
    _loopStack.add(loopContext);

    // Avaliar condição (se presente), senão assume verdadeiro
    int? exitJump;
    if (stmt.condition != null) {
      _generateExpr(stmt.condition!);
      exitJump = _emitJump(OpCode.jumpIfFalse);
    }

    // Executar corpo do loop
    _generateStmt(stmt.body);

    // Ponto onde continue deve pular - incremento (se presente) ou início do loop
    final incrementStart = _chunk.code.length;
    
    // Patcha todos os continues para o incremento
    for (final continueJump in loopContext.continueJumps) {
      final jump = incrementStart - continueJump - 1;
      _chunk.code[continueJump] = Instruction(_chunk.code[continueJump].opcode, jump);
    }

    // Executar incremento (se presente)
    if (stmt.increment != null) {
      _generateExpr(stmt.increment!);
      _chunk.write(OpCode.pop, 0); // remove resultado do incremento da pilha
    }

    // Volta para avaliação da condição
    _emitLoop(loopStart);

    // Sair do loop se condição for falsa
    if (exitJump != null) {
      _patchJump(exitJump);
    }
    
    // Patcha todos os breaks para sair do loop
    for (final breakJump in loopContext.breakJumps) {
      _patchJump(breakJump);
    }
    
    _loopStack.removeLast();
  }

  @override
  void visitSwitchStmt(SwitchStmt stmt) {
    // Cria contexto de switch para rastrear breaks
    final switchContext = SwitchContext();
    _switchStack.add(switchContext);
    
    // Implementação simplificada: transforma switch em cadeia de if-else
    final exitJumps = <int>[];
    
    for (int i = 0; i < stmt.cases.length; i++) {
      final caseStmt = stmt.cases[i];
      
      if (caseStmt.value != null) {
        // Gera: if (expression == value)
        _generateExpr(stmt.expression);
        _generateExpr(caseStmt.value!);
        _chunk.write(OpCode.equal, caseStmt.keyword.line);
        
        // Se não for igual, pula este caso
        final skipJump = _emitJump(OpCode.jumpIfFalse);
        
        // Executa os statements do caso
        for (final statement in caseStmt.statements) {
          _generateStmt(statement);
        }
        
        // Pula para o final do switch (simula break automático)
        final exitJump = _emitJump(OpCode.jump);
        exitJumps.add(exitJump);
        
        // Patcha o jump de skip
        _patchJump(skipJump);
      } else {
        // Caso default - executa incondicionalmente
        for (final statement in caseStmt.statements) {
          _generateStmt(statement);
        }
      }
    }
    
    // Patcha todos os jumps de saída e de break
    for (final exitJump in exitJumps) {
      _patchJump(exitJump);
    }
    
    // Patcha todos os breaks do switch
    for (final breakJump in switchContext.breakJumps) {
      _patchJump(breakJump);
    }
    
    _switchStack.removeLast();
  }

  @override
  void visitBreakStmt(BreakStmt stmt) {
    if (_loopStack.isEmpty && _switchStack.isEmpty) {
      throw Exception('break fora de um loop ou switch');
    }
    
    // Emite um jump incondicional que será patchado no final do loop/switch
    final breakJump = _emitJump(OpCode.jump);
    
    // Adiciona o jump ao contexto apropriado
    if (_switchStack.isNotEmpty) {
      _switchStack.last.breakJumps.add(breakJump);
    } else {
      _loopStack.last.breakJumps.add(breakJump);
    }
  }

  @override
  void visitContinueStmt(ContinueStmt stmt) {
    if (_loopStack.isEmpty) {
      throw Exception('continue fora de um loop');
    }
    
    // Emite um jump incondicional que será patchado apropriadamente
    // Para while/do-while: volta ao início do loop
    // Para for: volta ao incremento
    final continueJump = _emitJump(OpCode.jump);
    _loopStack.last.continueJumps.add(continueJump);
  }

  // --- Visitantes para Expressions ---

  @override
  void visitCompoundAssignExpr(CompoundAssignExpr expr) {
    // Para x += y, equivale a x = x + y
    final globalIndex = _chunk.addConstant(expr.name.lexeme);

    // Carrega valor atual da variável (lado esquerdo)
    _chunk.write(OpCode.getGlobal, expr.name.line, globalIndex);

    // Calcula valor do lado direito
    _generateExpr(expr.value);

    // Aplica operação
    final location = SourceLocation(expr.operator.line, expr.operator.column);
    switch (expr.operator.type) {
      case TokenType.plusEqual:
        _chunk.writeWithLocation(OpCode.add, location);
        break;
      case TokenType.minusEqual:
        _chunk.writeWithLocation(OpCode.subtract, location);
        break;
      case TokenType.starEqual:
        _chunk.writeWithLocation(OpCode.multiply, location);
        break;
      case TokenType.slashEqual:
        _chunk.writeWithLocation(OpCode.divide, location);
        break;
      case TokenType.percentEqual:
        _chunk.writeWithLocation(OpCode.modulo, location);
        break;
      default:
        break;
    }

    // Armazena resultado de volta na variável
    _chunk.write(OpCode.setGlobal, expr.name.line, globalIndex);
  }

  @override
  void visitDecrementExpr(DecrementExpr expr) {
<<<<<<< HEAD
    final globalIndex = _chunk.addConstant(expr.name.lexeme);

    if (expr.isPrefix) {
      // Decremento pré-fixo (--i): decrementa primeiro, depois retorna o novo valor
      _chunk.write(OpCode.getGlobal, expr.name.line, globalIndex);
      _emitConstant(1, expr.name.line);
      _chunk.write(OpCode.subtract, expr.name.line);

      // Armazena o novo valor na variável e carrega novamente para retornar
      _chunk.write(OpCode.setGlobal, expr.name.line, globalIndex);
      _chunk.write(OpCode.getGlobal, expr.name.line, globalIndex);
    } else {
      // Decremento pós-fixo (i--): retorna valor original, depois decrementa
      // Carrega o valor atual da variável (este será o valor retornado)
      _chunk.write(OpCode.getGlobal, expr.name.line, globalIndex);

      // Carrega o valor novamente para calcular o decremento
      _chunk.write(OpCode.getGlobal, expr.name.line, globalIndex);
      _emitConstant(1, expr.name.line);
      _chunk.write(OpCode.subtract, expr.name.line);

      // Armazena o novo valor na variável (o valor original ainda está na pilha)
      _chunk.write(OpCode.setGlobal, expr.name.line, globalIndex);

      // Remove o valor decrementado da pilha, deixando apenas o valor original
      _chunk.write(OpCode.pop, expr.name.line);
=======
    final localSlot = _resolveLocal(expr.name.lexeme);

    if (expr.isPrefix) {
      // Decremento pré-fixo (--i): decrementa primeiro, depois retorna o novo valor
      if (localSlot != null) {
        // Variável local
        _chunk.write(OpCode.getLocal, expr.name.line, localSlot);
        _emitConstant(1, expr.name.line);
        _chunk.write(OpCode.subtract, expr.name.line);
        _chunk.write(OpCode.setLocal, expr.name.line, localSlot);
        _chunk.write(OpCode.getLocal, expr.name.line, localSlot);
      } else {
        // Variável global
        final globalIndex = _chunk.addConstant(expr.name.lexeme);
        _chunk.write(OpCode.getGlobal, expr.name.line, globalIndex);
        _emitConstant(1, expr.name.line);
        _chunk.write(OpCode.subtract, expr.name.line);
        _chunk.write(OpCode.setGlobal, expr.name.line, globalIndex);
        _chunk.write(OpCode.getGlobal, expr.name.line, globalIndex);
      }
    } else {
      // Decremento pós-fixo (i--): retorna valor original, depois decrementa
      if (localSlot != null) {
        // Variável local
        _chunk.write(OpCode.getLocal, expr.name.line, localSlot);
        _chunk.write(OpCode.getLocal, expr.name.line, localSlot);
        _emitConstant(1, expr.name.line);
        _chunk.write(OpCode.subtract, expr.name.line);
        _chunk.write(OpCode.setLocal, expr.name.line, localSlot);
      } else {
        // Variável global
        final globalIndex = _chunk.addConstant(expr.name.lexeme);
        _chunk.write(OpCode.getGlobal, expr.name.line, globalIndex);
        _chunk.write(OpCode.getGlobal, expr.name.line, globalIndex);
        _emitConstant(1, expr.name.line);
        _chunk.write(OpCode.subtract, expr.name.line);
        _chunk.write(OpCode.setGlobal, expr.name.line, globalIndex);
        _chunk.write(OpCode.pop, expr.name.line);
      }
>>>>>>> origin/dev
    }
  }

  @override
  void visitIncrementExpr(IncrementExpr expr) {
<<<<<<< HEAD
    final globalIndex = _chunk.addConstant(expr.name.lexeme);

    if (expr.isPrefix) {
      // Incremento pré-fixo (++i): incrementa primeiro, depois retorna o novo valor
      _chunk.write(OpCode.getGlobal, expr.name.line, globalIndex);
      _emitConstant(1, expr.name.line);
      _chunk.write(OpCode.add, expr.name.line);

      // Armazena o novo valor na variável e carrega novamente para retornar
      _chunk.write(OpCode.setGlobal, expr.name.line, globalIndex);
      _chunk.write(OpCode.getGlobal, expr.name.line, globalIndex);
    } else {
      // Incremento pós-fixo (i++): retorna valor original, depois incrementa
      // Carrega o valor atual da variável (este será o valor retornado)
      _chunk.write(OpCode.getGlobal, expr.name.line, globalIndex);

      // Carrega o valor novamente para calcular o incremento
      _chunk.write(OpCode.getGlobal, expr.name.line, globalIndex);
      _emitConstant(1, expr.name.line);
      _chunk.write(OpCode.add, expr.name.line);

      // Armazena o novo valor na variável (o valor original ainda está na pilha)
      _chunk.write(OpCode.setGlobal, expr.name.line, globalIndex);

      // Remove o valor incrementado da pilha, deixando apenas o valor original
      _chunk.write(OpCode.pop, expr.name.line);
=======
    final localSlot = _resolveLocal(expr.name.lexeme);

    if (expr.isPrefix) {
      // Incremento pré-fixo (++i): incrementa primeiro, depois retorna o novo valor
      if (localSlot != null) {
        // Variável local
        _chunk.write(OpCode.getLocal, expr.name.line, localSlot);
        _emitConstant(1, expr.name.line);
        _chunk.write(OpCode.add, expr.name.line);
        _chunk.write(OpCode.setLocal, expr.name.line, localSlot);
        _chunk.write(OpCode.getLocal, expr.name.line, localSlot);
      } else {
        // Variável global
        final globalIndex = _chunk.addConstant(expr.name.lexeme);
        _chunk.write(OpCode.getGlobal, expr.name.line, globalIndex);
        _emitConstant(1, expr.name.line);
        _chunk.write(OpCode.add, expr.name.line);
        _chunk.write(OpCode.setGlobal, expr.name.line, globalIndex);
        _chunk.write(OpCode.getGlobal, expr.name.line, globalIndex);
      }
    } else {
      // Incremento pós-fixo (i++): retorna valor original, depois incrementa
      if (localSlot != null) {
        // Variável local
        _chunk.write(OpCode.getLocal, expr.name.line, localSlot);
        _chunk.write(OpCode.getLocal, expr.name.line, localSlot);
        _emitConstant(1, expr.name.line);
        _chunk.write(OpCode.add, expr.name.line);
        _chunk.write(OpCode.setLocal, expr.name.line, localSlot);
      } else {
        // Variável global
        final globalIndex = _chunk.addConstant(expr.name.lexeme);
        _chunk.write(OpCode.getGlobal, expr.name.line, globalIndex);
        _chunk.write(OpCode.getGlobal, expr.name.line, globalIndex);
        _emitConstant(1, expr.name.line);
        _chunk.write(OpCode.add, expr.name.line);
        _chunk.write(OpCode.setGlobal, expr.name.line, globalIndex);
      }
>>>>>>> origin/dev
    }
  }

  @override
  void visitAssignExpr(AssignExpr expr) {
    _generateExpr(expr.value);
<<<<<<< HEAD
    final globalIndex = _chunk.addConstant(expr.name.lexeme);
    _chunk.write(OpCode.setGlobal, expr.name.line, globalIndex);
=======
    
    final localSlot = _resolveLocal(expr.name.lexeme);
    if (localSlot != null) {
      // Variável local
      _chunk.write(OpCode.setLocal, expr.name.line, localSlot);
    } else {
      // Variável global
      final globalIndex = _chunk.addConstant(expr.name.lexeme);
      _chunk.write(OpCode.setGlobal, expr.name.line, globalIndex);
    }
>>>>>>> origin/dev
  }

  @override
  void visitBinaryExpr(BinaryExpr expr) {
    _generateExpr(expr.left);
    _generateExpr(expr.right);
    final location = SourceLocation(expr.operator.line, expr.operator.column);
    switch (expr.operator.type) {
      case TokenType.plus:
        _chunk.writeWithLocation(OpCode.add, location);
        break;
      case TokenType.minus:
        _chunk.writeWithLocation(OpCode.subtract, location);
        break;
      case TokenType.star:
        _chunk.writeWithLocation(OpCode.multiply, location);
        break;
      case TokenType.slash:
        _chunk.writeWithLocation(OpCode.divide, location);
        break;
      case TokenType.percent:
        _chunk.writeWithLocation(OpCode.modulo, location);
        break;
      case TokenType.equalEqual:
        _chunk.writeWithLocation(OpCode.equal, location);
        break;
      case TokenType.bangEqual:
        _chunk.writeWithLocation(OpCode.equal, location);
        _chunk.writeWithLocation(OpCode.not, location);
        break;
      case TokenType.greater:
        _chunk.writeWithLocation(OpCode.greater, location);
        break;
      case TokenType.greaterEqual:
        _chunk.writeWithLocation(OpCode.less, location);
        _chunk.writeWithLocation(OpCode.not, location);
        break;
      case TokenType.less:
        _chunk.writeWithLocation(OpCode.less, location);
        break;
      case TokenType.lessEqual:
        _chunk.write(OpCode.greater, expr.operator.line);
        _chunk.write(OpCode.not, expr.operator.line);
        break;
      default:
        break; // Inalcançável
    }
  }

  @override
  void visitLogicalExpr(LogicalExpr expr) {
<<<<<<< HEAD
    // Implementação de curto-circuito
    if (expr.operator.type == TokenType.or) {
      _generateExpr(expr.left);
      final elseJump = _emitJump(OpCode.jumpIfFalse);
      final endJump = _emitJump(OpCode.jump);
      _patchJump(elseJump);
      _generateExpr(expr.right);
      _patchJump(endJump);
    } else {
      // and
      _generateExpr(expr.left);
      final endJump = _emitJump(OpCode.jumpIfFalse);
      _generateExpr(expr.right);
      _patchJump(endJump);
=======
    // Implementação simples: avalia ambos operandos
    _generateExpr(expr.left);
    _generateExpr(expr.right);
    
    // Implementa a operação lógica usando instruções básicas
    if (expr.operator.type == TokenType.or) {
      // OR lógico: true se pelo menos um for true
      // Converte para valores booleanos e usa a lógica: A || B = A + B - A*B
      // Mas de forma mais simples: se A é true, resultado é true; senão B
      // Por agora, implementação básica sem short-circuit
      
      // Empilha uma função nativa que implementa OR
      final nameIndex = _chunk.addConstant('__or__');
      _chunk.write(OpCode.getGlobal, expr.operator.line, nameIndex);
      _chunk.write(OpCode.call, expr.operator.line, 2);
    } else {
      // AND lógico  
      final nameIndex = _chunk.addConstant('__and__');
      _chunk.write(OpCode.getGlobal, expr.operator.line, nameIndex);
      _chunk.write(OpCode.call, expr.operator.line, 2);
>>>>>>> origin/dev
    }
  }

  @override
  void visitUnaryExpr(UnaryExpr expr) {
    _generateExpr(expr.right);
    switch (expr.operator.type) {
      case TokenType.minus:
        _chunk.write(OpCode.negate, expr.operator.line);
        break;
      case TokenType.bang:
        _chunk.write(OpCode.not, expr.operator.line);
        break;
      case TokenType.typeof_:
        _chunk.write(OpCode.typeof_, expr.operator.line);
        break;
      default:
        break; // Inalcançável
    }
  }

  @override
  void visitTernaryExpr(TernaryExpr expr) {
    // Gera código para a condição
    _generateExpr(expr.condition);

    // Se falso, pula para o else (jumpIfFalse consome a condição da pilha)
    final elseJump = _emitJump(OpCode.jumpIfFalse);

    // Gera código para o branch verdadeiro
    _generateExpr(expr.thenBranch);

    // Pula o branch falso
    final endJump = _emitJump(OpCode.jump);

    // Patch do salto para o else
    _patchJump(elseJump);

    // Gera código para o branch falso
    _generateExpr(expr.elseBranch);

    // Patch do salto final
    _patchJump(endJump);
  }

  @override
  void visitVariableExpr(VariableExpr expr) {
<<<<<<< HEAD
    final globalIndex = _chunk.addConstant(expr.name.lexeme);
    _chunk.write(OpCode.getGlobal, expr.name.line, globalIndex);
=======
    final localSlot = _resolveLocal(expr.name.lexeme);
    if (localSlot != null) {
      // Variável local
      _chunk.write(OpCode.getLocal, expr.name.line, localSlot);
    } else {
      // Variável global
      final globalIndex = _chunk.addConstant(expr.name.lexeme);
      _chunk.write(OpCode.getGlobal, expr.name.line, globalIndex);
    }
>>>>>>> origin/dev
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
    
    // Define o tipo de retorno para conversões implícitas
    funcGenerator._currentFunctionReturnType = stmt.returnType?.type.type;

<<<<<<< HEAD
=======
    // Configura o contexto de função para variáveis locais
    funcGenerator._currentFunction = FunctionContext(stmt.name.lexeme);
    
    // Adiciona os parâmetros como variáveis locais
    for (final param in stmt.params) {
      funcGenerator._addLocal(param.name.lexeme);
    }

>>>>>>> origin/dev
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
      
      // Aplicar conversão implícita baseada no tipo de retorno da função
      if (_currentFunctionReturnType != null) {
        if (_currentFunctionReturnType == TokenType.inteiro) {
          _chunk.write(OpCode.toInt, stmt.keyword.line);
        } else if (_currentFunctionReturnType == TokenType.real) {
          _chunk.write(OpCode.toDouble, stmt.keyword.line);
        }
      }
    } else {
      // Retorno vazio - coloca nil na pilha
      _emitConstant(null, stmt.keyword.line);
    }
    _chunk.write(OpCode.return_, stmt.keyword.line);
  }

  @override
  void visitImportStmt(ImportStmt stmt) {
    // Registrar o alias/nome no mapeamento
    final usedName = stmt.alias?.lexeme ?? stmt.library.lexeme;
    final libraryName = stmt.library.lexeme;

    _libraryAliases[usedName] = libraryName;

    // Imports não geram bytecode - apenas registram bibliotecas disponíveis
    // As chamadas reais acontecem via MemberAccessExpr
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

  @override
  void visitMemberAccessExpr(MemberAccessExpr expr) {
<<<<<<< HEAD
    // Para acesso a membro (objeto.propriedade), geramos uma string
    // que representa o nome completo da função nativa
=======
    // Para acesso a membro (objeto.propriedade), geramos uma chamada
    // de função nativa sem argumentos
>>>>>>> origin/dev
    if (expr.object is VariableExpr) {
      final objectName = (expr.object as VariableExpr).name.lexeme;
      final propertyName = expr.property.lexeme;

      // Resolver alias para nome real da biblioteca
      final realLibraryName = _libraryAliases[objectName] ?? objectName;
<<<<<<< HEAD
      final fullName = '$realLibraryName.$propertyName';

      // Emite uma constante string com o nome completo
=======
      
      // Se é uma biblioteca conhecida, tratar como chamada de função
      if (['math', 'string', 'data', 'io'].contains(realLibraryName)) {
        final functionName = '$realLibraryName.$propertyName';
        
        // Emitir chamada de função nativa sem argumentos
        final nameIndex = _chunk.addConstant(functionName);
        _chunk.write(OpCode.getGlobal, expr.dot.line, nameIndex);
        _chunk.write(OpCode.call, expr.dot.line, 0); // 0 argumentos
        return;
      }

      // Se não é biblioteca, tratar como acesso normal (futuras extensões)
      final fullName = '$realLibraryName.$propertyName';
>>>>>>> origin/dev
      _emitConstant(fullName, expr.dot.line);
    } else {
      throw Exception(
        'Acesso a membro só é suportado em identificadores simples',
      );
    }
  }

  @override
  void visitListDeclStmt(ListDeclStmt stmt) {
    // Se há inicializador, geramos o código
    if (stmt.initializer != null) {
      _generateExpr(stmt.initializer!);
    } else {
      // Lista vazia - emite uma lista vazia
      _emitConstant([], stmt.name.line);
    }

<<<<<<< HEAD
    // Define a variável global
    final globalIndex = _chunk.addConstant(stmt.name.lexeme);
    _chunk.write(OpCode.defineGlobal, stmt.name.line, globalIndex);
=======
    if (_isInFunction) {
      // Variável local - apenas adiciona à lista de locais
      _addLocal(stmt.name.lexeme);
    } else {
      // Variável global
      final globalIndex = _chunk.addConstant(stmt.name.lexeme);
      _chunk.write(OpCode.defineGlobal, stmt.name.line, globalIndex);
    }
>>>>>>> origin/dev
  }

  @override
  void visitListLiteralExpr(ListLiteralExpr expr) {
    // Gera código para cada elemento
    for (final element in expr.elements) {
      _generateExpr(element);
    }

    // Emite instrução para criar lista com N elementos
    _chunk.write(OpCode.createList, expr.leftBracket.line, expr.elements.length);
  }

  @override
  void visitIndexAccessExpr(IndexAccessExpr expr) {
    // Gera código para a lista
    _generateExpr(expr.object);
    
    // Gera código para o índice
    _generateExpr(expr.index);
    
    // Emite instrução de acesso por índice
    _chunk.write(OpCode.indexAccess, expr.bracket.line);
  }

  @override
  void visitIndexAssignExpr(IndexAssignExpr expr) {
    // Gera código para a lista
    _generateExpr(expr.object);
    
    // Gera código para o índice
    _generateExpr(expr.index);
    
    // Gera código para o valor
    _generateExpr(expr.value);
    
    // Emite instrução de atribuição por índice
    _chunk.write(OpCode.indexAssign, expr.bracket.line);
  }

  @override
  void visitMethodCallExpr(MethodCallExpr expr) {
<<<<<<< HEAD
=======
    final methodName = expr.name.lexeme;
    
    // Verificar se é um método de módulo
    if (expr.object is VariableExpr) {
      final objectName = (expr.object as VariableExpr).name.lexeme;
      final realLibraryName = _libraryAliases[objectName] ?? objectName;
      
      // Se é um método de biblioteca, tratar como chamada de função nativa
      if (['math', 'string', 'data', 'io'].contains(realLibraryName)) {
        final functionName = '$realLibraryName.$methodName';
        
        // Gera código para os argumentos
        for (final argument in expr.arguments) {
          _generateExpr(argument);
        }
        
        // Emitir chamada de função nativa
        final nameIndex = _chunk.addConstant(functionName);
        _chunk.write(OpCode.getGlobal, expr.name.line, nameIndex);
        _chunk.write(OpCode.call, expr.name.line, expr.arguments.length);
        return;
      }
    }
    
    // Se não é método de módulo, tratar como método de lista
>>>>>>> origin/dev
    // Gera código para o objeto
    _generateExpr(expr.object);
    
    // Gera código para os argumentos
    for (final argument in expr.arguments) {
      _generateExpr(argument);
    }
    
    // Determinar qual instrução emitir baseado no método
<<<<<<< HEAD
    final methodName = expr.name.lexeme;
=======
>>>>>>> origin/dev
    switch (methodName) {
      case 'tamanho':
        _chunk.write(OpCode.listSize, expr.name.line);
        break;
      case 'adicionar':
        _chunk.write(OpCode.listAdd, expr.name.line);
        break;
      case 'remover':
        _chunk.write(OpCode.listRemove, expr.name.line);
        break;
      case 'vazio':
        _chunk.write(OpCode.listEmpty, expr.name.line);
        break;
      default:
        throw Exception("Método '$methodName' não implementado na linha ${expr.name.line}.");
    }
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
  @override
  int visitAssignExpr(AssignExpr expr) => expr.name.line;
  @override
  int visitCompoundAssignExpr(CompoundAssignExpr expr) => expr.name.line;
  @override
  int visitIncrementExpr(IncrementExpr expr) => expr.name.line;
  @override
  int visitDecrementExpr(DecrementExpr expr) => expr.name.line;
  @override
  int visitBinaryExpr(BinaryExpr expr) => expr.operator.line;
  @override
  int visitGroupingExpr(GroupingExpr expr) => expr.expression.accept(this);
  @override
  int visitTernaryExpr(TernaryExpr expr) => expr.condition.accept(this);
  @override
  int visitLiteralExpr(LiteralExpr expr) => -1; // Não tem linha específica
  @override
  int visitLogicalExpr(LogicalExpr expr) => expr.operator.line;
  @override
  int visitUnaryExpr(UnaryExpr expr) => expr.operator.line;
  @override
  int visitVariableExpr(VariableExpr expr) => expr.name.line;

  // Statements não são expressões, mas para completar a interface:
  @override
  int visitBlockStmt(BlockStmt stmt) => -1;
  @override
  int visitExpressionStmt(ExpressionStmt stmt) => stmt.expression.accept(this);
  @override
  int visitIfStmt(IfStmt stmt) => -1;
  @override
  int visitPrintStmt(PrintStmt stmt) => stmt.expression.accept(this);
  @override
  int visitVarDeclStmt(VarDeclStmt stmt) => stmt.name.line;
  @override
  int visitTypedVarDeclStmt(TypedVarDeclStmt stmt) => stmt.name.line;
  @override
  int visitConstDeclStmt(ConstDeclStmt stmt) => stmt.name.line;
  @override
  int visitWhileStmt(WhileStmt stmt) => -1;
  @override
  int visitDoWhileStmt(DoWhileStmt stmt) => -1;
  @override
  int visitForStmt(ForStmt stmt) => stmt.variable.line;
  @override
  int visitForCStmt(ForCStmt stmt) => -1; // Pode não ter linha específica
  @override
  int visitForStepStmt(ForStepStmt stmt) => stmt.variable.line;
  @override
  int visitFunctionStmt(FunctionStmt stmt) => stmt.name.line;
  @override
  int visitReturnStmt(ReturnStmt stmt) => stmt.keyword.line;
  @override
  int visitImportStmt(ImportStmt stmt) => stmt.keyword.line;
  @override
  int visitCallExpr(CallExpr expr) => expr.paren.line;
  @override
  int visitMemberAccessExpr(MemberAccessExpr expr) => expr.dot.line;
  @override
  int visitBreakStmt(BreakStmt stmt) => stmt.keyword.line;
  @override
  int visitContinueStmt(ContinueStmt stmt) => stmt.keyword.line;
  @override
  int visitSwitchStmt(SwitchStmt stmt) => stmt.keyword.line;
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

/// Visitor que extrai informações de localização completa (linha e coluna) dos nós da AST
class LocationVisitor implements AstVisitor<SourceLocation> {
  @override
  SourceLocation visitAssignExpr(AssignExpr expr) =>
      SourceLocation(expr.name.line, expr.name.column);
  @override
  SourceLocation visitCompoundAssignExpr(CompoundAssignExpr expr) =>
      SourceLocation(expr.name.line, expr.name.column);
  @override
  SourceLocation visitIncrementExpr(IncrementExpr expr) =>
      SourceLocation(expr.name.line, expr.name.column);
  @override
  SourceLocation visitDecrementExpr(DecrementExpr expr) =>
      SourceLocation(expr.name.line, expr.name.column);
  @override
  SourceLocation visitBinaryExpr(BinaryExpr expr) =>
      SourceLocation(expr.operator.line, expr.operator.column);
  @override
  SourceLocation visitGroupingExpr(GroupingExpr expr) =>
      expr.expression.accept(this);
  @override
  SourceLocation visitTernaryExpr(TernaryExpr expr) =>
      expr.condition.accept(this);
  @override
  SourceLocation visitLiteralExpr(LiteralExpr expr) => SourceLocation(-1, -1); // Não tem localização específica
  @override
  SourceLocation visitLogicalExpr(LogicalExpr expr) =>
      SourceLocation(expr.operator.line, expr.operator.column);
  @override
  SourceLocation visitUnaryExpr(UnaryExpr expr) =>
      SourceLocation(expr.operator.line, expr.operator.column);
  @override
  SourceLocation visitVariableExpr(VariableExpr expr) =>
      SourceLocation(expr.name.line, expr.name.column);

  // Statements não são expressões, mas para completar a interface:
  @override
  SourceLocation visitBlockStmt(BlockStmt stmt) => SourceLocation(-1, -1);
  @override
  SourceLocation visitExpressionStmt(ExpressionStmt stmt) =>
      stmt.expression.accept(this);
  @override
  SourceLocation visitIfStmt(IfStmt stmt) => SourceLocation(-1, -1);
  @override
  SourceLocation visitPrintStmt(PrintStmt stmt) => stmt.expression.accept(this);
  @override
  SourceLocation visitVarDeclStmt(VarDeclStmt stmt) =>
      SourceLocation(stmt.name.line, stmt.name.column);
  @override
  SourceLocation visitTypedVarDeclStmt(TypedVarDeclStmt stmt) =>
      SourceLocation(stmt.name.line, stmt.name.column);
  @override
  SourceLocation visitConstDeclStmt(ConstDeclStmt stmt) =>
      SourceLocation(stmt.name.line, stmt.name.column);
  @override
  SourceLocation visitWhileStmt(WhileStmt stmt) => SourceLocation(-1, -1);
  @override
  SourceLocation visitDoWhileStmt(DoWhileStmt stmt) => SourceLocation(-1, -1);
  @override
  SourceLocation visitForStmt(ForStmt stmt) =>
      SourceLocation(stmt.variable.line, stmt.variable.column);
  @override
  SourceLocation visitForCStmt(ForCStmt stmt) => SourceLocation(-1, -1); // Pode não ter localização específica
  @override
  SourceLocation visitForStepStmt(ForStepStmt stmt) =>
      SourceLocation(stmt.variable.line, stmt.variable.column);
  @override
  SourceLocation visitFunctionStmt(FunctionStmt stmt) =>
      SourceLocation(stmt.name.line, stmt.name.column);
  @override
  SourceLocation visitReturnStmt(ReturnStmt stmt) =>
      SourceLocation(stmt.keyword.line, stmt.keyword.column);
  @override
  SourceLocation visitImportStmt(ImportStmt stmt) =>
      SourceLocation(stmt.keyword.line, stmt.keyword.column);
  @override
  SourceLocation visitCallExpr(CallExpr expr) =>
      SourceLocation(expr.paren.line, expr.paren.column);
  @override
  SourceLocation visitMemberAccessExpr(MemberAccessExpr expr) =>
      SourceLocation(expr.dot.line, expr.dot.column);
  @override
  SourceLocation visitBreakStmt(BreakStmt stmt) =>
      SourceLocation(stmt.keyword.line, stmt.keyword.column);
  @override
  SourceLocation visitContinueStmt(ContinueStmt stmt) =>
      SourceLocation(stmt.keyword.line, stmt.keyword.column);
  @override
  SourceLocation visitSwitchStmt(SwitchStmt stmt) =>
      SourceLocation(stmt.keyword.line, stmt.keyword.column);
  @override
  SourceLocation visitListDeclStmt(ListDeclStmt stmt) =>
      SourceLocation(stmt.name.line, stmt.name.column);
  @override
  SourceLocation visitListLiteralExpr(ListLiteralExpr expr) =>
      SourceLocation(expr.leftBracket.line, expr.leftBracket.column);
  @override
  SourceLocation visitIndexAccessExpr(IndexAccessExpr expr) =>
      SourceLocation(expr.bracket.line, expr.bracket.column);
  @override
  SourceLocation visitIndexAssignExpr(IndexAssignExpr expr) =>
      SourceLocation(expr.bracket.line, expr.bracket.column);
  @override
  SourceLocation visitMethodCallExpr(MethodCallExpr expr) =>
      SourceLocation(expr.dot.line, expr.dot.column);
}
