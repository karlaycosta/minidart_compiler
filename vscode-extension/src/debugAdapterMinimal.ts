import {
    DebugSession,
    InitializedEvent,
    TerminatedEvent,
    StoppedEvent,
    OutputEvent,
    Thread,
    StackFrame,
    Source
} from '@vscode/debugadapter';
import { DebugProtocol } from '@vscode/debugprotocol';

interface MiniDartLaunchRequestArguments extends DebugProtocol.LaunchRequestArguments {
    program: string;
    args?: string[];
    cwd?: string;
    compilerPath?: string;
    stopOnEntry?: boolean;
}

/**
 * Debug Adapter MÍNIMO para MiniDart - Apenas para testar se funciona
 */
export class MiniDartDebugSessionMinimal extends DebugSession {
    private static THREAD_ID = 1;

    public constructor() {
        super();
        console.log('🟢 MiniDartDebugSessionMinimal construído');
        this.setDebuggerLinesStartAt1(true);
        this.setDebuggerColumnsStartAt1(false);
    }

    protected initializeRequest(response: DebugProtocol.InitializeResponse): void {
        console.log('🟢 Initialize request received');
        
        response.body = response.body || {};
        response.body.supportsConfigurationDoneRequest = true;
        response.body.supportTerminateDebuggee = true;
        
        this.sendResponse(response);
        this.sendEvent(new InitializedEvent());
        console.log('🟢 Initialize response sent');
    }

    protected configurationDoneRequest(response: DebugProtocol.ConfigurationDoneResponse): void {
        console.log('🟢 Configuration done request');
        super.configurationDoneRequest(response, arguments);
    }

    protected async launchRequest(response: DebugProtocol.LaunchResponse, args: MiniDartLaunchRequestArguments) {
        console.log('🟢 Launch request para:', args.program);
        
        try {
            // Simulação simples - só envia mensagens
            this.sendEvent(new OutputEvent('🎉 Debug iniciado com sucesso!\n', 'stdout'));
            this.sendEvent(new OutputEvent(`📄 Arquivo: ${args.program}\n`, 'stdout'));
            this.sendEvent(new OutputEvent('🔴 Breakpoints funcionando!\n', 'stdout'));
            
            this.sendResponse(response);
            console.log('🟢 Launch response sent');
            
            if (args.stopOnEntry) {
                console.log('🟢 Stopping on entry');
                this.sendEvent(new StoppedEvent('entry', MiniDartDebugSessionMinimal.THREAD_ID));
            }
            
        } catch (error) {
            console.log('🔴 Erro no launch:', error);
            this.sendErrorResponse(response, 1001, `Erro mínimo: ${error}`);
        }
    }

    protected setBreakPointsRequest(response: DebugProtocol.SetBreakpointsResponse, args: DebugProtocol.SetBreakpointsArguments): void {
        console.log('🟢 Breakpoints request:', args.lines);
        
        const lines = args.lines || [];
        const breakpoints = lines.map(line => ({
            verified: true,
            line: line,
            id: line
        }));
        
        response.body = { breakpoints: breakpoints };
        this.sendResponse(response);
        console.log('🟢 Breakpoints response sent:', breakpoints.length);
    }

    protected threadsRequest(response: DebugProtocol.ThreadsResponse): void {
        console.log('🟢 Threads request');
        response.body = {
            threads: [new Thread(MiniDartDebugSessionMinimal.THREAD_ID, "main")]
        };
        this.sendResponse(response);
    }

    protected stackTraceRequest(response: DebugProtocol.StackTraceResponse): void {
        console.log('🟢 Stack trace request');
        const frame = new StackFrame(
            0,
            'main',
            new Source('main', 'teste_breakpoints.mdart'),
            1,
            0
        );

        response.body = {
            stackFrames: [frame],
            totalFrames: 1
        };
        this.sendResponse(response);
    }

    protected continueRequest(response: DebugProtocol.ContinueResponse): void {
        console.log('🟢 Continue request');
        this.sendResponse(response);
        this.sendEvent(new TerminatedEvent());
    }

    protected nextRequest(response: DebugProtocol.NextResponse): void {
        console.log('🟢 Next request');
        this.sendResponse(response);
        this.sendEvent(new TerminatedEvent());
    }

    protected stepInRequest(response: DebugProtocol.StepInResponse): void {
        console.log('🟢 Step in request');
        this.sendResponse(response);
        this.sendEvent(new TerminatedEvent());
    }

    protected stepOutRequest(response: DebugProtocol.StepOutResponse): void {
        console.log('🟢 Step out request');
        this.sendResponse(response);
        this.sendEvent(new TerminatedEvent());
    }

    protected disconnectRequest(response: DebugProtocol.DisconnectResponse): void {
        console.log('🟢 Disconnect request');
        this.sendResponse(response);
    }
}
