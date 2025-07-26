import 'dart:io';
import 'package:args/args.dart';
import 'package:minidart_compiler/src/lexer.dart';
import 'package:minidart_compiler/src/parser.dart';
import 'package:minidart_compiler/src/error.dart';
import 'package:minidart_compiler/src/semantic_analyzer.dart';
import 'package:minidart_compiler/src/code_generator.dart';
import 'package:minidart_compiler/src/vm.dart';
import 'package:minidart_compiler/src/ast_graphviz_generator.dart';
import 'package:minidart_compiler/src/interactive_debugger.dart';

// Cria uma instância única do reporter de erros para todo o compilador.
final errorReporter = ErrorReporter();

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addFlag(
      'version',
      abbr: 'v',
      negatable: false,
      help: 'Mostra a versão do compilador',
    )
    ..addFlag(
      'ast-only',
      abbr: 'a',
      negatable: false,
      help: 'Gera apenas a AST em Graphviz (não executa o código)',
    )
    ..addFlag(
      'bytecode',
      abbr: 'b',
      negatable: false,
      help: 'Mostra o bytecode gerado durante a compilação',
    )
    ..addFlag(
      'debug-interactive',
      abbr: 'i',
      negatable: false,
      help: 'Inicia o debugger interativo com breakpoints e step-by-step',
    );

  ArgResults argResults;
  try {
    argResults = parser.parse(arguments);
  } on FormatException catch (e) {
    stderr.writeln('Erro ao analisar os argumentos: ${e.message}');
    stderr.writeln(getUsage(parser));
    exit(64);
  }

  // Verifica se é pedido para mostrar a versão
  if (argResults['version']) {
      print('🚀 MiniDart Compiler v1.14.0');
    print('Copyright (c) 2025 Deriks Karlay Dias Costa');
    print('Linguagem de programação educacional em português');
    exit(0);
  }

  if (argResults.rest.isEmpty) {
    print('Erro: Nenhum arquivo de entrada fornecido.\n');
    print(getUsage(parser));
    exit(64); // Código de erro para uso incorreto.
  }

  final filePath = argResults.rest.first;
  final astOnly = argResults['ast-only'] as bool;
  final showBytecode = argResults['bytecode'] as bool;
  final debugInteractive = argResults['debug-interactive'] as bool;

  try {
    final source = File(filePath).readAsStringSync();
    run(source, astOnly: astOnly, showBytecode: showBytecode, debugInteractive: debugInteractive);
  } on FileSystemException {
    print('Erro: Não foi possível encontrar o arquivo "$filePath"');
    exit(66); // Código de erro para arquivo de entrada não encontrado.
  }
}

String getUsage(ArgParser parser) {
  return '''
Uso: dart bin/compile.dart <caminho_para_arquivo.mdart> [opções]

Opções:
${parser.usage}

Exemplos:
  dart bin/compile.dart exemplos/teste_simples.mdart
  dart bin/compile.dart exemplos/teste_complexo.mdart --bytecode
  dart bin/compile.dart exemplos/teste_simples.mdart --ast-only
  dart bin/compile.dart exemplos/teste_debug.mdart --debug-interactive
''';
}

void run(String source, {bool astOnly = false, bool showBytecode = false, bool debugInteractive = false}) {
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
  // Se for apenas AST, parar aqui
  if (astOnly) {
    print('--- AST em Graphviz ---');
    final astGenerator = ASTGraphvizGenerator();
    astGenerator.saveAndVisualize(statements, filename: 'minidart_ast');
    print('-----------------------\n');
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

  // Mostra bytecode apenas se solicitado
  if (showBytecode) {
    print('--- Bytecode Gerado ---');
    chunk.disassemble();
    print('-----------------------\n');
  }

  // --- Fase 5: Execução na VM ---
  final vm = VM();
  vm.setFunctions(codeGenerator.functions);
  
  // Verifica se deve usar debugger interativo
  if (debugInteractive) {
    print('🔍 Iniciando Debugger Interativo...\n');
    final debugger = InteractiveDebugger(vm);
    debugger.start(chunk, source);
  } else {
    // Passa as funções compiladas para a VM
    vm.interpret(chunk);
  }
}
