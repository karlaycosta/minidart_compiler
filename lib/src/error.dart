/// Uma classe centralizada para reportar erros durante a compilação.
class ErrorReporter {
  bool _hadError = false;

  bool get hadError => _hadError;

  /// Reporta um erro em uma linha específica.
  void report(int line, String where, String message) {
    print('[Linha $line] Erro $where: $message');
    _hadError = true;
  }

  /// Reporta um erro de sintaxe associado a um token.
  void error(int line, String message) {
    report(line, "", message);
  }

  /// Reseta o estado de erro para uma nova compilação.
  void reset() {
    _hadError = false;
  }
}
