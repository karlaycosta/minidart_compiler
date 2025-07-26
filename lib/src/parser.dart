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
      if (_match([TokenType.constante])) return _constDeclaration();
      
      // Verificar se é uma declaração de função (tipo + identificador + parênteses)
      if (_isTypeToken(_peek()) && 
          _current + 1 < _tokens.length && 
          _peekNext().type == TokenType.identifier && 
          _current + 2 < _tokens.length && 
          _peekNextNext().type == TokenType.leftParen) {
        return _functionDeclaration();
      }
      
      // Verificar se é uma declaração de variável tipada (tipo + identificador + =)
      if (_isTypeToken(_peek()) && 
          _current + 1 < _tokens.length && 
          _peekNext().type == TokenType.identifier) {
        return _typedVarDeclaration();
      }
      
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

  /// **Análise de Declaração de Variável Tipada**
  /// 
  /// Processa declarações como: inteiro a = 10; ou texto nome = "João";
  /// 
  /// **Sintaxe:** tipo identificador [= expressão];
  /// 
  /// **Exemplos:**
  /// - inteiro idade = 25;
  /// - real altura = 1.75;
  /// - texto nome = "Maria";
  /// - logico ativo = verdadeiro;
  /// - inteiro contador; // sem inicialização
  Stmt _typedVarDeclaration() {
    // Consumir o tipo
    final typeToken = _advance();
    final type = TypeInfo(typeToken);
    
    // Consumir o nome da variável
    final name = _consume(TokenType.identifier, "Esperado nome da variável após tipo.");
    
    // Verificar se há inicialização
    Expr? initializer;
    if (_match([TokenType.equal])) {
      initializer = _expression();
    }
    
    _consume(TokenType.semicolon, "Esperado ';' após a declaração da variável tipada.");
    return TypedVarDeclStmt(type, name, initializer);
  }

  /// **Parsing de Declaração de Constante**
  /// 
  /// Reconhece e analisa declarações de constantes com tipo explícito.
  /// Sintaxe: constante <tipo> <nome> = <valor>;
  /// 
  /// **Exemplos:**
  /// - constante inteiro MAXIMO = 100;
  /// - constante texto VERSAO = "v1.5.0";
  /// - constante real PI = 3.14159;
  /// - constante logico DEBUG = verdadeiro;
  Stmt _constDeclaration() {
    TypeInfo? type;
    
    // Verificar se é declaração tipada (constante tipo nome) ou inferência (constante var nome)
    if (_isTypeToken(_peek())) {
      // Declaração tipada: constante inteiro nome = valor;
      final typeToken = _advance();
      type = TypeInfo(typeToken);
    } else if (_check(TokenType.var_)) {
      // Declaração com inferência: constante var nome = valor;
      _advance(); // consumir 'var'
      type = null; // será inferido do initializer
    } else {
      throw _error(_peek(), "Esperado tipo ou 'var' após 'constante'.");
    }
    
    // Consumir o nome da constante
    final name = _consume(TokenType.identifier, "Esperado nome da constante.");
    
    // Inicialização é obrigatória para constantes
    _consume(TokenType.equal, "Constantes devem ser inicializadas. Esperado '='.");
    final initializer = _expression();
    
    // Se tipo não foi especificado, inferir do valor inicial
    type ??= _inferTypeFromExpression(initializer);
    
    _consume(TokenType.semicolon, "Esperado ';' após a declaração da constante.");
    return ConstDeclStmt(type, name, initializer);
  }

  Stmt _statement() {
    if (_match([TokenType.import_])) return _importStatement();
    if (_match([TokenType.if_])) return _ifStatement();
    if (_match([TokenType.print_])) return _printStatement();
    if (_match([TokenType.while_])) return _whileStatement();
    if (_match([TokenType.do_])) return _doWhileStatement();
    if (_match([TokenType.for_])) {
      // Verifica se é loop estilo C (com parênteses) ou tradicional
      if (_check(TokenType.leftParen)) {
        return _forCStatement();
      } else {
        return _forStatement();
      }
    }
    if (_match([TokenType.return_])) return _returnStatement();
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
  
  Stmt _importStatement() {
    final keyword = _previous(); // Token 'importar'
    
    // Nome da biblioteca a ser importada
    final library = _consume(TokenType.identifier, "Esperado nome da biblioteca após 'importar'.");
    
    // Verificar se há alias (palavra 'como')
    Token? alias;
    if (_match([TokenType.as_])) {
      alias = _consume(TokenType.identifier, "Esperado nome do alias após 'como'.");
    }
    
    _consume(TokenType.semicolon, "Esperado ';' após declaração de import.");
    return ImportStmt(keyword, library, alias);
  }
  
  Stmt _whileStatement() {
    _consume(TokenType.leftParen, "Esperado '(' após 'enquanto'.");
    final condition = _expression();
    _consume(TokenType.rightParen, "Esperado ')' após a condição do 'enquanto'.");
    final body = _statement();
    return WhileStmt(condition, body);
  }
  
  Stmt _doWhileStatement() {
    final body = _statement();
    _consume(TokenType.while_, "Esperado 'enquanto' após o corpo do loop 'faca'.");
    _consume(TokenType.leftParen, "Esperado '(' após 'enquanto'.");
    final condition = _expression();
    _consume(TokenType.rightParen, "Esperado ')' após a condição do 'enquanto'.");
    _consume(TokenType.semicolon, "Esperado ';' após o loop 'faca...enquanto'.");
    return DoWhileStmt(body, condition);
  }
  
  Stmt _forStatement() {
    // Verificar se é for estilo C: para (init; condition; increment)
    if (_check(TokenType.leftParen)) {
      return _forCStatement();
    }
    
    // para variavel = inicio ate fim [incremente/decremente valor] faca statement
    final variable = _consume(TokenType.identifier, "Esperado nome da variável após 'para'.");
    _consume(TokenType.equal, "Esperado '=' após o nome da variável.");
    final initializer = _expression();
    _consume(TokenType.to_, "Esperado 'ate' após o valor inicial.");
    final condition = _expression();
    
    // Verifica se há incremento/decremento personalizado
    if (_match([TokenType.increment_])) {
      // Sintaxe: para variavel = inicio ate fim incremente valor faca statement
      final step = _expression();
      _consume(TokenType.do_, "Esperado 'faca' após o valor de incremento.");
      final body = _statement();
      return ForStepStmt(variable, initializer, condition, step, true, body);
    } else if (_match([TokenType.decrement_])) {
      // Sintaxe: para variavel = inicio ate fim decremente valor faca statement
      final step = _expression();
      _consume(TokenType.do_, "Esperado 'faca' após o valor de decremento.");
      final body = _statement();
      return ForStepStmt(variable, initializer, condition, step, false, body);
    } else {
      // Sintaxe: para variavel = inicio ate fim faca statement (incremento = 1)
      _consume(TokenType.do_, "Esperado 'faca' após o valor final.");
      final body = _statement();
      return ForStmt(variable, initializer, condition, body);
    }
  }

  /// Parse um loop for estilo C: para (init; condition; increment) { body }
  Stmt _forCStatement() {
    _consume(TokenType.leftParen, "Esperado '(' após 'para'.");
    
    // Inicialização (pode ser null para ;;)
    Stmt? initializer;
    if (_match([TokenType.semicolon])) {
      initializer = null;
    } else if (_match([TokenType.var_])) {
      initializer = _varDeclaration();
    } else if (_isTypeToken(_peek())) {
      initializer = _typedVarDeclaration();
    } else {
      initializer = _expressionStatement();
    }
    
    // Condição (pode ser null para ;)
    Expr? condition;
    if (!_check(TokenType.semicolon)) {
      condition = _expression();
    }
    _consume(TokenType.semicolon, "Esperado ';' após condição do for.");
    
    // Incremento (pode ser null para )
    Expr? increment;
    if (!_check(TokenType.rightParen)) {
      increment = _expression();
    }
    _consume(TokenType.rightParen, "Esperado ')' após incremento do for.");
    
    // Corpo do loop
    final body = _statement();
    
    return ForCStmt(initializer, condition, increment, body);
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
    final expr = _ternary();
    if (_match([TokenType.equal])) {
      final equals = _previous();
      final value = _assignment();
      if (expr is VariableExpr) {
        return AssignExpr(expr.name, value);
      }
      _error(equals, "Alvo de atribuição inválido.");
    } else if (_match([TokenType.plusEqual, TokenType.minusEqual, TokenType.starEqual, TokenType.slashEqual, TokenType.percentEqual])) {
      final operator = _previous();
      final value = _assignment();
      if (expr is VariableExpr) {
        return CompoundAssignExpr(expr.name, operator, value);
      }
      _error(operator, "Alvo de atribuição composta inválido.");
    }
    return expr;
  }
  
  Expr _ternary() {
    final expr = _or();
    
    if (_match([TokenType.question])) {
      final thenBranch = _expression();
      _consume(TokenType.colon, "Esperado ':' após expressão verdadeira do operador ternário.");
      final elseBranch = _ternary(); // Associatividade à direita
      return TernaryExpr(expr, thenBranch, elseBranch);
    }
    
    return expr;
  }
  
  Expr _or() => _binary(next: _and, types: [TokenType.or]);
  Expr _and() => _binary(next: _equality, types: [TokenType.and]);
  Expr _equality() => _binary(next: _comparison, types: [TokenType.bangEqual, TokenType.equalEqual]);
  Expr _comparison() => _binary(next: _term, types: [TokenType.greater, TokenType.greaterEqual, TokenType.less, TokenType.lessEqual]);
  Expr _term() => _binary(next: _factor, types: [TokenType.minus, TokenType.plus]);
  Expr _factor() => _binary(next: _unary, types: [TokenType.slash, TokenType.star, TokenType.percent]);

  Expr _unary() {
    if (_match([TokenType.bang, TokenType.minus])) {
      final operator = _previous();
      final right = _unary();
      return UnaryExpr(operator, right);
    }
    if (_match([TokenType.minusMinus])) {
      // Suporte a decremento pré-fixo: --variable
      final expr = _call(); // Usar _call() em vez de _unary() para evitar recursão infinita
      if (expr is VariableExpr) {
        return DecrementExpr(expr.name, isPrefix: true);
      } else {
        throw _error(_previous(), "Operador '--' só pode ser aplicado a variáveis.");
      }
    }
    if (_match([TokenType.plusPlus])) {
      // Suporte a incremento pré-fixo: ++variable
      final expr = _call();
      if (expr is VariableExpr) {
        return IncrementExpr(expr.name, isPrefix: true);
      } else {
        throw _error(_previous(), "Operador '++' só pode ser aplicado a variáveis.");
      }
    }
    return _call();
  }

  Expr _call() {
    Expr expr = _primary();

    while (true) {
      if (_match([TokenType.leftParen])) {
        expr = _finishCall(expr);
      } else if (_match([TokenType.dot])) {
        // Suporte a acesso de membro: objeto.propriedade
        final dot = _previous();
        final property = _consume(TokenType.identifier, "Esperado nome da propriedade após '.'.");
        expr = MemberAccessExpr(expr, dot, property);
      } else if (_match([TokenType.plusPlus])) {
        // Suporte a incremento pós-fixo: variavel++
        if (expr is VariableExpr) {
          expr = IncrementExpr(expr.name, isPrefix: false);
        } else {
          throw _error(_previous(), "Operador '++' só pode ser aplicado a variáveis.");
        }
      } else if (_match([TokenType.minusMinus])) {
        // Suporte a decremento pós-fixo: variavel--
        if (expr is VariableExpr) {
          expr = DecrementExpr(expr.name, isPrefix: false);
        } else {
          throw _error(_previous(), "Operador '--' só pode ser aplicado a variáveis.");
        }
      } else {
        break;
      }
    }

    return expr;
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

  // ===== NOVOS MÉTODOS PARA FUNÇÕES =====

  /// Verifica se o token representa um tipo válido
  bool _isTypeToken(Token token) {
    return token.type == TokenType.inteiro ||
           token.type == TokenType.real ||
           token.type == TokenType.texto ||
           token.type == TokenType.logico ||
           token.type == TokenType.vazio;
  }

  /// Retorna o próximo token sem consumi-lo
  Token _peekNext() {
    if (_current + 1 >= _tokens.length) return _tokens.last;
    return _tokens[_current + 1];
  }

  /// Retorna o token seguinte ao próximo sem consumi-lo
  Token _peekNextNext() {
    if (_current + 2 >= _tokens.length) return _tokens.last;
    return _tokens[_current + 2];
  }

  /// Analisa declaração de função: tipo nome(params) { body }
  Stmt _functionDeclaration() {
    // Consumir o tipo de retorno
    final returnTypeToken = _advance();
    final returnType = TypeInfo(returnTypeToken);

    // Consumir o nome da função
    final name = _consume(TokenType.identifier, "Esperado nome da função.");

    // Consumir parênteses e parâmetros
    _consume(TokenType.leftParen, "Esperado '(' após nome da função.");
    
    final parameters = <Parameter>[];
    if (!_check(TokenType.rightParen)) {
      do {
        // Tipo do parâmetro
        if (!_isTypeToken(_peek())) {
          throw _error(_peek(), "Esperado tipo do parâmetro.");
        }
        final paramType = TypeInfo(_advance());
        
        // Nome do parâmetro
        final paramName = _consume(TokenType.identifier, "Esperado nome do parâmetro.");
        
        parameters.add(Parameter(paramType, paramName));
      } while (_match([TokenType.comma]));
    }
    
    _consume(TokenType.rightParen, "Esperado ')' após parâmetros.");

    // Corpo da função
    _consume(TokenType.leftBrace, "Esperado '{' antes do corpo da função.");
    final body = BlockStmt(_block());

    return FunctionStmt(returnType, name, parameters, body);
  }

  /// Analisa comando de retorno: retorne [expressão];
  Stmt _returnStatement() {
    final keyword = _previous();
    Expr? value;
    
    if (!_check(TokenType.semicolon)) {
      value = _expression();
    }
    
    _consume(TokenType.semicolon, "Esperado ';' após valor de retorno.");
    return ReturnStmt(keyword, value);
  }

  /// Finaliza uma chamada de função processando os argumentos
  Expr _finishCall(Expr callee) {
    final arguments = <Expr>[];
    
    if (!_check(TokenType.rightParen)) {
      do {
        arguments.add(_expression());
      } while (_match([TokenType.comma]));
    }
    
    final paren = _consume(TokenType.rightParen, "Esperado ')' após argumentos.");
    return CallExpr(callee, paren, arguments);
  }

  // ===== FIM DOS NOVOS MÉTODOS =====

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
  
  /// **Inferência de Tipo baseada em Expressão**
  /// 
  /// Infere o tipo de uma constante baseado no valor inicial fornecido.
  /// Usado para declarações do tipo: constante var nome = valor;
  TypeInfo _inferTypeFromExpression(Expr expr) {
    if (expr is LiteralExpr) {
      final value = expr.value;
      if (value is double) {
        // Verificar se é um número inteiro (sem casas decimais)
        if (value == value.toInt()) {
          // É um número inteiro (ex: 16.0 -> inferir como inteiro)
          return TypeInfo(Token(
            type: TokenType.inteiro,
            lexeme: 'inteiro',
            literal: null,
            line: _peek().line,
            column: _peek().column,
          ));
        } else {
          // É um número real com casas decimais (ex: 1.75 -> inferir como real)
          return TypeInfo(Token(
            type: TokenType.real,
            lexeme: 'real',
            literal: null,
            line: _peek().line,
            column: _peek().column,
          ));
        }
      } else if (value is int) {
        // Criar token artificial para tipo inteiro
        return TypeInfo(Token(
          type: TokenType.inteiro,
          lexeme: 'inteiro',
          literal: null,
          line: _peek().line,
          column: _peek().column,
        ));
      } else if (value is String) {
        // Criar token artificial para tipo texto
        return TypeInfo(Token(
          type: TokenType.texto,
          lexeme: 'texto',
          literal: null,
          line: _peek().line,
          column: _peek().column,
        ));
      } else if (value is bool) {
        // Criar token artificial para tipo logico
        return TypeInfo(Token(
          type: TokenType.logico,
          lexeme: 'logico',
          literal: null,
          line: _peek().line,
          column: _peek().column,
        ));
      }
    }
    
    // Se não conseguir inferir, assume tipo real como padrão (compatível com números)
    return TypeInfo(Token(
      type: TokenType.real,
      lexeme: 'real',
      literal: null,
      line: _peek().line,
      column: _peek().column,
    ));
  }
  
  // Sincroniza o parser após um erro para tentar continuar.
  void _synchronize() {
    _advance();
    while (!_isAtEnd()) {
      if (_previous().type == TokenType.semicolon) return;
      switch (_peek().type) {
        case TokenType.var_:
        case TokenType.for_:
        case TokenType.if_:
        case TokenType.while_:
        case TokenType.print_:
        case TokenType.return_:
        case TokenType.inteiro:
        case TokenType.real:
        case TokenType.texto:
        case TokenType.logico:
        case TokenType.vazio:
          return;
        default:
          break;
      }
      _advance();
    }
  }
}

class ParseError extends Error {}
