import * as vscode from 'vscode';
import * as path from 'path';
import * as fs from 'fs';

/**
 * Debug Adapter Descriptor Factory para MiniDart
 */
class MiniDartDebugAdapterDescriptorFactory implements vscode.DebugAdapterDescriptorFactory {
    createDebugAdapterDescriptor(session: vscode.DebugSession): vscode.ProviderResult<vscode.DebugAdapterDescriptor> {
        // Retorna o caminho para o debug adapter DAP completo
        const adapterPath = path.join(__dirname, 'debugMainStandalone.js');
        console.log('🎯 Debug Adapter Standalone Path:', adapterPath);
        return new vscode.DebugAdapterExecutable('node', [adapterPath]);
    }
}

export function activate(context: vscode.ExtensionContext) {
    console.log('MiniDart Extension ativada!');

    // Registrar Debug Adapter Factory
    const debugAdapterFactory = new MiniDartDebugAdapterDescriptorFactory();
    context.subscriptions.push(
        vscode.debug.registerDebugAdapterDescriptorFactory('minidart', debugAdapterFactory)
    );

    // Registrar comandos
    const compileCommand = vscode.commands.registerCommand('minidart.compile', compileFile);
    const runCommand = vscode.commands.registerCommand('minidart.run', runFile);
    const debugCommand = vscode.commands.registerCommand('minidart.debug', debugFile);
    const generateASTCommand = vscode.commands.registerCommand('minidart.generateAST', generateAST);
    const openASTCommand = vscode.commands.registerCommand('minidart.openAST', openAST);
    const newFileCommand = vscode.commands.registerCommand('minidart.newFile', createNewFile);

    // Registrar provedor de diagnósticos
    const diagnosticCollection = vscode.languages.createDiagnosticCollection('minidart');
    context.subscriptions.push(diagnosticCollection);

    // Auto-compilação ao salvar
    const saveListener = vscode.workspace.onDidSaveTextDocument((document: vscode.TextDocument) => {
        if (document.languageId === 'minidart') {
            const config = vscode.workspace.getConfiguration('minidart');
            if (config.get('autoCompile')) {
                compileFile();
            }
        }
    });

    context.subscriptions.push(
        compileCommand,
        runCommand,
        debugCommand,
        generateASTCommand,
        openASTCommand,
        newFileCommand,
        saveListener
    );
}

async function compileFile() {
    const editor = vscode.window.activeTextEditor;
    if (!editor || !editor.document.fileName.endsWith('.mdart')) {
        vscode.window.showErrorMessage('Por favor, abra um arquivo .mdart');
        return;
    }

    const filePath = editor.document.fileName;
    const workspaceFolder = vscode.workspace.getWorkspaceFolder(editor.document.uri);
    
    if (!workspaceFolder) {
        vscode.window.showErrorMessage('Arquivo deve estar em um workspace');
        return;
    }

    const config = vscode.workspace.getConfiguration('minidart');
    const compilerPath = config.get<string>('compilerPath', 'bin/compile.dart');
    const fullCompilerPath = path.join(workspaceFolder.uri.fsPath, compilerPath);

    // Verificar se o compilador existe
    if (!fs.existsSync(fullCompilerPath)) {
        vscode.window.showErrorMessage(`Compilador não encontrado em: ${fullCompilerPath}`);
        return;
    }

    // Salvar arquivo antes de compilar
    await editor.document.save();

    const terminal = vscode.window.createTerminal('MiniDart Compiler');
    terminal.sendText(`dart "${fullCompilerPath}" "${filePath}"`);
    terminal.show();

    vscode.window.showInformationMessage('🚀 Compilando arquivo MiniDart...');
}

async function runFile() {
    const editor = vscode.window.activeTextEditor;
    if (!editor || !editor.document.fileName.endsWith('.mdart')) {
        vscode.window.showErrorMessage('Por favor, abra um arquivo .mdart');
        return;
    }

    const filePath = editor.document.fileName;
    const workspaceFolder = vscode.workspace.getWorkspaceFolder(editor.document.uri);
    
    if (!workspaceFolder) {
        vscode.window.showErrorMessage('Arquivo deve estar em um workspace');
        return;
    }

    const config = vscode.workspace.getConfiguration('minidart');
    const compilerPath = config.get<string>('compilerPath', 'bin/compile.dart');
    const fullCompilerPath = path.join(workspaceFolder.uri.fsPath, compilerPath);

    // Salvar arquivo antes de executar
    await editor.document.save();

    const terminal = vscode.window.createTerminal('MiniDart Runner');
    terminal.sendText(`dart "${fullCompilerPath}" "${filePath}"`);
    terminal.show();

    vscode.window.showInformationMessage('▶️ Executando arquivo MiniDart...');
}

async function debugFile() {
    const editor = vscode.window.activeTextEditor;
    if (!editor || !editor.document.fileName.endsWith('.mdart')) {
        vscode.window.showErrorMessage('Por favor, abra um arquivo .mdart');
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
        type: 'minidart',
        name: 'Debug MiniDart',
        request: 'launch',
        program: filePath,
        stopOnEntry: true,
        compilerPath: path.join(workspaceFolder.uri.fsPath, 'bin/compile.dart'),
        cwd: workspaceFolder.uri.fsPath
    };

    // Iniciar sessão de debug
    const started = await vscode.debug.startDebugging(workspaceFolder, debugConfig);
    
    if (started) {
        vscode.window.showInformationMessage('🐛 Iniciando debug MiniDart...');
    } else {
        vscode.window.showErrorMessage('❌ Erro ao iniciar debug. Verifique a configuração.');
    }
}

async function generateAST() {
    const editor = vscode.window.activeTextEditor;
    if (!editor || !editor.document.fileName.endsWith('.mdart')) {
        vscode.window.showErrorMessage('Por favor, abra um arquivo .mdart');
        return;
    }

    const filePath = editor.document.fileName;
    const workspaceFolder = vscode.workspace.getWorkspaceFolder(editor.document.uri);
    
    if (!workspaceFolder) {
        vscode.window.showErrorMessage('Arquivo deve estar em um workspace');
        return;
    }

    const config = vscode.workspace.getConfiguration('minidart');
    const compilerPath = config.get<string>('compilerPath', 'bin/compile.dart');
    const fullCompilerPath = path.join(workspaceFolder.uri.fsPath, compilerPath);

    // Salvar arquivo antes de gerar AST
    await editor.document.save();

    const terminal = vscode.window.createTerminal('MiniDart AST Generator');
    terminal.sendText(`dart "${fullCompilerPath}" "${filePath}" --ast-only`);
    terminal.show();

    vscode.window.showInformationMessage('🌳 Gerando AST...');

    // Tentar abrir a imagem AST após um tempo
    setTimeout(async () => {
        const baseName = path.basename(filePath, '.mdart');
        const astImagePath = path.join(path.dirname(filePath), `${baseName}_ast.png`);
        
        if (fs.existsSync(astImagePath)) {
            const uri = vscode.Uri.file(astImagePath);
            await vscode.commands.executeCommand('vscode.open', uri);
            vscode.window.showInformationMessage('👁️ AST gerada e aberta!');
        }
    }, 2000);
}

async function openAST() {
    const editor = vscode.window.activeTextEditor;
    if (!editor || !editor.document.fileName.endsWith('.mdart')) {
        vscode.window.showErrorMessage('Por favor, abra um arquivo .mdart');
        return;
    }

    const filePath = editor.document.fileName;
    const baseName = path.basename(filePath, '.mdart');
    const astImagePath = path.join(path.dirname(filePath), `${baseName}_ast.png`);

    if (fs.existsSync(astImagePath)) {
        const uri = vscode.Uri.file(astImagePath);
        await vscode.commands.executeCommand('vscode.open', uri);
    } else {
        const result = await vscode.window.showInformationMessage(
            'AST não encontrada. Deseja gerar?',
            'Gerar AST',
            'Cancelar'
        );
        if (result === 'Gerar AST') {
            generateAST();
        }
    }
}

async function createNewFile() {
    const workspaceFolder = vscode.workspace.workspaceFolders?.[0];
    if (!workspaceFolder) {
        vscode.window.showErrorMessage('Nenhum workspace aberto');
        return;
    }

    const fileName = await vscode.window.showInputBox({
        prompt: 'Nome do arquivo MiniDart (sem extensão)',
        placeHolder: 'exemplo: meu_programa'
    });

    if (!fileName) {
        return;
    }

    const template = `algoritmo ${fileName}
inicio
    // Seu código aqui
    escreva("Olá, mundo!");
fim`;

    const filePath = path.join(workspaceFolder.uri.fsPath, `${fileName}.mdart`);
    const uri = vscode.Uri.file(filePath);

    try {
        await vscode.workspace.fs.writeFile(uri, Buffer.from(template));
        const document = await vscode.workspace.openTextDocument(uri);
        await vscode.window.showTextDocument(document);
        vscode.window.showInformationMessage(`📄 Arquivo ${fileName}.mdart criado!`);
    } catch (error) {
        vscode.window.showErrorMessage(`Erro ao criar arquivo: ${error}`);
    }
}

export function deactivate() {
    console.log('MiniDart Extension desativada!');
}
