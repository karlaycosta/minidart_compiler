// ============================================
// GERENCIADOR DO EDITOR
// ============================================
// Responsável por:
// - Gerenciar textarea do editor
// - Contar linhas e caracteres
// - Fornecer interface para get/set código
// - Funcionalidades auxiliares (inserir texto, limpar)
// NOTA: main.dart também controla o editor, mas usa esta classe para stats

/**
 * Classe que gerencia o editor de código
 * Funcionalidades:
 * - Inicialização com código padrão
 * - Contagem de linhas/caracteres em tempo real
 * - Interface para manipulação de código
 * - Coordenação com main.dart (que também controla o editor)
 */
class EditorManager {
    constructor() {
        // Busca elemento textarea do editor
        this.editor = document.getElementById('editor');
        this.setupEditor();
    }

    /**
     * FUNCIONALIDADE: Configuração inicial do editor
     * Processo:
     * 1. Adiciona listener para contar caracteres
     * 2. Carrega código padrão MiniDart
     * 3. Atualiza estatísticas iniciais
     * NOTA: main.dart também carrega código padrão (pode sobrescrever)
     */
    setupEditor() {
        if (!this.editor) return;
        
        // PASSO 1: Event listener para atualizar stats em tempo real
        this.editor.addEventListener('input', () => {
            this.updateStats();
        });

        // PASSO 2: Carrega código padrão (importar io + saida.imprimir)
        this.editor.value = `importar io como saida;

saida.imprimir("Olá, LiPo!");
saida.imprimir("Bem-vindo à Linguagem em Portugol!");

var nome = "Desenvolvedor";
saida.imprimir("Olá, " + nome + "!");`;
        
        // PASSO 3: Atualiza contadores iniciais
        this.updateStats();
    }

    /**
     * FUNCIONALIDADE: Atualizar estatísticas do editor
     * Conta linhas (quebras de linha) e caracteres totais
     * Atualiza elemento .editor-stats na interface
     */
    updateStats() {
        const content = this.editor.value;
        const lines = content.split('\n').length;
        const chars = content.length;
        
        // Atualiza elemento de estatísticas na interface
        const statsElement = document.querySelector('.editor-stats');
        if (statsElement) {
            statsElement.textContent = `Linhas: ${lines} | Caracteres: ${chars}`;
        }
    }

    /**
     * FUNCIONALIDADE: Obter código atual
     * Retorna conteúdo do editor como string
     * Usado por app.js para compartilhamento
     */
    getCode() {
        return this.editor ? this.editor.value : '';
    }

    /**
     * FUNCIONALIDADE: Definir código no editor
     * Carrega código no textarea e atualiza stats
     * Usado para código compartilhado via URL
     */
    setCode(code) {
        if (this.editor) {
            this.editor.value = code;
            this.updateStats();
        }
    }

    /**
     * FUNCIONALIDADE: Limpar editor
     * Remove todo conteúdo e atualiza estatísticas
     */
    clear() {
        if (this.editor) {
            this.editor.value = '';
            this.updateStats();
        }
    }

    /**
     * FUNCIONALIDADE: Inserir texto na posição do cursor
     * Útil para botões de inserção automática ou snippets
     * Mantém posição do cursor após inserção
     */
    insertAtCursor(text) {
        if (!this.editor) return;
        
        // Obtém posição atual do cursor
        const start = this.editor.selectionStart;
        const end = this.editor.selectionEnd;
        const current = this.editor.value;
        
        // Insere texto na posição selecionada
        this.editor.value = current.substring(0, start) + text + current.substring(end);
        
        // Reposiciona cursor após o texto inserido
        this.editor.selectionStart = this.editor.selectionEnd = start + text.length;
        this.updateStats();
    }
}

// ============================================
// EXPORTAÇÃO GLOBAL
// ============================================
// Disponibiliza classe globalmente para uso em app.js
window.EditorManager = EditorManager;
