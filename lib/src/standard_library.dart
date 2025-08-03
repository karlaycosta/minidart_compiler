import 'dart:math' as math;
import 'dart:io';

import 'version.dart';

/// Representa uma função nativa que pode ser chamada
class NativeFunction {
  final String name;
  final int arity;
  final Function(List<Object?>) implementation;

  const NativeFunction(this.name, this.arity, this.implementation);

  /// Executa a função nativa com os argumentos fornecidos
  Object? call(List<Object?> args) {
    if (args.length != arity) {
      throw Exception(
        'Função $name espera $arity argumentos, mas recebeu ${args.length}',
      );
    }
    return implementation(args);
  }

  @override
  String toString() => 'NativeFunction($name/$arity)';
}

/// Gerenciador da biblioteca padrão
class StandardLibrary {
  final Map<String, NativeFunction> _functions = {};
  void Function(String)? _printCallback;

  StandardLibrary({void Function(String)? printCallback}) {
    _printCallback = printCallback;
    _registerMathLibrary();
    _registerStringLibrary();
    _registerIOLibrary();
    _registerDataLibrary();
    _registerTypeLibrary();
    _registerLogicalOperators();
  }

  /// Registra uma função nativa
  void register(String name, int arity, Function(List<Object?>) impl) {
    _functions[name] = NativeFunction(name, arity, impl);
  }

  /// Obtém uma função nativa pelo nome
  NativeFunction? getFunction(String name) {
    return _functions[name];
  }

  /// Verifica se uma função nativa existe
  bool hasFunction(String name) {
    return _functions.containsKey(name);
  }

  /// Lista todas as funções disponíveis
  List<String> listFunctions() {
    return _functions.keys.toList()..sort();
  }

  /// Registra as funções da biblioteca matemática
  void _registerMathLibrary() {
    // Funções trigonométricas
    register('math.sin', 1, (args) => math.sin(_toDouble(args[0])));
    register('math.cos', 1, (args) => math.cos(_toDouble(args[0])));
    register('math.tan', 1, (args) => math.tan(_toDouble(args[0])));
    register('math.asin', 1, (args) => math.asin(_toDouble(args[0])));
    register('math.acos', 1, (args) => math.acos(_toDouble(args[0])));
    register('math.atan', 1, (args) => math.atan(_toDouble(args[0])));

    // Funções exponenciais e logarítmicas
    register('math.exp', 1, (args) => math.exp(_toDouble(args[0])));
    register('math.log', 1, (args) => math.log(_toDouble(args[0])));
    register(
      'math.log10',
      1,
      (args) => math.log(_toDouble(args[0])) / math.ln10,
    );
    register(
      'math.pow',
      2,
      (args) => math.pow(_toDouble(args[0]), _toDouble(args[1])),
    );
    register('math.sqrt', 1, (args) => math.sqrt(_toDouble(args[0])));

    // Funções de arredondamento
    register('math.abs', 1, (args) {
      final value = args[0];
      if (value is int) return value.abs();
      if (value is double) return value.abs();
      throw Exception('math.abs espera um número');
    });
    register('math.ceil', 1, (args) => _toDouble(args[0]).ceil());
    register('math.floor', 1, (args) => _toDouble(args[0]).floor());
    register('math.round', 1, (args) => _toDouble(args[0]).round());

    // Funções de comparação
    register('math.max', 2, (args) {
      final a = _toDouble(args[0]);
      final b = _toDouble(args[1]);
      return math.max(a, b);
    });
    register('math.min', 2, (args) {
      final a = _toDouble(args[0]);
      final b = _toDouble(args[1]);
      return math.min(a, b);
    });

    // Função aleatória
    register('math.random', 0, (args) => math.Random().nextDouble());

    // Constantes matemáticas (como funções sem parâmetros)
    register('math.PI', 0, (args) => math.pi);
    register('math.E', 0, (args) => math.e);
    register('math.LN2', 0, (args) => math.ln2);
    register('math.LN10', 0, (args) => math.ln10);
    register('math.LOG2E', 0, (args) => math.log2e);
    register('math.LOG10E', 0, (args) => math.log10e);
    register('math.SQRT1_2', 0, (args) => math.sqrt1_2);
    register('math.SQRT2', 0, (args) => math.sqrt2);

    // Aliases em português para funções matemáticas
    register('math.raiz', 1, (args) => math.sqrt(_toDouble(args[0])));
    register('math.pi', 0, (args) => math.pi);
    register('math.absoluto', 1, (args) {
      final value = args[0];
      if (value is int) return value.abs();
      if (value is double) return value.abs();
      throw Exception('math.absoluto espera um número');
    });
    register('math.potencia', 2, (args) => math.pow(_toDouble(args[0]), _toDouble(args[1])));
    register('math.arredondar', 1, (args) => _toDouble(args[0]).round());
    register('math.maximo', 2, (args) {
      final a = _toDouble(args[0]);
      final b = _toDouble(args[1]);
      return math.max(a, b);
    });
    register('math.minimo', 2, (args) {
      final a = _toDouble(args[0]);
      final b = _toDouble(args[1]);
      return math.min(a, b);
    });
  }

  /// Registra as funções da biblioteca de strings
  void _registerStringLibrary() {
    // Propriedades básicas
    register('string.tamanho', 1, (args) => _toString(args[0]).length);
    register('string.vazio', 1, (args) => _toString(args[0]).isEmpty);

    // Transformações
    register('string.maiuscula', 1, (args) => _toString(args[0]).toUpperCase());
    register('string.minuscula', 1, (args) => _toString(args[0]).toLowerCase());
    register(
      'string.inverter',
      1,
      (args) => _toString(args[0]).split('').reversed.join(''),
    );
    register('string.limpar', 1, (args) => _toString(args[0]).trim());

    // Verificações
    register(
      'string.contem',
      2,
      (args) => _toString(args[0]).contains(_toString(args[1])),
    );
    register(
      'string.comecaCom',
      2,
      (args) => _toString(args[0]).startsWith(_toString(args[1])),
    );
    register(
      'string.terminaCom',
      2,
      (args) => _toString(args[0]).endsWith(_toString(args[1])),
    );

    // Busca e manipulação
    register(
      'string.encontrar',
      2,
      (args) => _toString(args[0]).indexOf(_toString(args[1])),
    );
    register(
      'string.encontrarUltimo',
      2,
      (args) => _toString(args[0]).lastIndexOf(_toString(args[1])),
    );
    register(
      'string.substituir',
      3,
      (args) =>
          _toString(args[0]).replaceAll(_toString(args[1]), _toString(args[2])),
    );
    register(
      'string.substituirPrimeiro',
      3,
      (args) => _toString(
        args[0],
      ).replaceFirst(_toString(args[1]), _toString(args[2])),
    );

    // Extração
    register('string.fatiar', 3, (args) {
      final str = _toString(args[0]);
      final start = _toInt(args[1]);
      final end = _toInt(args[2]);

      // Validações
      if (start < 0 || end < 0 || start > str.length || end > str.length) {
        throw Exception('Índices de fatia fora dos limites da string');
      }
      if (start > end) {
        throw Exception('Índice inicial deve ser menor ou igual ao final');
      }

      return str.substring(start, end);
    });

    register('string.caractereEm', 2, (args) {
      final str = _toString(args[0]);
      final index = _toInt(args[1]);

      if (index < 0 || index >= str.length) {
        throw Exception(
          'Índice $index fora dos limites da string (0-${str.length - 1})',
        );
      }

      return str[index];
    });

    // Repetição e concatenação
    register(
      'string.repetir',
      2,
      (args) => _toString(args[0]) * _toInt(args[1]),
    );
    register(
      'string.concatenar',
      2,
      (args) => _toString(args[0]) + _toString(args[1]),
    );

    // Divisão e junção
    register('string.dividir', 2, (args) {
      final str = _toString(args[0]);
      final separator = _toString(args[1]);
      final parts = str.split(separator);

      // Retorna o número de partes como uma representação simples
      return parts.length;
    });
  }

  /// Registra as funções da biblioteca de entrada/saída
  void _registerIOLibrary() {
    register('io.imprimir', 1, (args) {
      final output = args[0].toString();
      if (_printCallback != null) {
        _printCallback!(output);
      } else {
        print(output);
      }
      return null;
    });

    register('io.escrever', 1, (args) {
      stdout.write(args[0]);
      return null;
    });

    register('io.novaLinha', 0, (args) {
      stdout.writeln();
      return null;
    });

    // Nota: io.lerTexto() é uma simulação para propósitos educacionais
    // Em uma implementação real, seria necessário integração com stdin
    register('io.lerTexto', 0, (args) {
      // Por enquanto, retorna uma string fixa para demonstração
      // TODO: Implementar leitura real do stdin
      return "entrada_do_usuario";
    });

    register('io.lerNumero', 0, (args) {
      // Simulação de leitura de número
      // TODO: Implementar leitura real e conversão
      return 42;
    });
  }

  // ===== UTILITÁRIOS DE CONVERSÃO =====

  /// Converte um valor para double
  double _toDouble(Object? value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      final parsed = double.tryParse(value);
      if (parsed != null) return parsed;
    }
    throw Exception('Não é possível converter $value para número real');
  }

  /// Converte um valor para int
  int _toInt(Object? value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      final parsed = int.tryParse(value);
      if (parsed != null) return parsed;
    }
    throw Exception('Não é possível converter $value para número inteiro');
  }

  /// Converte um valor para string
  String _toString(Object? value) {
    if (value is String) return value;
    return value.toString();
  }

  /// Registra as funções da biblioteca de data e tempo
  void _registerDataLibrary() {
    // Data atual (YYYY-MM-DD)
    register('data.hoje', 0, (args) {
      return DateTime.now().toString().split(' ')[0];
    });
    
    // Alias para compatibilidade
    // TODO: A data não está no formato brasileiro 2025-08-02
    register('data.dataAtual', 0, (args) {
      return DateTime.now().toString().split(' ')[0];
    });

    // Hora atual (HH:MM:SS)
    register('data.horaAtual', 0, (args) {
      final now = DateTime.now();
      return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    });

    // Diferença entre duas datas em dias
    register('data.diferenca', 2, (args) {
      final data1Str = _toString(args[0]);
      final data2Str = _toString(args[1]);

      try {
        final data1 = DateTime.parse(data1Str);
        final data2 = DateTime.parse(data2Str);
        return data2.difference(data1).inDays;
      } catch (e) {
        throw Exception('Formato de data inválido. Use YYYY-MM-DD');
      }
    });

    // Verificar se um ano é bissexto
    register('data.ehBissexto', 1, (args) {
      final ano = _toInt(args[0]);
      return (ano % 4 == 0 && ano % 100 != 0) || (ano % 400 == 0);
    });

    // Formatar data (básico)
    register('data.formatar', 2, (args) {
      final dataStr = _toString(args[0]);
      final formato = _toString(args[1]);

      try {
        final data = DateTime.parse(dataStr);

        // Formatação básica DD/MM/YYYY
        if (formato == "dd/MM/yyyy") {
          return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
        }

        // Formatação YYYY-MM-DD (padrão)
        return data.toString().split(' ')[0];
      } catch (e) {
        throw Exception('Formato de data inválido. Use YYYY-MM-DD');
      }
    });

    // Obter dia da semana (1=Segunda, 7=Domingo)
    register('data.diaSemana', 1, (args) {
      final dataStr = _toString(args[0]);

      try {
        final data = DateTime.parse(dataStr);
        return data.weekday;
      } catch (e) {
        throw Exception('Formato de data inválido. Use YYYY-MM-DD');
      }
    });

    // Obter nome do mês
    register('data.nomeMes', 1, (args) {
      final mes = _toInt(args[0]);

      const meses = [
        '',
        'Janeiro',
        'Fevereiro',
        'Março',
        'Abril',
        'Maio',
        'Junho',
        'Julho',
        'Agosto',
        'Setembro',
        'Outubro',
        'Novembro',
        'Dezembro',
      ];

      if (mes < 1 || mes > 12) {
        throw Exception('Mês deve estar entre 1 e 12');
      }

      return meses[mes];
    });

    // Obter nome do dia da semana
    register('data.nomeDiaSemana', 1, (args) {
      final diaSemana = _toInt(args[0]);

      const dias = [
        '',
        'Segunda-feira',
        'Terça-feira',
        'Quarta-feira',
        'Quinta-feira',
        'Sexta-feira',
        'Sábado',
        'Domingo',
      ];

      if (diaSemana < 1 || diaSemana > 7) {
        throw Exception(
          'Dia da semana deve estar entre 1 (Segunda) e 7 (Domingo)',
        );
      }

      return dias[diaSemana];
    });

    // Validar se uma string é uma data válida
    register('data.ehDataValida', 1, (args) {
      final dataStr = _toString(args[0]);

      try {
        DateTime.parse(dataStr);
        return true;
      } catch (e) {
        return false;
      }
    });

    // Adicionar dias a uma data
    register('data.adicionarDias', 2, (args) {
      final dataStr = _toString(args[0]);
      final dias = _toInt(args[1]);

      try {
        final data = DateTime.parse(dataStr);
        final novaData = data.add(Duration(days: dias));
        return novaData.toString().split(' ')[0];
      } catch (e) {
        throw Exception('Formato de data inválido. Use YYYY-MM-DD');
      }
    });

    // Timestamp Unix atual
    register('data.timestamp', 0, (args) {
      return DateTime.now().millisecondsSinceEpoch ~/ 1000;
    });

    // Converter timestamp para data
    register('data.deTimestamp', 1, (args) {
      final timestamp = _toInt(args[0]);
      final data = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      return data.toString().split(' ')[0];
    });
  }

  /// Registra as funções da biblioteca de tipos
  void _registerTypeLibrary() {
    // Função para converter qualquer tipo para texto
    register('paraTexto', 1, (args) {
      final value = args[0];
      
      // Conversão específica para cada tipo
      if (value == null) return 'nulo';
      if (value is bool) return value ? 'verdadeiro' : 'falso';
      if (value is List) {
        // Para listas, mostra os elementos separados por vírgula entre colchetes
        final elementos = value.map((e) => e?.toString() ?? 'nulo').join(', ');
        return '[$elementos]';
      }
      
      // Para outros tipos, usa toString() padrão
      return value.toString();
    });

    // Função para obter o tipo de uma variável (similar ao runtimeType do Dart)
    register('tipo', 1, (args) {
      final value = args[0];

      if (value == null) return 'nulo';
      if (value is int) return 'inteiro';
      if (value is double) return 'real';
      if (value is String) return 'texto';
      if (value is bool) return 'logico';
      if (value is List) return 'lista';

      // Fallback para tipos não reconhecidos
      return 'desconhecido';
    });

    // Função de debug para inspecionar valores
    register('debug', 1, (args) {
      final value = args[0];
      final tipo = value == null
          ? 'nulo'
          : value is int
          ? 'inteiro'
          : value is double
          ? 'real'
          : value is String
          ? 'texto'
          : value is bool
          ? 'logico'
          : 'desconhecido';

      print('DEBUG: valor=$value, tipo=$tipo');
      return value; // Retorna o valor original para não interromper o fluxo
    });

    // Função para mostrar informações de debug (sem argumentos)
    register('info_debug', 0, (args) {
      print('LiPo Debug Info:');
      print('  • Compilador: $versionString');
      print('  • Sistema de tipos: dinâmico com inferência');
      print('  • Funções nativas disponíveis: ${_functions.length}');
      return null;
    });
  }

  /// Registra operadores lógicos internos
  void _registerLogicalOperators() {
    // Operador OR lógico
    register('__or__', 2, (args) {
      final left = args[0];
      final right = args[1];
      
      // Converte para boolean e faz OR
      final leftBool = _toBool(left);
      final rightBool = _toBool(right);
      
      return leftBool || rightBool;
    });

    // Operador AND lógico
    register('__and__', 2, (args) {
      final left = args[0];
      final right = args[1];
      
      // Converte para boolean e faz AND
      final leftBool = _toBool(left);
      final rightBool = _toBool(right);
      
      return leftBool && rightBool;
    });
  }

  /// Converte um valor para boolean seguindo as regras
  bool _toBool(Object? value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value != 0;
    if (value is double) return value != 0.0;
    if (value is String) return value.isNotEmpty;
    return true; // outros valores são considerados true
  }
}
