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
