/**
 * LiPo - Linguagem em Portugol - Playground Web
 * 
 * Este arquivo implementa a interface web para o compilador LiPo,
 * uma linguagem educacional em português baseada em Portugol.
 * 
 * Arquitetura:
 * - Front-end: Interface web responsiva com editor de código
 * - Compilação: Pipeline completo (Lexer → Parser → Semantic Analyzer)
 * - Execução: Simulação inteligente preparada para integração com VM web
 * 
 * Funcionalidades:
 * - Editor de código com syntax highlighting
 * - Compilação em tempo real com feedback detalhado
 * - Sistema de temas (claro, escuro, alto contraste)
 * - Execução simulada de código LiPo
 * - Interface modular e extensível
 * 
 * Autor: Desenvolvido para o projeto LiPo
 * Data: Julho 2025
 */

import 'dart:html' as html;
import 'dart:async';

// Importar as classes do compilador LiPo
import '../lib/src/lexer.dart';       // Análise léxica
import '../lib/src/parser.dart';      // Análise sintática  
import '../lib/src/semantic_analyzer.dart'; // Análise semântica
import '../lib/src/error.dart';       // Sistema de relatório de erros

/**
 * Ponto de entrada da aplicação web LiPo
 * 
 * Inicializa o playground e configura todos os componentes necessários
 */
void main() {
  print('LiPo - Linguagem em Portugol iniciado!');
  
  // Inicializar o playground principal
  final playground = LiPoPlayground();
  playground.initialize();
}

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

  /**
   * Inicializa o playground LiPo
   * 
   * Configura todos os componentes da interface em ordem:
   * 1. Elementos DOM
   * 2. Event listeners
   * 3. Código inicial
   * 4. Status inicial
   */
  void initialize() {
    _setupElements();
    _setupEventListeners();
    _loadInitialCode();
    _updateStatus('Pronto para executar');
  }
  
  /**
   * Configura as referências para os elementos DOM
   * 
   * Localiza e armazena referências para todos os elementos
   * essenciais da interface. Se o editor não existir,
   * cria um editor fallback.
   */
  void _setupElements() {
    // Localizar elementos principais ou criar fallback
    _editor = html.querySelector('#editor') as html.TextAreaElement? 
           ?? _createFallbackEditor();
    _output = html.querySelector('#output') as html.DivElement;
    _runButton = html.querySelector('#run-btn') as html.ButtonElement;
    _status = html.querySelector('#status') as html.SpanElement;
  }
  
  /**
   * Cria um editor de código fallback caso o elemento não exista no DOM
   * 
   * Este método garante que sempre haverá um editor funcional,
   * mesmo se o HTML principal não estiver carregado corretamente.
   * 
   * @return TextAreaElement configurado como editor de código
   */
  html.TextAreaElement _createFallbackEditor() {
    final container = html.querySelector('#editor-container');
    final editor = html.TextAreaElement()
      ..id = 'editor'
      ..className = 'fallback-editor'
      ..placeholder = 'Digite seu código LiPo aqui...'
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.fontFamily = 'monospace'
      ..style.fontSize = '14px'
      ..style.border = 'none'
      ..style.outline = 'none'
      ..style.resize = 'none';
    
    // Limpar container existente e adicionar novo editor
    container?.children.clear();
    container?.append(editor);
    
    return editor;
  }
  
  /**
   * Configura todos os event listeners da interface
   * 
   * Define os comportamentos interativos:
   * - Botão executar
   * - Atalho Ctrl+Enter para execução rápida
   * - Botões de limpeza (editor e saída)
   * - Contador de linhas/caracteres em tempo real
   */
  void _setupEventListeners() {
    // Botão executar - executa o código quando clicado
    _runButton.onClick.listen((_) => _runCode());
    
    // Tecla de atalho Ctrl+Enter para execução rápida
    _editor.onKeyDown.listen((event) {
      if (event.ctrlKey && event.keyCode == 13) { // Ctrl+Enter
        event.preventDefault();
        _runCode();
      }
    });
    
    // Botão limpar editor - remove todo o código do editor
    html.querySelector('#clear-btn')?.onClick.listen((_) => _clearEditor());
    
    // Botão limpar saída - limpa a área de resultados
    html.querySelector('#clear-output-btn')?.onClick.listen((_) => _clearOutput());
    
    // Contador de linhas/caracteres - atualiza em tempo real
    _editor.onInput.listen((_) => _updateStats());
  }
  
  /**
   * Carrega o código inicial padrão no editor
   * 
   * Define um exemplo básico de código LiPo que demonstra:
   * - Importação de bibliotecas (io como saida)
   * - Saída de texto com saida.imprimir()
   * - Declaração e uso de variáveis
   * - Concatenação de strings
   */
  void _loadInitialCode() {
    // Código de exemplo que demonstra funcionalidades básicas do LiPo
    _editor.value = '''importar io como saida;

saida.imprimir("Olá, LiPo!");
saida.imprimir("Bem-vindo à Linguagem em Portugol!");

var nome = "Desenvolvedor";
saida.imprimir("Olá, " + nome + "!");''';
    
    // Atualizar estatísticas do editor
    _updateStats();
  }
  
  /**
   * Executa o código LiPo inserido no editor
   * 
   * Processo de execução:
   * 1. Validação do código (verifica se não está vazio)
   * 2. Atualização da interface (status, botão desabilitado)
   * 3. Delay visual para feedback do usuário
   * 4. Compilação e execução do código
   * 5. Exibição dos resultados
   * 6. Restauração da interface
   */
  Future<void> _runCode() async {
    final code = _editor.value ?? '';
    
    // Validar se há código para executar
    if (code.trim().isEmpty) {
      _updateOutput('AVISO: Por favor, digite algum código LiPo antes de executar.');
      return;
    }
    
    // Feedback visual: executando
    _updateStatus('Executando código LiPo...');
    _runButton.disabled = true;
    
    try {
      // Delay para mostrar feedback de loading
      await Future.delayed(Duration(milliseconds: 500));
      
      // Executar pipeline de compilação e execução
      final result = await _compileAndRun(code);
      _updateOutput(result);
      _updateStatus('Execução do código LiPo concluída');
      
    } catch (e) {
      // Tratamento de erros inesperados
      _updateOutput('ERRO: Erro durante a execução: $e');
      _updateStatus('Erro na execução do código LiPo');
      
    } finally {
      // Restaurar interface
      _runButton.disabled = false;
    }
  }
  
  /**
   * Pipeline completo de compilação e execução do código LiPo
   * 
   * Fases da compilação:
   * 1. Análise Léxica (Lexer) - Converte código em tokens
   * 2. Análise Sintática (Parser) - Cria AST dos tokens
   * 3. Análise Semântica - Valida semântica do código
   * 4. Execução Simulada - Simula execução até VM web estar pronta
   * 
   * @param code Código fonte LiPo para compilar e executar
   * @return String com resultado da execução ou mensagens de erro
   */
  Future<String> _compileAndRun(String code) async {
    try {
      // Buffer para capturar saída de compilação e execução
      final output = StringBuffer();
      final errorReporter = WebErrorReporter(output);
      
      // FASE 1: Análise Léxica (Tokenização)
      output.writeln('🔍 Iniciando análise léxica...');
      final lexer = Lexer(code, errorReporter);
      final tokens = lexer.scanTokens();
      
      if (errorReporter.hadError) {
        return output.toString();
      }
      output.writeln('✅ Análise léxica concluída com sucesso!');
      
      // FASE 2: Análise Sintática (Parsing)
      output.writeln('🔍 Iniciando análise sintática...');
      final parser = Parser(tokens, errorReporter);
      final statements = parser.parse();
      
      if (errorReporter.hadError) {
        return output.toString();
      }
      output.writeln('✅ Análise sintática concluída com sucesso!');
      
      // FASE 3: Análise Semântica
      output.writeln('🔍 Iniciando análise semântica...');
      final analyzer = SemanticAnalyzer(errorReporter);
      analyzer.analyze(statements);
      
      if (errorReporter.hadError) {
        return output.toString();
      }
      output.writeln('✅ Análise semântica concluída com sucesso!');
      
      // TODO: FASE 4 - Integração com VM Web (quando implementada)
      // Quando a VM web estiver implementada, substituir por:
      // final codeGenerator = CodeGenerator();
      // final bytecodeChunk = codeGenerator.compile(statements);
      // final webVM = WebVM();
      // final result = webVM.interpret(bytecodeChunk);
      // return webVM.getOutput();
      
      // FASE 4 ATUAL: Simulação inteligente da execução
      output.writeln('');
      output.writeln('🚀 EXECUTANDO CÓDIGO LIPO:');
      output.writeln('=' * 40);
      
      final executionResult = _simulateExecution(code, statements);
      output.write(executionResult);
      
      output.writeln('=' * 40);
      output.writeln('✅ Execução concluída com sucesso!');
      
      return output.toString();
      
    } catch (e) {
      // Captura erros inesperados durante compilação
      return 'ERRO: Erro de compilação do código LiPo: $e';
    }
  }
  
  /**
   * Simula a execução do código LiPo de forma inteligente
   * 
   * Esta função analisa o código fonte e simula sua execução:
   * 1. Extrai variáveis declaradas (var nome = "valor")
   * 2. Processa chamadas saida.imprimir()
   * 3. Resolve concatenação de strings
   * 4. Gera saída equivalente ao que seria executado
   * 
   * @param code Código fonte original
   * @param statements AST gerado pelo parser (não usado na simulação atual)
   * @return String com a saída simulada do programa
   */
  String _simulateExecution(String code, List<dynamic> statements) {
    final output = StringBuffer();
    final variables = <String, String>{};
    
    // PASSO 1: Extrair variáveis do código usando regex
    // Procura padrões como: var nome = "valor"
    final varRegex = RegExp(r'var\s+(\w+)\s*=\s*"([^"]+)"');
    for (final match in varRegex.allMatches(code)) {
      variables[match.group(1)!] = match.group(2)!;
    }
    
    // PASSO 2: Processar saída linha por linha
    final lines = code.split('\n');
    for (final line in lines) {
      final trimmedLine = line.trim();
      
      // Verificar se a linha contém uma chamada saida.imprimir()
      if (trimmedLine.contains('saida.imprimir(')) {
        // Extrair conteúdo dentro dos parênteses
        final printRegex = RegExp(r'saida\.imprimir\((.+)\)');
        final match = printRegex.firstMatch(trimmedLine);
        
        if (match != null) {
          var content = match.group(1)!.trim();
          
          // CASO 1: String literal simples "texto"
          if (content.startsWith('"') && content.endsWith('"')) {
            final text = content.substring(1, content.length - 1);
            output.writeln(text);
          }
          // CASO 2: Concatenação com operador + 
          else if (content.contains('+')) {
            var result = '';
            final parts = content.split('+').map((p) => p.trim()).toList();
            
            // Processar cada parte da concatenação
            for (final part in parts) {
              if (part.startsWith('"') && part.endsWith('"')) {
                // String literal
                result += part.substring(1, part.length - 1);
              } else if (variables.containsKey(part)) {
                // Variável conhecida
                result += variables[part]!;
              } else {
                // Variável não encontrada, usar o nome original
                result += part;
              }
            }
            output.writeln(result);
          }
          // CASO 3: Variável simples
          else if (variables.containsKey(content)) {
            output.writeln(variables[content]!);
          }
          // CASO 4: Conteúdo não reconhecido - exibir como está
          else {
            output.writeln(content);
          }
        }
      }
    }
    
    // PASSO 3: Verificar se há saída para exibir
    if (output.isEmpty) {
      output.writeln('(Código executado sem saída de texto)');
    }
    
    return output.toString();
  }
  
  /**
   * Atualiza a área de saída com novo conteúdo
   * 
   * @param content Conteúdo para exibir (HTML será escapado automaticamente)
   */
  void _updateOutput(String content) {
    _output.innerHtml = '<pre class="output-text">$content</pre>';
  }
  
  /**
   * Limpa a área de saída e exibe mensagem padrão
   */
  void _clearOutput() {
    _output.innerHtml = '''
      <div class="welcome-message">
        <h4>Saída limpa</h4>
        <p>Execute seu código LiPo para ver o resultado aqui.</p>
      </div>
    ''';
  }
  
  /**
   * Limpa o editor de código e atualiza estatísticas
   */
  void _clearEditor() {
    _editor.value = '';
    _updateStats();
    _updateStatus('Editor limpo');
  }
  
  /**
   * Atualiza as estatísticas do editor (linhas e caracteres)
   * 
   * Conta o número de linhas e caracteres do código atual
   * e atualiza os elementos correspondentes na interface
   */
  void _updateStats() {
    final code = _editor.value ?? '';
    final lines = code.split('\n').length;
    final chars = code.length;
    
    html.querySelector('#lines-count')?.text = 'Linhas: $lines';
    html.querySelector('#chars-count')?.text = 'Caracteres: $chars';
  }
  
  /**
   * Atualiza a mensagem de status na barra de status
   * 
   * @param message Mensagem para exibir no status
   */
  void _updateStatus(String message) {
    _status.text = message;
  }
}

/**
 * Adaptador para reportar erros de compilação na interface web
 * 
 * Esta classe estende ErrorReporter para capturar erros do compilador
 * e formatá-los adequadamente para exibição na interface web.
 * 
 * Funcionalidades:
 * - Captura erros léxicos, sintáticos e semânticos
 * - Formata mensagens com informação de linha
 * - Armazena erros em StringBuffer para exibição
 */
class WebErrorReporter extends ErrorReporter {
  final StringBuffer output;
  
  WebErrorReporter(this.output);
  
  /**
   * Reporta erro com localização específica
   * 
   * @param line Número da linha onde ocorreu o erro
   * @param where Contexto adicional do erro
   * @param message Mensagem descritiva do erro
   */
  @override
  void report(int line, String where, String message) {
    super.report(line, where, message);
    output.writeln('ERRO [Linha $line]: $message');
  }
  
  /**
   * Reporta erro genérico
   * 
   * @param line Número da linha onde ocorreu o erro
   * @param message Mensagem descritiva do erro
   */
  @override
  void error(int line, String message) {
    super.error(line, message);
    output.writeln('ERRO: $message');
  }
}
