import 'package:test/test.dart';
import 'package:lipo_compiler/src/error.dart';
import 'package:lipo_compiler/src/lexer.dart';
import 'package:lipo_compiler/src/parser.dart';
import 'package:lipo_compiler/src/semantic_analyzer.dart';
import 'package:lipo_compiler/src/code_generator.dart';
import 'package:lipo_compiler/src/vm.dart';

void main() {
  group('Compiler Integration Tests', () {
    test('deve compilar e executar programa completo', () {
      final source = '''
        funcao inteiro fibonacci(inteiro n) {
          se (n <= 1) {
            retornar n;
          } senao {
            retornar fibonacci(n - 1) + fibonacci(n - 2);
          }
        }

        var resultado = fibonacci(8);
        imprimir(resultado);
      ''';

      final errorReporter = ErrorReporter();

      // Análise léxica
      final lexer = Lexer(source, errorReporter);
      final tokens = lexer.scanTokens();
      expect(errorReporter.hadError, isFalse);

      // Análise sintática
      final parser = Parser(tokens, errorReporter);
      final statements = parser.parse();
      expect(errorReporter.hadError, isFalse);

      // Análise semântica
      final semanticAnalyzer = SemanticAnalyzer(errorReporter);
      semanticAnalyzer.analyze(statements);
      expect(errorReporter.hadError, isFalse);

      // Geração de código
      final codeGenerator = CodeGenerator();
      final chunk = codeGenerator.compile(statements);

      // Execução
      final vm = VM();
      vm.setFunctions(codeGenerator.functions);
      final result = vm.interpret(chunk);
      expect(result, InterpretResult.ok);
    });

    test('deve detectar erros léxicos', () {
      final source = '''
        var x = 10;
        var y = @invalid_char;
      ''';

      final errorReporter = ErrorReporter();
      final lexer = Lexer(source, errorReporter);
      lexer.scanTokens();

      expect(errorReporter.hadError, isTrue);
    });

    test('deve detectar erros sintáticos', () {
      final source = '''
        var x = 10 +;
        var y = 20;
      ''';

      final errorReporter = ErrorReporter();
      final lexer = Lexer(source, errorReporter);
      final tokens = lexer.scanTokens();

      final parser = Parser(tokens, errorReporter);
      expect(() => parser.parse(), throwsA(isA<Exception>()));
    });

    test('deve detectar erros semânticos', () {
      final source = '''
        var x = variavel_inexistente + 10;
      ''';

      final errorReporter = ErrorReporter();
      final lexer = Lexer(source, errorReporter);
      final tokens = lexer.scanTokens();
      expect(errorReporter.hadError, isFalse);

      final parser = Parser(tokens, errorReporter);
      final statements = parser.parse();
      expect(errorReporter.hadError, isFalse);

      final semanticAnalyzer = SemanticAnalyzer(errorReporter);
      semanticAnalyzer.analyze(statements);
      expect(errorReporter.hadError, isTrue);
    });

    test('deve compilar programa com funções e variáveis', () {
      final source = '''
        funcao inteiro somar(inteiro a, inteiro b) {
          retornar a + b;
        }
        
        funcao inteiro multiplicar(inteiro x, inteiro y) {
          retornar x * y;
        }
        
        var num1 = 10;
        var num2 = 20;
        var soma = somar(num1, num2);
        var produto = multiplicar(num1, num2);
        
        imprimir("Soma: ");
        imprimir(soma);
        imprimir("Produto: ");
        imprimir(produto);
      ''';

      final errorReporter = ErrorReporter();
      final lexer = Lexer(source, errorReporter);
      final tokens = lexer.scanTokens();
      final parser = Parser(tokens, errorReporter);
      final statements = parser.parse();
      final semanticAnalyzer = SemanticAnalyzer(errorReporter);
      semanticAnalyzer.analyze(statements);

      expect(errorReporter.hadError, isFalse);

      final codeGenerator = CodeGenerator();
      final chunk = codeGenerator.compile(statements);
      final vm = VM();
      vm.setFunctions(codeGenerator.functions);
      final result = vm.interpret(chunk);

      expect(result, InterpretResult.ok);
    });

    test('deve compilar programa com estruturas de controle', () {
      final source = '''
        var contador = 0;
        var limite = 10;
        
        enquanto (contador < limite) {
          se (contador % 2 == 0) {
            imprimir("Par: ");
            imprimir(contador);
          } senao {
            imprimir("Ímpar: ");
            imprimir(contador);
          }
          contador = contador + 1;
        }
        
        imprimir("Fim do loop");
      ''';

      final errorReporter = ErrorReporter();
      final lexer = Lexer(source, errorReporter);
      final tokens = lexer.scanTokens();
      final parser = Parser(tokens, errorReporter);
      final statements = parser.parse();
      final semanticAnalyzer = SemanticAnalyzer(errorReporter);
      semanticAnalyzer.analyze(statements);

      expect(errorReporter.hadError, isFalse);

      final codeGenerator = CodeGenerator();
      final chunk = codeGenerator.compile(statements);
      final vm = VM();
      final result = vm.interpret(chunk);

      expect(result, InterpretResult.ok);
    });

    test('deve compilar programa com operações aritméticas complexas', () {
      final source = '''
        var a = 10;
        var b = 3;
        
        var soma = a + b;
        var subtracao = a - b;
        var multiplicacao = a * b;
        var divisao = a / b;
        var resto = a % b;
        
        imprimir("Operações com ");
        imprimir(a);
        imprimir(" e ");
        imprimir(b);
        imprimir("Soma: ");
        imprimir(soma);
        imprimir("Subtração: ");
        imprimir(subtracao);
        imprimir("Multiplicação: ");
        imprimir(multiplicacao);
        imprimir("Divisão: ");
        imprimir(divisao);
        imprimir("Resto: ");
        imprimir(resto);
      ''';

      final errorReporter = ErrorReporter();
      final lexer = Lexer(source, errorReporter);
      final tokens = lexer.scanTokens();
      final parser = Parser(tokens, errorReporter);
      final statements = parser.parse();
      final semanticAnalyzer = SemanticAnalyzer(errorReporter);
      semanticAnalyzer.analyze(statements);

      expect(errorReporter.hadError, isFalse);

      final codeGenerator = CodeGenerator();
      final chunk = codeGenerator.compile(statements);
      final vm = VM();
      final result = vm.interpret(chunk);

      expect(result, InterpretResult.ok);
    });

    test('deve compilar programa com constantes', () {
      final source = '''
        constante inteiro MAX_VALOR = 100;
        constante texto MENSAGEM = "Hello World";
        constante logico DEBUG = verdadeiro;
        
        var valor = MAX_VALOR / 2;
        
        se (DEBUG) {
          imprimir(MENSAGEM);
          imprimir("Valor calculado: ");
          imprimir(valor);
        }
      ''';

      final errorReporter = ErrorReporter();
      final lexer = Lexer(source, errorReporter);
      final tokens = lexer.scanTokens();
      final parser = Parser(tokens, errorReporter);
      final statements = parser.parse();
      final semanticAnalyzer = SemanticAnalyzer(errorReporter);
      semanticAnalyzer.analyze(statements);

      expect(errorReporter.hadError, isFalse);

      final codeGenerator = CodeGenerator();
      final chunk = codeGenerator.compile(statements);
      final vm = VM();
      final result = vm.interpret(chunk);

      expect(result, InterpretResult.ok);
    });

    test('deve detectar erro de runtime (divisão por zero)', () {
      final source = '''
        var x = 10;
        var y = 0;
        var resultado = x / y;
      ''';

      final errorReporter = ErrorReporter();
      final lexer = Lexer(source, errorReporter);
      final tokens = lexer.scanTokens();
      final parser = Parser(tokens, errorReporter);
      final statements = parser.parse();
      final semanticAnalyzer = SemanticAnalyzer(errorReporter);
      semanticAnalyzer.analyze(statements);

      expect(errorReporter.hadError, isFalse);

      final codeGenerator = CodeGenerator();
      final chunk = codeGenerator.compile(statements);
      final vm = VM();
      final result = vm.interpret(chunk);

      expect(result, InterpretResult.runtimeError);
    });

    test('deve executar recursão profunda corretamente', () {
      final source = '''
        funcao inteiro fatorial(inteiro n) {
          se (n <= 1) {
            retornar 1;
          } senao {
            retornar n * fatorial(n - 1);
          }
        }
        
        var resultado = fatorial(6);
        imprimir("Fatorial de 6: ");
        imprimir(resultado);
      ''';

      final errorReporter = ErrorReporter();
      final lexer = Lexer(source, errorReporter);
      final tokens = lexer.scanTokens();
      final parser = Parser(tokens, errorReporter);
      final statements = parser.parse();
      final semanticAnalyzer = SemanticAnalyzer(errorReporter);
      semanticAnalyzer.analyze(statements);

      expect(errorReporter.hadError, isFalse);

      final codeGenerator = CodeGenerator();
      final chunk = codeGenerator.compile(statements);
      final vm = VM();
      vm.setFunctions(codeGenerator.functions);
      final result = vm.interpret(chunk);

      expect(result, InterpretResult.ok);
    });
  });
}
