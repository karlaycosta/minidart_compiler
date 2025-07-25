"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.deactivate = exports.activate = void 0;
const vscode = __importStar(require("vscode"));
const path = __importStar(require("path"));
const fs = __importStar(require("fs"));
function activate(context) {
    console.log('MiniDart Extension ativada!');
    // Registrar comandos
    const compileCommand = vscode.commands.registerCommand('minidart.compile', compileFile);
    const runCommand = vscode.commands.registerCommand('minidart.run', runFile);
    const generateASTCommand = vscode.commands.registerCommand('minidart.generateAST', generateAST);
    const openASTCommand = vscode.commands.registerCommand('minidart.openAST', openAST);
    const newFileCommand = vscode.commands.registerCommand('minidart.newFile', createNewFile);
    // Registrar provedor de diagnósticos
    const diagnosticCollection = vscode.languages.createDiagnosticCollection('minidart');
    context.subscriptions.push(diagnosticCollection);
    // Auto-compilação ao salvar
    const saveListener = vscode.workspace.onDidSaveTextDocument((document) => {
        if (document.languageId === 'minidart') {
            const config = vscode.workspace.getConfiguration('minidart');
            if (config.get('autoCompile')) {
                compileFile();
            }
        }
    });
    context.subscriptions.push(compileCommand, runCommand, generateASTCommand, openASTCommand, newFileCommand, saveListener);
}
exports.activate = activate;
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
    const compilerPath = config.get('compilerPath', 'bin/compile.dart');
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
    const compilerPath = config.get('compilerPath', 'bin/compile.dart');
    const fullCompilerPath = path.join(workspaceFolder.uri.fsPath, compilerPath);
    // Salvar arquivo antes de executar
    await editor.document.save();
    const terminal = vscode.window.createTerminal('MiniDart Runner');
    terminal.sendText(`dart "${fullCompilerPath}" "${filePath}"`);
    terminal.show();
    vscode.window.showInformationMessage('▶️ Executando arquivo MiniDart...');
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
    const compilerPath = config.get('compilerPath', 'bin/compile.dart');
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
    }
    else {
        const result = await vscode.window.showInformationMessage('AST não encontrada. Deseja gerar?', 'Gerar AST', 'Cancelar');
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
    }
    catch (error) {
        vscode.window.showErrorMessage(`Erro ao criar arquivo: ${error}`);
    }
}
function deactivate() {
    console.log('MiniDart Extension desativada!');
}
exports.deactivate = deactivate;
//# sourceMappingURL=extension.js.map