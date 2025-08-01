import { MiniDartDebugSessionHybrid } from './debugAdapterHybrid';

/**
 * Ponto de entrada HÍBRIDO para o Debug Adapter do MiniDart
 * Combina funcionalidade visual do VS Code com terminal interativo
 */

function main() {
    console.log('🔄 Iniciando MiniDart Debug Adapter HÍBRIDO...');
    
    // Cria uma nova sessão de debug híbrida
    const session = new MiniDartDebugSessionHybrid();
    
    // Inicia a sessão (conecta stdin/stdout para comunicação DAP)
    session.start(process.stdin, process.stdout);
}

// Executa apenas se este arquivo for o ponto de entrada
if (require.main === module) {
    main();
}

export { MiniDartDebugSessionHybrid };
