#!/usr/bin/env dart

import 'dart:io';

/// Script para sincronizar a versão do pubspec.yaml com version.dart
/// 
/// Uso: dart scripts/sync_version.dart [nova_versao]
/// 
/// Se nova_versao for fornecida, atualiza version.dart e pubspec.yaml
/// Caso contrário, sincroniza pubspec.yaml com a versão em version.dart

void main(List<String> args) async {
  final versionFile = File('lib/src/version.dart');
  final pubspecFile = File('pubspec.yaml');

  if (!versionFile.existsSync()) {
    print('❌ Arquivo version.dart não encontrado!');
    exit(1);
  }

  if (!pubspecFile.existsSync()) {
    print('❌ Arquivo pubspec.yaml não encontrado!');
    exit(1);
  }

  if (args.isNotEmpty) {
    // Atualizar para nova versão
    final newVersion = args[0];
    if (!RegExp(r'^\d+\.\d+\.\d+$').hasMatch(newVersion)) {
      print('❌ Formato de versão inválido! Use: MAJOR.MINOR.PATCH');
      exit(1);
    }

    await updateVersion(newVersion, versionFile, pubspecFile);
  } else {
    // Sincronizar pubspec com version.dart
    await syncFromVersionFile(versionFile, pubspecFile);
  }
}

Future<void> updateVersion(String newVersion, File versionFile, File pubspecFile) async {
  print('🔄 Atualizando para versão $newVersion...');

  // Atualizar version.dart
  final versionContent = await versionFile.readAsString();
  final newVersionContent = versionContent.replaceFirst(
    RegExp(r"const String VERSION = '[^']+';"),
    "const String VERSION = '$newVersion';",
  );
  await versionFile.writeAsString(newVersionContent);
  print('✅ version.dart atualizado');

  // Atualizar pubspec.yaml
  final pubspecContent = await pubspecFile.readAsString();
  final newPubspecContent = pubspecContent.replaceFirst(
    RegExp(r'^version: .+$', multiLine: true),
    'version: $newVersion',
  );
  await pubspecFile.writeAsString(newPubspecContent);
  print('✅ pubspec.yaml atualizado');

  print('🎉 Versão $newVersion aplicada com sucesso!');
}

Future<void> syncFromVersionFile(File versionFile, File pubspecFile) async {
  print('🔄 Sincronizando pubspec.yaml com version.dart...');

  // Ler versão atual do version.dart
  final versionContent = await versionFile.readAsString();
  final versionMatch = RegExp(r"const String VERSION = '([^']+)';").firstMatch(versionContent);
  
  if (versionMatch == null) {
    print('❌ Não foi possível encontrar a versão em version.dart');
    exit(1);
  }

  final currentVersion = versionMatch.group(1)!;
  print('📋 Versão encontrada: $currentVersion');

  // Atualizar pubspec.yaml
  final pubspecContent = await pubspecFile.readAsString();
  final newPubspecContent = pubspecContent.replaceFirst(
    RegExp(r'^version: .+$', multiLine: true),
    'version: $currentVersion',
  );
  await pubspecFile.writeAsString(newPubspecContent);
  
  print('✅ pubspec.yaml sincronizado com versão $currentVersion');
}
