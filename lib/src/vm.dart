import 'bytecode.dart';

enum InterpretResult { ok, compileError, runtimeError }

class VM {
  late BytecodeChunk _chunk;
  int _ip = 0;
  final List<Object?> _stack = [];
  final Map<String, Object?> _globals = {};

  InterpretResult interpret(BytecodeChunk chunk) {
    _chunk = chunk;
    _ip = 0;
    _stack.clear();
    _globals.clear();

    try {
      return _run();
    } on VmRuntimeError catch (e) {
      print('Erro de Execução: ${e.message}');
      _printStackTrace();
      return InterpretResult.runtimeError;
    }
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
          print(_stringify(_pop()));
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
    throw VmRuntimeError(message);
  }

  void _printStackTrace() {
    for (int i = _ip - 1; i >= 0; i--) {
      final line = _chunk.lines[i];
      if (line != -1) {
        print('[linha $line]');
        break;
      }
    }
  }
}

class VmRuntimeError implements Exception {
  final String message;
  VmRuntimeError(this.message);
}
