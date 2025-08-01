import 'dart:io';

void main() async {
  final server = await HttpServer.bind('localhost', 8080);
  
  print('🚀 MiniDart Compiler Web Server iniciado!');
  print('📱 Acesse: http://localhost:8080');
  print('🛑 Use Ctrl+C para parar o servidor\n');
  
  await for (final request in server) {
    final path = request.uri.path;
    String filePath;
    String contentType;
    
    if (path == '/' || path == '/index.html') {
      filePath = 'index.html';
      contentType = 'text/html';
    } else if (path == '/index_wasm.html') {
      filePath = 'index_wasm.html';
      contentType = 'text/html';
    } else if (path == '/test_wasm.html') {
      filePath = 'test_wasm.html';
      contentType = 'text/html';
    } else if (path == '/styles.css') {
      filePath = 'styles.css';
      contentType = 'text/css';
    } else if (path == '/main.dart.js') {
      filePath = 'main.dart.js';
      contentType = 'application/javascript';
    } else if (path == '/main.mjs') {
      filePath = 'main.mjs';
      contentType = 'application/javascript';
    } else if (path == '/main.wasm') {
      filePath = 'main.wasm';
      contentType = 'application/wasm';
    } else if (path == '/main.unopt.wasm') {
      filePath = 'main.unopt.wasm';
      contentType = 'application/wasm';
    } else if (path == '/main.support.js') {
      filePath = 'main.support.js';
      contentType = 'application/javascript';
    } else {
      // 404 - Arquivo não encontrado
      request.response
        ..statusCode = 404
        ..write('Arquivo não encontrado: $path')
        ..close();
      continue;
    }
    
    try {
      final file = File(filePath);
      
      // Arquivos binários (WebAssembly) devem ser lidos como bytes
      if (filePath.endsWith('.wasm')) {
        final bytes = await file.readAsBytes();
        request.response
          ..headers.contentType = ContentType.parse(contentType)
          ..headers.add('Cache-Control', 'no-cache')
          ..headers.add('Access-Control-Allow-Origin', '*')
          ..headers.add('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
          ..headers.add('Access-Control-Allow-Headers', 'Content-Type')
          ..add(bytes)
          ..close();
        print('📄 Servindo (binário): $filePath (${bytes.length} bytes)');
      } else {
        // Arquivos de texto
        final content = await file.readAsString();
        request.response
          ..headers.contentType = ContentType.parse('$contentType; charset=utf-8')
          ..headers.add('Cache-Control', 'no-cache')
          ..headers.add('Access-Control-Allow-Origin', '*')
          ..write(content)
          ..close();
        print('📄 Servindo: $filePath (${content.length} bytes)');
      }
    } catch (e) {
      request.response
        ..statusCode = 500
        ..headers.contentType = ContentType.parse('text/plain; charset=utf-8')
        ..write('Erro interno do servidor: $e')
        ..close();
      print('❌ Erro ao servir $filePath: $e');
    }
  }
}
