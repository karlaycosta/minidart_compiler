import 'dart:io';
import 'dart:convert';
import 'bytecode.dart';
import 'vm.dart';

/// **Debugger DAP (Debug Adapter Protocol) do MiniDart**
///
/// Implementa comunicação bidirecional com VS Code via DAP
/// - Processa comandos DAP via stdin
/// - Envia eventos DAP via stdout  
/// - Integra com a VM para execução controlada
/// - Suporta breakpoints, stepping, e monitoramento de variáveis
class DAPDebugger {
  final VM _vm;
  final Map<String, int> _sourceLines = {};
  final Map<String, Set<int>> _breakpoints = {};
  final Map<String, dynamic> _variables = {};

  bool _isRunning = false;
  bool _isPaused = true; // Inicia pausado esperando comandos
  bool _stepMode = false;
  int _currentLine = 0;

  DAPDebugger(this._vm);

  /// Inicia o debugger DAP
  void start(BytecodeChunk chunk, String source) {
    print('🎯 Iniciando Debugger DAP para comunicação com VS Code...');
    
    _parseSourceLines(source);
    _setupDebugHooks();
    _isRunning = true;

    // Enviar evento inicial
    _sendDAPMessage({
      'type': 'output',
      'category': 'console',
      'text': '🎯 Debugger DAP iniciado - aguardando comandos do VS Code\n'
    });

    _sendDAPMessage({
      'type': 'stopped',
      'reason': 'entry',
      'line': 1
    });

    _dapLoop(chunk);
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

  /// Loop principal DAP
  void _dapLoop(BytecodeChunk chunk) {
    // Configurar listener para comandos stdin
    stdin.transform(utf8.decoder).transform(const LineSplitter()).listen((line) {
      if (line.startsWith('DAP:')) {
        try {
          final command = jsonDecode(line.substring(4));
          _processDAPCommand(command, chunk);
        } catch (e) {
          _sendDAPMessage({
            'type': 'output',
            'category': 'stderr',
            'text': 'Erro ao processar comando DAP: $e\n'
          });
        }
      }
    });

    // Loop de execução
    while (_isRunning) {
      if (!_isPaused) {
        try {
          final result = _vm.interpretStep(chunk);
          if (result == InterpretResult.ok && _vm.isAtEnd()) {
            _sendDAPMessage({
              'type': 'output',
              'category': 'stdout',
              'text': '✅ Programa executado com sucesso\n'
            });
            
            _sendDAPMessage({
              'type': 'terminated'
            });
            break;
          }
        } catch (e) {
          _sendDAPMessage({
            'type': 'output',
            'category': 'stderr',
            'text': 'Erro durante execução: $e\n'
          });
          break;
        }
      } else {
        // Aguarda comandos quando pausado
        sleep(const Duration(milliseconds: 10));
      }
    }
  }

  /// Processa comandos DAP vindos do VS Code
  void _processDAPCommand(Map<String, dynamic> command, BytecodeChunk chunk) {
    final type = command['type'] as String?;
    
    switch (type) {
      case 'setBreakpoints':
        _handleSetBreakpoints(command);
        break;
        
      case 'continue':
        _handleContinue();
        break;
        
      case 'next':
        _handleNext();
        break;
        
      case 'stepIn':
        _handleStepIn();
        break;
        
      case 'stepOut':
        _handleStepOut();
        break;
        
      case 'pause':
        _handlePause();
        break;
        
      default:
        _sendDAPMessage({
          'type': 'output',
          'category': 'console',
          'text': '⚠️ Comando DAP não reconhecido: $type\n'
        });
    }
  }

  /// Handle set breakpoints
  void _handleSetBreakpoints(Map<String, dynamic> command) {
    final file = command['file'] as String? ?? 'main';
    final lines = (command['lines'] as List<dynamic>?)?.cast<int>() ?? [];
    
    _breakpoints[file] = Set<int>.from(lines);
    
    _sendDAPMessage({
      'type': 'output',
      'category': 'console',
      'text': '🎯 ${lines.length} breakpoint(s) configurado(s) nas linhas: ${lines.join(', ')}\n'
    });
  }

  /// Handle continue
  void _handleContinue() {
    _isPaused = false;
    _stepMode = false;
    
    _sendDAPMessage({
      'type': 'output',
      'category': 'console',
      'text': '▶️ Execução continuada\n'
    });
  }

  /// Handle next (step over)
  void _handleNext() {
    _stepMode = true;
    _isPaused = false;
    
    _sendDAPMessage({
      'type': 'output',
      'category': 'console',
      'text': '⏭️ Step Over\n'
    });
  }

  /// Handle step in
  void _handleStepIn() {
    _stepMode = true;
    _isPaused = false;
    
    _sendDAPMessage({
      'type': 'output',
      'category': 'console',
      'text': '⬇️ Step Into\n'
    });
  }

  /// Handle step out
  void _handleStepOut() {
    _stepMode = false;
    _isPaused = false;
    
    _sendDAPMessage({
      'type': 'output',
      'category': 'console',
      'text': '⬆️ Step Out\n'
    });
  }

  /// Handle pause
  void _handlePause() {
    _isPaused = true;
    
    _sendDAPMessage({
      'type': 'stopped',
      'reason': 'pause',
      'line': _currentLine
    });
  }

  /// Callback executado a cada instrução
  void _onInstructionExecute(
    int ip,
    OpCode opCode,
    List<dynamic> stack,
    Map<String, dynamic> globals,
  ) {
    _updateCurrentLine(ip);
    _updateVariables(globals);

    // Verifica breakpoints
    if (_hasBreakpointAtLine(_currentLine)) {
      _isPaused = true;
      
      _sendDAPMessage({
        'type': 'output',
        'category': 'console',
        'text': '🛑 BREAKPOINT atingido na linha $_currentLine\n'
      });
      
      _sendDAPMessage({
        'type': 'stopped',
        'reason': 'breakpoint',
        'line': _currentLine
      });
      return;
    }

    // Modo step-by-step
    if (_stepMode) {
      _isPaused = true;
      
      _sendDAPMessage({
        'type': 'stopped',
        'reason': 'step',
        'line': _currentLine
      });
    }
  }

  /// Callback para chamadas de função
  void _onFunctionCall(String functionName, List<dynamic> args) {
    _sendDAPMessage({
      'type': 'output',
      'category': 'console',
      'text': '📞 Chamando função: $functionName(${args.join(', ')})\n'
    });
  }

  /// Callback para retorno de função
  void _onFunctionReturn(String functionName, dynamic returnValue) {
    _sendDAPMessage({
      'type': 'output',
      'category': 'console',
      'text': '↩️ Retorno de $functionName: $returnValue\n'
    });
  }

  /// Atualiza linha atual baseada no IP
  void _updateCurrentLine(int ip) {
    _currentLine = (ip ~/ 3) + 1; // Estimativa baseada em IP
  }

  /// Atualiza variáveis
  void _updateVariables(Map<String, dynamic> globals) {
    _variables.clear();
    _variables.addAll(globals);
    
    // Enviar variáveis para VS Code
    _sendDAPMessage({
      'type': 'variables',
      'data': _variables
    });
  }

  /// Verifica se há breakpoint na linha
  bool _hasBreakpointAtLine(int line) {
    for (final breakpoints in _breakpoints.values) {
      if (breakpoints.contains(line)) {
        return true;
      }
    }
    return false;
  }

  /// Envia mensagem DAP para o VS Code
  void _sendDAPMessage(Map<String, dynamic> message) {
    final json = jsonEncode(message);
    print('DAP:$json');
    stdout.flush();
  }
}
