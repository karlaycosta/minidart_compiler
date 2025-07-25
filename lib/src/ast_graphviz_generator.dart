import 'dart:io';
import 'ast.dart';

/// **Gerador de Visualização AST em Graphviz**
/// 
/// Converte a AST gerada pelo parser em formato DOT do Graphviz
/// para visualização gráfica da árvore sintática.
/// 
/// Uso:
/// ```dart
/// final generator = ASTGraphvizGenerator();
/// final dotCode = generator.generateDot(statements);
/// File('ast.dot').writeAsStringSync(dotCode);
/// ```
/// 
/// Para visualizar:
/// ```bash
/// dot -Tpng ast.dot -o ast.png
/// ```
class ASTGraphvizGenerator implements AstVisitor<String> {
  final StringBuffer _buffer = StringBuffer();
  int _nodeId = 0;

  /// Gera o código DOT completo para a AST
  String generateDot(List<Stmt> statements) {
    _buffer.clear();
    _nodeId = 0;
    
    _buffer.writeln('digraph AST {');
    _buffer.writeln('  rankdir=TB;');
    _buffer.writeln('  node [shape=box, style=filled, fontname="Arial", fontsize=10];');
    _buffer.writeln('  edge [color=darkblue, fontname="Arial", fontsize=8];');
    _buffer.writeln();
    
    // Nó raiz
    final rootId = _nextId();
    _buffer.writeln('  $rootId [label="📄 Programa MiniDart", fillcolor=lightgreen, shape=ellipse];');
    
    // Processar cada statement
    for (final stmt in statements) {
      final stmtId = stmt.accept(this);
      _buffer.writeln('  $rootId -> $stmtId;');
    }
    
    _buffer.writeln('}');
    return _buffer.toString();
  }

  /// Salva a AST em arquivo DOT e gera imagem PNG (se Graphviz estiver instalado)
  void saveAndVisualize(List<Stmt> statements, {String filename = 'ast'}) {
    final dotCode = generateDot(statements);
    
    // Salvar arquivo .dot
    final dotFile = File('$filename.dot');
    dotFile.writeAsStringSync(dotCode);
    print('🌳 AST salva em: ${dotFile.absolute.path}');
    
    // Tentar gerar PNG
    try {
      final result = Process.runSync('dot', ['-Tpng', '$filename.dot', '-o', '$filename.png']);
      if (result.exitCode == 0) {
        print('🖼️  Imagem gerada: $filename.png');
        print('📋 Para visualizar outros formatos:');
        print('   dot -Tsvg $filename.dot -o $filename.svg');
        print('   dot -Tpdf $filename.dot -o $filename.pdf');
      } else {
        print('⚠️  Graphviz não encontrado. Instale para gerar imagens automaticamente.');
        print('   https://graphviz.org/download/');
      }
    } catch (e) {
      print('⚠️  Graphviz não encontrado. Para visualizar:');
      print('   dot -Tpng $filename.dot -o $filename.png');
    }
  }

  String _nextId() => 'node_${_nodeId++}';

  // === IMPLEMENTAÇÃO PARA STATEMENTS ===

  @override
  String visitVarDeclStmt(VarDeclStmt stmt) {
    final nodeId = _nextId();
    final varName = _escapeLabel(stmt.name.lexeme);
    _buffer.writeln('  $nodeId [label="📦 var $varName", fillcolor=yellow];');
    
    if (stmt.initializer != null) {
      final initId = stmt.initializer!.accept(this);
      _buffer.writeln('  $nodeId -> $initId [label="inicializar"];');
    }
    
    return nodeId;
  }

  @override
  String visitTypedVarDeclStmt(TypedVarDeclStmt stmt) {
    final nodeId = _nextId();
    final varName = _escapeLabel(stmt.name.lexeme);
    final typeName = _escapeLabel(stmt.type.name);
    _buffer.writeln('  $nodeId [label="📦 $typeName $varName", fillcolor=lightblue];');
    
    if (stmt.initializer != null) {
      final initId = stmt.initializer!.accept(this);
      _buffer.writeln('  $nodeId -> $initId [label="inicializar"];');
    }
    
    return nodeId;
  }

  @override
  String visitConstDeclStmt(ConstDeclStmt stmt) {
    final nodeId = _nextId();
    final constName = _escapeLabel(stmt.name.lexeme);
    final typeName = _escapeLabel(stmt.type.name);
    _buffer.writeln('  $nodeId [label="🔒 constante $typeName $constName", fillcolor=lightcoral];');
    
    final initId = stmt.initializer.accept(this);
    _buffer.writeln('  $nodeId -> $initId [label="valor"];');
    
    return nodeId;
  }

  @override
  String visitIfStmt(IfStmt stmt) {
    final nodeId = _nextId();
    _buffer.writeln('  $nodeId [label="🔀 se", fillcolor=orange, shape=diamond];');
    
    // Condição
    final condId = stmt.condition.accept(this);
    _buffer.writeln('  $nodeId -> $condId [label="condição"];');
    
    // Then branch
    final thenId = stmt.thenBranch.accept(this);
    _buffer.writeln('  $nodeId -> $thenId [label="então"];');
    
    // Else branch (se existir)
    if (stmt.elseBranch != null) {
      final elseId = stmt.elseBranch!.accept(this);
      _buffer.writeln('  $nodeId -> $elseId [label="senão"];');
    }
    
    return nodeId;
  }

  @override
  String visitWhileStmt(WhileStmt stmt) {
    final nodeId = _nextId();
    _buffer.writeln('  $nodeId [label="🔄 enquanto", fillcolor=orange, shape=diamond];');
    
    // Condição
    final condId = stmt.condition.accept(this);
    _buffer.writeln('  $nodeId -> $condId [label="condição"];');
    
    // Corpo
    final bodyId = stmt.body.accept(this);
    _buffer.writeln('  $nodeId -> $bodyId [label="corpo"];');
    
    return nodeId;
  }

  @override
  String visitDoWhileStmt(DoWhileStmt stmt) {
    final nodeId = _nextId();
    _buffer.writeln('  $nodeId [label="🔄 faca-enquanto", fillcolor=orange, shape=diamond];');
    
    // Corpo (executa primeiro)
    final bodyId = stmt.body.accept(this);
    _buffer.writeln('  $nodeId -> $bodyId [label="corpo"];');
    
    // Condição (verificada depois)
    final condId = stmt.condition.accept(this);
    _buffer.writeln('  $nodeId -> $condId [label="condição"];');
    
    return nodeId;
  }
  
  @override
  String visitForStmt(ForStmt stmt) {
    final nodeId = _nextId();
    _buffer.writeln('  $nodeId [label="🔄 para", fillcolor=orange, shape=diamond];');
    
    // Variável
    _buffer.writeln('  ${nodeId}_var [label="${stmt.variable.lexeme}", fillcolor=lightgreen];');
    _buffer.writeln('  $nodeId -> ${nodeId}_var [label="variável"];');
    
    // Inicializador
    final initId = stmt.initializer.accept(this);
    _buffer.writeln('  $nodeId -> $initId [label="início"];');
    
    // Condição (limite)
    final condId = stmt.condition.accept(this);
    _buffer.writeln('  $nodeId -> $condId [label="até"];');
    
    // Corpo
    final bodyId = stmt.body.accept(this);
    _buffer.writeln('  $nodeId -> $bodyId [label="faça"];');
    
    return nodeId;
  }
  
  @override
  String visitForStepStmt(ForStepStmt stmt) {
    final nodeId = _nextId();
    final direction = stmt.isIncrement ? "incremente" : "decremente";
    _buffer.writeln('  $nodeId [label="🔄 para+$direction", fillcolor=orange, shape=diamond];');
    
    // Variável
    _buffer.writeln('  ${nodeId}_var [label="${stmt.variable.lexeme}", fillcolor=lightgreen];');
    _buffer.writeln('  $nodeId -> ${nodeId}_var [label="variável"];');
    
    // Inicializador
    final initId = stmt.initializer.accept(this);
    _buffer.writeln('  $nodeId -> $initId [label="início"];');
    
    // Condição (limite)
    final condId = stmt.condition.accept(this);
    _buffer.writeln('  $nodeId -> $condId [label="até"];');
    
    // Incremento/Decremento
    final stepId = stmt.step.accept(this);
    _buffer.writeln('  $nodeId -> $stepId [label="$direction"];');
    
    // Corpo
    final bodyId = stmt.body.accept(this);
    _buffer.writeln('  $nodeId -> $bodyId [label="faça"];');
    
    return nodeId;
  }

  @override
  String visitForCStmt(ForCStmt stmt) {
    final nodeId = _nextId();
    _buffer.writeln('  $nodeId [label="🔄 para(;;)", fillcolor=darkturquoise, shape=diamond];');
    
    // Inicializador (se presente)
    if (stmt.initializer != null) {
      final initId = stmt.initializer!.accept(this);
      _buffer.writeln('  $nodeId -> $initId [label="init"];');
    }
    
    // Condição (se presente)
    if (stmt.condition != null) {
      final condId = stmt.condition!.accept(this);
      _buffer.writeln('  $nodeId -> $condId [label="condição"];');
    }
    
    // Incremento (se presente)
    if (stmt.increment != null) {
      final incId = stmt.increment!.accept(this);
      _buffer.writeln('  $nodeId -> $incId [label="incremento"];');
    }
    
    // Corpo
    final bodyId = stmt.body.accept(this);
    _buffer.writeln('  $nodeId -> $bodyId [label="corpo"];');
    
    return nodeId;
  }

  @override
  String visitPrintStmt(PrintStmt stmt) {
    final nodeId = _nextId();
    _buffer.writeln('  $nodeId [label="🖨️ imprimir", fillcolor=pink];');
    
    final exprId = stmt.expression.accept(this);
    _buffer.writeln('  $nodeId -> $exprId [label="valor"];');
    
    return nodeId;
  }

  @override
  String visitBlockStmt(BlockStmt stmt) {
    final nodeId = _nextId();
    _buffer.writeln('  $nodeId [label="📦 { bloco }", fillcolor=lightgray];');
    
    for (int i = 0; i < stmt.statements.length; i++) {
      final stmtId = stmt.statements[i].accept(this);
      _buffer.writeln('  $nodeId -> $stmtId [label="${i + 1}"];');
    }
    
    return nodeId;
  }

  @override
  String visitExpressionStmt(ExpressionStmt stmt) {
    final nodeId = _nextId();
    _buffer.writeln('  $nodeId [label="📝 expressão;", fillcolor=lightcyan];');
    
    final exprId = stmt.expression.accept(this);
    _buffer.writeln('  $nodeId -> $exprId;');
    
    return nodeId;
  }

  // === IMPLEMENTAÇÃO PARA EXPRESSÕES ===

  @override
  String visitBinaryExpr(BinaryExpr expr) {
    final nodeId = _nextId();
    final op = _escapeLabel(expr.operator.lexeme);
    _buffer.writeln('  $nodeId [label="⚙️ $op", fillcolor=lightsteelblue, shape=circle];');
    
    final leftId = expr.left.accept(this);
    final rightId = expr.right.accept(this);
    
    _buffer.writeln('  $nodeId -> $leftId [label="esquerda"];');
    _buffer.writeln('  $nodeId -> $rightId [label="direita"];');
    
    return nodeId;
  }

  @override
  String visitTernaryExpr(TernaryExpr expr) {
    final nodeId = _nextId();
    _buffer.writeln('  $nodeId [label="❓ ?:", fillcolor=lightyellow, shape=diamond];');
    
    final condId = expr.condition.accept(this);
    final thenId = expr.thenBranch.accept(this);
    final elseId = expr.elseBranch.accept(this);
    
    _buffer.writeln('  $nodeId -> $condId [label="condição"];');
    _buffer.writeln('  $nodeId -> $thenId [label="verdadeiro"];');
    _buffer.writeln('  $nodeId -> $elseId [label="falso"];');
    
    return nodeId;
  }

  @override
  String visitLogicalExpr(LogicalExpr expr) {
    final nodeId = _nextId();
    final op = _escapeLabel(expr.operator.lexeme);
    _buffer.writeln('  $nodeId [label="🧠 $op", fillcolor=lightcoral, shape=circle];');
    
    final leftId = expr.left.accept(this);
    final rightId = expr.right.accept(this);
    
    _buffer.writeln('  $nodeId -> $leftId [label="esquerda"];');
    _buffer.writeln('  $nodeId -> $rightId [label="direita"];');
    
    return nodeId;
  }

  @override
  String visitUnaryExpr(UnaryExpr expr) {
    final nodeId = _nextId();
    final op = _escapeLabel(expr.operator.lexeme);
    _buffer.writeln('  $nodeId [label="⚙️ $op", fillcolor=lightsteelblue, shape=circle];');
    
    final rightId = expr.right.accept(this);
    _buffer.writeln('  $nodeId -> $rightId [label="operando"];');
    
    return nodeId;
  }

  @override
  String visitLiteralExpr(LiteralExpr expr) {
    final nodeId = _nextId();
    String value;
    String color;
    
    if (expr.value == null) {
      value = '🚫 nulo';
      color = 'lightgray';
    } else if (expr.value is String) {
      // Para strings, remover aspas da string original e re-escapar adequadamente
      final stringValue = expr.value.toString();
      final escapedString = _escapeLabel(stringValue);
      value = '📝 $escapedString';  // Remover aspas duplas extras
      color = 'lightgreen';
    } else if (expr.value is num) {
      value = '🔢 ${expr.value}';
      color = 'lightblue';
    } else if (expr.value is bool) {
      value = expr.value == true ? '✅ verdadeiro' : '❌ falso';
      color = 'lightyellow';
    } else {
      value = _escapeLabel(expr.value.toString());
      color = 'white';
    }
    
    _buffer.writeln('  $nodeId [label="$value", fillcolor=$color, shape=ellipse];');
    
    return nodeId;
  }

  @override
  String visitVariableExpr(VariableExpr expr) {
    final nodeId = _nextId();
    final name = _escapeLabel(expr.name.lexeme);
    _buffer.writeln('  $nodeId [label="🏷️ $name", fillcolor=wheat, shape=ellipse];');
    
    return nodeId;
  }

  @override
  String visitCompoundAssignExpr(CompoundAssignExpr expr) {
    final nodeId = _nextId();
    final name = _escapeLabel(expr.name.lexeme);
    final op = _escapeLabel(expr.operator.lexeme);
    _buffer.writeln('  $nodeId [label="🔧 $name $op", fillcolor=lightblue];');
    
    final valueId = expr.value.accept(this);
    _buffer.writeln('  $nodeId -> $valueId [label="valor"];');
    
    return nodeId;
  }

  @override
  String visitDecrementExpr(DecrementExpr expr) {
    final nodeId = _nextId();
    final name = _escapeLabel(expr.name.lexeme);
    _buffer.writeln('  $nodeId [label="⬇️ $name--", fillcolor=lightpink];');
    
    return nodeId;
  }

  @override
  String visitIncrementExpr(IncrementExpr expr) {
    final nodeId = _nextId();
    final name = _escapeLabel(expr.name.lexeme);
    _buffer.writeln('  $nodeId [label="⬆️ $name++", fillcolor=lightcoral];');
    
    return nodeId;
  }

  @override
  String visitAssignExpr(AssignExpr expr) {
    final nodeId = _nextId();
    final name = _escapeLabel(expr.name.lexeme);
    _buffer.writeln('  $nodeId [label="📝 $name =", fillcolor=lightyellow];');
    
    final valueId = expr.value.accept(this);
    _buffer.writeln('  $nodeId -> $valueId [label="novo valor"];');
    
    return nodeId;
  }

  @override
  String visitGroupingExpr(GroupingExpr expr) {
    final nodeId = _nextId();
    _buffer.writeln('  $nodeId [label="🔘 ( )", fillcolor=lavender, shape=circle];');
    
    final exprId = expr.expression.accept(this);
    _buffer.writeln('  $nodeId -> $exprId [label="agrupado"];');
    
    return nodeId;
  }

  // ===== NOVOS VISITANTES PARA FUNÇÕES =====
  
  @override
  String visitFunctionStmt(FunctionStmt stmt) {
    final nodeId = _nextId();
    final funcName = _escapeLabel(stmt.name.lexeme);
    final returnTypeName = stmt.returnType?.name ?? "vazio";
    _buffer.writeln('  $nodeId [label="🔧 função $funcName\\n($returnTypeName)", fillcolor=lightblue, shape=box];');
    
    // Parâmetros
    if (stmt.params.isNotEmpty) {
      final paramsId = _nextId();
      _buffer.writeln('  ${paramsId} [label="📝 parâmetros", fillcolor=lightgreen];');
      _buffer.writeln('  $nodeId -> $paramsId [label="params"];');
      
      for (int i = 0; i < stmt.params.length; i++) {
        final param = stmt.params[i];
        final paramId = _nextId();
        _buffer.writeln('  $paramId [label="${param.type.name} ${_escapeLabel(param.name.lexeme)}", fillcolor=white];');
        _buffer.writeln('  $paramsId -> $paramId [label="param ${i + 1}"];');
      }
    }
    
    // Corpo da função
    final bodyId = stmt.body.accept(this);
    _buffer.writeln('  $nodeId -> $bodyId [label="corpo"];');
    
    return nodeId;
  }
  
  @override
  String visitReturnStmt(ReturnStmt stmt) {
    final nodeId = _nextId();
    _buffer.writeln('  $nodeId [label="↩️ retornar", fillcolor=orange];');
    
    if (stmt.value != null) {
      final valueId = stmt.value!.accept(this);
      _buffer.writeln('  $nodeId -> $valueId [label="valor"];');
    }
    
    return nodeId;
  }
  
  @override
  String visitImportStmt(ImportStmt stmt) {
    final nodeId = _nextId();
    final escapedLibrary = _escapeLabel(stmt.library.lexeme);
    
    if (stmt.alias != null) {
      final escapedAlias = _escapeLabel(stmt.alias!.lexeme);
      _buffer.writeln('  $nodeId [label="📦 importar\\n$escapedLibrary como $escapedAlias", fillcolor=lightgray];');
    } else {
      _buffer.writeln('  $nodeId [label="📦 importar\\n$escapedLibrary", fillcolor=lightgray];');
    }
    
    return nodeId;
  }
  
  @override
  String visitCallExpr(CallExpr expr) {
    final nodeId = _nextId();
    _buffer.writeln('  $nodeId [label="📞 chamada", fillcolor=lightcyan, shape=ellipse];');
    
    // Função sendo chamada
    final calleeId = expr.callee.accept(this);
    _buffer.writeln('  $nodeId -> $calleeId [label="função"];');
    
    // Argumentos
    if (expr.arguments.isNotEmpty) {
      final argsId = _nextId();
      _buffer.writeln('  ${argsId} [label="📋 argumentos", fillcolor=lightgreen];');
      _buffer.writeln('  $nodeId -> $argsId [label="args"];');
      
      for (int i = 0; i < expr.arguments.length; i++) {
        final argId = expr.arguments[i].accept(this);
        _buffer.writeln('  $argsId -> $argId [label="arg ${i + 1}"];');
      }
    }
    
    return nodeId;
  }

  @override
  String visitMemberAccessExpr(MemberAccessExpr expr) {
    final nodeId = _nextId();
    final escapedProperty = _escapeLabel(expr.property.lexeme);
    _buffer.writeln('  $nodeId [label="🔗 acesso\\n$escapedProperty", fillcolor=lightblue, shape=ellipse];');
    
    // Objeto sendo acessado
    final objectId = expr.object.accept(this);
    _buffer.writeln('  $nodeId -> $objectId [label="objeto"];');
    
    return nodeId;
  }

  // ===== FIM DOS NOVOS VISITANTES =====

  /// Escapa caracteres especiais para o formato DOT
  String _escapeLabel(String label) {
    return label
        .replaceAll('\\', '\\\\')  // Escape backslashes primeiro
        .replaceAll('"', '\\"')    // Escape aspas duplas
        .replaceAll('\n', '\\n')   // Escape quebras de linha
        .replaceAll('\t', '\\t')   // Escape tabs
        .replaceAll('\r', '\\r');  // Escape carriage returns
  }
}
