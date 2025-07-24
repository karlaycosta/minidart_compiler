import 'dart:io';
import 'dart:convert';
import 'bytecode.dart';

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

  VM() {
    // Configura stdout para UTF-8
    stdout.encoding = utf8;
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
      print('Erro de Execução: ${e.message}');
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
          stdout.write(value + '\n');
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
      // Resolve o nome da função para a função compilada
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
    
    // Define parâmetros como variáveis globais temporárias
    for (int i = 0; i < function.paramNames.length; i++) {
      _globals[function.paramNames[i]] = args[i];
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
    
    // Limpa parâmetros temporários
    for (final paramName in function.paramNames) {
      _globals.remove(paramName);
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
        print(_pop());
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

}

class VmRuntimeError implements Exception {
  final String message;
  VmRuntimeError(this.message);
}
