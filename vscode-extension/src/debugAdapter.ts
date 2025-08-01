import {
    DebugSession,
    InitializedEvent,
    TerminatedEvent,
    StoppedEvent,
    BreakpointEvent,
    OutputEvent,
    Thread,
    StackFrame,
    Scope,
    Variable,
    Breakpoint,
    Source
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

interface MiniDartBreakpoint {
    line: number;
    verified: boolean;
    source?: DebugProtocol.Source;
}

interface MiniDartVariable {
    name: string;
    value: string;
    type: string;
}

interface MiniDartStackFrame {
    name: string;
    line: number;
    args: any[];
}

/**
 * Debug Adapter para MiniDart
 * 
 * Implementa o Debug Adapter Protocol (DAP) para permitir debugging
 * visual do MiniDart no VS Code com:
 * - Breakpoints visuais
 * - Step-by-step execution
 * - Watch de variáveis
 * - Call stack visualization
 */
export class MiniDartDebugSession extends DebugSession {
    private static THREAD_ID = 1;
    private _compilerProcess?: ChildProcess;
    private _breakpoints = new Map<string, MiniDartBreakpoint[]>();
    private _currentLine = 1;
    private _currentFile = '';
    private _variables: MiniDartVariable[] = [];
    private _callStack: MiniDartStackFrame[] = [];
    private _isRunning = false;
    private _isPaused = false;
    private _stopOnEntry = false;
    private _sourceLines: string[] = [];

    public constructor() {
        super();
        this.setDebuggerLinesStartAt1(true);
        this.setDebuggerColumnsStartAt1(false);
    }

    protected initializeRequest(response: DebugProtocol.InitializeResponse, args: DebugProtocol.InitializeRequestArguments): void {
        response.body = response.body || {};
        
        // Capacidades do debugger
        response.body.supportsConfigurationDoneRequest = true;
        response.body.supportsEvaluateForHovers = true;
        response.body.supportsStepBack = false;
        response.body.supportsDataBreakpoints = false;
        response.body.supportsCompletionsRequest = false;
        response.body.supportsCancelRequest = false;
        response.body.supportsBreakpointLocationsRequest = false;
        response.body.supportsStepInTargetsRequest = false;
        response.body.supportsGotoTargetsRequest = false;
        response.body.supportsModulesRequest = false;
        response.body.supportsRestartRequest = false;
        response.body.supportsExceptionOptions = false;
        response.body.supportsValueFormattingOptions = true;
        response.body.supportsExceptionInfoRequest = false;
        response.body.supportTerminateDebuggee = true;
        response.body.supportSuspendDebuggee = true;
        response.body.supportsDelayedStackTraceLoading = false;
        response.body.supportsLoadedSourcesRequest = false;
        response.body.supportsLogPoints = false;
        response.body.supportsTerminateThreadsRequest = false;
        response.body.supportsSetVariable = false;
        response.body.supportsRestartFrame = false;
        response.body.supportsSetExpression = false;

        this.sendResponse(response);
        this.sendEvent(new InitializedEvent());
    }

    protected configurationDoneRequest(response: DebugProtocol.ConfigurationDoneResponse, args: DebugProtocol.ConfigurationDoneArguments): void {
        super.configurationDoneRequest(response, args);
    }

    protected async launchRequest(response: DebugProtocol.LaunchResponse, args: MiniDartLaunchRequestArguments) {
        try {
            this._currentFile = args.program;
            this._stopOnEntry = args.stopOnEntry || false;
            
            // Lê o arquivo fonte
            if (fs.existsSync(args.program)) {
                const sourceContent = fs.readFileSync(args.program, 'utf8');
                this._sourceLines = sourceContent.split('\n');
            }

            // Inicia o processo do compilador em modo debug
            await this._startDebugProcess(args);
            
            this.sendResponse(response);
            
            if (this._stopOnEntry) {
                this._isPaused = true;
                this.sendEvent(new StoppedEvent('entry', MiniDartDebugSession.THREAD_ID));
            }
        } catch (error) {
            this.sendErrorResponse(response, 1001, `Erro ao iniciar debug: ${error}`);
        }
    }

    private async _startDebugProcess(args: MiniDartLaunchRequestArguments): Promise<void> {
        return new Promise((resolve, reject) => {
            const compilerPath = args.compilerPath || 'bin/compile.dart';
            const cwd = args.cwd || path.dirname(args.program);
            
            // Comando para executar o compilador em modo debug interativo
            const dartArgs = ['run', compilerPath, args.program, '--debug-interactive'];
            
            this._compilerProcess = spawn('dart', dartArgs, {
                cwd: cwd,
                stdio: ['pipe', 'pipe', 'pipe']
            });

            this._compilerProcess.stdout?.on('data', (data) => {
                this._handleDebugOutput(data.toString());
            });

            this._compilerProcess.stderr?.on('data', (data) => {
                this.sendEvent(new OutputEvent(data.toString(), 'stderr'));
            });

            this._compilerProcess.on('close', (code) => {
                this._isRunning = false;
                this.sendEvent(new TerminatedEvent());
            });

            this._compilerProcess.on('error', (error) => {
                reject(error);
            });

            // Aguarda um pouco para o processo iniciar
            setTimeout(() => {
                this._isRunning = true;
                resolve();
            }, 500);
        });
    }

    private _handleDebugOutput(output: string): void {
        this.sendEvent(new OutputEvent(output, 'stdout'));
        
        // Parse da saída do debugger para extrair informações
        const lines = output.split('\n');
        
        for (const line of lines) {
            if (line.includes('BREAKPOINT atingido na linha')) {
                const match = line.match(/linha (\d+)/);
                if (match) {
                    this._currentLine = parseInt(match[1]);
                    this._isPaused = true;
                    this.sendEvent(new StoppedEvent('breakpoint', MiniDartDebugSession.THREAD_ID));
                }
            } else if (line.includes('Variáveis monitoradas:')) {
                // Atualizar variáveis
                this._parseVariables(output);
            } else if (line.includes('Call Stack:')) {
                // Atualizar call stack
                this._parseCallStack(output);
            }
        }
    }

    private _parseVariables(output: string): void {
        this._variables = [];
        const lines = output.split('\n');
        let inVariableSection = false;
        
        for (const line of lines) {
            if (line.includes('Variáveis monitoradas:')) {
                inVariableSection = true;
                continue;
            }
            
            if (inVariableSection && line.trim().startsWith('   ')) {
                const match = line.match(/^\s+(\w+) = (.+)$/);
                if (match) {
                    this._variables.push({
                        name: match[1],
                        value: match[2],
                        type: this._inferType(match[2])
                    });
                }
            } else if (inVariableSection && !line.trim().startsWith('   ')) {
                break;
            }
        }
    }

    private _parseCallStack(output: string): void {
        this._callStack = [];
        const lines = output.split('\n');
        let inStackSection = false;
        
        for (const line of lines) {
            if (line.includes('Call Stack:')) {
                inStackSection = true;
                continue;
            }
            
            if (inStackSection && line.includes('📞')) {
                const match = line.match(/📞 (\w+)\(([^)]*)\) \[linha (\d+)\]/);
                if (match) {
                    this._callStack.push({
                        name: match[1],
                        line: parseInt(match[3]),
                        args: match[2] ? match[2].split(', ') : []
                    });
                }
            } else if (inStackSection && !line.trim().startsWith('   ')) {
                break;
            }
        }
    }

    private _inferType(value: string): string {
        if (value === 'verdadeiro' || value === 'falso') return 'logico';
        if (value === 'nulo') return 'nulo';
        if (/^\d+$/.test(value)) return 'inteiro';
        if (/^\d+\.\d+$/.test(value)) return 'real';
        if (value.startsWith('"') && value.endsWith('"')) return 'texto';
        return 'desconhecido';
    }

    protected setBreakPointsRequest(response: DebugProtocol.SetBreakpointsResponse, args: DebugProtocol.SetBreakpointsArguments): void {
        const path = args.source.path!;
        const clientLines = args.lines || [];
        
        // Converter breakpoints do cliente para formato interno
        const breakpoints: MiniDartBreakpoint[] = clientLines.map((line: number) => ({
            line,
            verified: true,
            source: args.source
        }));
        
        this._breakpoints.set(path, breakpoints);
        
        // Enviar comando para o debugger
        if (this._compilerProcess && this._compilerProcess.stdin) {
            // Limpar breakpoints existentes
            this._compilerProcess.stdin.write('clear\n');
            
            // Adicionar novos breakpoints
            for (const bp of breakpoints) {
                this._compilerProcess.stdin.write(`break ${bp.line}\n`);
            }
        }
        
        // Resposta com breakpoints verificados
        response.body = {
            breakpoints: breakpoints.map(bp => ({
                verified: bp.verified,
                line: bp.line
            }))
        };
        
        this.sendResponse(response);
    }

    protected threadsRequest(response: DebugProtocol.ThreadsResponse): void {
        response.body = {
            threads: [
                new Thread(MiniDartDebugSession.THREAD_ID, "main")
            ]
        };
        this.sendResponse(response);
    }

    protected stackTraceRequest(response: DebugProtocol.StackTraceResponse, args: DebugProtocol.StackTraceArguments): void {
        const frames: StackFrame[] = [];
        
        // Frame principal
        frames.push(new StackFrame(
            0,
            'main',
            new Source(path.basename(this._currentFile), this._currentFile),
            this._currentLine,
            0
        ));
        
        // Frames da call stack
        this._callStack.forEach((frame, index) => {
            frames.push(new StackFrame(
                index + 1,
                frame.name,
                new Source(path.basename(this._currentFile), this._currentFile),
                frame.line,
                0
            ));
        });

        response.body = {
            stackFrames: frames,
            totalFrames: frames.length
        };
        this.sendResponse(response);
    }

    protected scopesRequest(response: DebugProtocol.ScopesResponse, args: DebugProtocol.ScopesArguments): void {
        response.body = {
            scopes: [
                new Scope("Locais", 1000, false),
                new Scope("Globais", 1001, false),
                new Scope("Watch", 1002, false)
            ]
        };
        this.sendResponse(response);
    }

    protected variablesRequest(response: DebugProtocol.VariablesResponse, args: DebugProtocol.VariablesArguments): void {
        const variables: Variable[] = [];
        
        switch (args.variablesReference) {
            case 1000: // Locais
            case 1001: // Globais
            case 1002: // Watch
                this._variables.forEach(variable => {
                    variables.push(new Variable(
                        variable.name,
                        variable.value,
                        0
                    ));
                });
                break;
        }

        response.body = {
            variables: variables
        };
        this.sendResponse(response);
    }

    protected continueRequest(response: DebugProtocol.ContinueResponse, args: DebugProtocol.ContinueArguments): void {
        this._isPaused = false;
        
        if (this._compilerProcess && this._compilerProcess.stdin) {
            this._compilerProcess.stdin.write('continue\n');
        }
        
        response.body = {
            allThreadsContinued: true
        };
        this.sendResponse(response);
    }

    protected nextRequest(response: DebugProtocol.NextResponse, args: DebugProtocol.NextArguments): void {
        if (this._compilerProcess && this._compilerProcess.stdin) {
            this._compilerProcess.stdin.write('next\n');
        }
        this.sendResponse(response);
    }

    protected stepInRequest(response: DebugProtocol.StepInResponse, args: DebugProtocol.StepInArguments): void {
        if (this._compilerProcess && this._compilerProcess.stdin) {
            this._compilerProcess.stdin.write('step\n');
        }
        this.sendResponse(response);
    }

    protected stepOutRequest(response: DebugProtocol.StepOutResponse, args: DebugProtocol.StepOutArguments): void {
        // Implementação básica - continua execução
        if (this._compilerProcess && this._compilerProcess.stdin) {
            this._compilerProcess.stdin.write('continue\n');
        }
        this.sendResponse(response);
    }

    protected pauseRequest(response: DebugProtocol.PauseResponse, args: DebugProtocol.PauseArguments): void {
        this._isPaused = true;
        this.sendEvent(new StoppedEvent('pause', MiniDartDebugSession.THREAD_ID));
        this.sendResponse(response);
    }

    protected evaluateRequest(response: DebugProtocol.EvaluateResponse, args: DebugProtocol.EvaluateArguments): void {
        // Implementação básica de avaliação
        if (args.context === 'watch') {
            // Adicionar ao watch
            if (this._compilerProcess && this._compilerProcess.stdin) {
                this._compilerProcess.stdin.write(`watch ${args.expression}\n`);
            }
        }
        
        response.body = {
            result: `Avaliando: ${args.expression}`,
            variablesReference: 0
        };
        this.sendResponse(response);
    }

    protected terminateRequest(response: DebugProtocol.TerminateResponse, args: DebugProtocol.TerminateArguments): void {
        if (this._compilerProcess) {
            this._compilerProcess.kill();
        }
        this.sendResponse(response);
    }

    protected disconnectRequest(response: DebugProtocol.DisconnectResponse, args: DebugProtocol.DisconnectArguments): void {
        if (this._compilerProcess) {
            this._compilerProcess.kill();
        }
        this.sendResponse(response);
    }
}
