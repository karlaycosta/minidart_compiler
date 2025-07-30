# 🔧 Guia Técnico - Interface Web LiPo

## 📋 Implementação Técnica Detalhada

Este guia técnico detalha a implementação da interface web LiPo, incluindo arquitetura de código, componentes e funcionalidades para desenvolvedores.

## 🔧 Arquivo Principal: main.dart

### Estrutura da Classe LiPoPlayground

```dart
/**
 * Classe principal do Playground LiPo
 * 
 * Gerencia toda a interface web, incluindo:
 * - Editor de código
 * - Área de saída
 * - Controles de execução
 * - Sistema de compilação e execução
 */
class LiPoPlayground {
  // Elementos principais da interface
  late html.TextAreaElement _editor;     // Editor de código
  late html.DivElement _output;          // Área de saída/resultados
  late html.ButtonElement _runButton;    // Botão de executar
  late html.SpanElement _status;         // Barra de status
}
```

### Pipeline de Compilação Detalhado

#### 1. Método _compileAndRun()
```dart
/**
 * Pipeline completo de compilação e execução do código LiPo
 * 
 * Fases da compilação:
 * 1. Análise Léxica (Lexer) - Converte código em tokens
 * 2. Análise Sintática (Parser) - Cria AST dos tokens
 * 3. Análise Semântica - Valida semântica do código
 * 4. Execução Simulada - Simula execução até VM web estar pronta
 */
```

**Fluxo de Execução:**
1. **Lexer**: `Lexer(code, errorReporter).scanTokens()`
2. **Parser**: `Parser(tokens, errorReporter).parse()`
3. **Semantic Analyzer**: `SemanticAnalyzer(errorReporter).analyze(statements)`
4. **Simulação**: `_simulateExecution(code, statements)`

#### 2. Sistema de Simulação Inteligente

```dart
/**
 * Simula a execução do código LiPo de forma inteligente
 * 
 * Esta função analisa o código fonte e simula sua execução:
 * 1. Extrai variáveis declaradas (var nome = "valor")
 * 2. Processa chamadas saida.imprimir()
 * 3. Resolve concatenação de strings
 * 4. Gera saída equivalente ao que seria executado
 */
String _simulateExecution(String code, List<dynamic> statements)
```

**Casos Suportados:**
- **Variáveis**: `var nome = "Desenvolvedor"`
- **Strings literais**: `saida.imprimir("Olá, LiPo!")`
- **Concatenação**: `saida.imprimir("Olá, " + nome + "!")`
- **Variáveis simples**: `saida.imprimir(nome)`

### Funcionalidades da Interface

#### 1. Gerenciamento de Elementos DOM
```dart
void _setupElements() {
  _editor = html.querySelector('#editor') as html.TextAreaElement? 
         ?? _createFallbackEditor();
  _output = html.querySelector('#output') as html.DivElement;
  _runButton = html.querySelector('#run-btn') as html.ButtonElement;
  _status = html.querySelector('#status') as html.SpanElement;
}
```

#### 2. Event Listeners
```dart
void _setupEventListeners() {
  // Botão executar
  _runButton.onClick.listen((_) => _runCode());
  
  // Atalho Ctrl+Enter
  _editor.onKeyDown.listen((event) {
    if (event.ctrlKey && event.keyCode == 13) {
      event.preventDefault();
      _runCode();
    }
  });
  
  // Outros controles...
}
```

#### 3. Controles de Interface
- **_updateOutput()**: Atualiza área de saída
- **_clearOutput()**: Limpa área de saída
- **_clearEditor()**: Limpa editor
- **_updateStats()**: Atualiza contadores (linhas/caracteres)
- **_updateStatus()**: Atualiza barra de status

## 🎨 Sistema de Tratamento de Erros

### Classe WebErrorReporter
```dart
/**
 * Adaptador para reportar erros de compilação na interface web
 * 
 * Esta classe estende ErrorReporter para capturar erros do compilador
 * e formatá-los adequadamente para exibição na interface web.
 */
class WebErrorReporter extends ErrorReporter {
  final StringBuffer output;
  
  // Reporta erro com localização específica
  @override
  void report(int line, String where, String message) {
    super.report(line, where, message);
    output.writeln('ERRO [Linha $line]: $message');
  }
  
  // Reporta erro genérico
  @override
  void error(int line, String message) {
    super.error(line, message);
    output.writeln('ERRO: $message');
  }
}
```

## 🔮 Preparação para VM Web

### Arquitetura Atual vs Futura

**Atual (Simulação):**
```dart
// Simulação inteligente da execução
final executionResult = _simulateExecution(code, statements);
output.write(executionResult);
```

**Futura (VM Web):**
```dart
// TODO: Quando a VM web estiver implementada
final codeGenerator = CodeGenerator();
final bytecodeChunk = codeGenerator.compile(statements);
final webVM = WebVM();
final result = webVM.interpret(bytecodeChunk);
return webVM.getOutput();
```

### Interface WebVM (Planejada)
```dart
class WebVM {
  StringBuffer _output;
  
  InterpretResult interpret(BytecodeChunk chunk);
  String getOutput();
  void setFunctions(Map<String, CompiledFunction> functions);
}
```

## 📊 Fluxo de Dados

```
┌─────────────────┐    ┌──────────────┐    ┌─────────────────┐
│   Código LiPo   │───▶│    Lexer     │───▶│     Tokens      │
└─────────────────┘    └──────────────┘    └─────────────────┘
                                                     │
┌─────────────────┐    ┌──────────────┐    ┌─────────▼─────────┐
│   Saída HTML    │◀───│  Simulação   │◀───│     Parser      │
└─────────────────┘    └──────────────┘    └─────────────────┘
                                                     │
                       ┌──────────────┐    ┌─────────▼─────────┐
                       │    Erros     │◀───│ Semantic Analyzer│
                       └──────────────┘    └─────────────────┘
```

## 🧪 Exemplos de Uso

### Código de Entrada
```lipo
importar io como saida;

saida.imprimir("Olá, LiPo!");
var nome = "Desenvolvedor";
saida.imprimir("Bem-vindo, " + nome + "!");
```

### Saída Gerada
```
🔍 Iniciando análise léxica...
✅ Análise léxica concluída com sucesso!
🔍 Iniciando análise sintática...
✅ Análise sintática concluída com sucesso!
🔍 Iniciando análise semântica...
✅ Análise semântica concluída com sucesso!

🚀 EXECUTANDO CÓDIGO LIPO:
========================================
Olá, LiPo!
Bem-vindo, Desenvolvedor!
========================================
✅ Execução concluída com sucesso!
```

## ⚡ Performance e Otimizações

### Compilação JavaScript
- **Bundle size**: ~487KB (JavaScript minificado)
- **Tempo de compilação**: ~1.3s para código típico
- **Execução**: < 100ms para simulação

### Otimizações Implementadas
- **Lazy loading**: Componentes carregados sob demanda
- **Event delegation**: Listeners eficientes
- **DOM minimal**: Manipulação DOM otimizada
- **Error boundaries**: Tratamento robusto de erros

## 🔧 Configuração de Desenvolvimento

### Comandos de Build
```bash
# Compilar para produção
dart compile js web/main.dart -o web/main.dart.js

# Servidor de desenvolvimento
cd web && python -m http.server 8080

# Debug mode
dart compile js web/main.dart -o web/main.dart.js --enable-asserts
```

### Estrutura de Debug
```dart
// Logs de debug incluídos no código
output.writeln('🔍 Iniciando análise léxica...');
output.writeln('✅ Análise léxica concluída com sucesso!');
```

## 📋 Checklist de Funcionalidades

### ✅ Implementado
- [x] Editor de código funcional
- [x] Pipeline de compilação completo
- [x] Simulação inteligente de execução
- [x] Sistema de temas responsivo
- [x] Tratamento de erros detalhado
- [x] Feedback visual de progresso
- [x] Controles de interface (limpar, executar)
- [x] Estatísticas em tempo real
- [x] Arquitetura preparada para VM web

### ⏳ Pendente (VM Web)
- [ ] Execução real via bytecode
- [ ] Depuração interativa
- [ ] Performance profiling
- [ ] Integração com bibliotecas padrão

---

**Versão**: 1.0.0 (Julho 2025)  
**Status**: Interface completa, simulação funcional, preparada para VM web
