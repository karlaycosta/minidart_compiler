import 'dart:io';
import 'package:minidart_compiler/src/lexer.dart';
import 'package:minidart_compiler/src/parser.dart';
import 'package:minidart_compiler/src/error.dart';
import 'package:minidart_compiler/src/semantic_analyzer.dart';
import 'package:minidart_compiler/src/code_generator.dart';
import 'package:minidart_compiler/src/vm.dart';
import 'package:minidart_compiler/src/ast_graphviz_generator.dart';

// Cria uma instância única do reporter de erros para todo o compilador.
final errorReporter = ErrorReporter();

void main(List<String> args) {
  if (args.isEmpty) {
    print('Uso: dart bin/compile.dart <caminho_para_arquivo.mdart> [--ast-only]');
    print('');
    print('Opções:');
    print('  --ast-only    Gera apenas a AST em Graphviz (não executa o código)');
    print('');
    print('Exemplos:');
    print('  dart bin/compile.dart exemplos/exemplo_basico.mdart');
    print('  dart bin/compile.dart exemplos/exemplo_ast.mdart --ast-only');
    exit(64); // Código de erro para uso incorreto.
  }

  final filePath = args.first;
  final astOnly = args.contains('--ast-only');
  final source = File(filePath).readAsStringSync();

  run(source, astOnly: astOnly);
}

void run(String source, {bool astOnly = false}) {
  errorReporter.reset();

  // --- Fase 1: Análise Léxica (Scanner) ---
  final lexer = Lexer(source, errorReporter);
  final tokens = lexer.scanTokens();
  if (errorReporter.hadError) {
    print('Erros encontrados durante a análise léxica. Compilação abortada.');
    return;
  }

  // --- Fase 2: Análise Sintática (Parser) ---
  final parser = Parser(tokens, errorReporter);
  final statements = parser.parse();
  if (errorReporter.hadError) {
    print(
      'Erros encontrados durante a análise sintática. Compilação abortada.',
    );
    return;
  }

  // 🌳 === GERAÇÃO DA AST EM GRAPHVIZ ===
  print('--- AST em Graphviz ---');
  final astGenerator = ASTGraphvizGenerator();
  astGenerator.saveAndVisualize(statements, filename: 'minidart_ast');
  print('-----------------------\n');

  // Se for apenas AST, parar aqui
  if (astOnly) {
    print('✅ AST gerada com sucesso! Use o comando abaixo para visualizar:');
    print('   dot -Tpng minidart_ast.dot -o minidart_ast.png');
    return;
  }

  // --- Fase 3: Análise Semântica ---
  final semanticAnalyzer = SemanticAnalyzer(errorReporter);
  semanticAnalyzer.analyze(statements);
  if (errorReporter.hadError) {
    print(
      'Erros encontrados durante a análise semântica. Compilação abortada.',
    );
    return;
  }

  // --- Fase 4: Geração de Código ---
  final codeGenerator = CodeGenerator();
  final chunk = codeGenerator.compile(statements);

  print('--- Bytecode Gerado ---');
  chunk.disassemble();
  print('-----------------------\n');

  // --- Fase 5: Execução na VM ---
  final vm = VM();
  print('--- Saída da Execução ---');
  vm.interpret(chunk);
  print('-------------------------');
}
