import 'package:test/test.dart';
import 'package:lipo_compiler/src/standard_library.dart';
import 'dart:math' as math;

void main() {
  group('Standard Library Tests', () {
    late StandardLibrary stdlib;

    setUp(() {
      stdlib = StandardLibrary();
    });

    group('Math Functions', () {
      test('math.sqrt deve calcular raiz quadrada', () {
        final func = stdlib.getFunction('math.sqrt');
        expect(func, isNotNull);
        final result = func!.call([9.0]);
        expect(result, equals(3.0));
      });

      test('math.sqrt deve rejeitar números negativos', () {
        final func = stdlib.getFunction('math.sqrt');
        expect(func, isNotNull);
        expect(() => func!.call([-4.0]), throwsException);
      });

      test('math.pow deve calcular potência', () {
        final func = stdlib.getFunction('math.pow');
        expect(func, isNotNull);
        final result = func!.call([2.0, 3.0]);
        expect(result, equals(8.0));
      });

      test('math.abs deve calcular valor absoluto', () {
        final func = stdlib.getFunction('math.abs');
        expect(func, isNotNull);
        expect(func!.call([-5]), equals(5));
        expect(func.call([5.0]), equals(5.0));
        expect(func.call([0]), equals(0));
      });

      test('math.max deve retornar maior valor', () {
        final func = stdlib.getFunction('math.max');
        expect(func, isNotNull);
        final result = func!.call([5.0, 3.0]);
        expect(result, equals(5.0));
      });

      test('math.min deve retornar menor valor', () {
        final func = stdlib.getFunction('math.min');
        expect(func, isNotNull);
        final result = func!.call([5.0, 3.0]);
        expect(result, equals(3.0));
      });

      test('math.floor deve arredondar para baixo', () {
        final func = stdlib.getFunction('math.floor');
        expect(func, isNotNull);
        final result = func!.call([3.7]);
        expect(result, equals(3));
      });

      test('math.ceil deve arredondar para cima', () {
        final func = stdlib.getFunction('math.ceil');
        expect(func, isNotNull);
        final result = func!.call([3.2]);
        expect(result, equals(4));
      });

      test('math.round deve arredondar para o mais próximo', () {
        final func = stdlib.getFunction('math.round');
        expect(func, isNotNull);
        expect(func!.call([3.4]), equals(3));
        expect(func.call([3.6]), equals(4));
        expect(func.call([3.5]), equals(4));
      });

      test('math.sin deve calcular seno', () {
        final func = stdlib.getFunction('math.sin');
        expect(func, isNotNull);
        final result = func!.call([math.pi / 2]);
        expect(result, closeTo(1.0, 0.001));
      });

      test('math.cos deve calcular cosseno', () {
        final func = stdlib.getFunction('math.cos');
        expect(func, isNotNull);
        final result = func!.call([0.0]);
        expect(result, equals(1.0));
      });

      test('math.tan deve calcular tangente', () {
        final func = stdlib.getFunction('math.tan');
        expect(func, isNotNull);
        final result = func!.call([0.0]);
        expect(result, equals(0.0));
      });
    });

    group('String Functions', () {
      test('string.tamanho deve existir', () {
        final func = stdlib.getFunction('string.tamanho');
        expect(func, isNotNull);
      });

      test('string.maiuscula deve existir', () {
        final func = stdlib.getFunction('string.maiuscula');
        expect(func, isNotNull);
      });

      test('string.minuscula deve existir', () {
        final func = stdlib.getFunction('string.minuscula');
        expect(func, isNotNull);
      });

      test('string.contains deve existir', () {
        final func = stdlib.getFunction('string.contains');
        expect(func, isNotNull);
      });
    });

    group('Type Conversion Functions', () {
      test('convert.paraInteiro deve existir', () {
        final func = stdlib.getFunction('convert.paraInteiro');
        expect(func, isNotNull);
      });

      test('convert.paraReal deve existir', () {
        final func = stdlib.getFunction('convert.paraReal');
        expect(func, isNotNull);
      });

      test('convert.paraTexto deve existir', () {
        final func = stdlib.getFunction('convert.paraTexto');
        expect(func, isNotNull);
      });

      test('convert.paraLogico deve existir', () {
        final func = stdlib.getFunction('convert.paraLogico');
        expect(func, isNotNull);
      });
    });

    group('I/O Functions', () {
      test('io.lerTexto deve existir', () {
        final func = stdlib.getFunction('io.lerTexto');
        expect(func, isNotNull);
      });

      test('io.lerInteiro deve existir', () {
        final func = stdlib.getFunction('io.lerInteiro');
        expect(func, isNotNull);
      });
    });

    group('Utility Functions', () {
      test('util.aleatorio deve existir', () {
        final func = stdlib.getFunction('util.aleatorio');
        expect(func, isNotNull);
      });

      test('util.aleatorioInteiro deve existir', () {
        final func = stdlib.getFunction('util.aleatorioInteiro');
        expect(func, isNotNull);
      });

      test('util.tempo deve existir', () {
        final func = stdlib.getFunction('util.tempo');
        expect(func, isNotNull);
      });
    });

    group('Error Handling', () {
      test('deve retornar null para função inexistente', () {
        final func = stdlib.getFunction('funcao.inexistente');
        expect(func, isNull);
      });

      test('deve lançar exceção para número incorreto de argumentos', () {
        final func = stdlib.getFunction('math.sqrt');
        expect(func, isNotNull);
        expect(() => func!.call([]), throwsException);
        expect(() => func!.call([4.0, 5.0]), throwsException);
      });
    });

    group('Function Registration', () {
      test('deve permitir verificar se função existe', () {
        expect(stdlib.hasFunction('math.sqrt'), isTrue);
        expect(stdlib.hasFunction('funcao.inexistente'), isFalse);
      });

      test('deve listar todas as funções disponíveis', () {
        final functions = stdlib.listFunctions();
        expect(functions, isNotEmpty);
        expect(functions, contains('math.sqrt'));
        expect(functions, contains('math.pow'));
      });

      test('deve permitir registro de nova função', () {
        stdlib.register('teste.dobrar', 1, (args) => (args[0] as num) * 2);
        expect(stdlib.hasFunction('teste.dobrar'), isTrue);

        final func = stdlib.getFunction('teste.dobrar');
        expect(func, isNotNull);
        expect(func!.call([5]), equals(10));
      });
    });
  });
}
