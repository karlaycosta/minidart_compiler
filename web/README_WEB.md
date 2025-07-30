# 🌐 MiniDart Compiler Web v1.4.1

## Visão Geral
A versão web do MiniDart Compiler oferece uma interface moderna e interativa para compilar e executar código MiniDart diretamente no navegador, sem necessidade de instalação local.

## ✨ Características

### 🎯 Interface Moderna
- **Design Responsivo**: Adaptável a desktop, tablet e mobile
- **Dark/Light Mode**: Suporte automático baseado na preferência do sistema
- **Tipografia Profissional**: Fonte JetBrains Mono para código e Inter para interface
- **Animações Fluidas**: Transições suaves e feedback visual

### 🛠️ Funcionalidades
- **Compilação Interativa**: Execução em tempo real com feedback visual
- **Visualização da AST**: Árvore sintática abstrata formatada e legível
- **Bytecode Inspector**: Visualização do código intermediário gerado
- **Error Reporting**: Relatórios de erro precisos com localização
- **Exemplos Integrados**: 6 exemplos pré-carregados para aprendizado

### ⌨️ Atalhos de Teclado
- `Ctrl+Enter`: Executar código
- `Ctrl+1`: Aba Saída
- `Ctrl+2`: Aba AST
- `Ctrl+3`: Aba Bytecode
- `Ctrl+4`: Aba Erros
- `Tab`: Indentação automática no editor

## 🏗️ Arquitetura

### Estrutura dos Arquivos
```
web/
├── index.html          # Interface HTML principal
├── styles.css          # Estilos CSS modernos
├── main.dart           # Lógica Dart da aplicação
├── main.dart.js        # Código compilado para JavaScript
├── pubspec.yaml        # Dependências do projeto
└── server.dart         # Servidor HTTP local (opcional)
```

### Componentes Principais

#### 1. WebCompiler
Simula o comportamento do compilador MiniDart:
- Análise lexical básica
- Geração de AST mock
- Produção de bytecode simulado
- Execução de código simples

#### 2. WebInterface
Gerencia a interface do usuário:
- Manipulação do DOM
- Eventos de teclado e mouse
- Gerenciamento de tabs
- Feedback visual e notificações

#### 3. CompilationResult
Estrutura de dados para resultados:
```dart
class CompilationResult {
  final bool success;
  final String output;
  final List<String> errors;
  final String? ast;
  final String? bytecode;
}
```

## 🚀 Deploy e Execução

### Desenvolvimento Local
```bash
# 1. Navegar para o diretório web
cd web/

# 2. Instalar dependências
dart pub get

# 3. Compilar para JavaScript
dart compile js main.dart -o main.dart.js

# 4. Iniciar servidor local
dhttpd --port 8080

# 5. Abrir no navegador
# http://localhost:8080
```

### Deploy para Produção
```bash
# 1. Compilar com otimizações
dart compile js main.dart -o main.dart.js --minify

# 2. Servir arquivos estáticos
# - index.html
# - styles.css
# - main.dart.js

# 3. Configurar servidor web (nginx/apache)
# Servir arquivos com Content-Type correto
```

## 📱 Responsividade

### Breakpoints
- **Desktop**: >= 1024px (layout grid 2 colunas)
- **Tablet**: 768px - 1023px (layout grid 1 coluna)
- **Mobile**: <= 767px (interface compacta)

### Adaptações Mobile
- Interface vertical (editor + output)
- Botões otimizados para toque
- Tabs com scroll horizontal
- Fonte reduzida para melhor visualização

## 🎨 Sistema de Design

### Paleta de Cores
```css
--primary-color: #2563eb      /* Azul principal */
--success-color: #10b981      /* Verde sucesso */
--error-color: #ef4444        /* Vermelho erro */
--background: #ffffff         /* Fundo claro */
--surface: #f8fafc           /* Superfície */
--text-primary: #1e293b      /* Texto principal */
```

### Componentes
- **Botões**: 3 variações (primary, secondary, outline)
- **Tabs**: Navegação com indicador ativo
- **Modais**: Overlay com backdrop blur
- **Loading**: Spinner animado com backdrop
- **Notifications**: Toast messages temporárias

## 🔧 Customização

### Adicionando Novos Exemplos
```dart
String _getExampleCode(String exampleKey) {
  switch (exampleKey) {
    case 'novo_exemplo':
      return '''// Novo Exemplo
var x = 42;
imprimir x;''';
    // ...
  }
}
```

### Modificando Cores
Edite as variáveis CSS em `styles.css`:
```css
:root {
  --primary-color: #sua-cor;
  --success-color: #sua-cor;
  /* ... */
}
```

### Adicionando Funcionalidades
1. Adicione métodos à classe `WebInterface`
2. Registre eventos em `_bindEvents()`
3. Atualize HTML conforme necessário

## 🔍 Limitações Atuais

### Simulação vs Compilação Real
Esta versão usa simulação para demonstração:
- **AST**: Gerada por parsing regex simples
- **Bytecode**: Mock baseado no número de linhas
- **Execução**: Extração básica de `imprimir` statements

### Melhorias Futuras
1. **Integração Real**: Adapter o compilador real para web
2. **WebAssembly**: Compilar VM para WASM para performance
3. **Syntax Highlighting**: Editor com destaque de sintaxe
4. **Autocompletar**: IntelliSense para MiniDart
5. **Debug Mode**: Stepping e breakpoints
6. **Sharing**: URLs para compartilhar código

## 📊 Performance

### Metrics
- **Bundle Size**: ~288KB (JavaScript compilado)
- **Load Time**: < 1s em conexão rápida
- **Memory Usage**: ~15MB typical
- **Compilation**: < 500ms para códigos pequenos

### Otimizações
- **Minificação**: Código JavaScript otimizado
- **Lazy Loading**: Recursos carregados sob demanda
- **Caching**: Headers apropriados para cache
- **Compression**: Gzip recomendado no servidor

## 🛡️ Segurança

### Client-side Only
- Sem processamento server-side
- Código executado apenas no navegador
- Sem riscos de execução remota

### Sanitização
- Escape automático de HTML
- Validação de entrada básica
- Prevenção de XSS em outputs

## 📈 Analytics e Monitoramento

### Métricas Recomendadas
- Tempo de carregamento
- Taxa de compilação bem-sucedida
- Exemplos mais utilizados
- Dispositivos e navegadores

### Error Tracking
- JavaScript errors
- Compilation failures
- Performance bottlenecks

---

**Desenvolvido por**: Deriks Karlay Dias Costa  
**Versão**: 1.4.1  
**Data**: Julho 2025  
**Licença**: MIT
