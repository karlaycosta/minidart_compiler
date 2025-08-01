import 'dart:io';
import 'bytecode.dart';
import 'vm.dart';

/// **Debugger Interativo do MiniDart**
///
/// Sistema completo de debugging com:
/// - Breakpoints em linhas específicas
/// - Execução step-by-step (passo a passo)
/// - Watch variables (monitoramento de variáveis)
/// - Call stack visualization (visualização da pilha de chamadas)
/// - Interface interativa no terminal
class InteractiveDebugger {
  final VM _vm;
  final Map<String, int> _sourceLines = {};
  final Set<int> _breakpoints = <int>{};
  final Map<String, dynamic> _watchVariables = <String, dynamic>{};
  final List<DebugCallFrame> _callStack = <DebugCallFrame>[];

  bool _isRunning = false;
  bool _stepMode = false;
  bool _isPaused = false;
  int _currentLine = 0;
  int _currentIP = 0;
  String? _currentFunction;

  InteractiveDebugger(this._vm);

  /// Inicia o debugger interativo
  void start(BytecodeChunk chunk, String source) {
    print('🔍 ═══════════════════════════════════════════════════════════════');
    print('🔍 MINIDART INTERACTIVE DEBUGGER v1.13.0');
    print('🔍 ═══════════════════════════════════════════════════════════════');
    print('🔍 Digite "help" para ver comandos disponíveis');
    print('🔍 ═══════════════════════════════════════════════════════════════');

    _parseSourceLines(source);
    _setupDebugHooks();
    _isRunning = true;

    _showCurrentState();
    _interactiveLoop(chunk);
  }

  /// Configura hooks de debug na VM
  void _setupDebugHooks() {
    _vm.setDebugMode(true);
    _vm.setOnInstructionExecute(_onInstructionExecute);
    _vm.setOnFunctionCall(_onFunctionCall);
    _vm.setOnFunctionReturn(_onFunctionReturn);
  }

  /// Parse das linhas do código fonte
  void _parseSourceLines(String source) {
    final lines = source.split('\n');
    for (int i = 0; i < lines.length; i++) {
      _sourceLines['${i + 1}'] = i + 1;
    }
  }

  /// Callback executado a cada instrução
  void _onInstructionExecute(
    int ip,
    OpCode opCode,
    List<dynamic> stack,
    Map<String, dynamic> globals,
  ) {
    _currentIP = ip;
    _updateCurrentLine(ip);

    // Verifica breakpoints
    if (_breakpoints.contains(_currentLine)) {
      _isPaused = true;
      print('🛑 BREAKPOINT atingido na linha $_currentLine');
      _showCurrentState();
      _interactivePrompt();
      return;
    }

    // Modo step-by-step
    if (_stepMode) {
      _isPaused = true;
      _showCurrentState();
      _interactivePrompt();
    }
  }

  /// Callback para chamadas de função
  void _onFunctionCall(String functionName, List<dynamic> args) {
    final frame = DebugCallFrame(functionName, args, _currentLine);
    _callStack.add(frame);
    _currentFunction = functionName;

    if (_stepMode) {
      print('📞 CALL: $functionName(${args.join(', ')})');
    }
  }

  /// Callback para retorno de função
  void _onFunctionReturn(String functionName, dynamic returnValue) {
    if (_callStack.isNotEmpty) {
      _callStack.removeLast();
    }
    _currentFunction = _callStack.isNotEmpty
        ? _callStack.last.functionName
        : 'main';

    if (_stepMode) {
      print('↩️  RETURN: $functionName → $returnValue');
    }
  }

  /// Atualiza linha atual baseada no IP
  void _updateCurrentLine(int ip) {
    // Implementação simplificada - em um debugger real,
    // haveria mapeamento preciso entre IP e linha de código
    _currentLine = (ip ~/ 3) + 1; // Estimativa baseada em IP
  }

  /// Loop interativo principal
  void _interactiveLoop(BytecodeChunk chunk) {
    // Pausa automaticamente no início para modo interativo
    _isPaused = true;
    print('🔍 ═══ PROGRAMA INICIADO - PAUSADO ═══');
    print('💡 Digite "help" para ver comandos disponíveis');
    print('💡 Digite "step" ou "s" para executar passo a passo');
    print('💡 Digite "continue" ou "c" para continuar execução');
    _showCurrentState();
    
    while (_isRunning) {
      if (!_isPaused) {
        // Executa próxima instrução
        try {
          final result = _vm.interpretStep(chunk);
          if (result == InterpretResult.ok && _vm.isAtEnd()) {
            print('✅ Programa executado com sucesso');
            break;
          }
        } catch (e) {
          print('❌ Erro durante execução: $e');
          break;
        }
      } else {
        _interactivePrompt();
      }
    }

    print('🔍 Debugger finalizado');
  }

  /// Prompt interativo para comandos
  void _interactivePrompt() {
    while (_isPaused && _isRunning) {
      stdout.write('(minidart-debug) ');
      final input = stdin.readLineSync()?.trim() ?? '';

      if (!_processCommand(input)) {
        break; // Sair do prompt
      }
    }
  }

  /// Processa comandos do debugger
  bool _processCommand(String command) {
    final parts = command.split(' ');
    final cmd = parts[0].toLowerCase();

    switch (cmd) {
      case 'help' || 'h':
        _showHelp();
        break;

      case 'continue' || 'c':
        _isPaused = false;
        _stepMode = false;
        print('▶️  Continuando execução...');
        return false;

      case 'step' || 's':
        _stepMode = true;
        _isPaused = false;
        print('👣 Modo step-by-step ativado');
        return false;

      case 'next' || 'n':
        _isPaused = false;
        print('⏭️  Próxima instrução...');
        return false;

      case 'break' || 'b':
        if (parts.length > 1) {
          _setBreakpoint(parts[1]);
        } else {
          print('❌ Uso: break <linha>');
        }
        break;

      case 'clear':
        if (parts.length > 1) {
          _clearBreakpoint(parts[1]);
        } else {
          _clearAllBreakpoints();
        }
        break;

      case 'list' || 'l':
        _listBreakpoints();
        break;

      case 'watch' || 'w':
        if (parts.length > 1) {
          _addWatch(parts[1]);
        } else {
          _showWatches();
        }
        break;

      case 'unwatch':
        if (parts.length > 1) {
          _removeWatch(parts[1]);
        } else {
          print('❌ Uso: unwatch <variável>');
        }
        break;

      case 'stack' || 'st':
        _showCallStack();
        break;

      case 'vars' || 'v':
        _showVariables();
        break;

      case 'state':
        _showCurrentState();
        break;

      case 'quit' || 'q':
        _isRunning = false;
        print('👋 Saindo do debugger...');
        return false;

      default:
        print('❌ Comando desconhecido: $command');
        print('💡 Digite "help" para ver comandos disponíveis');
        break;
    }

    return true;
  }

  /// Adiciona breakpoint
  void _setBreakpoint(String lineStr) {
    try {
      final line = int.parse(lineStr);
      if (_sourceLines.containsKey(line.toString())) {
        _breakpoints.add(line);
        print('🛑 Breakpoint adicionado na linha $line');
      } else {
        print('❌ Linha $line não existe no código');
      }
    } catch (e) {
      print('❌ Número de linha inválido: $lineStr');
    }
  }

  /// Remove breakpoint
  void _clearBreakpoint(String lineStr) {
    try {
      final line = int.parse(lineStr);
      if (_breakpoints.remove(line)) {
        print('✅ Breakpoint removido da linha $line');
      } else {
        print('❌ Nenhum breakpoint na linha $line');
      }
    } catch (e) {
      print('❌ Número de linha inválido: $lineStr');
    }
  }

  /// Remove todos os breakpoints
  void _clearAllBreakpoints() {
    final count = _breakpoints.length;
    _breakpoints.clear();
    print('✅ $count breakpoint(s) removido(s)');
  }

  /// Lista breakpoints
  void _listBreakpoints() {
    if (_breakpoints.isEmpty) {
      print('📋 Nenhum breakpoint definido');
      return;
    }

    print('📋 Breakpoints ativos:');
    for (final line in _breakpoints.toList()..sort()) {
      print('   🛑 Linha $line');
    }
  }

  /// Adiciona variável para watch
  void _addWatch(String variable) {
    _watchVariables[variable] = null;
    print('👁️  Monitorando variável: $variable');
    _updateWatchValue(variable);
  }

  /// Remove variável do watch
  void _removeWatch(String variable) {
    if (_watchVariables.remove(variable) != null) {
      print('✅ Removido do watch: $variable');
    } else {
      print('❌ Variável não estava sendo monitorada: $variable');
    }
  }

  /// Atualiza valor de variável watch
  void _updateWatchValue(String variable) {
    try {
      final value = _vm.getGlobalValue(variable);
      _watchVariables[variable] = value;
    } catch (e) {
      _watchVariables[variable] = '<undefined>';
    }
  }

  /// Mostra variáveis em watch
  void _showWatches() {
    if (_watchVariables.isEmpty) {
      print('👁️  Nenhuma variável sendo monitorada');
      return;
    }

    print('👁️  Variáveis monitoradas:');
    for (final entry in _watchVariables.entries) {
      _updateWatchValue(entry.key);
      print('   ${entry.key} = ${_watchVariables[entry.key]}');
    }
  }

  /// Mostra call stack
  void _showCallStack() {
    if (_callStack.isEmpty) {
      print('📚 Call Stack: [main]');
      return;
    }

    print('📚 Call Stack:');
    print('   🏠 main');
    for (int i = 0; i < _callStack.length; i++) {
      final frame = _callStack[i];
      final indent = '   ${'  ' * (i + 1)}';
      print(
        '$indent📞 ${frame.functionName}(${frame.arguments.join(', ')}) [linha ${frame.line}]',
      );
    }
  }

  /// Mostra todas as variáveis
  void _showVariables() {
    print('📊 Estado das Variáveis:');

    // Variáveis globais
    final globals = _vm.getAllGlobals();
    if (globals.isNotEmpty) {
      print('   🌍 Globais:');
      for (final entry in globals.entries) {
        print('     ${entry.key} = ${entry.value}');
      }
    }

    // Stack atual
    final stack = _vm.getStackValues();
    if (stack.isNotEmpty) {
      print('   📚 Stack:');
      for (int i = 0; i < stack.length; i++) {
        print('     [$i] = ${stack[i]}');
      }
    }
  }

  /// Mostra estado atual
  void _showCurrentState() {
    print('');
    print('🔍 ═══ ESTADO ATUAL ═══');
    print('📍 Linha: $_currentLine');
    print('🎯 IP: $_currentIP');
    print('🏷️  Função: ${_currentFunction ?? 'main'}');

    // Mostra watches se existirem
    if (_watchVariables.isNotEmpty) {
      print('');
      _showWatches();
    }

    print('🔍 ═══════════════════');
  }

  /// Mostra ajuda
  void _showHelp() {
    print('');
    print('🔍 ═══ COMANDOS DO DEBUGGER ═══');
    print('');
    print('📋 CONTROLE DE EXECUÇÃO:');
    print('   continue, c     - Continua execução');
    print('   step, s         - Ativa modo step-by-step');
    print('   next, n         - Executa próxima instrução');
    print('   quit, q         - Sai do debugger');
    print('');
    print('🛑 BREAKPOINTS:');
    print('   break <linha>   - Adiciona breakpoint');
    print('   clear <linha>   - Remove breakpoint');
    print('   clear           - Remove todos breakpoints');
    print('   list, l         - Lista breakpoints');
    print('');
    print('👁️  MONITORAMENTO:');
    print('   watch <var>     - Monitora variável');
    print('   unwatch <var>   - Para de monitorar');
    print('   watch           - Mostra variáveis monitoradas');
    print('');
    print('📊 INFORMAÇÕES:');
    print('   stack, st       - Mostra call stack');
    print('   vars, v         - Mostra todas variáveis');
    print('   state           - Mostra estado atual');
    print('   help, h         - Mostra esta ajuda');
    print('');
    print('🔍 ═══════════════════════════════');
    print('');
  }
}

/// Frame da call stack para debugging
class DebugCallFrame {
  final String functionName;
  final List<dynamic> arguments;
  final int line;

  DebugCallFrame(this.functionName, this.arguments, this.line);

  @override
  String toString() => '$functionName(${arguments.join(', ')}) [linha $line]';
}
