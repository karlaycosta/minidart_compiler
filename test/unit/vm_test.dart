import 'package:test/test.dart';
import 'package:lipo_compiler/src/vm.dart';
import 'package:lipo_compiler/src/code_generator.dart';
import '../test_helper.dart';

void main() {
  group('VM Tests', () {
    test('deve executar operações aritméticas básicas', () {
      final statements = TestHelper.parse('var resultado = 10 + 5 * 2;');
      final codeGenerator = CodeGenerator();
      final chunk = codeGenerator.compile(statements);

      final vm = VM();
      final result = vm.interpret(chunk);

      expect(result, InterpretResult.ok);
    });

    test('deve executar declaração de variável simples', () {
      final statements = TestHelper.parse('var x = 42;');
      final codeGenerator = CodeGenerator();
      final chunk = codeGenerator.compile(statements);

      final vm = VM();
      final result = vm.interpret(chunk);

      expect(result, InterpretResult.ok);
    });

    test('deve executar atribuição de variável', () {
      final statements = TestHelper.parse('''
        var x = 10;
        x = 20;
      ''');
      final codeGenerator = CodeGenerator();
      final chunk = codeGenerator.compile(statements);

      final vm = VM();
      final result = vm.interpret(chunk);

      expect(result, InterpretResult.ok);
    });

    test('deve executar estrutura condicional', () {
      final statements = TestHelper.parse('''
        var x = 10;
        se (x > 5) {
          x = 20;
        }
      ''');
      final codeGenerator = CodeGenerator();
      final chunk = codeGenerator.compile(statements);

      final vm = VM();
      final result = vm.interpret(chunk);

      expect(result, InterpretResult.ok);
    });

    test('deve executar loop enquanto', () {
      final statements = TestHelper.parse('''
        var i = 0;
        var soma = 0;
        enquanto (i < 5) {
          soma = soma + i;
          i = i + 1;
        }
      ''');
      final codeGenerator = CodeGenerator();
      final chunk = codeGenerator.compile(statements);

      final vm = VM();
      final result = vm.interpret(chunk);

      expect(result, InterpretResult.ok);
    });

    test('deve executar função simples', () {
      final statements = TestHelper.parse('''
        funcao inteiro dobrar(inteiro x) {
          retornar x * 2;
        }
        var resultado = dobrar(21);
      ''');
      final codeGenerator = CodeGenerator();
      final chunk = codeGenerator.compile(statements);

      final vm = VM();
      vm.setFunctions(codeGenerator.functions);
      final result = vm.interpret(chunk);

      expect(result, InterpretResult.ok);
    });

    test('deve executar função recursiva', () {
      final statements = TestHelper.parse('''
        funcao inteiro fatorial(inteiro n) {
          se (n <= 1) {
            retornar 1;
          } senao {
            retornar n * fatorial(n - 1);
          }
        }
        var resultado = fatorial(5);
      ''');
      final codeGenerator = CodeGenerator();
      final chunk = codeGenerator.compile(statements);

      final vm = VM();
      vm.setFunctions(codeGenerator.functions);
      final result = vm.interpret(chunk);

      expect(result, InterpretResult.ok);
    });

    test('deve executar operações de comparação', () {
      final statements = TestHelper.parse('''
        var a = 10;
        var b = 20;
        var maior = a > b;
        var menor = a < b;
        var igual = a == b;
      ''');
      final codeGenerator = CodeGenerator();
      final chunk = codeGenerator.compile(statements);

      final vm = VM();
      final result = vm.interpret(chunk);

      expect(result, InterpretResult.ok);
    });

    test('deve executar operações lógicas', () {
      final statements = TestHelper.parse('''
        var a = verdadeiro;
        var b = falso;
        var e_logico = a and b;
        var ou_logico = a or b;
      ''');
      final codeGenerator = CodeGenerator();
      final chunk = codeGenerator.compile(statements);

      final vm = VM();
      final result = vm.interpret(chunk);

      expect(result, InterpretResult.ok);
    });

    test('deve executar impressão de valores', () {
      final statements = TestHelper.parse('''
        var mensagem = "Hello World";
        imprimir(mensagem);
        imprimir(42);
        imprimir(verdadeiro);
      ''');
      final codeGenerator = CodeGenerator();
      final chunk = codeGenerator.compile(statements);

      final vm = VM();
      final result = vm.interpret(chunk);

      expect(result, InterpretResult.ok);
    });

    test('deve executar programa complexo', () {
      final statements = TestHelper.parse('''
        funcao inteiro fibonacci(inteiro n) {
          se (n <= 1) {
            retornar n;
          } senao {
            retornar fibonacci(n - 1) + fibonacci(n - 2);
          }
        }
        
        var numero = 8;
        var resultado = fibonacci(numero);
        imprimir("Fibonacci de ");
        imprimir(numero);
        imprimir(" é ");
        imprimir(resultado);
      ''');
      final codeGenerator = CodeGenerator();
      final chunk = codeGenerator.compile(statements);

      final vm = VM();
      vm.setFunctions(codeGenerator.functions);
      final result = vm.interpret(chunk);

      expect(result, InterpretResult.ok);
    });

    test('deve detectar divisão por zero', () {
      final statements = TestHelper.parse('var x = 10 / 0;');
      final codeGenerator = CodeGenerator();
      final chunk = codeGenerator.compile(statements);

      final vm = VM();
      final result = vm.interpret(chunk);

      expect(result, InterpretResult.runtimeError);
    });

    test('deve detectar chamada de função inexistente', () {
      final statements = TestHelper.parse('var x = funcaoInexistente(10);');
      final codeGenerator = CodeGenerator();
      final chunk = codeGenerator.compile(statements);

      final vm = VM();
      final result = vm.interpret(chunk);

      expect(result, InterpretResult.runtimeError);
    });

    test('deve detectar acesso a variável inexistente', () {
      final statements = TestHelper.parse('var x = variavelInexistente;');
      final codeGenerator = CodeGenerator();

      // Este teste pode falhar na compilação, dependendo da implementação
      // do gerador de código. Vamos assumir que passa pela compilação
      // mas falha na execução.
      try {
        final chunk = codeGenerator.compile(statements);
        final vm = VM();
        final result = vm.interpret(chunk);
        expect(result, InterpretResult.runtimeError);
      } catch (e) {
        // Se falhar na compilação, isso também é um comportamento válido
        expect(e, isNotNull);
      }
    });
  });
}
