import 'token.dart';
import 'error.dart';

/// **Analisador Léxico (Lexer) do MiniDart**
///
/// O Lexer é responsável pela **primeira fase da compilação**: a análise léxica.
/// Converte o código fonte (string) em uma sequência de tokens que representam
/// os elementos básicos da linguagem.
///
/// **Processo de Tokenização:**
/// 1. Percorre o código fonte caractere por caractere
/// 2. Reconhece padrões (números, strings, identificadores, operadores)
/// 3. Agrupa caracteres em tokens significativos
/// 4. Reporta erros léxicos quando encontra caracteres inválidos
///
/// **Características Especiais:**
/// - Palavras-chave localizadas em português
/// - Suporte a comentários de linha (//)
/// - Números decimais com ponto flutuante
/// - Strings multi-linha com rastreamento de linha
/// - Operadores compostos (==, !=, <=, >=)
///
/// **Exemplo de uso:**
/// ```dart
/// final lexer = Lexer("var idade = 25;", errorReporter);
/// final tokens = lexer.scanTokens();
/// // Resultado: [VAR, IDENTIFIER, EQUAL, NUMBER, SEMICOLON, EOF]
/// ```
class Lexer {
  // === Estado do Lexer ===

  /// Código fonte completo a ser analisado
  final String _source;

  /// Reporter para comunicar erros léxicos encontrados
  final ErrorReporter _errorReporter;

  /// Lista de tokens gerados durante a análise
  final List<Token> _tokens = [];

  // === Ponteiros de Navegação ===

  /// Posição do início do token atual no código fonte
  int _start = 0;

  /// Posição atual do cursor no código fonte
  int _current = 0;

  /// Número da linha atual (para rastreamento de erros)
  int _line = 1;

  /// Posição da coluna atual na linha (para rastreamento de erros)
  int _column = 1;

  /// Posição da coluna onde o token atual começou
  int _tokenStartColumn = 1;

  final int length;

  /// **Tabela de Palavras-Chave da Linguagem MiniDart**
  ///
  /// Mapeia palavras-chave em português para seus tipos de token correspondentes.
  /// Esta tabela permite que a linguagem use termos familiares para falantes
  /// de português, tornando o código mais acessível.
  ///
  /// **Categorias de palavras-chave:**
  /// - **Controle de fluxo**: se, senao, enquanto, para
  /// - **Declarações**: var, classe, fun
  /// - **Operadores lógicos**: e, ou
  /// - **Literais**: verdadeiro, falso, nulo
  /// - **Comandos**: imprimir, retornar
  /// - **Orientação a objetos**: isto, super
  static final Map<String, TokenType> _keywords = {
    'e': TokenType.and, // Operador lógico AND
    'classe': TokenType.class_, // Declaração de classe
    'senao': TokenType.else_, // Estrutura condicional ELSE
    'falso': TokenType.false_, // Literal booleano false
    'funcao': TokenType.fun, // Declaração de função
    'para': TokenType.for_, // Loop FOR
    'se': TokenType.if_, // Estrutura condicional IF
    'nulo': TokenType.nil, // Literal valor nulo
    'ou': TokenType.or, // Operador lógico OR
    'imprimir': TokenType.print_, // Comando de impressão
    'retornar': TokenType.return_, // Comando de retorno de função
    'super': TokenType.super_, // Referência à classe pai
    'isto': TokenType.this_, // Referência ao objeto atual
    'verdadeiro': TokenType.true_, // Literal booleano true
    'var': TokenType.var_, // Declaração de variável
    'enquanto': TokenType.while_, // Loop WHILE
    'ate': TokenType.to_, // Loop FOR - até
    'faca': TokenType.do_, // Loop FOR - faça
    'passo': TokenType.step_, // Loop FOR - incremento
    // Tipos de dados
    'inteiro': TokenType.inteiro, // Tipo de dados inteiro
    'real': TokenType.real, // Tipo de dados real/float
    'texto': TokenType.texto, // Tipo de dados string
    'logico': TokenType.logico, // Tipo de dados boolean
    'vazio': TokenType.vazio, // Tipo de retorno void
  };

  /// **Construtor do Lexer**
  ///
  /// Inicializa o analisador léxico com o código fonte e o reporter de erros.
  ///
  /// **Parâmetros:**
  /// - [source]: String contendo o código MiniDart a ser analisado
  /// - [_errorReporter]: Instância para reportar erros léxicos encontrados
  Lexer(this._source, this._errorReporter) : length = _source.length;

  /// **Método Principal de Tokenização**
  ///
  /// Executa a análise léxica completa do código fonte, convertendo-o
  /// em uma lista de tokens. Este é o ponto de entrada principal do lexer.
  ///
  /// **Algoritmo:**
  /// 1. Percorre todo o código fonte até o final
  /// 2. Para cada posição, identifica e processa um token
  /// 3. Adiciona um token EOF ao final para marcar o fim
  /// 4. Retorna a lista completa de tokens
  ///
  /// **Retorna:** Lista de tokens representando o código fonte
  ///
  /// **Exemplo:**
  /// ```dart
  /// final tokens = lexer.scanTokens();
  /// for (final token in tokens) {
  ///   print('${token.type}: ${token.lexeme}');
  /// }
  /// ```
  List<Token> scanTokens() {
    while (_isNotEnd) {
      _start = _current; // Marca o início do próximo token
      _tokenStartColumn = _column; // Marca a coluna do início do token
      _scanToken(); // Processa um token
    }
    // Adiciona token de fim de arquivo
    _tokens.add(Token(type: TokenType.eof, lexeme: "", line: _line, column: _column));
    return _tokens;
  }

  bool get _isNotEnd => _current < length;
  bool get _isEnd => _current >= length;

  /// **Processamento Individual de Tokens**
  ///
  /// Analisa o caractere atual e determina que tipo de token criar.
  /// Este é o coração do lexer, implementando um autômato finito
  /// que reconhece todos os padrões léxicos da linguagem MiniDart.
  ///
  /// **Tipos de tokens reconhecidos:**
  /// - **Símbolos simples**: (, ), {, }, +, -, *, etc.
  /// - **Operadores compostos**: ==, !=, <=, >=
  /// - **Comentários**: // até fim da linha
  /// - **Literals**: números, strings, identificadores
  /// - **Whitespace**: espaços, tabs, quebras de linha
  ///
  /// **Estratégia de reconhecimento:**
  /// 1. Consome o próximo caractere
  /// 2. Usa switch para determinar o tipo
  /// 3. Para tokens complexos, chama métodos especializados
  /// 4. Reporta erro para caracteres não reconhecidos
  void _scanToken() {
    final c = _advance();
    switch (c) {
      // === Delimitadores e Símbolos Simples ===
      case '(':
        _addToken(TokenType.leftParen); // Parêntese esquerdo
      case ')':
        _addToken(TokenType.rightParen); // Parêntese direito
      case '{':
        _addToken(TokenType.leftBrace); // Chave esquerda
      case '}':
        _addToken(TokenType.rightBrace); // Chave direita
      case ',':
        _addToken(TokenType.comma); // Vírgula
      case '.':
        _addToken(TokenType.dot); // Ponto
      case '-':
        _addToken(TokenType.minus); // Subtração/negação
      case '+':
        _addToken(TokenType.plus); // Adição
      case ';':
        _addToken(TokenType.semicolon); // Ponto e vírgula
      case '*':
        _addToken(TokenType.star); // Multiplicação

      // === Operadores que podem ser compostos ===
      case '!':
        _addToken(
          _match('=') ? TokenType.bangEqual : TokenType.bang,
        ); // != ou !
      case '=':
        _addToken(
          _match('=') ? TokenType.equalEqual : TokenType.equal,
        ); // == ou =
      case '<':
        _addToken(
          _match('=') ? TokenType.lessEqual : TokenType.less,
        ); // <= ou <
      case '>':
        _addToken(
          _match('=') ? TokenType.greaterEqual : TokenType.greater,
        ); // >= ou >

      // === Divisão ou Comentário ===
      case '/':
        if (_match('/')) {
          // Comentário de linha: ignora até quebra de linha
          while (_peek() != '\n' && _isNotEnd) {
            _advance();
          }
        } else {
          _addToken(TokenType.slash); // Operador de divisão
        }

      // === Whitespace (ignorado) ===
      case ' ': // Espaço
      case '\r': // Carriage return
      case '\t': // Tab
        // Ignora caracteres de espaçamento
        break;

      // === Quebra de linha ===
      case '\n':
        _line++; // Incrementa contador de linha para rastreamento
        _column = 1; // Reset da coluna para nova linha
        break;

      // === String literal ===
      case '"':
        _string(); // Processa string entre aspas duplas

      // === Casos complexos que requerem lookahead ===
      default:
        if (_isDigit(c)) {
          _number(); // Números (inteiros ou decimais)
        } else if (_isAlpha(c)) {
          _identifier(); // Identificadores ou palavras-chave
        } else {
          // Caractere não reconhecido - reporta erro
          _errorReporter.error(_line, "Caractere inesperado.");
        }
    }
  }

  // ========================================================================
  // MÉTODOS ESPECIALIZADOS PARA TOKENS COMPLEXOS
  // ========================================================================

  /// **Processamento de Identificadores e Palavras-Chave**
  ///
  /// Reconhece sequências alfanuméricas que podem ser:
  /// - Identificadores definidos pelo usuário (nomes de variáveis, funções)
  /// - Palavras-chave da linguagem (se, enquanto, var, etc.)
  ///
  /// **Algoritmo:**
  /// 1. Consome caracteres alfanuméricos consecutivos
  /// 2. Extrai o texto completo do identificador
  /// 3. Verifica na tabela de palavras-chave
  /// 4. Se encontrou, cria token da palavra-chave; senão, cria IDENTIFIER
  ///
  /// **Exemplos:**
  /// - "idade" → IDENTIFIER
  /// - "se" → IF
  /// - "minhaVariavel" → IDENTIFIER
  /// - "enquanto" → WHILE
  void _identifier() {
    // Consome todos os caracteres alfanuméricos
    while (_isAlphaNumeric(_peek())) {
      _advance();
    }

    // Extrai o texto do identificador
    final text = _source.substring(_start, _current);

    // Verifica se é palavra-chave ou identificador comum
    final type = _keywords[text] ?? TokenType.identifier;
    _addToken(type);
  }

  /// **Processamento de Números (Inteiros e Decimais)**
  ///
  /// Reconhece literais numéricos em formato decimal, incluindo:
  /// - Números inteiros: 42, 0, 1000
  /// - Números decimais: 3.14, 0.5, 42.0
  ///
  /// **Algoritmo:**
  /// 1. Consome dígitos da parte inteira
  /// 2. Se encontrar ponto seguido de dígito, processa parte decimal
  /// 3. Converte a string completa para double
  /// 4. Armazena o valor numérico no token
  ///
  /// **Limitações:**
  /// - Não suporta notação científica (1e10)
  /// - Não suporta números hexadecimais (0xFF)
  /// - Não suporta separadores de milhares (1_000)
  void _number() {
    // Consome a parte inteira
    while (_isDigit(_peek())) {
      _advance();
    }

    // Verifica se há parte decimal
    if (_peek() == '.' && _isDigit(_peekNext())) {
      _advance(); // Consome o ponto decimal

      // Consome a parte fracionária
      while (_isDigit(_peek())) {
        _advance();
      }
    }

    // Converte para double e cria o token
    final value = double.parse(_source.substring(_start, _current));
    _addToken(TokenType.number, value);
  }

  /// **Processamento de Strings Literais**
  ///
  /// Reconhece strings delimitadas por aspas duplas, suportando:
  /// - Strings simples: "Olá mundo"
  /// - Strings multi-linha: "Linha 1\nLinha 2"
  /// - Strings vazias: ""
  ///
  /// **Características:**
  /// - Suporta quebras de linha dentro da string
  /// - Rastreia número de linhas para relatórios de erro precisos
  /// - Reporta erro se a string não for terminada
  /// - Remove as aspas delimitadoras do valor final
  ///
  /// **Limitações:**
  /// - Não suporta escape sequences (\n, \t, etc.)
  /// - Apenas aspas duplas são suportadas (não aspas simples)
  void _string() {
    // Consome caracteres até encontrar a aspa de fechamento ou fim do arquivo
    while (_peek() != '"' && _isNotEnd) {
      if (_peek() == '\n') {
        _line++; // Rastreia quebras de linha dentro da string
        _column = 1; // Reset da coluna para nova linha
      }
      _advance();
    }

    // Verifica se a string foi terminada adequadamente
    if (_isEnd) {
      _errorReporter.error(_line, "String não terminada.");
      return;
    }

    _advance(); // Consome a aspa de fechamento

    // Extrai o valor da string (sem as aspas delimitadoras)
    final value = _source.substring(_start + 1, _current - 1);
    _addToken(TokenType.string, value);
  }

  // ========================================================================
  // MÉTODOS AUXILIARES DE NAVEGAÇÃO E ANÁLISE
  // ========================================================================

  /// **Lookahead Condicional**
  ///
  /// Verifica se o próximo caractere corresponde ao esperado e o consome
  /// apenas se houver correspondência. Essencial para reconhecer operadores
  /// compostos como ==, !=, <=, >=.
  ///
  /// **Parâmetros:**
  /// - [expected]: Caractere que se espera encontrar
  ///
  /// **Retorna:** true se o caractere foi encontrado e consumido
  ///
  /// **Exemplo:**
  /// ```dart
  /// // Para reconhecer == vs =
  /// if (_match('=')) {
  ///   // Encontrou ==
  /// } else {
  ///   // Apenas =
  /// }
  /// ```
  bool _match(String expected) {
    if (_isEnd) return false;
    if (_source[_current] != expected) return false;
    _current++;
    return true;
  }

  /// **Lookahead sem Consumo**
  ///
  /// Examina o caractere atual sem avançar o cursor.
  /// Fundamental para decisões de parsing que dependem do próximo caractere.
  ///
  /// **Retorna:** Caractere atual ou '\x00' se fim do arquivo
  ///
  /// **Uso típico:**
  /// - Verificar se há mais dígitos em um número
  /// - Detectar fim de string
  /// - Implementar lookahead em gramáticas
  String _peek() => _isEnd ? '\x00' : _source[_current];

  /// **Lookahead de Dois Caracteres**
  ///
  /// Examina o caractere seguinte ao atual sem consumir nenhum.
  /// Usado especificamente para reconhecer números decimais (verificar
  /// se após um ponto há um dígito).
  ///
  /// **Retorna:** Próximo caractere ou '\x00' se não existir
  ///
  /// **Exemplo de uso:**
  /// ```dart
  /// if (_peek() == '.' && _isDigit(_peekNext())) {
  ///   // É um número decimal como 3.14
  /// }
  /// ```
  String _peekNext() {
    if (_current + 1 >= length) return '\x00';
    return _source[_current + 1];
  }

  // ========================================================================
  // MÉTODOS DE CLASSIFICAÇÃO DE CARACTERES
  // ========================================================================

  /// **Verificação de Caractere Alfabético**
  ///
  /// Determina se um caractere pode iniciar um identificador.
  /// Inclui letras maiúsculas, minúsculas e underscore.
  ///
  /// **Parâmetros:**
  /// - [c]: Caractere a ser verificado
  ///
  /// **Retorna:** true se o caractere é alfabético ou underscore
  ///
  /// **Regras MiniDart:**
  /// - a-z: letras minúsculas ✓
  /// - A-Z: letras maiúsculas ✓
  /// - _: underscore ✓
  /// - Números: não podem iniciar identificador ✗
  bool _isAlpha(String c) =>
      (c.compareTo('a') >= 0 && c.compareTo('z') <= 0) ||
      (c.compareTo('A') >= 0 && c.compareTo('Z') <= 0) ||
      c == '_';

  /// **Verificação de Dígito Numérico**
  ///
  /// Determina se um caractere é um dígito decimal (0-9).
  ///
  /// **Parâmetros:**
  /// - [c]: Caractere a ser verificado
  ///
  /// **Retorna:** true se o caractere é dígito de 0 a 9
  bool _isDigit(String c) => c.compareTo('0') >= 0 && c.compareTo('9') <= 0;

  /// **Verificação de Caractere Alfanumérico**
  ///
  /// Determina se um caractere pode fazer parte de um identificador
  /// (após o primeiro caractere). Combina letras, dígitos e underscore.
  ///
  /// **Parâmetros:**
  /// - [c]: Caractere a ser verificado
  ///
  /// **Retorna:** true se é letra, dígito ou underscore
  ///
  /// **Uso:** Validar continuação de identificadores como "minhaVar123"
  bool _isAlphaNumeric(String c) => _isAlpha(c) || _isDigit(c);

  /// **Verificação de Fim de Arquivo**
  ///
  /// Determina se o cursor chegou ao final do código fonte.
  ///
  /// **Retorna:** true se não há mais caracteres para processar
  // TODO: Reativar
  // bool _isAtEnd() => _current >= _source.length;

  // ========================================================================
  // MÉTODOS DE MANIPULAÇÃO DE CURSOR E TOKEN
  // ========================================================================

  /// **Avanço do Cursor**
  ///
  /// Consome o caractere atual e avança o cursor para a próxima posição.
  ///
  /// **Retorna:** O caractere que foi consumido
  ///
  /// **Efeito colateral:** Incrementa _current e _column
  String _advance() {
    final char = _source[_current++];
    _column++;
    return char;
  }

  /// **Criação e Adição de Token**
  ///
  /// Cria um novo token com base no texto reconhecido e o adiciona à lista.
  ///
  /// **Parâmetros:**
  /// - [type]: Tipo do token (definido em TokenType)
  /// - [literal]: Valor literal opcional (para números, strings, etc.)
  ///
  /// **Processo:**
  /// 1. Extrai o texto do token (_start até _current)
  /// 2. Cria objeto Token com tipo, texto, valor e linha
  /// 3. Adiciona à lista de tokens
  void _addToken(TokenType type, [Object? literal]) {
    final text = _source.substring(_start, _current);
    _tokens.add(Token(type: type, lexeme: text, literal: literal, line: _line, column: _tokenStartColumn));
  }
}
