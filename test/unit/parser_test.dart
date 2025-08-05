import 'package:test/test.dart';
import 'package:lipo_compiler/src/ast.dart';
import 'package:lipo_compiler/src/token.dart';
import '../test_helper.dart';

void main() {
  group('Parser Tests', () {
    test('deve parsear declaração de variável simples', () {
      final statements = TestHelper.parse('var x = 10;');
      expect(statements.length, 1);
      expect(statements[0], isA<VarDeclStmt>());

      final varDecl = statements[0] as VarDeclStmt;
      expect(varDecl.name.lexeme, 'x');
      expect(varDecl.initializer, isA<LiteralExpr>());
    });

    test('deve parsear declaração tipada', () {
      final statements = TestHelper.parse('inteiro idade = 25;');
      expect(statements[0], isA<TypedVarDeclStmt>());

      final typedDecl = statements[0] as TypedVarDeclStmt;
      expect(typedDecl.name.lexeme, 'idade');
      expect(typedDecl.type.type.type, TokenType.inteiro);
    });

    test('deve parsear declaração de constante', () {
      final statements = TestHelper.parse('constante inteiro PI = 3;');
      expect(statements[0], isA<ConstDeclStmt>());

      final constDecl = statements[0] as ConstDeclStmt;
      expect(constDecl.name.lexeme, 'PI');
      expect(constDecl.type.type.type, TokenType.inteiro);
    });

    test('deve parsear estrutura condicional', () {
      final statements = TestHelper.parse('''
        se (x > 0) {
          imprimir("positivo");
        } senao {
          imprimir("negativo");
        }
      ''');

      expect(statements[0], isA<IfStmt>());
      final ifStmt = statements[0] as IfStmt;
      expect(ifStmt.condition, isA<BinaryExpr>());
      expect(ifStmt.thenBranch, isA<BlockStmt>());
      expect(ifStmt.elseBranch, isA<BlockStmt>());
    });

    test('deve parsear função com parâmetros tipados', () {
      final statements = TestHelper.parse('''
        funcao inteiro somar(inteiro a, inteiro b) {
          retornar a + b;
        }
      ''');

      expect(statements[0], isA<FunctionStmt>());
      final funcStmt = statements[0] as FunctionStmt;
      expect(funcStmt.name.lexeme, 'somar');
      expect(funcStmt.params.length, 2);
      expect(funcStmt.returnType?.type.type, TokenType.inteiro);
    });

    test('deve parsear loop enquanto', () {
      final statements = TestHelper.parse('''
        var i = 0;
        enquanto (i < 10) {
          i = i + 1;
        }
      ''');

      expect(statements.length, 2);
      expect(statements[1], isA<WhileStmt>());
    });

    test('deve parsear expressões binárias', () {
      final statements = TestHelper.parse('var resultado = 10 + 5 * 2;');
      final varDecl = statements[0] as VarDeclStmt;
      expect(varDecl.initializer, isA<BinaryExpr>());
    });

    test('deve parsear chamadas de função', () {
      final statements = TestHelper.parse('var resultado = somar(10, 20);');
      final varDecl = statements[0] as VarDeclStmt;
      expect(varDecl.initializer, isA<CallExpr>());
    });

    test('deve parsear expressões de atribuição', () {
      final statements = TestHelper.parse('x = 42;');
      expect(statements[0], isA<ExpressionStmt>());

      final exprStmt = statements[0] as ExpressionStmt;
      expect(exprStmt.expression, isA<AssignExpr>());
    });

    test('deve parsear declarações de impressão', () {
      final statements = TestHelper.parse('imprimir("Hello World");');
      expect(statements[0], isA<PrintStmt>());
    });

    test('deve parsear estrutura de bloco', () {
      final statements = TestHelper.parse('''
        {
          var x = 10;
          var y = 20;
          imprimir(x + y);
        }
      ''');

      expect(statements[0], isA<BlockStmt>());
      final blockStmt = statements[0] as BlockStmt;
      expect(blockStmt.statements.length, 3);
    });

    test('deve parsear estrutura se sem senao', () {
      final statements = TestHelper.parse('''
        se (x > 0) {
          imprimir("positivo");
        }
      ''');

      expect(statements[0], isA<IfStmt>());
      final ifStmt = statements[0] as IfStmt;
      expect(ifStmt.condition, isNotNull);
      expect(ifStmt.thenBranch, isNotNull);
      expect(ifStmt.elseBranch, isNull);
    });

    test('deve parsear retorno de função', () {
      final statements = TestHelper.parse('retornar 42;');
      expect(statements[0], isA<ReturnStmt>());

      final returnStmt = statements[0] as ReturnStmt;
      expect(returnStmt.value, isA<LiteralExpr>());
    });

    test('deve parsear expressões de agrupamento', () {
      final statements = TestHelper.parse('var resultado = (10 + 5) * 2;');
      final varDecl = statements[0] as VarDeclStmt;
      expect(varDecl.initializer, isA<BinaryExpr>());
    });

    test('deve parsear números negativos', () {
      final statements = TestHelper.parse('var x = -42;');
      final varDecl = statements[0] as VarDeclStmt;
      expect(varDecl.initializer, isA<UnaryExpr>());
    });

    test('deve parsear expressões lógicas', () {
      final statements = TestHelper.parse(
        'var resultado = verdadeiro and falso;',
      );
      final varDecl = statements[0] as VarDeclStmt;
      expect(varDecl.initializer, isA<LogicalExpr>());
    });

    test('deve detectar erros de sintaxe básicos', () {
      expect(TestHelper.hasParseErrors('var x = ;'), isTrue);
      expect(TestHelper.hasParseErrors('se () {}'), isTrue);
      expect(TestHelper.hasParseErrors('funcao () {}'), isTrue);
    });

    test('deve detectar parênteses não balanceados', () {
      expect(TestHelper.hasParseErrors('var x = (10 + 5;'), isTrue);
      expect(TestHelper.hasParseErrors('var x = 10 + 5);'), isTrue);
    });

    test('deve detectar chaves não balanceadas', () {
      expect(
        TestHelper.hasParseErrors('se (verdadeiro) { var x = 10;'),
        isTrue,
      );
    });
  });
}
