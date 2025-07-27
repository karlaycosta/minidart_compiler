import {
    DebugSession,
    InitializedEvent,
    TerminatedEvent,
    StoppedEvent,
    OutputEvent,
    Thread,
    StackFrame,
    Scope,
    Variable,
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

/**
 * Debug Adapter Simplificado para MiniDart
 */
export class MiniDartDebugSessionSimple extends DebugSession {
    private static THREAD_ID = 1;
    private _compilerProcess?: ChildProcess;
    private _currentLine = 1;
    private _variables: any[] = [];
    private _breakpoints = new Map<number, DebugProtocol.Breakpoint>();
    private _breakpointId = 1;

    public constructor() {
        super();
        // Configurações básicas
        this.setDebuggerLinesStartAt1(true);
        this.setDebuggerColumnsStartAt1(false);
    }

    protected initializeRequest(response: DebugProtocol.InitializeResponse): void {
        console.log('Initialize request received');
        
        // Configurações básicas do debugger
        response.body = response.body || {};
        response.body.supportsConfigurationDoneRequest = true;
        response.body.supportTerminateDebuggee = true;
        response.body.supportsEvaluateForHovers = false;
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
        response.body.supportsValueFormattingOptions = false;
        response.body.supportsExceptionInfoRequest = false;
        response.body.supportSuspendDebuggee = false;
        response.body.supportsDelayedStackTraceLoading = false;
        response.body.supportsLoadedSourcesRequest = false;
        response.body.supportsLogPoints = false;
        response.body.supportsTerminateThreadsRequest = false;
        response.body.supportsSetVariable = false;
        response.body.supportsRestartFrame = false;
        response.body.supportsSetExpression = false;
        
        this.sendResponse(response);
        this.sendEvent(new InitializedEvent());
        console.log('Initialize response sent');
    }

    protected configurationDoneRequest(response: DebugProtocol.ConfigurationDoneResponse): void {
        super.configurationDoneRequest(response, arguments);
    }

    protected async launchRequest(response: DebugProtocol.LaunchResponse, args: MiniDartLaunchRequestArguments) {
        console.log('🚀 Iniciando debug session para:', args.program);
        
        try {
            // Validar se o arquivo existe
            if (!fs.existsSync(args.program)) {
                throw new Error(`Arquivo não encontrado: ${args.program}`);
            }
            
            const compilerPath = args.compilerPath || 'bin/compile.dart';
            const cwd = args.cwd || path.dirname(args.program);
            
            console.log(`🔧 Compilador: ${compilerPath}`);
            console.log(`📁 Diretório: ${cwd}`);
            console.log(`📄 Programa: ${args.program}`);
            
            // Verificar se o compilador existe
            const fullCompilerPath = path.join(cwd, compilerPath);
            if (!fs.existsSync(fullCompilerPath)) {
                throw new Error(`Compilador não encontrado: ${fullCompilerPath}`);
            }
            
            // Comando para executar o compilador em modo debug interativo
            const dartArgs = ['run', compilerPath, args.program, '--debug-interactive'];
            console.log(`💻 Comando: dart ${dartArgs.join(' ')}`);
            
            this._compilerProcess = spawn('dart', dartArgs, {
                cwd: cwd,
                stdio: ['pipe', 'pipe', 'pipe']
            });

            this._compilerProcess.stdout?.on('data', (data) => {
                const output = data.toString();
                console.log('📤 STDOUT:', output);
                this.sendEvent(new OutputEvent(output, 'stdout'));
            });

            this._compilerProcess.stderr?.on('data', (data) => {
                const output = data.toString();
                console.log('❌ STDERR:', output);
                this.sendEvent(new OutputEvent(output, 'stderr'));
            });

            this._compilerProcess.on('error', (error) => {
                console.log('🚨 Erro no processo:', error);
                this.sendEvent(new OutputEvent(`Erro: ${error.message}\n`, 'stderr'));
                this.sendEvent(new TerminatedEvent());
            });

            this._compilerProcess.on('close', (code) => {
                console.log(`🏁 Processo finalizado com código: ${code}`);
                this.sendEvent(new TerminatedEvent());
            });

            console.log('✅ Processo iniciado com sucesso');
            this.sendResponse(response);
            
            if (args.stopOnEntry) {
                console.log('⏸️ Parando na entrada...');
                this.sendEvent(new StoppedEvent('entry', MiniDartDebugSessionSimple.THREAD_ID));
            }
        } catch (error) {
            console.log('💥 Erro detalhado:', error);
            this.sendErrorResponse(response, 1001, `Erro ao iniciar debug: ${error}`);
        }
    }

    protected setBreakPointsRequest(response: DebugProtocol.SetBreakpointsResponse, args: DebugProtocol.SetBreakpointsArguments): void {
        console.log('🔴 BREAKPOINT REQUEST RECEBIDO!');
        console.log('📍 Args completos:', JSON.stringify(args, null, 2));
        
        const lines = args.lines || [];
        const sourcePath = args.source.path;
        
        console.log(`📁 Arquivo: ${sourcePath}`);
        console.log(`📊 Linhas solicitadas: [${lines.join(', ')}]`);
        
        // Limpa breakpoints anteriores
        this._breakpoints.clear();
        
        // Envia comandos de breakpoint para o debugger se disponível
        if (this._compilerProcess && this._compilerProcess.stdin) {
            console.log('📤 Enviando comandos de breakpoint para o debugger...');
            for (const line of lines) {
                this._compilerProcess.stdin.write(`break ${line}\n`);
                console.log(`✅ Comando enviado: break ${line}`);
            }
        } else {
            console.log('⚠️ Processo do compilador não disponível para breakpoints');
        }
        
        // Cria response com breakpoints SEMPRE verificados
        const breakpoints = lines.map((line, index) => {
            const bp: DebugProtocol.Breakpoint = {
                id: this._breakpointId++,
                verified: true,
                line: line,
                column: 0,
                source: args.source
            };
            
            // Armazena o breakpoint
            this._breakpoints.set(line, bp);
            
            console.log(`🎯 Breakpoint ${index + 1}: linha ${line}, id ${bp.id} - VERIFICADO`);
            return bp;
        });
        
        response.body = {
            breakpoints: breakpoints
        };
        
        console.log(`🎉 TOTAL configurado: ${breakpoints.length} breakpoints`);
        console.log('📋 Response body:', JSON.stringify(response.body, null, 2));
        
        this.sendResponse(response);
        
        // Log do estado final
        console.log('🔍 Estado atual dos breakpoints armazenados:');
        this._breakpoints.forEach((bp, line) => {
            console.log(`  - Linha ${line}: ${bp.verified ? '✅ ATIVO' : '❌ INATIVO'} (id: ${bp.id})`);
        });
    }

    protected threadsRequest(response: DebugProtocol.ThreadsResponse): void {
        response.body = {
            threads: [new Thread(MiniDartDebugSessionSimple.THREAD_ID, "main")]
        };
        this.sendResponse(response);
    }

    protected stackTraceRequest(response: DebugProtocol.StackTraceResponse): void {
        const frame = new StackFrame(
            0,
            'main',
            new Source('main', this._compilerProcess ? 'main.mdart' : undefined),
            this._currentLine,
            0
        );

        response.body = {
            stackFrames: [frame],
            totalFrames: 1
        };
        this.sendResponse(response);
    }

    protected scopesRequest(response: DebugProtocol.ScopesResponse): void {
        response.body = {
            scopes: [
                new Scope("Variáveis", 1000, false)
            ]
        };
        this.sendResponse(response);
    }

    protected variablesRequest(response: DebugProtocol.VariablesResponse): void {
        const variables: Variable[] = this._variables.map(v => 
            new Variable(v.name, v.value, 0)
        );

        response.body = {
            variables: variables
        };
        this.sendResponse(response);
    }

    protected continueRequest(response: DebugProtocol.ContinueResponse): void {
        if (this._compilerProcess && this._compilerProcess.stdin) {
            this._compilerProcess.stdin.write('continue\n');
        }
        
        response.body = { allThreadsContinued: true };
        this.sendResponse(response);
    }

    protected nextRequest(response: DebugProtocol.NextResponse): void {
        if (this._compilerProcess && this._compilerProcess.stdin) {
            this._compilerProcess.stdin.write('next\n');
        }
        this.sendResponse(response);
    }

    protected stepInRequest(response: DebugProtocol.StepInResponse): void {
        if (this._compilerProcess && this._compilerProcess.stdin) {
            this._compilerProcess.stdin.write('step\n');
        }
        this.sendResponse(response);
    }

    protected terminateRequest(response: DebugProtocol.TerminateResponse): void {
        if (this._compilerProcess) {
            this._compilerProcess.kill();
        }
        this.sendResponse(response);
    }

    protected disconnectRequest(response: DebugProtocol.DisconnectResponse): void {
        if (this._compilerProcess) {
            this._compilerProcess.kill();
        }
        this.sendResponse(response);
    }
}
