# LiPo - Linguagem em Portugol - Interface Web

## 📋 Visão Geral

Este diretório contém a implementação da interface web para o compilador LiPo, uma linguagem educacional em português baseada em Portugol. A interface permite escrever, compilar e executar código LiPo diretamente no navegador.

## 🏗️ Arquitetura

### **Estrutura de Arquivos**

```
web/
├── main.dart              # Aplicação principal Dart
├── main.dart.js           # Código compilado para JavaScript
├── index.html             # Página principal
├── css/
│   ├── main.css          # Estilos principais
│   └── themes.css        # Sistema de temas
├── js/
│   ├── app.js            # Funcionalidades auxiliares
│   ├── theme-manager.js  # Gerenciamento de temas
│   ├── component-manager.js # Carregamento de componentes
│   └── editor-manager.js # Funcionalidades do editor
├── components/
│   ├── topbar.html       # Barra superior
│   └── footer.html       # Rodapé
└── icons/                # Ícones e recursos visuais
```

### Estilos CSS
- **`css/style.css`** - Estilos principais da interface
- **`css/editor.css`** - Estilos específicos do editor de código
- **`css/themes.css`** - Temas claro, escuro e alto contraste

### JavaScript
- **`js/utils.js`** - Utilitários JavaScript (temas, exemplos, compartilhamento)

### Ícones
- **`icons/logo.svg`** - Logo principal do MiniDart
- **`icons/favicon.svg`** - Ícone da página (favicon)
- **`icons/icon-*.png`** - Ícones PWA para diferentes tamanhos

## 🚀 Recursos Implementados

### Interface
- ✅ Editor de código com syntax highlighting
- ✅ Painel de saída em tempo real
- ✅ Temas claro/escuro/alto contraste
- ✅ Layout responsivo para mobile/desktop
- ✅ Galeria de exemplos integrada

### Funcionalidades
- ✅ Compilação e execução MiniDart
- ✅ Tratamento de erros detalhado
- ✅ Estatísticas do código (linhas, caracteres)
- ✅ Compartilhamento via URL
- ✅ Salvamento automático no localStorage
- ✅ Documentação integrada

### Exemplos Incluídos
- **Hello World** - Introdução básica
- **Variáveis** - Declaração e tipos
- **Funções** - Definição e chamada
- **Loops** - For e while
- **Condicionais** - If/else
- **Arrays** - Manipulação de listas
- **Bibliotecas** - Math, String, IO, Util

## 🛠️ Para Desenvolvedores

### Compilação Dart para Web
```bash
# Compilar para desenvolvimento
dart compile js web/main.dart -o web/main.dart.js

# Compilar para produção (otimizado)
dart compile js web/main.dart -o web/main.dart.js -O2
```

### Servir Localmente
```bash
# Usando servidor Python
python -m http.server 8000 -d web

# Usando Node.js (http-server)
npx http-server web -p 8000

# Usando PHP
php -S localhost:8000 -t web
```

### Deploy
- **GitHub Pages**: Coloque os arquivos na pasta `docs/` ou branch `gh-pages`
- **Netlify**: Drag & drop da pasta `web/`
- **Firebase Hosting**: `firebase deploy --only hosting`

## 🎨 Personalização

### Adicionando Novos Temas
1. Edite `css/themes.css`
2. Adicione variáveis CSS para o novo tema
3. Atualize `js/utils.js` no `ThemeManager`

### Adicionando Exemplos
1. Edite `js/utils.js` no `ExampleManager`
2. Adicione o código no objeto `examples`
3. Atualize o `<select>` no `index.html`

### Customizando o Editor
- Monaco Editor é carregado via CDN
- Fallback para `<textarea>` simples
- Configurações em `css/editor.css`

## 🔧 Dependências

### Externas
- **Monaco Editor** - Editor VS Code no navegador
- **Fonts** - Fira Code, Cascadia Code (fontes com ligaduras)

### Internas
- Reutiliza todo o código do compilador MiniDart
- Adaptações web nas classes `WebErrorReporter` e `WebVM`

## 📱 PWA (Progressive Web App)

O playground pode ser instalado como app nativo:
- Manifesto PWA configurado
- Service Worker para cache offline
- Ícones para diferentes dispositivos

## 🌐 Compatibilidade

### Navegadores Suportados
- ✅ Chrome/Edge 90+
- ✅ Firefox 78+
- ✅ Safari 14+
- ✅ Opera 76+

### Recursos Responsivos
- Desktop: Layout lado a lado
- Tablet: Layout adaptativo
- Mobile: Layout vertical empilhado

## 📄 Licença

Mesma licença do projeto principal MiniDart.
