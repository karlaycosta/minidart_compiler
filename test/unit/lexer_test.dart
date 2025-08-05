import 'package:test/test.dart';
import 'package:lipo_compiler/src/token.dart';
import '../test_helper.dart';

void main() {
  group('Lexer Tests', () {
    test('deve tokenizar números inteiros', () {
      final tokens = TestHelper.tokenize('123');
      expect(tokens.length, 2); // número + EOF
      expect(tokens[0].type, TokenType.number);
      expect(tokens[0].literal, 123);
    });

    test('deve tokenizar números decimais', () {
      final tokens = TestHelper.tokenize('123.45');
      expect(tokens[0].type, TokenType.number);
      expect(tokens[0].literal, 123.45);
    });

    test('deve tokenizar strings', () {
      final tokens = TestHelper.tokenize('"hello world"');
      expect(tokens[0].type, TokenType.string);
      expect(tokens[0].literal, 'hello world');
    });

    test('deve reconhecer palavras-chave em português', () {
      final keywords = {
        'var': TokenType.var_,
        'se': TokenType.if_,
        'senao': TokenType.else_,
        'enquanto': TokenType.while_,
        'para': TokenType.for_,
        'retornar': TokenType.return_,
        'imprimir': TokenType.print_,
        'constante': TokenType.constante,
        'verdadeiro': TokenType.true_,
        'falso': TokenType.false_,
        'inteiro': TokenType.inteiro,
        'real': TokenType.real,
        'texto': TokenType.texto,
        'logico': TokenType.logico,
        'vazio': TokenType.vazio,
      };

      keywords.forEach((keyword, expectedType) {
        final tokens = TestHelper.tokenize(keyword);
        expect(
          tokens[0].type,
          expectedType,
          reason: 'Palavra-chave "$keyword" não reconhecida',
        );
      });
    });

    test('deve tokenizar operadores aritméticos', () {
      final operators = {
        '+': TokenType.plus,
        '-': TokenType.minus,
        '*': TokenType.star,
        '/': TokenType.slash,
        '=': TokenType.equal,
        '==': TokenType.equalEqual,
        '!=': TokenType.bangEqual,
        '<': TokenType.less,
        '<=': TokenType.lessEqual,
        '>': TokenType.greater,
        '>=': TokenType.greaterEqual,
      };

      operators.forEach((operator, expectedType) {
        final tokens = TestHelper.tokenize(operator);
        expect(
          tokens[0].type,
          expectedType,
          reason: 'Operador "$operator" não reconhecido',
        );
      });
    });

    test('deve tokenizar delimitadores', () {
      final delimiters = {
        '(': TokenType.leftParen,
        ')': TokenType.rightParen,
        '{': TokenType.leftBrace,
        '}': TokenType.rightBrace,
        ',': TokenType.comma,
        ';': TokenType.semicolon,
        '.': TokenType.dot,
      };

      delimiters.forEach((delimiter, expectedType) {
        final tokens = TestHelper.tokenize(delimiter);
        expect(
          tokens[0].type,
          expectedType,
          reason: 'Delimitador "$delimiter" não reconhecido',
        );
      });
    });

    test('deve tokenizar identificadores', () {
      final identifiers = [
        'variavel',
        'minhaVariavel',
        'x',
        'contador1',
        '_private',
      ];

      for (final identifier in identifiers) {
        final tokens = TestHelper.tokenize(identifier);
        expect(tokens[0].type, TokenType.identifier);
        expect(tokens[0].lexeme, identifier);
      }
    });

    test('deve ignorar comentários de linha', () {
      final tokens = TestHelper.tokenize(
        'var x = 10; // comentário\nvar y = 20;',
      );
      final nonEofTokens = tokens
          .where((t) => t.type != TokenType.eof)
          .toList();
      expect(nonEofTokens.length, 8); // var x = 10 ; var y = 20
    });

    test('deve ignorar comentários de bloco', () {
      final tokens = TestHelper.tokenize(
        'var x = 10; /* comentário\nmúltiplas linhas */ var y = 20;',
      );
      final nonEofTokens = tokens
          .where((t) => t.type != TokenType.eof)
          .toList();
      expect(nonEofTokens.length, 8); // var x = 10 ; var y = 20
    });

    test('deve ignorar espaços em branco', () {
      final tokens = TestHelper.tokenize('   var    x   =   10   ;   ');
      final nonEofTokens = tokens
          .where((t) => t.type != TokenType.eof)
          .toList();
      expect(nonEofTokens.length, 5); // var x = 10 ;
    });

    test('deve contar linhas corretamente', () {
      final source = '''var x = 10;
var y = 20;
var z = 30;''';
      final tokens = TestHelper.tokenize(source);

      // Verificar se as linhas estão corretas
      final varTokens = tokens.where((t) => t.type == TokenType.var_).toList();
      expect(varTokens[0].line, 1);
      expect(varTokens[1].line, 2);
      expect(varTokens[2].line, 3);
    });

    test('deve reportar erros em caracteres inválidos', () {
      expect(TestHelper.hasErrors('@'), isTrue);
      expect(TestHelper.hasErrors('#'), isTrue);
      expect(TestHelper.hasErrors('\$'), isTrue);
      expect(TestHelper.hasErrors('%'), isTrue);
    });

    test('deve tokenizar strings com escape', () {
      final tokens = TestHelper.tokenize('"Hello\\nWorld"');
      expect(tokens[0].type, TokenType.string);
      expect(tokens[0].literal, 'Hello\nWorld');
    });

    test('deve detectar string não terminada', () {
      expect(TestHelper.hasErrors('"string sem fim'), isTrue);
    });

    test('deve tokenizar programa completo', () {
      final source = '''
        funcao inteiro fibonacci(inteiro n) {
          se (n <= 1) {
            retornar n;
          } senao {
            retornar fibonacci(n - 1) + fibonacci(n - 2);
          }
        }
        
        var resultado = fibonacci(10);
        imprimir(resultado);
      ''';

      final tokens = TestHelper.tokenize(source);
      expect(tokens.isNotEmpty, isTrue);
      expect(tokens.last.type, TokenType.eof);
      expect(TestHelper.hasErrors(source), isFalse);
    });
  });
}
