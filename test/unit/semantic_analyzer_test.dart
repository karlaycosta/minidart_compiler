import 'package:test/test.dart';
import '../test_helper.dart';

void main() {
  group('Semantic Analyzer Tests', () {
    test('deve analisar declaração de variável válida', () {
      final source = 'var x = 10;';
      expect(TestHelper.hasSemanticErrors(source), isFalse);
    });

    test('deve analisar declaração tipada válida', () {
      final source = 'inteiro idade = 25;';
      expect(TestHelper.hasSemanticErrors(source), isFalse);
    });

    test('deve analisar declaração de constante válida', () {
      final source = 'constante inteiro PI = 3;';
      expect(TestHelper.hasSemanticErrors(source), isFalse);
    });

    test('deve detectar uso de variável não declarada', () {
      final source = 'var y = x + 10;';
      expect(TestHelper.hasSemanticErrors(source), isTrue);
    });

    test('deve detectar redeclaração de variável', () {
      final source = '''
        var x = 10;
        var x = 20;
      ''';
      expect(TestHelper.hasSemanticErrors(source), isTrue);
    });

    test('deve detectar redeclaração de constante', () {
      final source = '''
        constante inteiro X = 10;
        constante inteiro X = 20;
      ''';
      expect(TestHelper.hasSemanticErrors(source), isTrue);
    });

    test('deve detectar tentativa de reatribuir constante', () {
      final source = '''
        constante inteiro X = 10;
        X = 20;
      ''';
      expect(TestHelper.hasSemanticErrors(source), isTrue);
    });

    test('deve analisar função válida', () {
      final source = '''
        funcao inteiro somar(inteiro a, inteiro b) {
          retornar a + b;
        }
      ''';
      expect(TestHelper.hasSemanticErrors(source), isFalse);
    });

    test('deve detectar uso de parâmetro fora da função', () {
      final source = '''
        funcao inteiro somar(inteiro a, inteiro b) {
          retornar a + b;
        }
        var x = a;
      ''';
      expect(TestHelper.hasSemanticErrors(source), isTrue);
    });

    test('deve analisar escopo de bloco', () {
      final source = '''
        var x = 10;
        {
          var y = 20;
          var z = x + y;
        }
        var w = x;
      ''';
      expect(TestHelper.hasSemanticErrors(source), isFalse);
    });

    test('deve detectar uso de variável fora de escopo', () {
      final source = '''
        var x = 10;
        {
          var y = 20;
        }
        var z = y;
      ''';
      expect(TestHelper.hasSemanticErrors(source), isTrue);
    });

    test('deve analisar estrutura condicional', () {
      final source = '''
        var x = 10;
        se (x > 0) {
          imprimir("positivo");
        } senao {
          imprimir("não positivo");
        }
      ''';
      expect(TestHelper.hasSemanticErrors(source), isFalse);
    });

    test('deve analisar loop enquanto', () {
      final source = '''
        var i = 0;
        enquanto (i < 10) {
          i = i + 1;
        }
      ''';
      expect(TestHelper.hasSemanticErrors(source), isFalse);
    });

    test('deve detectar chamada de função não declarada', () {
      final source = 'var x = funcaoInexistente(10);';
      expect(TestHelper.hasSemanticErrors(source), isTrue);
    });

    test('deve analisar chamada de função válida', () {
      final source = '''
        funcao inteiro dobrar(inteiro x) {
          retornar x * 2;
        }
        var resultado = dobrar(5);
      ''';
      expect(TestHelper.hasSemanticErrors(source), isFalse);
    });

    test('deve detectar número incorreto de argumentos', () {
      final source = '''
        funcao inteiro somar(inteiro a, inteiro b) {
          retornar a + b;
        }
        var resultado = somar(5);
      ''';
      expect(TestHelper.hasSemanticErrors(source), isTrue);
    });

    test('deve analisar expressões binárias válidas', () {
      final source = '''
        var a = 10;
        var b = 20;
        var soma = a + b;
        var produto = a * b;
        var divisao = a / b;
        var subtracao = a - b;
      ''';
      expect(TestHelper.hasSemanticErrors(source), isFalse);
    });

    test('deve analisar expressões de comparação', () {
      final source = '''
        var a = 10;
        var b = 20;
        var maior = a > b;
        var menor = a < b;
        var igual = a == b;
        var diferente = a != b;
      ''';
      expect(TestHelper.hasSemanticErrors(source), isFalse);
    });

    test('deve analisar expressões lógicas', () {
      final source = '''
        var a = verdadeiro;
        var b = falso;
        var e_logico = a and b;
        var ou_logico = a or b;
        var negacao = not a;
      ''';
      expect(TestHelper.hasSemanticErrors(source), isFalse);
    });

    test('deve detectar retorno fora de função', () {
      final source = 'retornar 42;';
      expect(TestHelper.hasSemanticErrors(source), isTrue);
    });

    test('deve analisar retorno dentro de função', () {
      final source = '''
        funcao inteiro obterValor() {
          retornar 42;
        }
      ''';
      expect(TestHelper.hasSemanticErrors(source), isFalse);
    });

    test('deve analisar programa complexo válido', () {
      final source = '''
        funcao inteiro fibonacci(inteiro n) {
          se (n <= 1) {
            retornar n;
          } senao {
            retornar fibonacci(n - 1) + fibonacci(n - 2);
          }
        }
        
        var numero = 10;
        var resultado = fibonacci(numero);
        imprimir(resultado);
      ''';
      expect(TestHelper.hasSemanticErrors(source), isFalse);
    });

    test('deve detectar múltiplos erros em programa inválido', () {
      final source = '''
        var x = variavelInexistente;
        var y = x;
        var y = 20; // redeclaração
        funcaoInexistente(10);
        retornar 42; // retorno fora de função
      ''';
      expect(TestHelper.hasSemanticErrors(source), isTrue);
    });
  });
}
