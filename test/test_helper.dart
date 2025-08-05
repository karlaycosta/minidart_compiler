import 'package:lipo_compiler/src/error.dart';
import 'package:lipo_compiler/src/lexer.dart';
import 'package:lipo_compiler/src/parser.dart';
import 'package:lipo_compiler/src/semantic_analyzer.dart';
import 'package:lipo_compiler/src/token.dart';
import 'package:lipo_compiler/src/ast.dart';

class TestHelper {
  static ErrorReporter createErrorReporter() => ErrorReporter();

  static List<Token> tokenize(String source) {
    final errorReporter = createErrorReporter();
    final lexer = Lexer(source, errorReporter);
    return lexer.scanTokens();
  }

  static List<Stmt> parse(String source) {
    final tokens = tokenize(source);
    final errorReporter = createErrorReporter();
    final parser = Parser(tokens, errorReporter);
    return parser.parse();
  }

  /// Verifica se há erros durante a análise
  static bool hasErrors(String source) {
    final errorReporter = createErrorReporter();
    final lexer = Lexer(source, errorReporter);
    lexer.scanTokens();
    return errorReporter.hadError;
  }

  /// Verifica se há erros durante o parsing
  static bool hasParseErrors(String source) {
    final errorReporter = createErrorReporter();
    final tokens = tokenize(source);
    final parser = Parser(tokens, errorReporter);
    try {
      parser.parse();
      return errorReporter.hadError;
    } catch (e) {
      return true;
    }
  }

  /// Verifica se há erros durante a análise semântica
  static bool hasSemanticErrors(String source) {
    final errorReporter = createErrorReporter();
    final tokens = tokenize(source);
    final parser = Parser(tokens, errorReporter);
    final statements = parser.parse();

    if (errorReporter.hadError) return true;

    final semanticAnalyzer = SemanticAnalyzer(errorReporter);
    semanticAnalyzer.analyze(statements);
    return errorReporter.hadError;
  }

  /// Cria um programa de teste simples
  static String createSimpleProgram({
    String varName = 'x',
    String value = '10',
    String type = 'inteiro',
  }) {
    return '$type $varName = $value;';
  }

  /// Cria uma função de teste simples
  static String createSimpleFunction({
    String name = 'teste',
    String returnType = 'inteiro',
    String params = '',
    String body = 'retornar 42;',
  }) {
    return 'funcao $returnType $name($params) { $body }';
  }
}
