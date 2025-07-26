import 'dart:io';
import 'dart:convert';
import 'bytecode.dart';
import 'standard_library.dart';

enum InterpretResult { ok, compileError, runtimeError }

/// Representa um frame de chamada de função
class CallFrame {
  /// Função sendo executada
  final CompiledFunction function;
  
  /// Ponteiro de instrução para esta função
  int ip;
  
  /// Posição na pilha onde começam as variáveis locais desta função
  final int slots;
  
  CallFrame({
    required this.function,
    this.ip = 0,
    required this.slots,
  });
  
  @override
  String toString() => 'CallFrame(${function.name}/${function.arity})';
}

class VM {
  late BytecodeChunk _chunk;
  int _ip = 0;
  final List<Object?> _stack = [];
  final Map<String, Object?> _globals = {};
  final List<CallFrame> _frames = [];
  Map<String, CompiledFunction> _functions = {};
  late StandardLibrary _standardLibrary;
  bool _debugMode = false; // Modo debug da VM
  
  // Callbacks para debugger interativo
  Function(int ip, OpCode opCode, List<dynamic> stack, Map<String, dynamic> globals)? onInstructionExecute;
  Function(String functionName, List<dynamic> args)? onFunctionCall;
  Function(String functionName, dynamic returnValue)? onFunctionReturn;

  VM() {
    // Configura stdout para UTF-8
    stdout.encoding = utf8;
    // Inicializa a biblioteca padrão
    _standardLibrary = StandardLibrary();
  }

  /// Ativa ou desativa o modo debug da VM
  void setDebugMode(bool enabled) {
    _debugMode = enabled;
  }

  InterpretResult interpret(BytecodeChunk chunk) {
    _chunk = chunk;
    _ip = 0;
    _stack.clear();
    _globals.clear();
    _frames.clear();

    try {
      return _run();
    } on VmRuntimeError catch (e) {
      stderr.writeln('Erro de Execução: ${e.message}');
      return InterpretResult.runtimeError;
    }
  }

  /// Define as funções disponíveis para execução
  void setFunctions(Map<String, CompiledFunction> functions) {
    _functions = functions;
  }

  InterpretResult _run() {
    while (true) {
      final instruction = _chunk.code[_ip++];
      
      // Debug: mostra instrução atual
      if (_debugMode) {
        _debugInstruction(instruction);
      }
      
      // Callback para debugger interativo
      if (onInstructionExecute != null) {
        onInstructionExecute!(_ip - 1, instruction.opcode, List.from(_stack), Map.from(_globals));
      }
      
      switch (instruction.opcode) {
        case OpCode.pushConst:
          _push(_chunk.constants[instruction.operand!]);
          break;
        case OpCode.pop:
          _pop();
          break;
        case OpCode.defineGlobal:
          final name = _chunk.constants[instruction.operand!] as String;
          _globals[name] = _pop();
          break;
        case OpCode.getGlobal:
          final name = _chunk.constants[instruction.operand!] as String;
          if (_globals.containsKey(name)) {
            _push(_globals[name]);
          } else if (_standardLibrary.hasFunction(name)) {
            // É uma função nativa, coloca o nome na pilha para posterior chamada
            _push(name);
          } else {
            _runtimeError("Variável global indefinida '$name'.");
          }
          break;
        case OpCode.setGlobal:
          final name = _chunk.constants[instruction.operand!] as String;
          if (!_globals.containsKey(name)) {
            _runtimeError("Variável global indefinida '$name'.");
          }
          _globals[name] = _peek(0); // Atribui sem desempilhar
          break;
        case OpCode.add:
          final b = _pop();
          final a = _pop();
          if (a is num && b is num) {
            _push(a + b);
          } else if (a is String && b is String) {
            _push(a + b);
          } else {
            _runtimeError("Operandos devem ser dois números ou duas strings.");
          }
          break;
        case OpCode.subtract:
          _binaryOp((a, b) => a - b);
          break;
        case OpCode.multiply:
          _binaryOp((a, b) => a * b);
          break;
        case OpCode.divide:
          _binaryOp((a, b) => a / b);
          break;
        case OpCode.modulo:
          _binaryOp((a, b) => a % b);
          break;
        case OpCode.negate:
          final value = _pop();
          if (value is num) {
            _push(-value);
          } else {
            _runtimeError("Operando deve ser um número.");
          }

          break;
        case OpCode.not:
          _push(!_isTruthy(_pop()));
          break;
        case OpCode.toInt:
          final value = _pop();
          if (value is double) {
            _push(value.toInt());
          } else {
            _push(value); // Se já é int ou outro tipo, mantém
          }
          break;
        case OpCode.equal:
          final b = _pop();
          final a = _pop();
          _push(a == b);
          break;
        case OpCode.greater:
          _binaryOp((a, b) => a > b);
          break;
        case OpCode.less:
          _binaryOp((a, b) => a < b);
          break;
        case OpCode.print:
          final value = _stringify(_pop());
          stdout.write('$value\n');
          break;
        case OpCode.jump:
          _ip += instruction.operand!;
          break;
        case OpCode.jumpIfFalse:
          if (!_isTruthy(_peek(0))) {
            _ip += instruction.operand!;
          }
          _pop(); // Remove a condição da pilha após verificá-la
          break;
        case OpCode.loop:
          _ip -= instruction.operand!;
          break;
        case OpCode.call:
          final argCount = instruction.operand!;
          if (!_callValue(_peek(0), argCount)) {  // A função está no topo da pilha
            return InterpretResult.runtimeError;
          }
          break;
        case OpCode.return_:
          return InterpretResult.ok;
      }
    }
  }

  void _binaryOp(Object Function(num a, num b) op) {
    final b = _pop();
    final a = _pop();
    if (a is num && b is num) {
      _push(op(a, b));
    } else {
      _runtimeError("Operandos devem ser números.");
    }
  }

  bool _isTruthy(Object? value) {
    if (value == null) return false;
    if (value is bool) return value;
    return true; // Números e strings são 'truthy'
  }

  String _stringify(Object? value) {
    if (value == null) return "nulo";
    return value.toString();
  }

  void _push(Object? value) => _stack.add(value);
  Object? _pop() => _stack.removeLast();
  Object? _peek(int distance) => _stack[_stack.length - 1 - distance];

  void _runtimeError(String message) {
    final currentLocation = _getCurrentSourceLocation();
    if (currentLocation != null) {
      throw VmRuntimeError('$message\n[$currentLocation]');
    } else {
      throw VmRuntimeError(message);
    }
  }

  /// Obtém a localização atual do código fonte
  SourceLocation? _getCurrentSourceLocation() {
    // _ip - 1 porque _ip já foi incrementado para a próxima instrução
    final instructionIndex = _ip - 1;
    return _chunk.getSourceLocation(instructionIndex);
  }

  // ===== MÉTODOS PARA CHAMADAS DE FUNÇÃO =====

  /// Chama um valor (que deve ser uma função)
  bool _callValue(Object? callee, int argCount) {
    if (callee is String) {
      // Primeiro verifica se é uma função nativa
      final nativeFunction = _standardLibrary.getFunction(callee);
      if (nativeFunction != null) {
        return _callNative(nativeFunction, argCount);
      }
      
      // Se não é nativa, verifica se é uma função compilada
      final function = _functions[callee];
      if (function != null) {
        return _call(function, argCount);
      } else {
        _runtimeError("Função '$callee' não encontrada.");
        return false;
      }
    } else if (callee is CompiledFunction) {
      return _call(callee, argCount);
    } else {
      _runtimeError("Só é possível chamar funções. Recebido: ${callee.runtimeType}");
      return false;
    }
  }

  /// Executa uma chamada de função nativa
  bool _callNative(NativeFunction nativeFunction, int argCount) {
    if (argCount != nativeFunction.arity) {
      _runtimeError("Esperado ${nativeFunction.arity} argumentos mas recebeu $argCount.");
      return false;
    }

    // Remove a função que está no topo
    _pop(); // Remove o nome da função da pilha
    
    // Coleta os argumentos da pilha
    final args = <Object?>[];
    for (int i = 0; i < argCount; i++) {
      args.insert(0, _pop()); // Remove argumentos na ordem reversa
    }
    
    try {
      // Executa a função nativa
      final result = nativeFunction.call(args);
      
      // Coloca o resultado na pilha (mesmo que seja null)
      _push(result);
      
      return true;
    } catch (e) {
      _runtimeError("Erro na função nativa ${nativeFunction.name}: $e");
      return false;
    }
  }

  /// Executa uma chamada de função
  bool _call(CompiledFunction function, int argCount) {
    if (argCount != function.arity) {
      _runtimeError("Esperado ${function.arity} argumentos mas recebeu $argCount.");
      return false;
    }

    // Remove a função que está no topo
    _pop(); // Remove a função da pilha
    
    // Salva os argumentos em variáveis globais temporárias para os parâmetros
    final args = <Object?>[];
    for (int i = 0; i < argCount; i++) {
      args.insert(0, _pop()); // Remove argumentos na ordem reversa
    }
    
    // Callback para debugger
    if (onFunctionCall != null) {
      onFunctionCall!(function.name, args);
    }
    
    // Salva as variáveis globais que podem ser sobrescritas pelos parâmetros
    final savedGlobals = <String, Object?>{};
    for (int i = 0; i < function.paramNames.length; i++) {
      final paramName = function.paramNames[i];
      if (_globals.containsKey(paramName)) {
        savedGlobals[paramName] = _globals[paramName];
      }
      _globals[paramName] = args[i];
    }

    // Cria um novo frame de chamada
    final frame = CallFrame(
      function: function,
      ip: 0,
      slots: _stack.length,
    );
    _frames.add(frame);

    // Executa a função
    final result = _executeFunction(frame);
    
    // Restaura as variáveis globais originais
    for (final paramName in function.paramNames) {
      if (savedGlobals.containsKey(paramName)) {
        _globals[paramName] = savedGlobals[paramName];
      } else {
        _globals.remove(paramName);
      }
    }
    
    return result;
  }

  /// Executa o bytecode de uma função
  bool _executeFunction(CallFrame frame) {
    final oldChunk = _chunk;
    final oldIp = _ip;

    _chunk = frame.function.chunk;
    _ip = frame.ip;

    try {
      while (true) {
        final instruction = _chunk.code[_ip++];
        switch (instruction.opcode) {
          case OpCode.pushConst:
            _push(_chunk.constants[instruction.operand!]);
            break;
          case OpCode.return_:
            // Remove o frame
            _frames.removeLast();
            
            // Resultado já está no topo da pilha
            final result = _pop();
            
            // Callback para debugger
            if (onFunctionReturn != null) {
              onFunctionReturn!(frame.function.name, result);
            }
            
            // Restaura contexto anterior
            _chunk = oldChunk;
            _ip = oldIp;
            
            // Coloca o resultado na pilha
            _push(result);
            
            return true;
          default:
            // Para outras operações, usa a implementação padrão
            _executeInstruction(instruction);
            break;
        }
      }
    } catch (e) {
      _chunk = oldChunk;
      _ip = oldIp;
      rethrow;
    }
  }

  /// Executa uma instrução individual
  void _executeInstruction(Instruction instruction) {
    switch (instruction.opcode) {
      case OpCode.pushConst:
        _push(_chunk.constants[instruction.operand!]);
        break;
      case OpCode.pop:
        _pop();
        break;
      case OpCode.defineGlobal:
        final name = _chunk.constants[instruction.operand!] as String;
        _globals[name] = _pop();
        break;
      case OpCode.getGlobal:
        final name = _chunk.constants[instruction.operand!] as String;
        if (!_globals.containsKey(name)) {
          _runtimeError("Variável global indefinida '$name'.");
        }
        _push(_globals[name]);
        break;
      case OpCode.setGlobal:
        final name = _chunk.constants[instruction.operand!] as String;
        if (!_globals.containsKey(name)) {
          _runtimeError("Variável global indefinida '$name'.");
        }
        _globals[name] = _peek(0); // Atribui sem desempilhar
        break;
      case OpCode.add:
        final b = _pop();
        final a = _pop();
        if (a is num && b is num) {
          _push(a + b);
        } else if (a is String && b is String) {
          _push(a + b);
        } else {
          _runtimeError("Operandos devem ser números ou strings.");
        }
        break;
      case OpCode.subtract:
        _binaryOp((a, b) => a - b);
        break;
      case OpCode.multiply:
        _binaryOp((a, b) => a * b);
        break;
      case OpCode.divide:
        _binaryOp((a, b) => a / b);
        break;
      case OpCode.modulo:
        _binaryOp((a, b) => a % b);
        break;
      case OpCode.negate:
        final a = _pop();
        if (a is num) {
          _push(-a);
        } else {
          _runtimeError("Operando deve ser um número.");
        }
        break;
      case OpCode.not:
        _push(_isFalsey(_pop()));
        break;
      case OpCode.equal:
        final b = _pop();
        final a = _pop();
        _push(a == b);
        break;
      case OpCode.greater:
        _binaryOp((a, b) => a > b);
        break;
      case OpCode.less:
        _binaryOp((a, b) => a < b);
        break;
      case OpCode.print:
        final value = _pop();
        // Se é um número e é inteiro, imprimir como inteiro
        if (value is double && value == value.truncate()) {
          print(value.toInt());
        } else {
          print(value);
        }
        break;
      case OpCode.jump:
        _ip += instruction.operand!;
        break;
      case OpCode.jumpIfFalse:
        if (!_isTruthy(_peek(0))) {
          _ip += instruction.operand!;
        }
        _pop(); // Remove a condição da pilha após verificá-la
        break;
      case OpCode.loop:
        _ip -= instruction.operand!;
        break;
      case OpCode.call:
        final argCount = instruction.operand!;
        if (!_callValue(_peek(0), argCount)) {
          _runtimeError("Erro na chamada de função.");
        }
        break;
      default:
        _runtimeError("Operação não suportada: ${instruction.opcode}");
        break;
    }
  }

  /// Verifica se um valor é falsey (nulo ou false)
  bool _isFalsey(Object? value) {
    if (value == null) return true;
    if (value is bool) return !value;
    return false;
  }

  /// Debug: mostra informações da instrução atual
  void _debugInstruction(Instruction instruction) {
    // Mostra posição atual e instrução
    print('🔍 [VM] IP: ${_ip - 1} | ${instruction.opcode}${instruction.operand != null ? ' ${instruction.operand}' : ''}');
    
    // Mostra pilha atual
    stdout.write('    Stack: [');
    for (int i = 0; i < _stack.length; i++) {
      if (i > 0) stdout.write(', ');
      final value = _stack[i];
      if (value is String) {
        stdout.write('"$value"');
      } else {
        stdout.write('$value');
      }
    }
    print(']');
    
    // Mostra globals relevantes (apenas se não vazio)
    if (_globals.isNotEmpty && _globals.length <= 5) {
      stdout.write('    Globals: {');
      final entries = _globals.entries.toList();
      for (int i = 0; i < entries.length; i++) {
        if (i > 0) stdout.write(', ');
        final entry = entries[i];
        stdout.write('${entry.key}: ${entry.value}');
      }
      print('}');
    }
    print('');
  }

  // ===== MÉTODOS PARA DEBUGGER INTERATIVO =====

  /// Executa uma única instrução (para step-by-step)
  InterpretResult interpretStep(BytecodeChunk chunk) {
    // Inicializa se necessário
    try {
      if (_chunk != chunk) {
        _chunk = chunk;
        _ip = 0;
        _stack.clear();
        _globals.clear();
        _frames.clear();
      }
    } catch (e) {
      // Se _chunk não foi inicializada ainda
      _chunk = chunk;
      _ip = 0;
      _stack.clear();
      _globals.clear();
      _frames.clear();
    }
    
    if (_ip >= chunk.code.length) {
      return InterpretResult.ok;
    }
    
    final instruction = chunk.code[_ip++];
    
    if (_debugMode) {
      _debugInstruction(instruction);
    }
    
    if (onInstructionExecute != null) {
      onInstructionExecute!(_ip - 1, instruction.opcode, List.from(_stack), Map.from(_globals));
    }
    
    try {
      _executeInstruction(instruction);
      return InterpretResult.ok;
    } on VmRuntimeError catch (e) {
      stderr.writeln('Erro de Execução: ${e.message}');
      return InterpretResult.runtimeError;
    }
  }

  /// Verifica se chegou ao fim do programa
  bool isAtEnd() {
    return _ip >= _chunk.code.length;
  }

  /// Obtém valor de uma variável global
  Object? getGlobalValue(String name) {
    if (_globals.containsKey(name)) {
      return _globals[name];
    }
    throw VmRuntimeError("Variável '$name' não encontrada");
  }

  /// Obtém todas as variáveis globais
  Map<String, Object?> getAllGlobals() {
    return Map.from(_globals);
  }

  /// Obtém valores da pilha
  List<Object?> getStackValues() {
    return List.from(_stack);
  }

  /// Obtém call stack atual
  List<CallFrame> getCallStack() {
    return List.from(_frames);
  }

  /// Define callback para execução de instrução
  void setOnInstructionExecute(Function(int ip, OpCode opCode, List<dynamic> stack, Map<String, dynamic> globals) callback) {
    onInstructionExecute = callback;
  }

  /// Define callback para chamada de função
  void setOnFunctionCall(Function(String functionName, List<dynamic> args) callback) {
    onFunctionCall = callback;
  }

  /// Define callback para retorno de função
  void setOnFunctionReturn(Function(String functionName, dynamic returnValue) callback) {
    onFunctionReturn = callback;
  }

}

class VmRuntimeError implements Exception {
  final String message;
  VmRuntimeError(this.message);
}
