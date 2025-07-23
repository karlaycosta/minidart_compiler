enum TokenType {
  // Tokens de um caractere
  leftParen,
  rightParen,
  leftBrace,
  rightBrace,
  comma,
  dot,
  minus,
  plus,
  semicolon,
  slash,
  star,

  // Tokens de um ou dois caracteres
  bang,
  bangEqual,
  equal,
  equalEqual,
  greater,
  greaterEqual,
  less,
  lessEqual,

  // Literais
  identifier,
  string,
  number,

  // Palavras-chave
  and,
  class_,
  else_,
  false_,
  fun,
  for_,
  if_,
  nil,
  or,
  print_,
  return_,
  super_,
  this_,
  true_,
  var_,
  while_,

  eof,
}

class Token {
  final TokenType type;
  final String lexeme;
  final Object? literal;
  final int line;

  Token({
    required this.type,
    required this.lexeme,
    this.literal,
    required this.line,
  });

  @override
  String toString() {
    return 'Token(tipo: ${type.nome}, lexema: \'$lexeme\', literal: $literal)';
  }
}

/// **Extensão para Nomes em Português**
///
/// Fornece nomes legíveis em português para todos os tipos de token,
/// facilitando relatórios de erro e debugging em português.
extension TokenTypeExtension on TokenType {
  /// **Nome em Português do Token**
  ///
  /// Retorna uma descrição amigável em português para cada tipo de token.
  /// Usado principalmente para mensagens de erro e debugging.
  String get nome {
    return switch (this) {
      // ========================================================================
      // SÍMBOLOS DE UM CARACTERE
      // ========================================================================
      TokenType.leftParen => 'Parêntese Esquerdo',
      TokenType.rightParen => 'Parêntese Direito',
      TokenType.leftBrace => 'Chave Esquerda',
      TokenType.rightBrace => 'Chave Direita',
      TokenType.comma => 'Vírgula',
      TokenType.dot => 'Ponto',
      TokenType.minus => 'Subtração',
      TokenType.plus => 'Adição',
      TokenType.semicolon => 'Ponto e Vírgula',
      TokenType.slash => 'Divisão',
      TokenType.star => 'Multiplicação',
      // ========================================================================
      // SÍMBOLOS DE UM OU DOIS CARACTERES
      // ========================================================================
      TokenType.bang => 'Negação',
      TokenType.bangEqual => 'Diferente',
      TokenType.equal => 'Atribuição',
      TokenType.equalEqual => 'Igualdade',
      TokenType.greater => 'Maior',
      TokenType.greaterEqual => 'Maior ou Igual',
      TokenType.less => 'Menor',
      TokenType.lessEqual => 'Menor ou Igual',
      // ========================================================================
      // TOKENS LITERAIS
      // ========================================================================
      TokenType.identifier => 'Identificador',
      TokenType.string => 'String',
      TokenType.number => 'Número',
      // ========================================================================
      // PALAVRAS-CHAVE
      // ========================================================================
      TokenType.and => 'E (operador lógico)',
      TokenType.class_ => 'Classe',
      TokenType.else_ => 'Senão',
      TokenType.false_ => 'Falso',
      TokenType.fun => 'Função',
      TokenType.for_ => 'Para (loop)',
      TokenType.if_ => 'Se (condicional)',
      TokenType.nil => 'Nulo',
      TokenType.or => 'Ou (operador lógico)',
      TokenType.print_ => 'Imprimir',
      TokenType.return_ => 'Retornar',
      TokenType.super_ => 'Super (classe pai)',
      TokenType.this_ => 'Isto (auto-referência)',
      TokenType.true_ => 'Verdadeiro',
      TokenType.var_ => 'Variável',
      TokenType.while_ => 'Enquanto (loop)',
      // ========================================================================
      // ESPECIAIS
      // ========================================================================
      TokenType.eof => 'Fim do Arquivo',
    };
  }

  /// **Símbolo do Token**
  ///
  /// Retorna o símbolo correspondente ao token quando aplicável.
  /// Para palavras-chave, retorna a palavra em português.
  String get simbolo {
    return switch (this) {
      // Símbolos de um caractere
      TokenType.leftParen => '(',
      TokenType.rightParen => ')',
      TokenType.leftBrace => '{',
      TokenType.rightBrace => '}',
      TokenType.comma => ',',
      TokenType.dot => '.',
      TokenType.minus => '-',
      TokenType.plus => '+',
      TokenType.semicolon => ',',
      TokenType.slash => '/',
      TokenType.star => '*',
      // Símbolos de dois caracteres
      TokenType.bang => '!',
      TokenType.bangEqual => '!=',
      TokenType.equal => '=',
      TokenType.equalEqual => '==',
      TokenType.greater => '>',
      TokenType.greaterEqual => '>=',
      TokenType.less => '<',
      TokenType.lessEqual => '<=',
      // Literais (sem símbolo fixo)
      TokenType.identifier => '<identificador>',
      TokenType.string => '<string>',
      TokenType.number => '<número>',
      // Palavras-chave em português
      TokenType.and => 'e',
      TokenType.class_ => 'classe',
      TokenType.else_ => 'senao',
      TokenType.false_ => 'falso',
      TokenType.fun => 'funcao',
      TokenType.for_ => 'para',
      TokenType.if_ => 'se',
      TokenType.nil => 'nulo',
      TokenType.or => 'ou',
      TokenType.print_ => 'imprimir',
      TokenType.return_ => 'retorna',
      TokenType.super_ => 'super',
      TokenType.this_ => 'isto',
      TokenType.true_ => 'verdadeiro',
      TokenType.var_ => 'var',
      TokenType.while_ => 'enquanto',
      // Especiais
      TokenType.eof => '<EOF>',
    };
  }
}
