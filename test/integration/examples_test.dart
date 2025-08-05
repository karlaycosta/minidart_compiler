import 'package:test/test.dart';
import 'dart:io';
import '../test_helper.dart';

void main() {
  group('Examples Tests', () {
    test('deve compilar exemplos básicos', () {
      final exampleFiles = [
        'test/fixtures/basic_test.lip',
        'test/fixtures/functions_test.lip',
        'test/fixtures/logical_operators_test.lip',
      ];

      for (final filePath in exampleFiles) {
        final file = File(filePath);
        if (file.existsSync()) {
          final source = file.readAsStringSync();

          // Verificar se não há erros de parsing
          expect(
            TestHelper.hasParseErrors(source),
            isFalse,
            reason: 'Erro de parsing no arquivo $filePath',
          );

          // Verificar se não há erros semânticos
          expect(
            TestHelper.hasSemanticErrors(source),
            isFalse,
            reason: 'Erro semântico no arquivo $filePath',
          );
        }
      }
    });

    test('programas válidos devem compilar sem erros', () {
      // Criar programas de teste válidos na pasta fixtures/valid_programs
      final validPrograms = [
        '''
        // Programa simples
        var x = 10;
        var y = 20;
        var soma = x + y;
        imprimir(soma);
        ''',
        '''
        // Função simples
        funcao inteiro dobrar(inteiro n) {
          retornar n * 2;
        }
        var resultado = dobrar(21);
        imprimir(resultado);
        ''',
        '''
        // Loop simples
        var i = 0;
        enquanto (i < 5) {
          imprimir(i);
          i = i + 1;
        }
        ''',
        '''
        // Condicional simples
        var idade = 18;
        se (idade >= 18) {
          imprimir("Maior de idade");
        } senao {
          imprimir("Menor de idade");
        }
        ''',
        '''
        // Constantes
        constante inteiro MAX = 100;
        constante texto MSG = "Hello";
        var valor = MAX / 2;
        imprimir(MSG);
        imprimir(valor);
        ''',
      ];

      for (int i = 0; i < validPrograms.length; i++) {
        final source = validPrograms[i];
        expect(
          TestHelper.hasParseErrors(source),
          isFalse,
          reason: 'Programa válido $i não deveria ter erros de parsing',
        );
        expect(
          TestHelper.hasSemanticErrors(source),
          isFalse,
          reason: 'Programa válido $i não deveria ter erros semânticos',
        );
      }
    });

    test('programas inválidos devem ser rejeitados', () {
      final invalidPrograms = [
        '''
        // Variável não declarada
        var x = variavelInexistente;
        ''',
        '''
        // Sintaxe inválida
        var x = 10 +;
        ''',
        '''
        // Redeclaração de variável
        var x = 10;
        var x = 20;
        ''',
        '''
        // Reatribuição de constante
        constante inteiro X = 10;
        X = 20;
        ''',
        '''
        // Função não declarada
        var x = funcaoInexistente(10);
        ''',
        '''
        // Número incorreto de argumentos
        funcao inteiro somar(inteiro a, inteiro b) {
          retornar a + b;
        }
        var x = somar(10);
        ''',
        '''
        // Retorno fora de função
        retornar 42;
        ''',
      ];

      for (int i = 0; i < invalidPrograms.length; i++) {
        final source = invalidPrograms[i];
        final hasParseError = TestHelper.hasParseErrors(source);
        final hasSemanticError = TestHelper.hasSemanticErrors(source);

        expect(
          hasParseError || hasSemanticError,
          isTrue,
          reason: 'Programa inválido $i deveria ser rejeitado',
        );
      }
    });

    test('deve criar arquivos de teste válidos', () {
      final validPrograms = {
        'test/fixtures/valid_programs/simple_var.lip': '''
var x = 10;
var y = 20;
var soma = x + y;
imprimir(soma);
''',
        'test/fixtures/valid_programs/simple_function.lip': '''
funcao inteiro dobrar(inteiro n) {
  retornar n * 2;
}
var resultado = dobrar(21);
imprimir(resultado);
''',
        'test/fixtures/valid_programs/while_loop.lip': '''
var i = 0;
enquanto (i < 5) {
  imprimir(i);
  i = i + 1;
}
''',
        'test/fixtures/valid_programs/if_else.lip': '''
var idade = 18;
se (idade >= 18) {
  imprimir("Maior de idade");
} senao {
  imprimir("Menor de idade");
}
''',
        'test/fixtures/valid_programs/constants.lip': '''
constante inteiro MAX = 100;
constante texto MSG = "Hello";
var valor = MAX / 2;
imprimir(MSG);
imprimir(valor);
''',
      };

      // Criar arquivos de teste para uso futuro
      validPrograms.forEach((path, content) {
        final file = File(path);
        file.parent.createSync(recursive: true);
        file.writeAsStringSync(content);
      });

      // Verificar se os arquivos foram criados e são válidos
      validPrograms.forEach((path, content) {
        final file = File(path);
        expect(file.existsSync(), isTrue);

        final source = file.readAsStringSync();
        expect(TestHelper.hasParseErrors(source), isFalse);
        expect(TestHelper.hasSemanticErrors(source), isFalse);
      });
    });

    test('deve criar arquivos de teste inválidos', () {
      final invalidPrograms = {
        'test/fixtures/invalid_programs/undefined_var.lip': '''
var x = variavelInexistente;
''',
        'test/fixtures/invalid_programs/syntax_error.lip': '''
var x = 10 +;
''',
        'test/fixtures/invalid_programs/redeclaration.lip': '''
var x = 10;
var x = 20;
''',
        'test/fixtures/invalid_programs/const_reassign.lip': '''
constante inteiro X = 10;
X = 20;
''',
        'test/fixtures/invalid_programs/undefined_function.lip': '''
var x = funcaoInexistente(10);
''',
        'test/fixtures/invalid_programs/wrong_args.lip': '''
funcao inteiro somar(inteiro a, inteiro b) {
  retornar a + b;
}
var x = somar(10);
''',
        'test/fixtures/invalid_programs/return_outside.lip': '''
retornar 42;
''',
      };

      // Criar arquivos de teste para uso futuro
      invalidPrograms.forEach((path, content) {
        final file = File(path);
        file.parent.createSync(recursive: true);
        file.writeAsStringSync(content);
      });

      // Verificar se os arquivos foram criados e são inválidos
      invalidPrograms.forEach((path, content) {
        final file = File(path);
        expect(file.existsSync(), isTrue);

        final source = file.readAsStringSync();
        final hasParseError = TestHelper.hasParseErrors(source);
        final hasSemanticError = TestHelper.hasSemanticErrors(source);

        expect(
          hasParseError || hasSemanticError,
          isTrue,
          reason: 'Arquivo $path deveria conter erros',
        );
      });
    });
  });
}
