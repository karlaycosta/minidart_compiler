import 'dart:io';
import 'package:minidart_compiler/src/lexer.dart';
import 'package:minidart_compiler/src/parser.dart';
import 'package:minidart_compiler/src/error.dart';
import 'package:minidart_compiler/src/semantic_analyzer.dart';
import 'package:minidart_compiler/src/code_generator.dart';
import 'package:minidart_compiler/src/vm.dart';

// Cria uma instância única do reporter de erros para todo o compilador.
final errorReporter = ErrorReporter();

void main(List<String> args) {

  if (args.isEmpty) {
    print('Uso: dart bin/compile.dart <caminho_para_arquivo.mdart>');
    exit(64); // Código de erro para uso incorreto.
  }

  final filePath = args.first;
  final source = File(filePath).readAsStringSync();

  run(source);
}

void run(String source) {
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
