import 'dart:io';
import 'package:args/args.dart';
import 'package:minidart_compiler/src/token.dart';
import 'package:minidart_compiler/src/version.dart';
import 'package:minidart_compiler/src/lexer.dart';
import 'package:minidart_compiler/src/parser.dart';
import 'package:minidart_compiler/src/error.dart';
import 'package:minidart_compiler/src/semantic_analyzer.dart';
import 'package:minidart_compiler/src/code_generator.dart';
import 'package:minidart_compiler/src/vm.dart';
import 'package:minidart_compiler/src/ast_graphviz_generator.dart';
import 'package:minidart_compiler/src/interactive_debugger.dart';
import 'package:minidart_compiler/src/dap_debugger.dart';

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
    )
    ..addFlag(
      'debug-dap',
      negatable: false,
      help:
          'Inicia o modo DAP (Debug Adapter Protocol) para integração VS Code',
    )
    ..addFlag(
      'debug-tokens',
      negatable: false,
      help: 'Mostra todos os tokens identificados durante a análise léxica',
    )
    ..addFlag(
      'debug-parser',
      negatable: false,
      help: 'Mostra detalhes da construção da AST durante o parsing',
    )
    ..addFlag(
      'debug-semantic',
      negatable: false,
      help: 'Exibe informações detalhadas da análise semântica e escopo',
    )
    ..addFlag(
      'debug-vm',
      negatable: false,
      help: 'Mostra execução passo-a-passo da VM com stack e instruções',
    )
    ..addFlag(
      'debug-all',
      negatable: false,
      help: 'Ativa todos os modos de debug (tokens + parser + semantic + vm)',
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
    print('🚀 $fullVersionString');
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
  final debugDAP = argResults['debug-dap'] as bool;
  final debugTokens = argResults['debug-tokens'] as bool;
  final debugParser = argResults['debug-parser'] as bool;
  final debugSemantic = argResults['debug-semantic'] as bool;
  final debugVM = argResults['debug-vm'] as bool;
  final debugAll = argResults['debug-all'] as bool;

  try {
    final source = File(filePath).readAsStringSync();
    run(
      source,
      astOnly: astOnly,
      showBytecode: showBytecode,
      debugInteractive: debugInteractive,
      debugDAP: debugDAP,
      debugTokens: debugTokens || debugAll,
      debugParser: debugParser || debugAll,
      debugSemantic: debugSemantic || debugAll,
      debugVM: debugVM || debugAll,
    );
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
  dart bin/compile.dart exemplos/teste_debug.mdart --debug-tokens
  dart bin/compile.dart exemplos/teste_debug.mdart --debug-parser
  dart bin/compile.dart exemplos/teste_debug.mdart --debug-semantic
  dart bin/compile.dart exemplos/teste_debug.mdart --debug-vm
  dart bin/compile.dart exemplos/teste_debug.mdart --debug-all
''';
}

void run(
  String source, {
  bool astOnly = false,
  bool showBytecode = false,
  bool debugInteractive = false,
  bool debugDAP = false,
  bool debugTokens = false,
  bool debugParser = false,
  bool debugSemantic = false,
  bool debugVM = false,
}) {
  errorReporter.reset();

  // --- Fase 1: Análise Léxica (Scanner) ---
  final lexer = Lexer(source, errorReporter);
  final tokens = lexer.scanTokens();

  if (debugTokens) {
    print('--- DEBUG: TOKENS ENCONTRADOS ---');
    print('=================================');
    for (int i = 0; i < tokens.length; i++) {
      final token = tokens[i];
      final index = '${i + 1}'.padLeft(3);
      final type = token.type.nome.padRight(20);
      final lexeme = token.lexeme.isEmpty ? '<vazio>' : token.lexeme;
      // final literal = token.literal != null ? '(${token.literal})' : '';
      print('  $index. $type | $lexeme');
    }
    final token = '${tokens.length}'.padLeft(3);
    print('=======================================');
    print('--- Total: $token tokens identificados ---\n');
  }

  if (errorReporter.hadError) {
    print('Erros encontrados durante a análise léxica. Compilação abortada.');
    return;
  }

  // --- Fase 2: Análise Sintática (Parser) ---
  final parser = Parser(tokens, errorReporter);

  if (debugParser) {
    print('🌳 === DEBUG: ANÁLISE SINTÁTICA (PARSER) ===');
    print('🔍 Iniciando construção da AST...');
  }

  final statements = parser.parse();

  if (debugParser) {
    print('📊 AST construída com ${statements.length} statement(s):');
    for (int i = 0; i < statements.length; i++) {
      final stmt = statements[i];
      print('  ${i + 1}. ${stmt.runtimeType} - ${stmt.toString()}');
    }
    print('✅ Parser finalizado com sucesso\n');
  }

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

  if (debugSemantic) {
    print('🔬 === DEBUG: ANÁLISE SEMÂNTICA ===');
    print('🔍 Verificando tipos, escopos e declarações...');
  }

  semanticAnalyzer.analyze(statements);

  if (debugSemantic) {
    print('✅ Análise semântica finalizada');
    print('📊 Programa validado semanticamente\n');
  }

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

  // Configurar debug da VM se solicitado
  if (debugVM) {
    print('🤖 === DEBUG: VIRTUAL MACHINE ===');
    print('🔍 Ativando modo debug da VM...');
    vm.setDebugMode(true);
    print('✅ VM configurada para execução step-by-step\n');
  }

  // Verifica o modo de debug
  if (debugDAP) {
    print('🎯 Iniciando modo DAP (Debug Adapter Protocol)...\n');
    final dapDebugger = DAPDebugger(vm);
    dapDebugger.start(chunk, source);
  } else if (debugInteractive) {
    print('🔍 Iniciando Debugger Interativo...\n');
    final debugger = InteractiveDebugger(vm);
    debugger.start(chunk, source);
  } else {
    // Passa as funções compiladas para a VM
    vm.interpret(chunk);
  }
}
