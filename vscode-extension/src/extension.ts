import * as vscode from 'vscode';
import * as path from 'path';
import * as fs from 'fs';

// Terminal compartilhado para todas as operações
let sharedTerminal: vscode.Terminal | undefined;

/**
 * Obtém ou cria o terminal compartilhado do LiPo
 */
function getSharedTerminal(): vscode.Terminal {
    if (!sharedTerminal || sharedTerminal.exitStatus) {
        sharedTerminal = vscode.window.createTerminal('LiPo Compiler');
    }
    return sharedTerminal;
}

/**
 * Debug Adapter Descriptor Factory para LiPo
 * Como removemos os arquivos de debug adapter, esta implementação usa um adaptador inline simples
 */
class LiPoDebugAdapterDescriptorFactory implements vscode.DebugAdapterDescriptorFactory {
    createDebugAdapterDescriptor(session: vscode.DebugSession): vscode.ProviderResult<vscode.DebugAdapterDescriptor> {
        // Por enquanto, usa um debug simples via terminal compartilhado
        // Em futuras versões, podemos implementar um debug adapter completo
        console.log('🎯 LiPo Debug: Usando debug simples via terminal');
        return undefined; // Usa debug padrão do VS Code
    }
}

export function activate(context: vscode.ExtensionContext) {
    console.log('LiPo Extension ativada!');

    // Registrar Debug Adapter Factory
    const debugAdapterFactory = new LiPoDebugAdapterDescriptorFactory();
    context.subscriptions.push(
        vscode.debug.registerDebugAdapterDescriptorFactory('lipo', debugAdapterFactory)
    );

    // Registrar comandos
    const compileCommand = vscode.commands.registerCommand('lipo.compile', compileFile);
    const runCommand = vscode.commands.registerCommand('lipo.run', runFile);
    const debugCommand = vscode.commands.registerCommand('lipo.debug', debugFile);
    const newFileCommand = vscode.commands.registerCommand('lipo.newFile', createNewFile);

    // Registrar provedor de diagnósticos
    const diagnosticCollection = vscode.languages.createDiagnosticCollection('lipo');
    context.subscriptions.push(diagnosticCollection);

    // Auto-compilação ao salvar
    const saveListener = vscode.workspace.onDidSaveTextDocument((document: vscode.TextDocument) => {
        if (document.languageId === 'lipo') {
            const config = vscode.workspace.getConfiguration('lipo');
            if (config.get('autoCompile')) {
                compileFile();
            }
        }
    });

    context.subscriptions.push(
        compileCommand,
        runCommand,
        debugCommand,
        newFileCommand,
        saveListener
    );
}

async function compileFile() {
    const editor = vscode.window.activeTextEditor;
    if (!editor || !editor.document.fileName.endsWith('.lip')) {
        vscode.window.showErrorMessage('Por favor, abra um arquivo .lip');
        return;
    }

    const filePath = editor.document.fileName;
    const workspaceFolder = vscode.workspace.getWorkspaceFolder(editor.document.uri);
    
    if (!workspaceFolder) {
        vscode.window.showErrorMessage('Arquivo deve estar em um workspace');
        return;
    }

    // Salvar arquivo antes de compilar
    await editor.document.save();

    const terminal = getSharedTerminal();
    terminal.sendText(`lipo "${filePath}"`);
    terminal.show();
}

async function runFile() {
    const editor = vscode.window.activeTextEditor;
    if (!editor || !editor.document.fileName.endsWith('.lip')) {
        vscode.window.showErrorMessage('Por favor, abra um arquivo .lip');
        return;
    }

    const filePath = editor.document.fileName;
    const workspaceFolder = vscode.workspace.getWorkspaceFolder(editor.document.uri);
    
    if (!workspaceFolder) {
        vscode.window.showErrorMessage('Arquivo deve estar em um workspace');
        return;
    }

    // Salvar arquivo antes de executar
    await editor.document.save();

    const terminal = getSharedTerminal();
    terminal.sendText(`lipo "${filePath}"`);
    terminal.show();
}

async function debugFile() {
    const editor = vscode.window.activeTextEditor;
    if (!editor || !editor.document.fileName.endsWith('.lip')) {
        vscode.window.showErrorMessage('Por favor, abra um arquivo .lip');
        return;
    }

    const filePath = editor.document.fileName;
    const workspaceFolder = vscode.workspace.getWorkspaceFolder(editor.document.uri);
    
    if (!workspaceFolder) {
        vscode.window.showErrorMessage('Arquivo deve estar em um workspace');
        return;
    }

    // Salvar arquivo antes de fazer debug
    await editor.document.save();

    // Criar configuração de debug
    const debugConfig: vscode.DebugConfiguration = {
        type: 'lipo',
        name: 'Debug Lipo',
        request: 'launch',
        program: filePath,
        stopOnEntry: true,
        cwd: workspaceFolder.uri.fsPath
    };

    // Iniciar sessão de debug
    const started = await vscode.debug.startDebugging(workspaceFolder, debugConfig);
    
    if (started) {
        vscode.window.showInformationMessage('🐛 Iniciando debug LiPo...');
    } else {
        vscode.window.showErrorMessage('❌ Erro ao iniciar debug. Verifique a configuração.');
    }
}

async function createNewFile() {
    const workspaceFolder = vscode.workspace.workspaceFolders?.[0];
    if (!workspaceFolder) {
        vscode.window.showErrorMessage('Nenhum workspace aberto');
        return;
    }

    const fileName = await vscode.window.showInputBox({
        prompt: 'Nome do arquivo LiPo (sem extensão)',
        placeHolder: 'exemplo: meu_programa'
    });

    if (!fileName) {
        return;
    }

    const template = `// Programa LiPo
vazio principal() {
    imprima "Olá, mundo!";
    // Seu código aqui
}`;

    const filePath = path.join(workspaceFolder.uri.fsPath, `${fileName}.lip`);
    const uri = vscode.Uri.file(filePath);

    try {
        await vscode.workspace.fs.writeFile(uri, Buffer.from(template));
        const document = await vscode.workspace.openTextDocument(uri);
        await vscode.window.showTextDocument(document);
        vscode.window.showInformationMessage(`📄 Arquivo ${fileName}.lip criado!`);
    } catch (error) {
        vscode.window.showErrorMessage(`Erro ao criar arquivo: ${error}`);
    }
}

export function deactivate() {
    console.log('LiPo Extension desativada!');
    
    // Limpar terminal compartilhado ao desativar
    if (sharedTerminal) {
        sharedTerminal.dispose();
        sharedTerminal = undefined;
    }
}
