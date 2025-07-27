import { MiniDartDebugSessionSimple } from './debugAdapterSimple';

/**
 * Ponto de entrada simplificado para o Debug Adapter do MiniDart
 */

function main() {
    console.log('Iniciando MiniDart Debug Adapter...');
    
    // Cria uma nova sessão de debug
    const session = new MiniDartDebugSessionSimple();
    
    // Inicia a sessão (conecta stdin/stdout para comunicação DAP)
    session.start(process.stdin, process.stdout);
}

// Executa apenas se este arquivo for o ponto de entrada
if (require.main === module) {
    main();
}

export { MiniDartDebugSessionSimple };
