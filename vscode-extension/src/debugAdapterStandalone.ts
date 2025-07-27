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
 * Debug Adapter Standalone - Funciona completamente dentro do VS Code
 * Não depende de processos externos, simula execução passo a passo
 */
export class MiniDartDebugStandalone extends DebugSession {
    private static THREAD_ID = 1;
    private static SCOPE_ID = 1;
    
    private _breakpoints = new Map<string, Set<number>>();
    private _breakpointId = 1;
    private _currentLine = 1;
    private _isRunning = false;
    private _isPaused = false;
    private _sourceLines: string[] = [];
    private _variables = new Map<string, any>();
    private _executionStep = 0;
    private _maxSteps = 0;
    private _currentSourcePath: string = '';

    public constructor() {
        super();
        this.setDebuggerLinesStartAt1(true);
        this.setDebuggerColumnsStartAt1(true);
    }

    protected initializeRequest(response: DebugProtocol.InitializeResponse): void {
        response.body = response.body || {};
        response.body.supportsConfigurationDoneRequest = true;
        response.body.supportTerminateDebuggee = true;
        response.body.supportsEvaluateForHovers = true;
        response.body.supportsStepBack = false;
        response.body.supportsRestartFrame = false;
        
        this.sendResponse(response);
        this.sendEvent(new InitializedEvent());
    }

    protected configurationDoneRequest(response: DebugProtocol.ConfigurationDoneResponse): void {
        super.configurationDoneRequest(response, arguments);
    }

    protected async launchRequest(response: DebugProtocol.LaunchResponse, args: MiniDartLaunchRequestArguments) {
        try {
            if (!fs.existsSync(args.program)) {
                throw new Error(`Arquivo não encontrado: ${args.program}`);
            }
            
            // Armazenar o caminho do arquivo
            this._currentSourcePath = args.program;
            
            // Ler código fonte
            const source = fs.readFileSync(args.program, 'utf-8');
            this._sourceLines = source.split('\n');
            this._maxSteps = this._sourceLines.length;
            
            this._isRunning = true;
            this._isPaused = false;
            this._currentLine = 1;
            this._executionStep = 0;
            
            // Simular análise inicial do código
            this._analyzeCode();
            
            this.sendResponse(response);
            
            this.sendEvent(new OutputEvent('🎯 MiniDart Debug Standalone iniciado!\n', 'console'));
            this.sendEvent(new OutputEvent(`📄 Arquivo: ${path.basename(args.program)}\n`, 'console'));
            this.sendEvent(new OutputEvent(`📊 ${this._sourceLines.length} linhas de código detectadas\n`, 'console'));
            this.sendEvent(new OutputEvent('🔴 Breakpoints visuais funcionando!\n', 'console'));
            this.sendEvent(new OutputEvent('💡 Use F5 (Continue), F10 (Step Over), F11 (Step Into)\n', 'console'));
            
            if (args.stopOnEntry) {
                this._isPaused = true;
                this.sendEvent(new StoppedEvent('entry', MiniDartDebugStandalone.THREAD_ID));
            } else {
                // Se não para na entrada, inicia execução automática
                setTimeout(() => {
                    this._simulateExecution();
                }, 100);
            }
            
        } catch (error) {
            this.sendErrorResponse(response, 2001, `Erro: ${error}`);
        }
    }

    private _analyzeCode(): void {
        // Não pré-analisar variáveis - apenas detectar estrutura
        this._variables.clear();
        
        // Adicionar variáveis básicas de contexto
        this._variables.set('_programa_carregado', true);
        this._variables.set('_total_linhas', this._sourceLines.length);
    }

    protected setBreakPointsRequest(response: DebugProtocol.SetBreakpointsResponse, args: DebugProtocol.SetBreakpointsArguments): void {
        const lines = args.lines || [];
        const sourcePath = args.source?.path || this._currentSourcePath || 'main';
        
        // Debug temporário
        console.log('🔍 DEBUG: SetBreakpoints chamado');
        console.log('🔍 DEBUG: Linhas:', lines);
        console.log('🔍 DEBUG: Source path:', sourcePath);
        console.log('🔍 DEBUG: Current source path:', this._currentSourcePath);
        
        // Armazenar breakpoints - usar tanto o path quanto um identificador genérico
        this._breakpoints.clear(); // Limpar breakpoints anteriores
        this._breakpoints.set(sourcePath, new Set(lines));
        this._breakpoints.set('main', new Set(lines)); // Fallback
        
        console.log('🔍 DEBUG: Breakpoints armazenados:', Array.from(this._breakpoints.entries()));
        
        // Criar responses de breakpoints
        const breakpoints: DebugProtocol.Breakpoint[] = lines.map(line => ({
            id: this._breakpointId++,
            verified: true,
            line: line,
            column: 0,
            source: args.source
        }));
        
        response.body = { breakpoints };
        this.sendResponse(response);
        
        this.sendEvent(new OutputEvent(`🛑 ${lines.length} breakpoint(s) configurado(s)!\n`, 'console'));
        
        // Mostrar quais linhas têm breakpoints
        for (const line of lines) {
            if (line <= this._sourceLines.length) {
                const code = this._sourceLines[line - 1].trim();
                this.sendEvent(new OutputEvent(`   Linha ${line}: ${code}\n`, 'console'));
            }
        }
    }

    protected threadsRequest(response: DebugProtocol.ThreadsResponse): void {
        response.body = {
            threads: [new Thread(MiniDartDebugStandalone.THREAD_ID, "main")]
        };
        this.sendResponse(response);
    }

    protected stackTraceRequest(response: DebugProtocol.StackTraceResponse): void {
        // Usar o caminho do arquivo atual em vez de um nome genérico
        const sourcePath = this._currentSourcePath || 'debug_simples.mdart';
        const sourceName = path.basename(sourcePath);
        
        // Certificar-se de que o Source aponta para um arquivo, não diretório
        const source = new Source(sourceName, sourcePath);
        
        const frame = new StackFrame(
            0,
            'main',
            source,
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
        const scopes = [
            new Scope("Variáveis", MiniDartDebugStandalone.SCOPE_ID, false)
        ];
        
        response.body = { scopes };
        this.sendResponse(response);
    }

    protected variablesRequest(response: DebugProtocol.VariablesResponse): void {
        const variables: Variable[] = [];
        
        this._variables.forEach((value, name) => {
            variables.push(new Variable(name, String(value), 0));
        });
        
        // Adicionar informações de contexto
        variables.push(new Variable('_linha_atual', String(this._currentLine), 0));
        variables.push(new Variable('_passo_execucao', String(this._executionStep), 0));
        
        response.body = { variables };
        this.sendResponse(response);
    }

    protected continueRequest(response: DebugProtocol.ContinueResponse): void {
        this._isPaused = false;
        
        response.body = { allThreadsContinued: true };
        this.sendResponse(response);
        
        this.sendEvent(new OutputEvent('▶️ Continuando execução...\n', 'console'));
        
        // Pequeno delay para garantir que o estado seja atualizado
        setTimeout(() => {
            this._simulateExecution();
        }, 50);
    }

    protected nextRequest(response: DebugProtocol.NextResponse): void {
        if (this._currentLine <= this._sourceLines.length) {
            this._simulateStep();
            this._currentLine++;
        }
        
        this.sendResponse(response);
        this.sendEvent(new OutputEvent(`⏭️ Step Over - Linha ${this._currentLine}\n`, 'console'));
        
        if (this._currentLine > this._sourceLines.length) {
            this.sendEvent(new OutputEvent('✅ Fim do programa\n', 'console'));
            this.sendEvent(new TerminatedEvent());
        } else {
            this.sendEvent(new StoppedEvent('step', MiniDartDebugStandalone.THREAD_ID));
        }
    }

    protected stepInRequest(response: DebugProtocol.StepInResponse): void {
        if (this._currentLine <= this._sourceLines.length) {
            this._simulateStep();
            this._currentLine++;
        }
        
        this.sendResponse(response);
        this.sendEvent(new OutputEvent(`⬇️ Step Into - Linha ${this._currentLine}\n`, 'console'));
        
        if (this._currentLine > this._sourceLines.length) {
            this.sendEvent(new OutputEvent('✅ Fim do programa\n', 'console'));
            this.sendEvent(new TerminatedEvent());
        } else {
            this.sendEvent(new StoppedEvent('step', MiniDartDebugStandalone.THREAD_ID));
        }
    }

    protected stepOutRequest(response: DebugProtocol.StepOutResponse): void {
        if (this._currentLine <= this._sourceLines.length) {
            this._simulateStep();
            this._currentLine++;
        }
        
        this.sendResponse(response);
        this.sendEvent(new OutputEvent(`⬆️ Step Out - Linha ${this._currentLine}\n`, 'console'));
        
        if (this._currentLine > this._sourceLines.length) {
            this.sendEvent(new OutputEvent('✅ Fim do programa\n', 'console'));
            this.sendEvent(new TerminatedEvent());
        } else {
            this.sendEvent(new StoppedEvent('step', MiniDartDebugStandalone.THREAD_ID));
        }
    }

    protected pauseRequest(response: DebugProtocol.PauseResponse): void {
        this._isPaused = true;
        this.sendResponse(response);
        this.sendEvent(new StoppedEvent('pause', MiniDartDebugStandalone.THREAD_ID));
    }

    protected disconnectRequest(response: DebugProtocol.DisconnectResponse): void {
        this._isRunning = false;
        this.sendResponse(response);
        this.sendEvent(new OutputEvent('👋 Sessão debug encerrada\n', 'console'));
    }

    protected evaluateRequest(response: DebugProtocol.EvaluateResponse): void {
        response.body = {
            result: 'Avaliação não implementada',
            variablesReference: 0
        };
        this.sendResponse(response);
    }

    private _simulateStep(): void {
        if (this._currentLine <= this._sourceLines.length) {
            const currentCode = this._sourceLines[this._currentLine - 1];
            
            // Simular atualização de variáveis apenas quando linha é executada
            this._updateVariablesForLine(currentCode);
            
            this.sendEvent(new OutputEvent(`📍 Executando linha ${this._currentLine}: ${currentCode.trim()}\n`, 'console'));
        }
        
        // Incrementar contador de execução
        this._executionStep++;
    }

    private _simulateExecution(): void {
        if (!this._isRunning || this._isPaused) {
            return;
        }
        
        // Executar linha por linha com pequenos delays
        const executeNextLine = () => {
            if (!this._isRunning || this._isPaused || this._currentLine > this._sourceLines.length) {
                if (this._currentLine > this._sourceLines.length) {
                    this.sendEvent(new OutputEvent('✅ Fim do programa\n', 'console'));
                    this.sendEvent(new TerminatedEvent());
                }
                return;
            }
            
            // Debug temporário
            console.log(`🔍 DEBUG: Verificando linha ${this._currentLine}`);
            console.log(`🔍 DEBUG: Breakpoints disponíveis:`, Array.from(this._breakpoints.entries()));
            
            // Verificar se há breakpoint na linha atual - múltiplas estratégias
            let hasBreakpoint = false;
            
            // Estratégia 1: Verificar todos os conjuntos de breakpoints
            for (const [path, breakpoints] of this._breakpoints.entries()) {
                if (breakpoints.has(this._currentLine)) {
                    hasBreakpoint = true;
                    console.log(`🔍 DEBUG: Breakpoint encontrado no path ${path}, linha ${this._currentLine}`);
                    break;
                }
            }
            
            console.log(`🔍 DEBUG: Linha ${this._currentLine} tem breakpoint? ${hasBreakpoint}`);
                
            if (hasBreakpoint) {
                this._isPaused = true;
                this.sendEvent(new OutputEvent(`🛑 BREAKPOINT atingido na linha ${this._currentLine}\n`, 'console'));
                
                // Mostrar código da linha atual
                if (this._currentLine <= this._sourceLines.length) {
                    const currentCode = this._sourceLines[this._currentLine - 1];
                    this.sendEvent(new OutputEvent(`📍 Código: ${currentCode.trim()}\n`, 'console'));
                }
                
                this.sendEvent(new StoppedEvent('breakpoint', MiniDartDebugStandalone.THREAD_ID));
                return;
            }
            
            // Executar linha atual
            this._simulateStep();
            
            // Avançar para próxima linha
            this._currentLine++;
            
            // Continuar execução com pequeno delay
            setTimeout(executeNextLine, 10);
        };
        
        executeNextLine();
    }

    private _updateVariablesForLine(code: string): void {
        const line = code.trim();
        
        // Detectar declarações de variáveis simples: var nome = valor
        const varMatch = line.match(/var\s+(\w+)\s*=\s*(.+);?$/);
        if (varMatch) {
            const varName = varMatch[1];
            const varExpr = varMatch[2].trim();
            
            // Avaliar expressões simples
            if (/^\d+$/.test(varExpr)) {
                // Número inteiro
                this._variables.set(varName, parseInt(varExpr));
            } else if (/^\d+\.\d+$/.test(varExpr)) {
                // Número decimal
                this._variables.set(varName, parseFloat(varExpr));
            } else if (/^".*"$/.test(varExpr)) {
                // String literal
                this._variables.set(varName, varExpr.slice(1, -1));
            } else if (varExpr.includes('+')) {
                // Expressão de soma
                const parts = varExpr.split('+').map(p => p.trim());
                if (parts.length === 2) {
                    const val1 = this._getVariableValue(parts[0]);
                    const val2 = this._getVariableValue(parts[1]);
                    
                    if (typeof val1 === 'number' && typeof val2 === 'number') {
                        this._variables.set(varName, val1 + val2);
                    } else {
                        this._variables.set(varName, `${val1} + ${val2}`);
                    }
                }
            } else if (this._variables.has(varExpr)) {
                // Atribuição de variável existente
                this._variables.set(varName, this._variables.get(varExpr));
            } else {
                // Expressão não avaliada
                this._variables.set(varName, `<${varExpr}>`);
            }
        }
        
        // Detectar declarações com tipo: inteiro nome = valor
        const typedVarMatch = line.match(/(\w+)\s+(\w+)\s*=\s*(.+);?$/);
        if (typedVarMatch && !varMatch) { // Só se não foi detectado como 'var'
            const varType = typedVarMatch[1];
            const varName = typedVarMatch[2];
            const varExpr = typedVarMatch[3].trim();
            
            if (varType === 'inteiro' && /^\d+$/.test(varExpr)) {
                this._variables.set(varName, parseInt(varExpr));
            } else if (varType === 'decimal' && /^\d+(\.\d+)?$/.test(varExpr)) {
                this._variables.set(varName, parseFloat(varExpr));
            } else if (varType === 'texto' && /^".*"$/.test(varExpr)) {
                this._variables.set(varName, varExpr.slice(1, -1));
            } else {
                this._variables.set(varName, `<${varType}: ${varExpr}>`);
            }
        }
    }
    
    private _getVariableValue(expr: string): any {
        // Remover espaços
        expr = expr.trim();
        
        // Se é número literal
        if (/^\d+$/.test(expr)) {
            return parseInt(expr);
        }
        
        // Se é decimal literal
        if (/^\d+\.\d+$/.test(expr)) {
            return parseFloat(expr);
        }
        
        // Se é string literal
        if (/^".*"$/.test(expr)) {
            return expr.slice(1, -1);
        }
        
        // Se é variável existente
        if (this._variables.has(expr)) {
            return this._variables.get(expr);
        }
        
        // Valor padrão
        return expr;
    }
}
