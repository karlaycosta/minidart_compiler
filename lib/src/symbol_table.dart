import 'token.dart';

/// Armazena informações sobre um símbolo (variável) declarado.
class Symbol {
  final Token declaration;
  bool isInitialized = false;

  Symbol(this.declaration);
}

/// Gerencia os escopos e os símbolos declarados dentro deles.
class SymbolTable {
  final SymbolTable? enclosing;
  final Map<String, Symbol> _symbols = {};

  SymbolTable({this.enclosing});

  /// Define um novo símbolo no escopo atual.
  void define(Token name) {
    // Permite redefinição em escopos filhos, mas não no mesmo escopo.
    if (_symbols.containsKey(name.lexeme)) {
      // Em uma implementação mais robusta, isso seria um erro.
      // Aqui, permitimos sombreamento (shadowing).
    }
    _symbols[name.lexeme] = Symbol(name);
  }

  /// Atribui um valor a um símbolo existente, marcando-o como inicializado.
  /// Retorna verdadeiro se o símbolo foi encontrado e atualizado.
  bool assign(Token name) {
    if (_symbols.containsKey(name.lexeme)) {
      _symbols[name.lexeme]!.isInitialized = true;
      return true;
    }
    if (enclosing != null) {
      return enclosing!.assign(name);
    }
    return false;
  }

  /// Busca por um símbolo, começando do escopo atual e subindo para os pais.
  Symbol? get(Token name) {
    if (_symbols.containsKey(name.lexeme)) {
      return _symbols[name.lexeme];
    }
    if (enclosing != null) {
      return enclosing!.get(name);
    }
    return null;
  }
}
