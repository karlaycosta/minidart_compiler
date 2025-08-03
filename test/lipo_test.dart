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
    
    group('8. Testes das Bibliotecas Padrão', () {
      testStandardLibraries();
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
      // Capturar a primeira mensagem de erro detalhada
      final errorMessage = errorReporter.errors.isNotEmpty 
          ? errorReporter.errors.first 
          : "Erro léxico";
      return ExecutionResult(false, "", errorMessage);
    }
    
    // Análise sintática
    final parser = Parser(tokens, errorReporter);
    final statements = parser.parse();
    
    if (errorReporter.hadError) {
      // Capturar a primeira mensagem de erro detalhada
      final errorMessage = errorReporter.errors.isNotEmpty 
          ? errorReporter.errors.first 
          : "Erro sintático";
      return ExecutionResult(false, "", errorMessage);
    }
    
    // Análise semântica
    final analyzer = SemanticAnalyzer(errorReporter);
    analyzer.analyze(statements);
    
    if (errorReporter.hadError) {
      // Capturar a primeira mensagem de erro detalhada
      final errorMessage = errorReporter.errors.isNotEmpty 
          ? errorReporter.errors.first 
          : "Erro semântico";
      return ExecutionResult(false, "", errorMessage);
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

/// Testa as bibliotecas padrão (math, string, data, io)
void testStandardLibraries() {
  group('Biblioteca Math', () {
    test('Deve executar funções básicas de math', () {
      const source = '''
        importar math;
        imprima "PI: " + paraTexto(math.pi);
        imprima "Raiz de 25: " + paraTexto(math.raiz(25));
        imprima "Absoluto de -10: " + paraTexto(math.abs(-10));
        imprima "Potência 2^3: " + paraTexto(math.pow(2, 3));
        retorne 0;
      ''';
      
      final result = _executeCode(source);
      expect(result.success, isTrue);
      expect(result.output, contains('PI: 3.14'));
      expect(result.output, contains('Raiz de 25: 5'));
      expect(result.output, contains('Absoluto de -10: 10'));
      expect(result.output, contains('Potência 2^3: 8'));
    });

    test('Deve executar funções trigonométricas', () {
      const source = '''
        importar math;
        imprima "Sen(0): " + paraTexto(math.sin(0));
        imprima "Cos(0): " + paraTexto(math.cos(0));
        imprima "Tan(0): " + paraTexto(math.tan(0));
        retorne 0;
      ''';
      
      final result = _executeCode(source);
      expect(result.success, isTrue);
      expect(result.output, contains('Sen(0): 0'));
      expect(result.output, contains('Cos(0): 1'));
      expect(result.output, contains('Tan(0): 0'));
    });

    test('Deve executar funções de arredondamento', () {
      const source = '''
        importar math;
        imprima "Teto de 3.2: " + paraTexto(math.ceil(3.2));
        imprima "Piso de 3.8: " + paraTexto(math.floor(3.8));
        imprima "Arredondar 3.6: " + paraTexto(math.round(3.6));
        retorne 0;
      ''';
      
      final result = _executeCode(source);
      expect(result.success, isTrue);
      expect(result.output, contains('Teto de 3.2: 4'));
      expect(result.output, contains('Piso de 3.8: 3'));
      expect(result.output, contains('Arredondar 3.6: 4'));
    });

    test('Deve executar funções de comparação', () {
      const source = '''
        importar math;
        imprima "Máximo entre 5 e 8: " + paraTexto(math.max(5, 8));
        imprima "Mínimo entre 5 e 8: " + paraTexto(math.min(5, 8));
        retorne 0;
      ''';
      
      final result = _executeCode(source);
      expect(result.success, isTrue);
      expect(result.output, contains('Máximo entre 5 e 8: 8'));
      expect(result.output, contains('Mínimo entre 5 e 8: 5'));
    });

    test('Deve acessar constantes matemáticas', () {
      const source = '''
        importar math;
        imprima "E: " + paraTexto(math.E);
        imprima "PI: " + paraTexto(math.PI);
        retorne 0;
      ''';
      
      final result = _executeCode(source);
      expect(result.success, isTrue);
      expect(result.output, contains('E: 2.71'));
      expect(result.output, contains('PI: 3.14'));
    });
  });

  group('Biblioteca String', () {
    test('Deve executar transformações de string', () {
      const source = '''
        importar string como s;
        texto teste = "Olá Mundo";
        imprima "Original: " + teste;
        imprima "Maiúscula: " + s.maiuscula(teste);
        imprima "Minúscula: " + s.minuscula(teste);
        imprima "Tamanho: " + paraTexto(s.tamanho(teste));
        retorne 0;
      ''';
      
      final result = _executeCode(source);
      expect(result.success, isTrue);
      expect(result.output, contains('Original: Olá Mundo'));
      expect(result.output, contains('Maiúscula: OLÁ MUNDO'));
      expect(result.output, contains('Minúscula: olá mundo'));
      expect(result.output, contains('Tamanho: 9'));
    });

    test('Deve executar verificações de string', () {
      const source = '''
        importar string como s;
        texto teste = "Hello World";
        imprima "Está vazio? " + paraTexto(s.vazio(teste));
        imprima "Contém 'World'? " + paraTexto(s.contem(teste, "World"));
        imprima "Começa com 'Hello'? " + paraTexto(s.comecaCom(teste, "Hello"));
        imprima "Termina com 'World'? " + paraTexto(s.terminaCom(teste, "World"));
        retorne 0;
      ''';
      
      final result = _executeCode(source);
      expect(result.success, isTrue);
      expect(result.output, contains('Está vazio? falso'));
      expect(result.output, contains('Contém \'World\'? verdadeiro'));
      expect(result.output, contains('Começa com \'Hello\'? verdadeiro'));
      expect(result.output, contains('Termina com \'World\'? verdadeiro'));
    });

    test('Deve executar operações de busca e manipulação', () {
      const source = '''
        importar string como s;
        texto original = "banana";
        imprima "Encontrar 'na': " + paraTexto(s.encontrar(original, "na"));
        imprima "Repetir 3x: " + s.repetir("ABC", 3);
        imprima "Concatenar: " + s.concatenar("Hello", " World");
        retorne 0;
      ''';
      
      final result = _executeCode(source);
      expect(result.success, isTrue);
      expect(result.output, contains('Encontrar \'na\': 2'));
      expect(result.output, contains('Repetir 3x: ABCABCABC'));
      expect(result.output, contains('Concatenar: Hello World'));
    });
  });

  group('Biblioteca Data', () {
    test('Deve executar funções de data básicas', () {
      const source = '''
        importar data;
        imprima "Data atual: " + data.dataAtual();
        imprima "Hora atual: " + data.horaAtual();
        imprima "Hoje: " + data.hoje();
        retorne 0;
      ''';
      
      final result = _executeCode(source);
      expect(result.success, isTrue);
      expect(result.output, contains('Data atual: 2025'));
      expect(result.output, contains('Hora atual:'));
      expect(result.output, contains('Hoje: 2025'));
    });

    test('Deve executar operações com datas', () {
      const source = '''
        importar data;
        texto dataHoje = data.hoje();
        imprima "Dia da semana: " + paraTexto(data.diaSemana(dataHoje));
        imprima "2024 é bissexto? " + paraTexto(data.ehBissexto(2024));
        imprima "2023 é bissexto? " + paraTexto(data.ehBissexto(2023));
        imprima "Nome do mês 12: " + data.nomeMes(12);
        retorne 0;
      ''';
      
      final result = _executeCode(source);
      expect(result.success, isTrue);
      expect(result.output, contains('Dia da semana:'));
      expect(result.output, contains('2024 é bissexto? verdadeiro'));
      expect(result.output, contains('2023 é bissexto? falso'));
      expect(result.output, contains('Nome do mês 12: Dezembro'));
    });

    test('Deve validar e manipular datas', () {
      const source = '''
        importar data;
        imprima "Data válida? " + paraTexto(data.ehDataValida("2025-08-02"));
        imprima "Data inválida? " + paraTexto(data.ehDataValida("invalid"));
        imprima "Adicionar 7 dias: " + data.adicionarDias("2025-01-01", 7);
        retorne 0;
      ''';
      
      final result = _executeCode(source);
      expect(result.success, isTrue);
      expect(result.output, contains('Data válida? verdadeiro'));
      expect(result.output, contains('Data inválida? falso'));
      expect(result.output, contains('Adicionar 7 dias: 2025-01-08'));
    });

    test('Deve trabalhar com timestamps', () {
      const source = '''
        importar data;
        inteiro timestamp = data.timestamp();
        imprima "Timestamp gerado: " + paraTexto(timestamp > 1700000000);
        texto dataRecuperada = data.deTimestamp(1609459200); // 2021-01-01
        imprima "Data recuperada: " + dataRecuperada;
        retorne 0;
      ''';
      
      final result = _executeCode(source);
      expect(result.success, isTrue);
      expect(result.output, contains('Timestamp gerado: verdadeiro'));
      expect(result.output, contains('Data recuperada:'));
    });
  });

  group('Biblioteca IO', () {
    test('Deve executar operações de saída', () {
      const source = '''
        importar io;
        io.imprimir("Escrevendo texto");
        io.novaLinha();
        imprima "Teste finalizado";
        retorne 0;
      ''';
      
      final result = _executeCode(source);
      expect(result.success, isTrue);
      expect(result.output, contains('Escrevendo texto'));
      expect(result.output, contains('Teste finalizado'));
    });

    test('Deve simular operações de entrada', () {
      const source = '''
        importar io;
        texto entrada = io.lerTexto();
        inteiro numero = io.lerNumero();
        imprima "Texto lido: " + entrada;
        imprima "Número lido: " + paraTexto(numero);
        retorne 0;
      ''';
      
      final result = _executeCode(source);
      expect(result.success, isTrue);
      expect(result.output, contains('Texto lido: entrada_do_usuario'));
      expect(result.output, contains('Número lido: 42'));
    });
  });

  group('Testes de Integração de Bibliotecas', () {
    test('Deve usar múltiplas bibliotecas em conjunto', () {
      const source = '''
        importar math;
        importar string como s;
        importar data;
        
        real valor = math.raiz(16);
        texto resultado = s.maiuscula("resultado: " + paraTexto(valor));
        
        imprima resultado;
        imprima "Data do teste: " + data.hoje();
        texto piFormatado = s.maiuscula(paraTexto(math.pi));
        imprima "PI formatado: " + piFormatado;
        
        retorne 0;
      ''';
      
      final result = _executeCode(source);
      expect(result.success, isTrue);
      expect(result.output, contains('RESULTADO: 4'));
      expect(result.output, contains('Data do teste: 2025'));
      expect(result.output, contains('PI formatado: 3.141'));
    });

    test('Deve validar tipos de retorno das bibliotecas', () {
      const source = '''
        importar math;
        importar string como s;
        importar data;
        importar io;
        
        // Testando inferência de tipos
        real piValue = math.pi;
        inteiro tamTexto = s.tamanho("teste");
        texto dataAtual = data.hoje();
        logico bissexto = data.ehBissexto(2024);
        
        imprima "PI: " + paraTexto(piValue);
        imprima "Tamanho: " + paraTexto(tamTexto);
        imprima "Data: " + dataAtual;
        imprima "Bissexto: " + paraTexto(bissexto);
        
        retorne 0;
      ''';
      
      final result = _executeCode(source);
      expect(result.success, isTrue);
      expect(result.output, contains('PI: 3.14'));
      expect(result.output, contains('Tamanho: 5'));
      expect(result.output, contains('Data: 2025'));
      expect(result.output, contains('Bissexto: verdadeiro'));
    });

    test('Deve funcionar com aliases de bibliotecas', () {
      const source = '''
        importar math como m;
        importar string como str;
        importar data como dt;
        
        imprima "Math alias: " + paraTexto(m.abs(-5));
        imprima "String alias: " + str.maiuscula("hello");
        imprima "Data alias: " + dt.nomeMes(1);
        
        retorne 0;
      ''';
      
      final result = _executeCode(source);
      expect(result.success, isTrue);
      expect(result.output, contains('Math alias: 5'));
      expect(result.output, contains('String alias: HELLO'));
      expect(result.output, contains('Data alias: Janeiro'));
    });
  });

  group('Testes de Validação Semântica das Bibliotecas', () {
    test('Deve rejeitar uso de biblioteca não importada', () {
      const source = '''
        // Sem importar math
        imprima "PI: " + paraTexto(math.pi);
        retorne 0;
      ''';
      
      final result = _executeCode(source);
      expect(result.success, isFalse);
      expect(result.error, isNotEmpty);
    });

    test('Deve rejeitar métodos inexistentes', () {
      const source = '''
        importar math;
        imprima "Função inexistente: " + paraTexto(math.funcaoInexistente());
        retorne 0;
      ''';
      
      final result = _executeCode(source);
      expect(result.success, isFalse);
      expect(result.error, contains('não reconhecido'));
    });

    test('Deve rejeitar número incorreto de argumentos', () {
      const source = '''
        importar math;
        imprima "Sem argumentos: " + paraTexto(math.abs());
        retorne 0;
      ''';
      
      final result = _executeCode(source);
      expect(result.success, isFalse);
      expect(result.error, contains('requer exatamente um argumento'));
    });

    test('Deve rejeitar argumentos em propriedades', () {
      const source = '''
        importar math;
        imprima "Com argumentos: " + paraTexto(math.pi(5));
        retorne 0;
      ''';
      
      final result = _executeCode(source);
      expect(result.success, isFalse);
      expect(result.error, contains('não aceita argumentos'));
    });

    test('Deve validar tipos de retorno corretamente', () {
      const source = '''
        importar math;
        importar string como s;
        
        // Estas atribuições devem ser válidas
        real piValue = math.pi;
        inteiro tamanhoString = s.tamanho("teste");
        logico stringVazia = s.vazio("");
        
        imprima "Validação OK";
        retorne 0;
      ''';
      
      final result = _executeCode(source);
      expect(result.success, isTrue);
      expect(result.output, contains('Validação OK'));
    });
  });
}
