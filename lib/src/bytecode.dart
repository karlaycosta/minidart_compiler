import 'dart:io';

/// Define os Opcodes (códigos de operação) para a Máquina Virtual MiniDart.
enum OpCode {
  // --- Operações de Pilha e Constantes ---
  pushConst,
  pop,

  // --- Operações de Variáveis Globais (simplificação para este projeto) ---
  getGlobal,
  setGlobal,
  defineGlobal,

<<<<<<< HEAD
=======
  // --- Operações de Variáveis Locais ---
  getLocal,
  setLocal,

>>>>>>> origin/dev
  // --- Operações Aritméticas e Lógicas ---
  add,
  subtract,
  multiply,
  divide,
  modulo,
  negate,
  not,
  typeof_,      // Operador typeof
  toInt,        // Converte para inteiro
  toDouble,     // Converte para real (double)
  // --- Operações Relacionais ---
  equal,
  greater,
  less,

  // --- Operações de Controle de Fluxo ---
  jump,
  jumpIfFalse,
  loop, // Salto para trás
  break_, // Sai do loop atual
  continue_, // Pula para próxima iteração
  // --- Operações de Função ---
  call, // Chama uma função
  return_, // Retorna de uma função
  
  // --- Operações de Lista ---
  indexAccess, // Acesso por índice: lista[indice]
  indexAssign, // Atribuição por índice: lista[indice] = valor
  createList,  // Cria lista com N elementos da pilha
  listSize,    // Retorna o tamanho da lista
  listAdd,     // Adiciona elemento ao final da lista
  listRemove,  // Remove e retorna último elemento da lista
  listEmpty,   // Verifica se a lista está vazia
  
  // --- Outras Operações ---
  print,
}

/// Representa uma função compilada com seu bytecode
class CompiledFunction {
  /// Nome da função
  final String name;

  /// Número de parâmetros que a função espera
  final int arity;

  /// Bytecode da função
  final BytecodeChunk chunk;

  /// Nomes dos parâmetros para debugging
  final List<String> paramNames;

  CompiledFunction({
    required this.name,
    required this.arity,
    required this.chunk,
    required this.paramNames,
  });

  @override
  String toString() => 'Function($name/$arity)';
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

/// Representa informação de localização no código fonte
class SourceLocation {
  final int line;
  final int column;

  SourceLocation(this.line, this.column);

  @override
  String toString() => 'linha $line, coluna $column';
}

/// Um "chunk" de bytecode representa uma sequência de instruções executáveis.
class BytecodeChunk {
  final List<Instruction> code = [];
  final List<Object?> constants = [];
  final List<int> lines =
      []; // Mapeia cada instrução à sua linha no código fonte
  final List<SourceLocation> locations =
      []; // Mapeia cada instrução à sua localização completa

  /// Adiciona uma instrução ao chunk, associando-a a uma linha.
  void write(OpCode opcode, int line, [int? operand]) {
    code.add(Instruction(opcode, operand));
    lines.add(line);
    locations.add(
      SourceLocation(line, 1),
    ); // Coluna padrão 1 para compatibilidade
  }

  /// Adiciona uma instrução ao chunk com localização completa (linha e coluna)
  void writeWithLocation(
    OpCode opcode,
    SourceLocation location, [
    int? operand,
  ]) {
    code.add(Instruction(opcode, operand));
    lines.add(location.line);
    locations.add(location);
  }

  /// Retorna a linha do código fonte para uma instrução específica
  int getSourceLine(int instructionIndex) {
    if (instructionIndex >= 0 && instructionIndex < lines.length) {
      return lines[instructionIndex];
    }
    return -1;
  }

  /// Retorna a localização completa do código fonte para uma instrução específica
  SourceLocation? getSourceLocation(int instructionIndex) {
    if (instructionIndex >= 0 && instructionIndex < locations.length) {
      return locations[instructionIndex];
    }
    return null;
  }

  /// Adiciona uma constante à tabela e retorna seu índice.
  int addConstant(Object? value) {
    constants.add(value);
    return constants.length - 1;
  }

  /// Desmonta o bytecode para depuração.
  void disassemble() {
    stdout.writeln('--- Desmontagem do Bytecode ---');
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
      if (instruction.opcode == OpCode.pushConst ||
          instruction.opcode == OpCode.getGlobal ||
          instruction.opcode == OpCode.setGlobal ||
          instruction.opcode == OpCode.defineGlobal ||
          instruction.opcode == OpCode.call) {
        operandStr += ' (${constants[instruction.operand!]})';
      }
    }

    stdout.writeln('$offsetStr $lineStr $opName $operandStr');
  }
}
