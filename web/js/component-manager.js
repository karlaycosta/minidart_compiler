// ============================================
// GERENCIADOR DE COMPONENTES
// ============================================
// Responsável por:
// - Carregar componentes HTML modulares
// - Injetar topbar e footer no DOM
// - Permitir desenvolvimento modular da interface
// - Facilitar manutenção e reutilização de código

/**
 * Classe que gerencia carregamento de componentes modulares
 * Funcionalidades:
 * - Carrega arquivos HTML de /components/
 * - Injeta conteúdo em containers específicos
 * - Carregamento assíncrono e paralelo
 * - Tratamento de erros robusto
 */
class ComponentManager {
    /**
     * FUNCIONALIDADE: Carregar componente individual
     * Processo:
     * 1. Faz fetch do arquivo HTML
     * 2. Obtém conteúdo como texto
     * 3. Injeta no elemento container
     * 4. Trata erros graciosamente
     */
    async loadComponent(elementId, componentPath) {
        try {
            // PASSO 1: Busca arquivo HTML do componente
            const response = await fetch(componentPath);
            const html = await response.text();
            
            // PASSO 2: Encontra elemento container no DOM
            const element = document.getElementById(elementId);
            if (element) {
                // PASSO 3: Injeta HTML no container
                element.innerHTML = html;
            }
        } catch (error) {
            console.error(`Error loading component ${componentPath}:`, error);
        }
    }

    /**
     * FUNCIONALIDADE: Carregar todos os componentes
     * Carrega topbar e footer em paralelo para performance
     * Usado pelo app.js na inicialização
     */
    async loadAllComponents() {
        await Promise.all([
            this.loadComponent('topbar-container', 'components/topbar.html'),
            this.loadComponent('footer-container', 'components/footer.html')
        ]);
    }
}

// ============================================
// EXPORTAÇÃO GLOBAL
// ============================================
// Disponibiliza classe globalmente para uso em app.js
window.ComponentManager = ComponentManager;
