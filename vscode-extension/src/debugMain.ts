import { MiniDartDebugSession } from './debugAdapter';

/**
 * Ponto de entrada para o Debug Adapter do MiniDart
 * 
 * Este arquivo é executado pelo VS Code quando uma sessão de debug
 * é iniciada. Ele cria uma nova instância do MiniDartDebugSession
 * e inicia a comunicação via Debug Adapter Protocol.
 */

// Função principal
function main() {
    // Cria uma nova sessão de debug
    const session = new MiniDartDebugSession();
    
    // Inicia a sessão (conecta stdin/stdout para comunicação DAP)
    session.start(process.stdin, process.stdout);
}

// Executa apenas se este arquivo for o ponto de entrada
if (require.main === module) {
    main();
}

export { MiniDartDebugSession };
