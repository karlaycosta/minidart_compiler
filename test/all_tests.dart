import 'package:test/test.dart';

// Importar todos os grupos de teste
import 'unit/lexer_test.dart' as lexer_tests;
import 'unit/parser_test.dart' as parser_tests;
import 'unit/semantic_analyzer_test.dart' as semantic_tests;
import 'unit/vm_test.dart' as vm_tests;
import 'unit/standard_library_test.dart' as stdlib_tests;
import 'integration/compiler_integration_test.dart' as integration_tests;
import 'integration/examples_test.dart' as examples_tests;

void main() {
  group('LiPo Compiler Test Suite', () {
    // Testes unitários
    group('Unit Tests', () {
      lexer_tests.main();
      parser_tests.main();
      semantic_tests.main();
      vm_tests.main();
      stdlib_tests.main();
    });

    // Testes de integração
    group('Integration Tests', () {
      integration_tests.main();
      examples_tests.main();
    });
  });
}
