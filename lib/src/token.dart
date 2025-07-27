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
  plusPlus,
  minusMinus,
  percent,
  semicolon,
  slash,
  star,
  question, // ?
  colon,    // :

  // Tokens de um ou dois caracteres
  bang,
  bangEqual,
  equal,
  equalEqual,
  plusEqual,
  minusEqual,
  starEqual,
  slashEqual,
  percentEqual,
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
  else_,
  false_,
  for_,
  if_,
  nil,
  or,
  print_,
  return_,
  true_,
  var_,
  while_,
  
  // Controle de loops
  break_,      // 'parar'
  continue_,   // 'continuar'
  
  // Switch/Case
  switch_,     // 'escolha'
  case_,       // 'caso'
  default_,    // 'contrario'
  
  // Novos tokens para loop for
  to_,         // 'ate'
  do_,         // 'faca'
  increment_,  // 'incremente'
  decrement_,  // 'decremente'
  
  // Token para do-while
  dowhile_,    // 'faca' (usado em do-while)
  
  // Tipos de dados
  inteiro,     // 'inteiro'
  real,        // 'real'
  texto,       // 'texto'
  logico,      // 'logico'
  vazio,       // 'vazio'
  
  // Declaração de constante
  constante,   // 'constante'
  
  // Sistema de imports
  import_,     // 'importar'
  as_,         // 'como'

  eof,
}

class Token {
  final TokenType type;
  final String lexeme;
  final Object? literal;
  final int line;
  final int column;

  Token({
    required this.type,
    required this.lexeme,
    this.literal,
    required this.line,
    required this.column,
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
      TokenType.plusPlus => 'Incremento',
      TokenType.minusMinus => 'Decremento',
      TokenType.percent => 'Módulo',
      TokenType.semicolon => 'Ponto e Vírgula',
      TokenType.slash => 'Divisão',
      TokenType.star => 'Multiplicação',
      TokenType.question => 'Interrogação',
      TokenType.colon => 'Dois Pontos',
      // ========================================================================
      // SÍMBOLOS DE UM OU DOIS CARACTERES
      // ========================================================================
      TokenType.bang => 'Negação',
      TokenType.bangEqual => 'Diferente',
      TokenType.equal => 'Atribuição',
      TokenType.equalEqual => 'Igualdade',
      TokenType.plusEqual => 'Adição e Atribuição',
      TokenType.minusEqual => 'Subtração e Atribuição',
      TokenType.starEqual => 'Multiplicação e Atribuição',
      TokenType.slashEqual => 'Divisão e Atribuição',
      TokenType.percentEqual => 'Módulo e Atribuição',
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
      TokenType.else_ => 'Senão',
      TokenType.false_ => 'Falso',
      TokenType.for_ => 'Para (loop)',
      TokenType.if_ => 'Se (condicional)',
      TokenType.nil => 'Nulo',
      TokenType.or => 'Ou (operador lógico)',
      TokenType.print_ => 'Imprima',
      TokenType.return_ => 'Retorne',
      TokenType.true_ => 'Verdadeiro',
      TokenType.var_ => 'Variável',
      TokenType.while_ => 'Enquanto (loop)',
      TokenType.break_ => 'Parar (loop)',
      TokenType.continue_ => 'Continuar (loop)',
      TokenType.switch_ => 'Escolha (switch)',
      TokenType.case_ => 'Caso (case)',
      TokenType.default_ => 'Contrário (default)',
      TokenType.to_ => 'Até (loop for)',
      TokenType.do_ => 'Faça (loop)',
      TokenType.increment_ => 'Incremente (incremento)',
      TokenType.decrement_ => 'Decremente (decremento)',
      TokenType.dowhile_ => 'Faça-Enquanto (loop)',
      // ========================================================================
      // TIPOS DE DADOS
      // ========================================================================
      TokenType.inteiro => 'Tipo Inteiro',
      TokenType.real => 'Tipo Real',
      TokenType.texto => 'Tipo Texto',
      TokenType.logico => 'Tipo Lógico',
      TokenType.vazio => 'Tipo Vazio',
      TokenType.constante => 'Declaração de Constante',
      TokenType.import_ => 'Importar',
      TokenType.as_ => 'Como',
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
      TokenType.plusPlus => '++',
      TokenType.minusMinus => '--',
      TokenType.percent => '%',
      TokenType.semicolon => ',',
      TokenType.slash => '/',
      TokenType.star => '*',
      TokenType.question => '?',
      TokenType.colon => ':',
      // Símbolos de dois caracteres
      TokenType.bang => '!',
      TokenType.bangEqual => '!=',
      TokenType.equal => '=',
      TokenType.equalEqual => '==',
      TokenType.plusEqual => '+=',
      TokenType.minusEqual => '-=',
      TokenType.starEqual => '*=',
      TokenType.slashEqual => '/=',
      TokenType.percentEqual => '%=',
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
      TokenType.else_ => 'senao',
      TokenType.false_ => 'falso',
      TokenType.for_ => 'para',
      TokenType.if_ => 'se',
      TokenType.nil => 'nulo',
      TokenType.or => 'ou',
      TokenType.print_ => 'imprima',
      TokenType.return_ => 'retorne',
      TokenType.true_ => 'verdadeiro',
      TokenType.var_ => 'var',
      TokenType.while_ => 'enquanto',
      TokenType.break_ => 'parar',
      TokenType.continue_ => 'continuar',
      TokenType.switch_ => 'escolha',
      TokenType.case_ => 'caso',
      TokenType.default_ => 'contrario',
      TokenType.to_ => 'ate',
      TokenType.do_ => 'faca',
      TokenType.increment_ => 'incremente',
      TokenType.decrement_ => 'decremente',
      TokenType.dowhile_ => 'faca-enquanto',
      // Tipos de dados
      TokenType.inteiro => 'inteiro',
      TokenType.real => 'real',
      TokenType.texto => 'texto',
      TokenType.logico => 'logico',
      TokenType.vazio => 'vazio',
      TokenType.constante => 'constante',
      // Sistema de imports
      TokenType.import_ => 'importar',
      TokenType.as_ => 'como',
      // Especiais
      TokenType.eof => '<EOF>',
    };
  }
}
