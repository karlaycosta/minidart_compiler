/// Define os Opcodes (códigos de operação) para a Máquina Virtual MiniDart.
enum OpCode {
  // --- Operações de Pilha e Constantes ---
  pushConst,
  pop,

  // --- Operações de Variáveis Globais (simplificação para este projeto) ---
  getGlobal,
  setGlobal,
  defineGlobal,

  // --- Operações Aritméticas e Lógicas ---
  add,
  subtract,
  multiply,
  divide,
  negate,
  not,

  // --- Operações Relacionais ---
  equal,
  greater,
  less,

  // --- Operações de Controle de Fluxo ---
  jump,
  jumpIfFalse,
  loop, // Salto para trás

  // --- Outras Operações ---
  print,
  return_,
}

/// Representa uma única instrução de bytecode.
class Instruction {
  final OpCode opcode;
  final int? operand;

  Instruction(this.opcode, [this.operand]);

  @override
  String toString() {
    return '${opcode.name}${operand != null ? ' $operand' : ''}';
  }
}

/// Um "chunk" de bytecode representa uma sequência de instruções executáveis.
class BytecodeChunk {
  final List<Instruction> code = [];
  final List<Object?> constants = [];
  final List<int> lines = []; // Mapeia cada instrução à sua linha no código fonte

  /// Adiciona uma instrução ao chunk, associando-a a uma linha.
  void write(OpCode opcode, int line, [int? operand]) {
    code.add(Instruction(opcode, operand));
    lines.add(line);
  }

  /// Adiciona uma constante à tabela e retorna seu índice.
  int addConstant(Object? value) {
    constants.add(value);
    return constants.length - 1;
  }

  /// Desmonta o bytecode para depuração.
  void disassemble() {
    print('--- Desmontagem do Bytecode ---');
    for (int offset = 0; offset < code.length; offset++) {
      _disassembleInstruction(offset);
    }
  }

  void _disassembleInstruction(int offset) {
    final instruction = code[offset];
    final offsetStr = offset.toString().padLeft(4, '0');
    final lineStr = lines[offset].toString().padLeft(4, ' ');
    final opName = instruction.opcode.name.padRight(16);
    
    String operandStr = '';
    if (instruction.operand != null) {
      operandStr = instruction.operand.toString().padLeft(4, '0');
      if (instruction.opcode == OpCode.pushConst || instruction.opcode == OpCode.getGlobal || instruction.opcode == OpCode.setGlobal || instruction.opcode == OpCode.defineGlobal) {
        operandStr += ' (${constants[instruction.operand!]})';
      }
    }

    print('$offsetStr $lineStr $opName $operandStr');
  }
}
