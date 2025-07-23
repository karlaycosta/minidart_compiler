import 'token.dart';
import 'ast.dart';
import 'error.dart';

// Implementação de um parser de descida recursiva.
class Parser {
  final List<Token> _tokens;
  final ErrorReporter _errorReporter;
  int _current = 0;

  Parser(this._tokens, this._errorReporter);

  List<Stmt> parse() {
    final statements = <Stmt>[];
    while (!_isAtEnd()) {
      statements.add(_declaration());
    }
    return statements;
  }

  // Regras da gramática (do mais alto ao mais baixo nível de precedência)

  Stmt _declaration() {
    try {
      if (_match([TokenType.var_])) return _varDeclaration();
      return _statement();
    } on ParseError {
      _synchronize();
      return ExpressionStmt(LiteralExpr(null)); // Retorna um nó dummy
    }
  }

  Stmt _varDeclaration() {
    final name = _consume(TokenType.identifier, "Esperado nome da variável.");
    Expr? initializer;
    if (_match([TokenType.equal])) {
      initializer = _expression();
    }
    _consume(TokenType.semicolon, "Esperado ';' após a declaração da variável.");
    return VarDeclStmt(name, initializer);
  }

  Stmt _statement() {
    if (_match([TokenType.if_])) return _ifStatement();
    if (_match([TokenType.print_])) return _printStatement();
    if (_match([TokenType.while_])) return _whileStatement();
    if (_match([TokenType.leftBrace])) return BlockStmt(_block());
    return _expressionStatement();
  }
  
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
  
  Stmt _whileStatement() {
    _consume(TokenType.leftParen, "Esperado '(' após 'enquanto'.");
    final condition = _expression();
    _consume(TokenType.rightParen, "Esperado ')' após a condição do 'enquanto'.");
    final body = _statement();
    return WhileStmt(condition, body);
  }

  List<Stmt> _block() {
    final statements = <Stmt>[];
    while (!_check(TokenType.rightBrace) && !_isAtEnd()) {
      statements.add(_declaration());
    }
    _consume(TokenType.rightBrace, "Esperado '}' após o bloco.");
    return statements;
  }

  Stmt _printStatement() {
    final value = _expression();
    _consume(TokenType.semicolon, "Esperado ';' após o valor.");
    return PrintStmt(value);
  }

  Stmt _expressionStatement() {
    final expr = _expression();
    _consume(TokenType.semicolon, "Esperado ';' após a expressão.");
    return ExpressionStmt(expr);
  }

  Expr _expression() {
    return _assignment();
  }
  
  Expr _assignment() {
    final expr = _or();
    if (_match([TokenType.equal])) {
      final equals = _previous();
      final value = _assignment();
      if (expr is VariableExpr) {
        return AssignExpr(expr.name, value);
      }
      _error(equals, "Alvo de atribuição inválido.");
    }
    return expr;
  }
  
  Expr _or() => _binary(next: _and, types: [TokenType.or]);
  Expr _and() => _binary(next: _equality, types: [TokenType.and]);
  Expr _equality() => _binary(next: _comparison, types: [TokenType.bangEqual, TokenType.equalEqual]);
  Expr _comparison() => _binary(next: _term, types: [TokenType.greater, TokenType.greaterEqual, TokenType.less, TokenType.lessEqual]);
  Expr _term() => _binary(next: _factor, types: [TokenType.minus, TokenType.plus]);
  Expr _factor() => _binary(next: _unary, types: [TokenType.slash, TokenType.star]);

  Expr _unary() {
    if (_match([TokenType.bang, TokenType.minus])) {
      final operator = _previous();
      final right = _unary();
      return UnaryExpr(operator, right);
    }
    return _primary();
  }

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

  // Funções de utilidade do Parser
  
  Expr _binary({required Expr Function() next, required List<TokenType> types}) {
    var expr = next();
    while (_match(types)) {
      final operator = _previous();
      final right = next();
      expr = BinaryExpr(expr, operator, right);
    }
    return expr;
  }

  bool _match(List<TokenType> types) {
    for (final type in types) {
      if (_check(type)) {
        _advance();
        return true;
      }
    }
    return false;
  }

  Token _consume(TokenType type, String message) {
    if (_check(type)) return _advance();
    throw _error(_peek(), message);
  }

  bool _check(TokenType type) => !_isAtEnd() && _peek().type == type;
  
  Token _advance() {
    if (!_isAtEnd()) _current++;
    return _previous();
  }

  bool _isAtEnd() => _peek().type == TokenType.eof;
  Token _peek() => _tokens[_current];
  Token _previous() => _tokens[_current - 1];

  ParseError _error(Token token, String message) {
    _errorReporter.error(token.line, message);
    return ParseError();
  }
  
  // Sincroniza o parser após um erro para tentar continuar.
  void _synchronize() {
    _advance();
    while (!_isAtEnd()) {
      if (_previous().type == TokenType.semicolon) return;
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
}

class ParseError extends Error {}
