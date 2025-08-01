import { MiniDartDebugStandalone } from './debugAdapterStandalone';

/**
 * Entry point para Debug Adapter Standalone
 * Este modo funciona completamente dentro do VS Code
 */
console.log('🎯 Iniciando MiniDart Debug Adapter Standalone');

const session = new MiniDartDebugStandalone();
process.on('SIGTERM', () => {
    console.log('🎯 Debug Standalone terminando...');
    session.shutdown();
});

session.start(process.stdin, process.stdout);
console.log('🎯 Debug Standalone iniciado e aguardando comandos');
