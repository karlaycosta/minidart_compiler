// ============================================
// TESTE DE TEMA - LIPO PLAYGROUND
// ============================================

console.log('Script de teste do LiPo carregado');

// Verificar se o tema está sendo aplicado
document.addEventListener('DOMContentLoaded', () => {
    console.log('Body class:', document.body.className);
    
    // Teste manual do tema
    window.testTheme = function() {
        document.body.className = 'dark-theme';
        console.log('Tema alterado para dark-theme');
    };
    
    window.testLightTheme = function() {
        document.body.className = 'light-theme';
        console.log('Tema alterado para light-theme');
    };
    
    window.testHighContrastTheme = function() {
        document.body.className = 'high-contrast-theme';
        console.log('Tema alterado para high-contrast-theme');
    };
});
