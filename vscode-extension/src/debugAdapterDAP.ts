import {
    DebugSession,
    InitializedEvent,
    TerminatedEvent,
    StoppedEvent,
    OutputEvent,
    Thread,
    StackFrame,
    Source,
    Scope,
    Variable
} from '@vscode/debugadapter';
import { DebugProtocol } from '@vscode/debugprotocol';
import { spawn, ChildProcess } from 'child_process';
import * as path from 'path';
import * as fs from 'fs';

interface MiniDartLaunchRequestArguments extends DebugProtocol.LaunchRequestArguments {
    program: string;
    args?: string[];
    cwd?: string;
    compilerPath?: string;
    stopOnEntry?: boolean;
}

/**
 * Debug Adapter Protocol (DAP) Completo para MiniDart
 * Implementa comunicação bidirecional entre VS Code e compilador MiniDart
 */
export class MiniDartDebugSession extends DebugSession {
    private static THREAD_ID = 1;
    private static SCOPE_ID = 1;
    
    private _compilerProcess?: ChildProcess;
    private _breakpoints = new Map<string, Map<number, DebugProtocol.Breakpoint>>();
    private _breakpointId = 1;
    private _isRunning = false;
    private _isPaused = false;
    private _currentLine = 1;
    private _currentFile = '';
    private _variables = new Map<string, any>();
    private _callStack: StackFrame[] = [];

    public constructor() {
        super();
        console.log('🎯 MiniDartDebugSession DAP construído');
        
        // Configurações DAP
        this.setDebuggerLinesStartAt1(true);
        this.setDebuggerColumnsStartAt1(true);
    }

    /**
     * Inicialização DAP - Define capacidades do debugger
     */
    protected initializeRequest(response: DebugProtocol.InitializeResponse): void {
        console.log('🎯 DAP Initialize Request');
        
        // Definir capacidades do debugger conforme DAP
        response.body = response.body || {};
        
        // Configurações básicas
        response.body.supportsConfigurationDoneRequest = true;
        response.body.supportTerminateDebuggee = true;
        response.body.supportsTerminateRequest = true;
        response.body.supportsRestartRequest = false;
        
        // Suporte a breakpoints
        response.body.supportsBreakpointLocationsRequest = false;
        response.body.supportsConditionalBreakpoints = false;
        response.body.supportsHitConditionalBreakpoints = false;
        response.body.supportsFunctionBreakpoints = false;
        response.body.supportsLogPoints = false;
        
        // Suporte a stepping
        response.body.supportsStepBack = false;
        response.body.supportsStepInTargetsRequest = false;
        response.body.supportsRestartFrame = false;
        response.body.supportsGotoTargetsRequest = false;
        
        // Suporte a avaliação
        response.body.supportsEvaluateForHovers = true;
        response.body.supportsCompletionsRequest = false;
        response.body.supportsModulesRequest = false;
        response.body.supportsExceptionInfoRequest = false;
        response.body.supportsValueFormattingOptions = false;
        response.body.supportsExceptionOptions = false;
        
        // Filtros de exceção
        response.body.exceptionBreakpointFilters = [];
        
        console.log('🎯 DAP Capabilities configured:', response.body);
        
        this.sendResponse(response);
        this.sendEvent(new InitializedEvent());
        
        console.log('🎯 DAP Initialize Response sent');
    }

    /**
     * Configuração completa - chamado após initialize
     */
    protected configurationDoneRequest(response: DebugProtocol.ConfigurationDoneResponse): void {
        console.log('🎯 DAP Configuration Done');
        super.configurationDoneRequest(response, arguments);
    }

    /**
     * Launch Request - Inicia o processo de debug
     */
    protected async launchRequest(response: DebugProtocol.LaunchResponse, args: MiniDartLaunchRequestArguments) {
        console.log('🎯 DAP Launch Request:', args);
        
        try {
            // Validações de entrada
            if (!args.program) {
                throw new Error('Programa não especificado');
            }
            
            if (!fs.existsSync(args.program)) {
                throw new Error(`Arquivo não encontrado: ${args.program}`);
            }
            
            const compilerPath = args.compilerPath || 'bin/compile.dart';
            const cwd = args.cwd || process.cwd();
            
            this._currentFile = args.program;
            console.log(`🎯 Compilador: ${compilerPath}`);
            console.log(`🎯 Arquivo: ${args.program}`);
            console.log(`🎯 Diretório: ${cwd}`);
            
            // Preparar argumentos para o compilador
            const dartArgs = ['run', compilerPath, args.program];
            
            // Adicionar flag de debug se não estiver presente
            if (!dartArgs.includes('--debug-dap')) {
                dartArgs.push('--debug-dap');
            }
            
            console.log(`🎯 Comando: dart ${dartArgs.join(' ')}`);
            
            // Iniciar processo do compilador
            this._compilerProcess = spawn('dart', dartArgs, {
                cwd: cwd,
                stdio: ['pipe', 'pipe', 'pipe']
            });

            // Configurar handlers de comunicação
            this._setupProcessCommunication();
            
            this._isRunning = true;
            this._isPaused = args.stopOnEntry || false;
            
            this.sendResponse(response);
            
            // Notificar VS Code sobre o estado inicial
            this.sendEvent(new OutputEvent('🎯 MiniDart Debug Session iniciada\n', 'console'));
            this.sendEvent(new OutputEvent(`📄 Arquivo: ${path.basename(args.program)}\n`, 'console'));
            
            if (args.stopOnEntry) {
                console.log('🎯 Parando na entrada conforme solicitado');
                this.sendEvent(new StoppedEvent('entry', MiniDartDebugSession.THREAD_ID));
            }
            
        } catch (error) {
            console.error('🎯 Erro no Launch Request:', error);
            this.sendErrorResponse(response, 2001, `Erro ao iniciar debug: ${error}`);
        }
    }

    /**
     * Configurar comunicação bidirecional com o processo
     */
    private _setupProcessCommunication(): void {
        if (!this._compilerProcess) return;

        // STDOUT - Saída normal do programa
        this._compilerProcess.stdout?.on('data', (data) => {
            const output = data.toString();
            console.log('🎯 STDOUT:', output);
            this.sendEvent(new OutputEvent(output, 'stdout'));
            
            // Processar mensagens DAP do compilador
            this._processCompilerDAP(output);
        });

        // STDERR - Erros e mensagens de debug
        this._compilerProcess.stderr?.on('data', (data) => {
            const output = data.toString();
            console.log('🎯 STDERR:', output);
            this.sendEvent(new OutputEvent(output, 'stderr'));
        });

        // Processo encerrado
        this._compilerProcess.on('close', (code) => {
            console.log(`🎯 Processo encerrado com código: ${code}`);
            this._isRunning = false;
            this.sendEvent(new TerminatedEvent());
        });

        // Erro no processo
        this._compilerProcess.on('error', (error) => {
            console.error('🎯 Erro no processo:', error);
            this.sendEvent(new OutputEvent(`Erro: ${error.message}\n`, 'stderr'));
            this.sendEvent(new TerminatedEvent());
        });
    }

    /**
     * Processar mensagens DAP vindas do compilador
     */
    private _processCompilerDAP(output: string): void {
        const lines = output.split('\n');
        
        for (const line of lines) {
            if (line.startsWith('DAP:')) {
                try {
                    const dapMessage = JSON.parse(line.substring(4));
                    this._handleCompilerDAPMessage(dapMessage);
                } catch (e) {
                    console.log('🎯 Erro ao processar mensagem DAP:', e);
                }
            }
        }
    }

    /**
     * Processar mensagens DAP específicas do compilador
     */
    private _handleCompilerDAPMessage(message: any): void {
        console.log('🎯 Mensagem DAP do compilador:', message);
        
        switch (message.type) {
            case 'stopped':
                this._currentLine = message.line || 1;
                this._isPaused = true;
                this.sendEvent(new StoppedEvent(message.reason || 'pause', MiniDartDebugSession.THREAD_ID));
                break;
                
            case 'variables':
                this._variables.clear();
                for (const [name, value] of Object.entries(message.data || {})) {
                    this._variables.set(name, value);
                }
                break;
                
            case 'output':
                this.sendEvent(new OutputEvent(message.text || '', message.category || 'stdout'));
                break;
        }
    }

    /**
     * Configurar breakpoints
     */
    protected setBreakPointsRequest(response: DebugProtocol.SetBreakpointsResponse, args: DebugProtocol.SetBreakpointsArguments): void {
        console.log('🎯 DAP SetBreakpoints Request:', args);
        
        const lines = args.lines || [];
        const sourcePath = args.source?.path || this._currentFile;
        
        console.log(`🎯 Arquivo: ${sourcePath}`);
        console.log(`🎯 Linhas: [${lines.join(', ')}]`);
        
        // Limpar breakpoints anteriores para este arquivo
        if (!this._breakpoints.has(sourcePath)) {
            this._breakpoints.set(sourcePath, new Map());
        }
        const fileBreakpoints = this._breakpoints.get(sourcePath)!;
        fileBreakpoints.clear();
        
        // Criar novos breakpoints
        const breakpoints: DebugProtocol.Breakpoint[] = lines.map(line => {
            const bp: DebugProtocol.Breakpoint = {
                id: this._breakpointId++,
                verified: true,
                line: line,
                column: 0,
                source: args.source
            };
            
            fileBreakpoints.set(line, bp);
            console.log(`🎯 Breakpoint configurado: linha ${line}, id ${bp.id}`);
            
            return bp;
        });
        
        // Enviar comando para o compilador
        if (this._compilerProcess && this._compilerProcess.stdin) {
            const command = {
                type: 'setBreakpoints',
                file: sourcePath,
                lines: lines
            };
            
            this._compilerProcess.stdin.write(`DAP:${JSON.stringify(command)}\n`);
            console.log('🎯 Comando de breakpoints enviado para compilador:', command);
        }
        
        response.body = { breakpoints: breakpoints };
        this.sendResponse(response);
        
        this.sendEvent(new OutputEvent(`🎯 ${breakpoints.length} breakpoint(s) configurado(s)\n`, 'console'));
    }

    /**
     * Requisição de threads
     */
    protected threadsRequest(response: DebugProtocol.ThreadsResponse): void {
        console.log('🎯 DAP Threads Request');
        
        response.body = {
            threads: [new Thread(MiniDartDebugSession.THREAD_ID, "main")]
        };
        
        this.sendResponse(response);
    }

    /**
     * Requisição de stack trace
     */
    protected stackTraceRequest(response: DebugProtocol.StackTraceResponse, args: DebugProtocol.StackTraceArguments): void {
        console.log('🎯 DAP StackTrace Request');
        
        const frames: StackFrame[] = [
            new StackFrame(
                0,
                'main',
                new Source(path.basename(this._currentFile), this._currentFile),
                this._currentLine,
                0
            )
        ];
        
        response.body = {
            stackFrames: frames,
            totalFrames: frames.length
        };
        
        this.sendResponse(response);
    }

    /**
     * Requisição de scopes
     */
    protected scopesRequest(response: DebugProtocol.ScopesResponse, args: DebugProtocol.ScopesArguments): void {
        console.log('🎯 DAP Scopes Request');
        
        const scopes: Scope[] = [
            new Scope("Locais", MiniDartDebugSession.SCOPE_ID, false),
            new Scope("Globais", MiniDartDebugSession.SCOPE_ID + 1, false)
        ];
        
        response.body = { scopes: scopes };
        this.sendResponse(response);
    }

    /**
     * Requisição de variáveis
     */
    protected variablesRequest(response: DebugProtocol.VariablesResponse, args: DebugProtocol.VariablesArguments): void {
        console.log('🎯 DAP Variables Request');
        
        const variables: Variable[] = [];
        
        // Converter variáveis armazenadas
        this._variables.forEach((value, name) => {
            variables.push(new Variable(name, String(value)));
        });
        
        response.body = { variables: variables };
        this.sendResponse(response);
    }

    /**
     * Continue execution
     */
    protected continueRequest(response: DebugProtocol.ContinueResponse): void {
        console.log('🎯 DAP Continue Request');
        
        this._isPaused = false;
        
        if (this._compilerProcess && this._compilerProcess.stdin) {
            this._compilerProcess.stdin.write('DAP:{"type":"continue"}\n');
        }
        
        response.body = { allThreadsContinued: true };
        this.sendResponse(response);
        
        this.sendEvent(new OutputEvent('▶️ Execução continuada\n', 'console'));
    }

    /**
     * Step over
     */
    protected nextRequest(response: DebugProtocol.NextResponse): void {
        console.log('🎯 DAP Next (Step Over) Request');
        
        if (this._compilerProcess && this._compilerProcess.stdin) {
            this._compilerProcess.stdin.write('DAP:{"type":"next"}\n');
        }
        
        this.sendResponse(response);
        this.sendEvent(new OutputEvent('⏭️ Step Over executado\n', 'console'));
    }

    /**
     * Step into
     */
    protected stepInRequest(response: DebugProtocol.StepInResponse): void {
        console.log('🎯 DAP Step In Request');
        
        if (this._compilerProcess && this._compilerProcess.stdin) {
            this._compilerProcess.stdin.write('DAP:{"type":"stepIn"}\n');
        }
        
        this.sendResponse(response);
        this.sendEvent(new OutputEvent('⬇️ Step Into executado\n', 'console'));
    }

    /**
     * Step out
     */
    protected stepOutRequest(response: DebugProtocol.StepOutResponse): void {
        console.log('🎯 DAP Step Out Request');
        
        if (this._compilerProcess && this._compilerProcess.stdin) {
            this._compilerProcess.stdin.write('DAP:{"type":"stepOut"}\n');
        }
        
        this.sendResponse(response);
        this.sendEvent(new OutputEvent('⬆️ Step Out executado\n', 'console'));
    }

    /**
     * Pause execution
     */
    protected pauseRequest(response: DebugProtocol.PauseResponse): void {
        console.log('🎯 DAP Pause Request');
        
        this._isPaused = true;
        
        if (this._compilerProcess && this._compilerProcess.stdin) {
            this._compilerProcess.stdin.write('DAP:{"type":"pause"}\n');
        }
        
        this.sendResponse(response);
        this.sendEvent(new StoppedEvent('pause', MiniDartDebugSession.THREAD_ID));
    }

    /**
     * Disconnect/terminate
     */
    protected disconnectRequest(response: DebugProtocol.DisconnectResponse, args: DebugProtocol.DisconnectArguments): void {
        console.log('🎯 DAP Disconnect Request');
        
        this._isRunning = false;
        
        if (this._compilerProcess) {
            this._compilerProcess.kill();
        }
        
        this.sendResponse(response);
    }

    /**
     * Evaluate expression
     */
    protected evaluateRequest(response: DebugProtocol.EvaluateResponse, args: DebugProtocol.EvaluateArguments): void {
        console.log('🎯 DAP Evaluate Request:', args.expression);
        
        const expression = args.expression;
        let result = '';
        
        // Verificar se é uma variável conhecida
        if (this._variables.has(expression)) {
            result = String(this._variables.get(expression));
        } else {
            result = `<undefined: ${expression}>`;
        }
        
        response.body = {
            result: result,
            variablesReference: 0
        };
        
        this.sendResponse(response);
    }
}
