/// Uma classe centralizada para reportar erros durante a compilação.
class ErrorReporter {
  bool _hadError = false;
  final List<String> _errors = [];

  bool get hadError => _hadError;
  List<String> get errors => _errors;

  /// Reporta um erro em uma linha específica.
  void report(int line, String where, String message) {
    final fullMessage = '[Linha $line] Erro $where: $message';
    print(fullMessage);
    _errors.add(message); // Armazena apenas a mensagem sem formatação
    _hadError = true;
  }

  /// Reporta um erro de sintaxe associado a um token.
  void error(int line, String message) {
    report(line, "", message);
  }

  /// Reseta o estado de erro para uma nova compilação.
  void reset() {
    _hadError = false;
    _errors.clear();
  }
}
