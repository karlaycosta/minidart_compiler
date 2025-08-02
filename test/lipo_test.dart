import 'package:test/test.dart';
import 'package:lipo_compiler/src/lexer.dart';
import 'package:lipo_compiler/src/parser.dart';
import 'package:lipo_compiler/src/semantic_analyzer.dart';
import 'package:lipo_compiler/src/code_generator.dart';
import 'package:lipo_compiler/src/vm.dart';
import 'package:lipo_compiler/src/error.dart';
import 'package:lipo_compiler/src/token.dart';
import 'package:lipo_compiler/src/ast.dart';

void main() {
  group('Linguagem LiPo - Testes de Integridade', () {
    
    group('1. Testes do Lexer', () {
      testLexer();
    });
    
    group('2. Testes do Parser', () {
      testParser();
    });
    
    group('3. Testes do Analisador Semântico', () {
      testSemanticAnalyzer();
    });
    
    group('4. Testes do Gerador de Código', () {
      testCodeGenerator();
    });
    
    group('5. Testes da VM', () {
      testVM();
    });
    
    group('6. Testes de Integração End-to-End', () {
      testEndToEnd();
    });
    
    group('7. Testes de Regressão', () {
      testRegression();
    });
  });
}

/// Testa o analisador léxico
void testLexer() {
  test('Deve tokenizar tipos básicos corretamente', () {
    const source = 'inteiro real texto logico';
    final errorReporter = ErrorReporter();
    final lexer = Lexer(source, errorReporter);
    final tokens = lexer.scanTokens();
    
    expect(tokens.length, 5); // 4 tokens + EOF
    expect(tokens[0].type, TokenType.inteiro);
    expect(tokens[1].type, TokenType.real);
    expect(tokens[2].type, TokenType.texto);
    expect(tokens[3].type, TokenType.logico);
    expect(tokens[4].type, TokenType.eof);
  });
  
  test('Deve tokenizar operadores lógicos', () {
    const source = 'e ou !';
    final errorReporter = ErrorReporter();
    final lexer = Lexer(source, errorReporter);
    final tokens = lexer.scanTokens();
    
    expect(tokens[0].type, TokenType.and);
    expect(tokens[1].type, TokenType.or);
    expect(tokens[2].type, TokenType.bang);
  });
  
  test('Deve tokenizar números corretamente', () {
    const source = '42 3.14 0';
    final errorReporter = ErrorReporter();
    final lexer = Lexer(source, errorReporter);
    final tokens = lexer.scanTokens();
    
    expect(tokens[0].type, TokenType.number);
    expect(tokens[0].literal, 42);
    expect(tokens[1].type, TokenType.number);
    expect(tokens[1].literal, 3.14);
    expect(tokens[2].type, TokenType.number);
    expect(tokens[2].literal, 0);
  });
  
  test('Deve tokenizar strings corretamente', () {
    const source = '"Olá Mundo" "Teste"';
    final errorReporter = ErrorReporter();
    final lexer = Lexer(source, errorReporter);
    final tokens = lexer.scanTokens();
    
    expect(tokens[0].type, TokenType.string);
    expect(tokens[0].literal, "Olá Mundo");
    expect(tokens[1].type, TokenType.string);
    expect(tokens[1].literal, "Teste");
  });
  
  test('Deve tokenizar palavras-chave em português', () {
    const source = 'se senao enquanto para verdadeiro falso';
    final errorReporter = ErrorReporter();
    final lexer = Lexer(source, errorReporter);
    final tokens = lexer.scanTokens();
    
    expect(tokens[0].type, TokenType.if_);
    expect(tokens[1].type, TokenType.else_);
    expect(tokens[2].type, TokenType.while_);
    expect(tokens[3].type, TokenType.for_);
    expect(tokens[4].type, TokenType.true_);
    expect(tokens[5].type, TokenType.false_);
  });
}

/// Testa o analisador sintático
void testParser() {
  test('Deve parsear declaração de variável simples', () {
    const source = 'inteiro x = 42;';
    final errorReporter = ErrorReporter();
    final lexer = Lexer(source, errorReporter);
    final tokens = lexer.scanTokens();
    final parser = Parser(tokens, errorReporter);
    final statements = parser.parse();
    
    expect(statements.length, 1);
    expect(statements[0], isA<TypedVarDeclStmt>());
  });
  
  test('Deve parsear expressão ternária', () {
    const source = 'inteiro resultado = (x > 5) ? 10 : 20;';
    final errorReporter = ErrorReporter();
    final lexer = Lexer(source, errorReporter);
    final tokens = lexer.scanTokens();
    final parser = Parser(tokens, errorReporter);
    final statements = parser.parse();
    
    expect(statements.length, 1);
    final varDecl = statements[0] as TypedVarDeclStmt;
    expect(varDecl.initializer, isA<TernaryExpr>());
  });
  
  test('Deve parsear lista literal', () {
    const source = 'lista<inteiro> nums = [1, 2, 3];';
    final errorReporter = ErrorReporter();
    final lexer = Lexer(source, errorReporter);
    final tokens = lexer.scanTokens();
    final parser = Parser(tokens, errorReporter);
    final statements = parser.parse();
    
    expect(statements.length, 1);
    final listDecl = statements[0] as ListDeclStmt;
    expect(listDecl.initializer, isA<ListLiteralExpr>());
  });
  
  test('Deve parsear import com alias', () {
    const source = 'importar math como m;';
    final errorReporter = ErrorReporter();
    final lexer = Lexer(source, errorReporter);
    final tokens = lexer.scanTokens();
    final parser = Parser(tokens, errorReporter);
    final statements = parser.parse();
    
    expect(statements.length, 1);
    final importStmt = statements[0] as ImportStmt;
    expect(importStmt.library.lexeme, 'math');
    expect(importStmt.alias?.lexeme, 'm');
  });
}

/// Testa o analisador semântico
void testSemanticAnalyzer() {
  test('Deve detectar erro de tipo em atribuição', () {
    const source = 'inteiro x = "texto";';
    final errorReporter = ErrorReporter();
    final lexer = Lexer(source, errorReporter);
    final tokens = lexer.scanTokens();
    final parser = Parser(tokens, errorReporter);
    final statements = parser.parse();
    final analyzer = SemanticAnalyzer(errorReporter);
    
    analyzer.analyze(statements);
    
    expect(errorReporter.hadError, true);
  });
  
  test('Deve aceitar tipos compatíveis', () {
    const source = 'inteiro x = 42; real y = x;';
    final errorReporter = ErrorReporter();
    final lexer = Lexer(source, errorReporter);
    final tokens = lexer.scanTokens();
    final parser = Parser(tokens, errorReporter);
    final statements = parser.parse();
    final analyzer = SemanticAnalyzer(errorReporter);
    
    analyzer.analyze(statements);
    
    expect(errorReporter.hadError, false);
  });
  
  test('Deve validar métodos de módulos importados', () {
    const source = '''
    importar math;
    real resultado = math.raiz(16);
    ''';
    final errorReporter = ErrorReporter();
    final lexer = Lexer(source, errorReporter);
    final tokens = lexer.scanTokens();
    final parser = Parser(tokens, errorReporter);
    final statements = parser.parse();
    final analyzer = SemanticAnalyzer(errorReporter);
    
    analyzer.analyze(statements);
    
    expect(errorReporter.hadError, false);
  });
  
  test('Deve detectar método inválido de módulo', () {
    const source = '''
    importar math;
    real resultado = math.metodoInexistente(16);
    ''';
    final errorReporter = ErrorReporter();
    final lexer = Lexer(source, errorReporter);
    final tokens = lexer.scanTokens();
    final parser = Parser(tokens, errorReporter);
    final statements = parser.parse();
    final analyzer = SemanticAnalyzer(errorReporter);
    
    analyzer.analyze(statements);
    
    expect(errorReporter.hadError, true);
  });
}

/// Testa o gerador de código
void testCodeGenerator() {
  test('Deve gerar bytecode para operação aritmética simples', () {
    const source = 'inteiro resultado = 5 + 3;';
    final errorReporter = ErrorReporter();
    final lexer = Lexer(source, errorReporter);
    final tokens = lexer.scanTokens();
    final parser = Parser(tokens, errorReporter);
    final statements = parser.parse();
    final analyzer = SemanticAnalyzer(errorReporter);
    analyzer.analyze(statements);
    
    final generator = CodeGenerator();
    final chunk = generator.compile(statements);
    
    expect(chunk.code.isNotEmpty, true);
  });
  
  test('Deve gerar bytecode para operadores lógicos', () {
    const source = 'logico resultado = verdadeiro e falso;';
    final errorReporter = ErrorReporter();
    final lexer = Lexer(source, errorReporter);
    final tokens = lexer.scanTokens();
    final parser = Parser(tokens, errorReporter);
    final statements = parser.parse();
    final analyzer = SemanticAnalyzer(errorReporter);
    analyzer.analyze(statements);
    
    final generator = CodeGenerator();
    final chunk = generator.compile(statements);
    
    expect(chunk.code.isNotEmpty, true);
  });
}

/// Testa a máquina virtual
void testVM() {
  test('Deve executar programa simples sem erros', () {
    const source = 'imprima "Olá Mundo";';
    final result = _executeCode(source);
    
    expect(result.success, true);
    expect(result.output, contains("Olá Mundo"));
  });
  
  test('Deve executar operações aritméticas', () {
    const source = '''
    inteiro a = 10;
    inteiro b = 5;
    inteiro resultado = a + b;
    imprima paraTexto(resultado);
    ''';
    final result = _executeCode(source);
    
    expect(result.success, true);
    expect(result.output, contains("15"));
  });
  
  test('Deve executar operadores lógicos corretamente', () {
    const source = '''
    logico verdade = verdadeiro;
    logico mentira = falso;
    logico resultado = verdade ou mentira;
    imprima paraTexto(resultado);
    ''';
    final result = _executeCode(source);
    
    expect(result.success, true);
    expect(result.output, contains("verdadeiro"));
  });
  
  test('Deve executar funções de módulos', () {
    const source = '''
    importar math;
    real resultado = math.raiz(16);
    imprima paraTexto(resultado);
    ''';
    final result = _executeCode(source);
    
    expect(result.success, true);
    expect(result.output, contains("4"));
  });
}

/// Testa integração completa end-to-end
void testEndToEnd() {
  test('Deve executar programa completo com todas as funcionalidades', () {
    const source = '''
    // Variáveis
    inteiro idade = 25;
    texto nome = "LiPo";
    logico ativo = verdadeiro;
    
    // Lista
    lista<inteiro> numeros = [1, 2, 3];
    numeros.adicionar(4);
    
    // Função
    inteiro soma(inteiro a, inteiro b) {
      retorne a + b;
    }
    
    // Imports
    importar math;
    real raiz = math.raiz(16);
    
    // Estruturas de controle
    se (idade >= 18) {
      imprima "Maior de idade";
    }
    
    // Operadores
    logico resultado = ativo e (idade > 20);
    inteiro somaResult = soma(10, 5);
    
    imprima "Teste completo executado";
    ''';
    
    final result = _executeCode(source);
    
    expect(result.success, true);
    expect(result.output, contains("Maior de idade"));
    expect(result.output, contains("Teste completo executado"));
  });
}

/// Testes de regressão para bugs conhecidos
void testRegression() {
  test('Bug #1: Operadores lógicos não devem causar stack underflow', () {
    const source = '''
    logico verdade = verdadeiro;
    logico mentira = falso;
    logico resultado1 = verdade e mentira;
    logico resultado2 = verdade ou mentira;
    imprima "Operadores lógicos funcionando";
    ''';
    
    final result = _executeCode(source);
    
    expect(result.success, true);
    expect(result.output, contains("Operadores lógicos funcionando"));
  });
  
  test('Bug #2: Operador ternário deve funcionar com tipos diferentes', () {
    const source = '''
    inteiro dia = 3;
    texto resultado = (dia >= 6) ? "fim de semana" : "dia útil";
    imprima resultado;
    ''';
    
    final result = _executeCode(source);
    
    expect(result.success, true);
    expect(result.output, contains("dia útil"));
  });
  
  test('Bug #3: Increment/decrement deve funcionar com variáveis locais', () {
    const source = '''
    inteiro contador = 0;
    contador++;
    imprima paraTexto(contador);
    ''';
    
    final result = _executeCode(source);
    
    expect(result.success, true);
    expect(result.output, contains("1"));
  });
  
  test('Bug #4: Funções de biblioteca padrão devem funcionar em contexto de função', () {
    const source = '''
    inteiro testeParaTexto() {
      texto resultado = paraTexto(42);
      imprima resultado;
      retorne 1;
    }
    
    inteiro x = testeParaTexto();
    ''';
    
    final result = _executeCode(source);
    
    expect(result.success, true);
    expect(result.output, contains("42"));
  });
  
  test('Bug #5: Inferência de tipo de lista deve funcionar corretamente', () {
    const source = '''
    inteiro processarLista(lista<inteiro> nums) {
      retorne nums.tamanho();
    }
    
    lista<inteiro> minhaLista = [1, 2, 3];
    inteiro resultado = processarLista(minhaLista);
    imprima paraTexto(resultado);
    ''';
    
    final result = _executeCode(source);
    
    expect(result.success, true);
    expect(result.output, contains("3"));
  });
}

/// Classe para resultado de execução de código
class ExecutionResult {
  final bool success;
  final String output;
  final String? error;
  
  ExecutionResult(this.success, this.output, [this.error]);
}

/// Executa código LiPo e retorna o resultado
ExecutionResult _executeCode(String source) {
  try {
    final errorReporter = ErrorReporter();
    
    // Análise léxica
    final lexer = Lexer(source, errorReporter);
    final tokens = lexer.scanTokens();
    
    if (errorReporter.hadError) {
      return ExecutionResult(false, "", "Erro léxico");
    }
    
    // Análise sintática
    final parser = Parser(tokens, errorReporter);
    final statements = parser.parse();
    
    if (errorReporter.hadError) {
      return ExecutionResult(false, "", "Erro sintático");
    }
    
    // Análise semântica
    final analyzer = SemanticAnalyzer(errorReporter);
    analyzer.analyze(statements);
    
    if (errorReporter.hadError) {
      return ExecutionResult(false, "", "Erro semântico");
    }
    
    // Geração de código
    final generator = CodeGenerator();
    final chunk = generator.compile(statements);
    
    // Execução com captura de saída
    final output = <String>[];
    final vm = VM(printCallback: (String text) {
      output.add(text);
    });
    
    final result = vm.interpret(chunk);
    
    if (result == InterpretResult.ok) {
      return ExecutionResult(true, output.join('\n'));
    } else {
      return ExecutionResult(false, output.join('\n'), "Erro de execução");
    }
  } catch (e) {
    return ExecutionResult(false, "", e.toString());
  }
}
