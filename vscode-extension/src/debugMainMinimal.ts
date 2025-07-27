import { MiniDartDebugSessionMinimal } from './debugAdapterMinimal';

/**
 * Ponto de entrada MÍNIMO para teste do Debug Adapter do MiniDart
 */

function main() {
    console.log('🟢 Iniciando MiniDart Debug Adapter MINIMAL...');
    
    // Cria uma nova sessão de debug minimal
    const session = new MiniDartDebugSessionMinimal();
    
    // Inicia a sessão (conecta stdin/stdout para comunicação DAP)
    session.start(process.stdin, process.stdout);
}

// Executa apenas se este arquivo for o ponto de entrada
if (require.main === module) {
    main();
}

export { MiniDartDebugSessionMinimal };
