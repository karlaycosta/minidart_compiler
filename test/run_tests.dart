#!/usr/bin/env dart

import 'dart:io';

/// Script para executar todos os testes da Linguagem LiPo
void main(List<String> args) async {
  print('🧪 === EXECUTANDO TESTES DA LINGUAGEM LIPO ===');
  print('================================================');

  final stopwatch = Stopwatch()..start();

  // 1. Testes unitários com package:test
  print('\n📋 1. Executando testes unitários...');
  await runUnitTests();

  // 2. Testes de fixtures (arquivos .lip)
  print('\n📁 2. Executando testes de fixtures...');
  await runFixtureTests();

  // 3. Testes de regressão (exemplos existentes)
  print('\n🔄 3. Executando testes de regressão...');
  await runRegressionTests();

  stopwatch.stop();

  print('\n✅ === TESTES CONCLUÍDOS ===');
  print('Tempo total: ${stopwatch.elapsedMilliseconds}ms');
  print('============================');
}

/// Executa testes unitários usando package:test
Future<void> runUnitTests() async {
  try {
    final result = await Process.run('dart', [
      'test',
      'test/lipo_test.dart',
    ], workingDirectory: Directory.current.path);

    if (result.exitCode == 0) {
      print('✅ Testes unitários: SUCESSO');
      print(result.stdout);
    } else {
      print('❌ Testes unitários: FALHOU');
      print(result.stderr);
    }
  } catch (e) {
    print('⚠️ Erro ao executar testes unitários: $e');
  }
}

/// Executa testes de fixtures
Future<void> runFixtureTests() async {
  final fixturesDir = Directory('test/fixtures');

  if (!fixturesDir.existsSync()) {
    print('⚠️ Diretório de fixtures não encontrado');
    return;
  }

  final fixtures = fixturesDir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.lip'))
      .toList();

  int passed = 0;
  int failed = 0;

  for (final fixture in fixtures) {
    final filename = fixture.path.split(Platform.pathSeparator).last;
    stdout.write('  Testando $filename... ');

    try {
      final result = await Process.run('dart', [
        'run',
        'bin/compile.dart',
        fixture.path,
      ], workingDirectory: Directory.current.path);

      if (result.exitCode == 0) {
        print('✅');
        passed++;
      } else {
        print('❌');
        print('    Erro: ${result.stderr}');
        failed++;
      }
    } catch (e) {
      print('❌');
      print('    Exceção: $e');
      failed++;
    }
  }

  print('\nResumo Fixtures: $passed passou, $failed falhou');
}

/// Executa testes de regressão nos exemplos existentes
Future<void> runRegressionTests() async {
  final examplesDir = Directory('exemplos');

  if (!examplesDir.existsSync()) {
    print('⚠️ Diretório de exemplos não encontrado');
    return;
  }

  // Lista de arquivos que devem executar sem erro
  final expectedToPass = [
    'debug_basico.lip',
    'debug_comparacao.lip',
    'debug_comp_explicito.lip',
    'debug_incremento.lip',
    'debug_ternario.lip',
    'filipe.lip',
    'filipe_sem_imports.lip',
    'teste.lip',
    'teste_simples.lip',
    'teste_sintaxe_completa.lip',
  ];

  int passed = 0;
  int failed = 0;

  for (final filename in expectedToPass) {
    final file = File('exemplos/$filename');

    if (!file.existsSync()) {
      print('⚠️ Arquivo $filename não encontrado');
      continue;
    }

    stdout.write('  Testando $filename... ');

    try {
      final result = await Process.run('dart', [
        'run',
        'bin/compile.dart',
        file.path,
      ], workingDirectory: Directory.current.path);

      if (result.exitCode == 0) {
        print('✅');
        passed++;
      } else {
        print('❌');
        print('    Erro: ${result.stderr}');
        failed++;
      }
    } catch (e) {
      print('❌');
      print('    Exceção: $e');
      failed++;
    }
  }

  print('\nResumo Regressão: $passed passou, $failed falhou');
}
