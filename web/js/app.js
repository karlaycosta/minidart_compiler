// APLICAÇÃO PRINCIPAL - LIPO PLAYGROUND
// 
// Este arquivo gerencia os componentes modulares (topbar/footer) 
// e funcionalidades auxiliares como temas e compartilhamento.
// O controle principal do editor e execução fica no main.dart

/**
 * Classe principal que gerencia o LiPo Playground
 * Responsável por:
 * - Carregar componentes modulares (topbar, footer)
 * - Gerenciar sistema de temas
 * - Funcionalidades de compartilhamento
 * - Coordenar com main.dart (que controla execução)
 */
class LiPoPlayground {
    constructor() {
        // Inicializa os gerenciadores modulares
        this.themeManager = new ThemeManager();        // Gerencia temas (light/dark/high-contrast)
        this.componentManager = new ComponentManager(); // Carrega topbar e footer dinamicamente
        this.editorManager = new EditorManager();      // Gerencia estatísticas do editor
        this.isRunning = false;                        // Flag para controle de execução (não usado)
        
        // Inicia a aplicação
        this.init();
    }

    /**
     * Inicialização da aplicação
     * Ordem de carregamento:
     * 1. Componentes modulares (topbar/footer)
     * 2. Sistema de temas
     * 3. Event listeners auxiliares
     * 4. Mensagem de status inicial
     */
    async init() {
        // PASSO 1: Carregar componentes primeiro (topbar e footer)
        // O ComponentManager busca arquivos HTML em /components/ e injeta no DOM
        await this.componentManager.loadAllComponents();
        
        // PASSO 2: Inicializar theme manager após componentes carregarem
        // Garante que os elementos de tema estejam disponíveis no DOM
        this.themeManager.initialize();
        
        // PASSO 3: Setup event listeners auxiliares (não conflitam com main.dart)
        this.setupEventListeners();
        
        // PASSO 4: Atualizar mensagem de boas-vindas (será sobrescrita pelo main.dart)
        this.updateOutput('LiPo Playground carregado! Digite seu código e clique em Executar.');
        
        console.log('LiPo Playground initialized');
    }

    /**
     * Configuração de event listeners auxiliares
     * IMPORTANTE: Não conflita com main.dart
     * - main.dart controla: botão Executar, Ctrl+Enter, editor
     * - app.js controla: temas, compartilhamento, ajuda
     */
    setupEventListeners() {
        // FUNCIONALIDADE 1: Troca de temas (light/dark/high-contrast)
        // Delega para ThemeManager que aplica CSS e salva no localStorage
        document.addEventListener('click', (e) => {
            if (e.target.id === 'theme-toggle' || e.target.closest('#theme-toggle')) {
                this.themeManager.cycleTheme();
            }
        });

        // FUNCIONALIDADE 2: Compartilhamento de código via URL
        // Codifica o código em Base64 e gera link compartilhável
        document.addEventListener('click', (e) => {
            if (e.target.id === 'share-btn' || e.target.closest('#share-btn')) {
                this.shareCode();
            }
        });

        // FUNCIONALIDADE 3: Modal de ajuda com atalhos e sintaxe
        // Exibe alert com informações sobre o MiniDart
        document.addEventListener('click', (e) => {
            if (e.target.id === 'help-btn' || e.target.closest('#help-btn')) {
                this.showHelp();
            }
        });

        // NOTA: Botão Executar e Ctrl+Enter são controlados pelo main.dart
        // para evitar conflitos e duplicação de lógica
    }

    /**
     * FUNCIONALIDADE: Compartilhamento de código
     * Processo:
     * 1. Obtém código atual do editor
     * 2. Codifica em Base64 para URL segura
     * 3. Gera URL com parâmetro ?code=
     * 4. Copia para clipboard ou exibe prompt
     */
    shareCode() {
        // Obtém código do editor via EditorManager
        const code = this.editorManager.getCode();
        if (!code.trim()) {
            alert('Nenhum código para compartilhar!');
            return;
        }

        // Codifica código em Base64 para transmissão segura
        const encodedCode = btoa(code);
        const shareUrl = `${window.location.origin}${window.location.pathname}?code=${encodedCode}`;
        
        // Tenta copiar para clipboard (navegadores modernos)
        navigator.clipboard.writeText(shareUrl).then(() => {
            this.updateStatus('Link copiado para a área de transferência!');
        }).catch(() => {
            // Fallback para navegadores mais antigos
            prompt('Copie este link:', shareUrl);
        });
    }

    /**
     * FUNCIONALIDADE: Modal de ajuda
     * Exibe informações sobre:
     * - Atalhos do teclado
     * - Funcionalidades disponíveis
     * - Sintaxe básica do MiniDart
     */
    showHelp() {
        const helpText = `
LiPo - Linguagem em Portugol - Ajuda

Atalhos do Teclado:
• Ctrl + Enter: Executar código

Funcionalidades:
• Troca de temas (claro/escuro/alto contraste)
• Compartilhamento de código via URL
• Contador de linhas e caracteres
• Execução de código LiPo

Sintaxe LiPo:
• Funções: func nomeFuncao() { ... }
• Variáveis: var nome = valor;
• Saída: saida.imprimir("texto");
        `;
        
        // Usa alert simples (pode ser substituído por modal customizado)
        alert(helpText);
    }

    /**
     * FUNCIONALIDADE: Atualizar área de saída
     * Substitui conteúdo da div#output
     * NOTA: main.dart também controla esta área
     */
    updateOutput(text) {
        const output = document.getElementById('output');
        if (output) {
            output.textContent = text;
        }
    }

    /**
     * FUNCIONALIDADE: Atualizar status do playground
     * Exibe mensagens na barra de status
     * NOTA: main.dart também controla este elemento
     */
    updateStatus(text) {
        const status = document.querySelector('.status');
        if (status) {
            status.textContent = text;
        }
    }

    /**
     * FUNCIONALIDADE: Controlar estado do botão Executar
     * Alterna entre "Executar" e "Executando..."
     * NOTA: Não usado - main.dart controla este botão
     */
    setRunButtonState(running) {
        const runBtn = document.getElementById('run-btn');
        if (runBtn) {
            runBtn.disabled = running;
            if (running) {
                runBtn.innerHTML = 'Executando...';
            } else {
                runBtn.innerHTML = '<img src="icons/play.svg" style="width: 16px; height: 16px; margin-right: 0.5rem;" alt="Play"> Executar';
            }
        }
    }

    /**
     * FUNCIONALIDADE: Carregamento de código compartilhado
     * Processo:
     * 1. Verifica parâmetro ?code= na URL
     * 2. Decodifica Base64 para obter código original
     * 3. Carrega código no editor
     * 4. Atualiza status informando sucesso
     */
    loadSharedCode() {
        // Obtém parâmetros da URL atual
        const urlParams = new URLSearchParams(window.location.search);
        const encodedCode = urlParams.get('code');
        
        if (encodedCode) {
            try {
                // Decodifica Base64 para obter código original
                const code = atob(encodedCode);
                // Carrega no editor via EditorManager
                this.editorManager.setCode(code);
                this.updateStatus('Código carregado do link compartilhado');
            } catch (error) {
                console.error('Erro ao decodificar código compartilhado:', error);
            }
        }
    }
}

// ============================================
// INICIALIZAÇÃO DA APLICAÇÃO
// ============================================
/**
 * Inicializa o playground quando DOM estiver carregado
 * - Cria instância global da aplicação
 * - Carrega código compartilhado se houver
 * - Coordena com main.dart que será carregado depois
 */
document.addEventListener('DOMContentLoaded', () => {
    // Cria instância global para acesso de outros scripts
    window.playground = new LiPoPlayground();
    
    // Verifica se há código compartilhado para carregar
    window.playground.loadSharedCode();
});
