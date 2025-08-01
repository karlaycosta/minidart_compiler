# Componentes do MiniDart Playground

Esta pasta contém os componentes HTML modulares do MiniDart Playground, organizados para facilitar a manutenção e reutilização.

## Estrutura de Componentes

### 📁 `components/`
- **`topbar.html`** - Cabeçalho da aplicação com logo, título e botões de ação
- **`footer.html`** - Rodapé com informações do projeto e estatísticas

## Sistema de Carregamento

### 🔧 `js/components.js`
Gerenciador responsável pelo carregamento dinâmico dos componentes:

**Características:**
- ✅ Carregamento assíncrono via fetch API
- ✅ Cache automático para melhor performance
- ✅ Sistema de fallback em caso de erro
- ✅ Eventos personalizados para notificação
- ✅ Utilitários globais para recarga

**Uso:**
```javascript
// Carregar todos os componentes
await ComponentUtils.loadAll();

// Recarregar um componente específico
await ComponentUtils.reload('topbar');
```

## Integração com index.html

O arquivo principal usa containers vazios que são preenchidos dinamicamente:

```html
<!-- Header Container -->
<div id="topbar-container"></div>

<!-- Footer Container -->
<div id="footer-container"></div>
```

## Eventos Disponíveis

### `componentLoaded`
Disparado quando um componente individual é carregado.
```javascript
document.addEventListener('componentLoaded', function(event) {
    console.log('Componente carregado:', event.detail.name);
});
```

### `allComponentsLoaded`
Disparado quando todos os componentes foram carregados.
```javascript
document.addEventListener('allComponentsLoaded', function() {
    console.log('Todos os componentes prontos!');
});
```

## Vantagens da Separação

### 🔧 **Manutenibilidade**
- Código organizado em arquivos específicos
- Fácil localização e edição de componentes
- Redução de conflitos em desenvolvimento colaborativo

### ⚡ **Performance**
- Carregamento assíncrono não-bloqueante
- Cache automático de componentes
- Fallback rápido em caso de erro

### 🔄 **Reutilização**
- Componentes independentes
- Possibilidade de usar em outras páginas
- Fácil personalização por contexto

### 🛠️ **Desenvolvimento**
- Separação clara de responsabilidades  
- Testes independentes de componentes
- Hotreload mais eficiente

## Estrutura de Arquivos

```
web/
├── components/           # Componentes HTML
│   ├── topbar.html      # Cabeçalho
│   └── footer.html      # Rodapé
├── js/
│   ├── components.js    # Carregador de componentes
│   └── utils.js         # Utilitários gerais
└── index.html           # Página principal
```

## Fluxo de Carregamento

1. **DOMContentLoaded** → Inicialização dos gerenciadores
2. **ComponentLoader** → Carregamento dos componentes
3. **allComponentsLoaded** → Reconfiguração de temas
4. **Aplicação pronta** → Interface funcional

---

*Esta documentação é automaticamente atualizada conforme a evolução dos componentes.*
