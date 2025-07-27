import { MiniDartDebugSession } from './debugAdapterDAP';

/**
 * Ponto de entrada DAP (Debug Adapter Protocol) para MiniDart
 * Implementa comunicação bidirecional completa com VS Code
 */

function main() {
    console.log('🎯 Iniciando MiniDart Debug Adapter Protocol (DAP)...');
    
    // Cria sessão DAP completa
    const session = new MiniDartDebugSession();
    
    // Inicia comunicação DAP via stdin/stdout
    session.start(process.stdin, process.stdout);
    
    console.log('🎯 DAP Session iniciada e aguardando comunicação...');
}

// Executa se for o ponto de entrada principal
if (require.main === module) {
    main();
}

export { MiniDartDebugSession };
