// ============================================
// GERENCIADOR DE TEMAS
// ============================================
// Responsável por:
// - Aplicar temas (light, dark, high-contrast)
// - Persistir escolha no localStorage
// - Atualizar ícones dos botões de tema
// - Coordenar com CSS modular (themes.css)

/**
 * Classe que gerencia o sistema de temas do playground
 * Funcionalidades:
 * - 3 temas disponíveis: light-theme, dark-theme, high-contrast-theme
 * - Persistência no localStorage
 * - Aplicação via classes CSS no body
 * - Atualização de ícones dinamicamente
 */
class ThemeManager {
    constructor() {
        // Recupera tema salvo ou usa padrão (light)
        this.currentTheme = localStorage.getItem('theme') || 'light-theme';
        
        // Aplica tema inicial imediatamente (antes dos componentes carregarem)
        // Não tenta atualizar ícone ainda pois topbar pode não existir
        document.body.className = this.currentTheme;
    }

    /**
     * FUNCIONALIDADE: Aplicar tema específico
     * Processo:
     * 1. Remove todas as classes de tema do body
     * 2. Adiciona nova classe de tema
     * 3. Salva no localStorage para persistência
     * 4. Força re-render do CSS
     * 5. Atualiza ícone do botão (se existir)
     */
    applyTheme(theme) {
        console.log('Applying theme:', theme);
        
        // PASSO 1: Limpa todas as classes de tema existentes
        document.body.classList.remove('light-theme', 'dark-theme', 'high-contrast-theme');
        
        // PASSO 2: Aplica novo tema via classe CSS
        document.body.classList.add(theme);
        
        // PASSO 3: Salva estado atual
        this.currentTheme = theme;
        localStorage.setItem('theme', theme);
        console.log('Body class set to:', document.body.className);
        
        // PASSO 4: Força browser a recalcular estilos
        document.body.offsetHeight;
        
        // PASSO 5: Atualiza ícone do botão de tema (se existir no topbar)
        this.updateThemeIcon();
    }

    /**
     * FUNCIONALIDADE: Inicialização após componentes
     * Chamada pelo app.js após topbar/footer carregarem
     * Garante que ícones estejam disponíveis antes de atualizar
     */
    initialize() {
        this.applyTheme(this.currentTheme);
    }

    /**
     * FUNCIONALIDADE: Rotacionar entre temas
     * Sequência: light → dark → high-contrast → light
     * Chamada pelo clique no botão de tema
     */
    cycleTheme() {
        const themes = ['light-theme', 'dark-theme', 'high-contrast-theme'];
        const currentIndex = themes.indexOf(this.currentTheme);
        const nextIndex = (currentIndex + 1) % themes.length;
        this.applyTheme(themes[nextIndex]);
    }

    /**
     * FUNCIONALIDADE: Atualizar ícone do botão de tema
     * Processo:
     * 1. Busca elemento #theme-icon no topbar
     * 2. Se não encontrar, retry até 10x (componente pode estar carregando)
     * 3. Aplica ícone correspondente ao tema atual
     * 4. Mapeia: light→sun, dark→moon, high-contrast→contrast
     */
    updateThemeIcon() {
        const themeIcon = document.getElementById('theme-icon');
        if (!themeIcon) {
            console.log('Theme icon not found, retrying...');
            // Retry logic: componente pode estar carregando ainda
            if (!this.iconRetries) this.iconRetries = 0;
            if (this.iconRetries < 10) {
                this.iconRetries++;
                setTimeout(() => this.updateThemeIcon(), 100);
            }
            return;
        }

        // Reset contador de tentativas
        this.iconRetries = 0;
        
        // Mapeamento tema → ícone
        const icons = {
            'light-theme': 'icons/theme/sun.svg',
            'dark-theme': 'icons/theme/moon.svg',
            'high-contrast-theme': 'icons/theme/contrast.svg'
        };

        // Aplica ícone correspondente (fallback para sun.svg)
        themeIcon.src = icons[this.currentTheme] || 'icons/theme/sun.svg';
        console.log('Theme icon updated to:', icons[this.currentTheme]);
    }
}

// ============================================
// EXPORTAÇÃO GLOBAL
// ============================================
// Disponibiliza classe globalmente para uso em app.js
window.ThemeManager = ThemeManager;
