// Compiles a dart2wasm-generated main module from `source` which can then
// instantiatable via the `instantiate` method.
//
// `source` needs to be a `Response` object (or promise thereof) e.g. created
// via the `fetch()` JS API.
export async function compileStreaming(source) {
  const builtins = {builtins: ['js-string']};
  return new CompiledApp(
      await WebAssembly.compileStreaming(source, builtins), builtins);
}

// Compiles a dart2wasm-generated wasm modules from `bytes` which is then
// instantiatable via the `instantiate` method.
export async function compile(bytes) {
  const builtins = {builtins: ['js-string']};
  return new CompiledApp(await WebAssembly.compile(bytes, builtins), builtins);
}

// DEPRECATED: Please use `compile` or `compileStreaming` to get a compiled app,
// use `instantiate` method to get an instantiated app and then call
// `invokeMain` to invoke the main function.
export async function instantiate(modulePromise, importObjectPromise) {
  var moduleOrCompiledApp = await modulePromise;
  if (!(moduleOrCompiledApp instanceof CompiledApp)) {
    moduleOrCompiledApp = new CompiledApp(moduleOrCompiledApp);
  }
  const instantiatedApp = await moduleOrCompiledApp.instantiate(await importObjectPromise);
  return instantiatedApp.instantiatedModule;
}

// DEPRECATED: Please use `compile` or `compileStreaming` to get a compiled app,
// use `instantiate` method to get an instantiated app and then call
// `invokeMain` to invoke the main function.
export const invoke = (moduleInstance, ...args) => {
  moduleInstance.exports.$invokeMain(args);
}

class CompiledApp {
  constructor(module, builtins) {
    this.module = module;
    this.builtins = builtins;
  }

  // The second argument is an options object containing:
  // `loadDeferredWasm` is a JS function that takes a module name matching a
  //   wasm file produced by the dart2wasm compiler and returns the bytes to
  //   load the module. These bytes can be in either a format supported by
  //   `WebAssembly.compile` or `WebAssembly.compileStreaming`.
  async instantiate(additionalImports, {loadDeferredWasm, loadDynamicModule} = {}) {
    let dartInstance;

    // Prints to the console
    function printToConsole(value) {
      if (typeof dartPrint == "function") {
        dartPrint(value);
        return;
      }
      if (typeof console == "object" && typeof console.log != "undefined") {
        console.log(value);
        return;
      }
      if (typeof print == "function") {
        print(value);
        return;
      }

      throw "Unable to print message: " + js;
    }

    // A special symbol attached to functions that wrap Dart functions.
    const jsWrappedDartFunctionSymbol = Symbol("JSWrappedDartFunction");

    function finalizeWrapper(dartFunction, wrapped) {
      wrapped.dartFunction = dartFunction;
      wrapped[jsWrappedDartFunctionSymbol] = true;
      return wrapped;
    }

    // Imports
    const dart2wasm = {
            _37: x0 => new Array(x0),
      _39: x0 => x0.length,
      _41: (x0,x1) => x0[x1],
      _42: (x0,x1,x2) => x0[x1] = x2,
      _45: (x0,x1,x2) => new DataView(x0,x1,x2),
      _47: x0 => new Int8Array(x0),
      _48: (x0,x1,x2) => new Uint8Array(x0,x1,x2),
      _49: x0 => new Uint8Array(x0),
      _51: x0 => new Uint8ClampedArray(x0),
      _53: x0 => new Int16Array(x0),
      _55: x0 => new Uint16Array(x0),
      _57: x0 => new Int32Array(x0),
      _59: x0 => new Uint32Array(x0),
      _61: x0 => new Float32Array(x0),
      _63: x0 => new Float64Array(x0),
      _78: () => {
        let stackString = new Error().stack.toString();
        let frames = stackString.split('\n');
        let drop = 2;
        if (frames[0] === 'Error') {
            drop += 1;
        }
        return frames.slice(drop).join('\n');
      },
      _99: s => JSON.stringify(s),
      _100: s => printToConsole(s),
      _105: s => s.trim(),
      _108: (string, times) => string.repeat(times),
      _109: Function.prototype.call.bind(String.prototype.indexOf),
      _111: (string, token) => string.split(token),
      _123: a => a.length,
      _125: (a, i) => a[i],
      _129: (o, start, length) => new Uint8Array(o.buffer, o.byteOffset + start, length),
      _130: (o, start, length) => new Int8Array(o.buffer, o.byteOffset + start, length),
      _131: (o, start, length) => new Uint8ClampedArray(o.buffer, o.byteOffset + start, length),
      _132: (o, start, length) => new Uint16Array(o.buffer, o.byteOffset + start, length),
      _133: (o, start, length) => new Int16Array(o.buffer, o.byteOffset + start, length),
      _134: (o, start, length) => new Uint32Array(o.buffer, o.byteOffset + start, length),
      _135: (o, start, length) => new Int32Array(o.buffer, o.byteOffset + start, length),
      _138: (o, start, length) => new Float32Array(o.buffer, o.byteOffset + start, length),
      _139: (o, start, length) => new Float64Array(o.buffer, o.byteOffset + start, length),
      _140: (t, s) => t.set(s),
      _142: (o) => new DataView(o.buffer, o.byteOffset, o.byteLength),
      _144: o => o.buffer,
      _145: o => o.byteOffset,
      _146: Function.prototype.call.bind(Object.getOwnPropertyDescriptor(DataView.prototype, 'byteLength').get),
      _147: (b, o) => new DataView(b, o),
      _148: (b, o, l) => new DataView(b, o, l),
      _149: Function.prototype.call.bind(DataView.prototype.getUint8),
      _150: Function.prototype.call.bind(DataView.prototype.setUint8),
      _151: Function.prototype.call.bind(DataView.prototype.getInt8),
      _152: Function.prototype.call.bind(DataView.prototype.setInt8),
      _153: Function.prototype.call.bind(DataView.prototype.getUint16),
      _154: Function.prototype.call.bind(DataView.prototype.setUint16),
      _155: Function.prototype.call.bind(DataView.prototype.getInt16),
      _156: Function.prototype.call.bind(DataView.prototype.setInt16),
      _157: Function.prototype.call.bind(DataView.prototype.getUint32),
      _158: Function.prototype.call.bind(DataView.prototype.setUint32),
      _159: Function.prototype.call.bind(DataView.prototype.getInt32),
      _160: Function.prototype.call.bind(DataView.prototype.setInt32),
      _165: Function.prototype.call.bind(DataView.prototype.getFloat32),
      _166: Function.prototype.call.bind(DataView.prototype.setFloat32),
      _167: Function.prototype.call.bind(DataView.prototype.getFloat64),
      _168: Function.prototype.call.bind(DataView.prototype.setFloat64),
      _186: (ms, c) =>
      setTimeout(() => dartInstance.exports.$invokeCallback(c),ms),
      _190: (c) =>
      queueMicrotask(() => dartInstance.exports.$invokeCallback(c)),
      _198: (x0,x1) => x0.createElement(x1),
      _200: (x0,x1) => x0.querySelector(x1),
      _201: f => finalizeWrapper(f, function(x0) { return dartInstance.exports._201(f,arguments.length,x0) }),
      _203: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      _205: x0 => x0.preventDefault(),
      _207: x0 => x0.stopPropagation(),
      _220: (x0,x1) => x0.querySelectorAll(x1),
      _221: (x0,x1) => x0.item(x1),
      _222: (x0,x1) => x0.getAttribute(x1),
      _223: (x0,x1) => x0.querySelector(x1),
      _224: (x0,x1) => x0.contains(x1),
      _225: (x0,x1) => x0.add(x1),
      _226: (x0,x1) => x0.remove(x1),
      _227: (x0,x1) => x0.append(x1),
      _228: x0 => x0.remove(),
      _229: x0 => x0.select(),
      _230: (x0,x1) => x0.execCommand(x1),
      _231: (s, m) => {
        try {
          return new RegExp(s, m);
        } catch (e) {
          return String(e);
        }
      },
      _232: (x0,x1) => x0.exec(x1),
      _236: o => o === undefined,
      _238: o => typeof o === 'function' && o[jsWrappedDartFunctionSymbol] === true,
      _241: o => o instanceof RegExp,
      _242: (l, r) => l === r,
      _243: o => o,
      _244: o => o,
      _245: o => o,
      _246: b => !!b,
      _247: o => o.length,
      _249: (o, i) => o[i],
      _250: f => f.dartFunction,
      _257: (o, p) => o[p],
      _261: o => String(o),
      _263: o => {
        if (o === undefined) return 1;
        var type = typeof o;
        if (type === 'boolean') return 2;
        if (type === 'number') return 3;
        if (type === 'string') return 4;
        if (o instanceof Array) return 5;
        if (ArrayBuffer.isView(o)) {
          if (o instanceof Int8Array) return 6;
          if (o instanceof Uint8Array) return 7;
          if (o instanceof Uint8ClampedArray) return 8;
          if (o instanceof Int16Array) return 9;
          if (o instanceof Uint16Array) return 10;
          if (o instanceof Int32Array) return 11;
          if (o instanceof Uint32Array) return 12;
          if (o instanceof Float32Array) return 13;
          if (o instanceof Float64Array) return 14;
          if (o instanceof DataView) return 15;
        }
        if (o instanceof ArrayBuffer) return 16;
        return 17;
      },
      _278: x0 => new ArrayBuffer(x0),
      _283: x0 => x0.flags,
      _293: x0 => x0.random(),
      _296: () => globalThis.Math,
      _297: Function.prototype.call.bind(Number.prototype.toString),
      _298: Function.prototype.call.bind(BigInt.prototype.toString),
      _299: Function.prototype.call.bind(Number.prototype.toString),
      _416: x0 => x0.style,
      _1499: (x0,x1) => x0.selectedIndex = x1,
      _1502: x0 => x0.value,
      _1559: (x0,x1) => x0.value = x1,
      _1560: x0 => x0.value,
      _1566: (x0,x1) => x0.selectionStart = x1,
      _1567: x0 => x0.selectionStart,
      _1568: (x0,x1) => x0.selectionEnd = x1,
      _1569: x0 => x0.selectionEnd,
      _2059: () => globalThis.window,
      _6798: x0 => x0.target,
      _6848: x0 => x0.length,
      _6925: (x0,x1) => x0.textContent = x1,
      _6926: x0 => x0.textContent,
      _6930: () => globalThis.document,
      _7007: x0 => x0.body,
      _7354: (x0,x1) => x0.className = x1,
      _7356: x0 => x0.classList,
      _7670: x0 => x0.ctrlKey,
      _7677: x0 => x0.keyCode,
      _10057: (x0,x1) => x0.background = x1,
      _10227: (x0,x1) => x0.borderRadius = x1,
      _10267: (x0,x1) => x0.boxShadow = x1,
      _10305: (x0,x1) => x0.color = x1,
      _10461: (x0,x1) => x0.fontSize = x1,
      _10607: (x0,x1) => x0.left = x1,
      _10827: (x0,x1) => x0.padding = x1,
      _10877: (x0,x1) => x0.position = x1,
      _10905: (x0,x1) => x0.right = x1,
      _11167: (x0,x1) => x0.top = x1,
      _11265: (x0,x1) => x0.zIndex = x1,

    };

    const baseImports = {
      dart2wasm: dart2wasm,
      Math: Math,
      Date: Date,
      Object: Object,
      Array: Array,
      Reflect: Reflect,
            s: [
        "Attempt to execute code removed by Dart AOT compiler (TFA)",
"Could not call main",
"null",
"0.0",
"-0.0",
"1.0",
"-1.0",
"NaN",
"-Infinity",
"Infinity",
"e",
".0",
"Infinity or NaN toInt",
"Unsupported operation: ",
"Invalid value",
"",
" (",
")",
": ",
"Instance of '",
"'",
"Object?",
"Object",
"dynamic",
"void",
"Invalid top type kind",
"Type '",
"' is not a subtype of type '",
" in type cast",
"Null",
"Never",
": Not greater than or equal to ",
": Not in inclusive range ",
"..",
": Valid value range is empty",
": Only valid value is ",
"RangeError",
"Invalid argument",
"(s)",
"minified:Class",
"<",
", ",
">",
"?",
"bool",
"BoxedBool",
"JSStringImpl",
"_BottomType",
"_TopType",
"_InterfaceTypeParameterType",
"_FunctionTypeParameterType",
"_FutureOrType",
"_InterfaceType",
"_AbstractFunctionType",
"_FunctionType",
"_AbstractRecordType",
"_RecordType",
"DefaultMap",
"_ConstMap",
"CompactLinkedIdentityHashMap",
"DefaultSet",
"_ConstSet",
"Record_2",
"Record_3",
"Record_4",
"Record_5",
"Record_6",
"Record_7",
"Record_8",
"Record_9",
"GrowableList",
"ModifiableFixedLengthList",
"ImmutableList",
"UnmodifiableMapView",
"StringBuffer",
"_SuspendState",
"_Environment",
"_ModuleRtt",
"_NamedParameter",
"_NamedParameterValue",
"_Closure",
"_StringStackTrace",
"_SyncStarIterator",
"_CompactValuesIterable",
"SubListIterable",
"MappedListIterable",
"WhereIterable",
"_SyncStarIterable",
"StringAllMatchesIterable",
"_Invocation",
"IntegerDivisionByZeroException",
"FormatException",
"_Exception",
"LateError",
"_AssertionErrorImpl",
"ArgumentError",
"IndexError",
"NoSuchMethodError",
"UnsupportedError",
"StateError",
"ConcurrentModificationError",
"_TypeError",
"_JavaScriptError",
"_TypeCheckVerificationError",
"Duration",
"pragma",
"_AsyncSuspendState",
"WasmConstCache",
"_OneShotTimer",
"Pointer",
"_Compound",
"_FfiStructLayout",
"_FfiInlineArray",
"BoxedInt",
"_CompactIterator",
"_CompactIteratorImmutable",
"SentinelValue",
"_RootZone",
"_ZoneFunction",
"StringAllMatchesIterator",
"_EventStream",
"_ElementEventStreamImpl",
"ListIterator",
"ClassID",
"_AsyncCallbackEntry",
"_Future",
"_FutureListener",
"_AsyncCompleter",
"AsyncError",
"BoxedDouble",
"_Random",
"_GrowableListIterator",
"_FixedSizeListIterator",
"_JSFloat32ArrayIterator",
"_JSFloat64ArrayIterator",
"_JSUint8ArrayIterator",
"_JSInt8ArrayIterator",
"_JSUint16ArrayIterator",
"_JSInt16ArrayIterator",
"_JSUint32ArrayIterator",
"_JSInt32ArrayIterator",
"JSDataViewImpl",
"JSUint8ArrayImpl",
"JSInt8ArrayImpl",
"JSUint8ClampedArrayImpl",
"JSUint16ArrayImpl",
"JSInt16ArrayImpl",
"JSUint32ArrayImpl",
"JSInt32ArrayImpl",
"JSFloat32ArrayImpl",
"JSFloat64ArrayImpl",
"JSArrayBufferImpl",
"JSArrayImplIterator",
"JSArrayImpl",
"_MatchImplementation",
"JSSyntaxRegExp",
"JSValue",
"WasmArrayConstCache",
"Symbol",
"StringMatch",
"WhereIterator",
"CompilationResult",
"_EventStreamSubscription",
"EventStreamProvider",
"WebInterface",
"WebCompiler",
"WasmAnyRef",
"WasmEqRef",
"WasmStructRef",
"WasmArrayRef",
"WasmArray",
"ImmutableWasmArray",
"WasmExternRef",
"WasmFuncRef",
"WasmFunction",
"WasmI8",
"WasmI16",
"WasmI32",
"WasmI64",
"WasmF32",
"WasmF64",
"WasmVoid",
"WasmTable",
"num",
"double",
"int",
"_Type",
"_HashFieldBase",
"_HashBase",
"ByteBuffer",
"ByteData",
"Int8List",
"Uint8List",
"Uint8ClampedList",
"Int16List",
"Uint16List",
"Int32List",
"Uint32List",
"Float32List",
"Float64List",
"Function",
"Record",
"String",
"TypedData",
"TypedDataList",
"_TypedIntList",
"_TypedFloatList",
"ListBase",
"WasmListBase",
"_ModifiableList",
"SetBase",
"MapView",
"_UnmodifiableMapMixin",
"MapBase",
"LinkedHashMap",
"LinkedHashSet",
"StringSink",
"Invocation",
"_TypeUniverse",
"Type",
"StackTrace",
"Set",
"_SetIterable",
"RegExpMatch",
"RegExp",
"Match",
"Pattern",
"Exception",
"Map",
"List",
"_ListIterable",
"Iterator",
"Iterable",
"EfficientLengthIterable",
"ListIterable",
"Error",
"AssertionError",
"TypeError",
"_Error",
"Comparable",
"_Timer",
"NativeType",
"SizedNativeType",
"Struct",
"Union",
"_FfiAbiSpecificMapping",
"_UnmodifiableSetMixin",
"Random",
"_EqualsAndHashCode",
"_OperatorEqualsAndHashCode",
"_IdenticalAndIdentityHashCode",
"_MapCreateIndexMixin",
"_ImmutableLinkedHashMapMixin",
"_LinkedHashMapMixin",
"_LinkedHashSetMixin",
"_SetCreateIndexMixin",
"_ImmutableLinkedHashSetMixin",
"SystemHash",
"_Zone",
"HideEfficientLengthIterable",
"Zone",
"ZoneDelegate",
"Timer",
"StreamSubscription",
"Stream",
"_AsyncRun",
"_Completer",
"Completer",
"Future",
"IterableElementError",
"_DoubleListMixin",
"_DoubleArrayIteratorBase",
"_UnmodifiableIntListMixin",
"_IntListMixin",
"FixedLengthListMixin",
"_JSEventLoop",
"StringUncheckedOperationsBase",
"_IntArrayIteratorBase",
"JSArrayBase",
"JSIntegerArrayBase",
"UnmodifiableJSUint8Array",
"JSFloatArrayBase",
"UnmodifiableListMixin",
"IndexErrorUtils",
"RangeErrorUtils",
"Sort",
"ElementStream",
"_WasmBase",
"T",
"true",
"false",
"JavaScriptError",
"[",
"]",
"...",
"[]",
"Type parameter should have been substituted already.",
"Type argument substitution not supported for ",
"X",
" extends ",
"(",
"{",
"}",
" => ",
"Closure: ",
" ",
"FutureOr",
"required ",
"Null check operator used on a null value",
"Index out of range",
": index must not be negative",
": no indices are valid",
": index should be less than ",
"Concurrent modification during iteration: ",
".",
"🚀 MiniDart Compiler Web v1.4.1 iniciado com sucesso!",
"\n",
"linha",
"linhas",
"caractere",
"caracteres",
"charCount",
"Field '",
"' has not been initialized.",
"LateInitializationError: ",
"Unhandled dartifyRaw type case: ",
"max",
"Must be positive and <= 2^32",
"Division resulted in non-finite value",
"{...}",
"Function?",
"buffer",
"start",
"Too few elements",
"Bad state: ",
"value",
"[]=",
"type '",
"' is not a subtype of ",
"' of '",
"index",
"(...)",
"lineCount",
"codeEditor",
"#btn-compile",
"#btn-ast",
"#btn-bytecode",
"#btn-clear",
"#btn-copy-output",
"#btn-copy-ast",
"#btn-copy-bytecode",
"#btn-copy-errors",
"#link-about",
".modal-close",
"hidden",
"output",
"ast",
"bytecode",
"errors",
"active",
"Digite algum código para executar!",
"The error handler of Future.then must return a value of the returned future's type",
"onError",
"The error handler of Future.catchError must return a value of the future's type",
"sourceResult",
"Error handler must accept one Object or one Object and a StackTrace as arguments, and return a value of the returned future's type",
"Cannot complete a future with itself",
"-",
"0",
":",
"The implementation cannot handle very large operands (was: ",
").",
"Exception: ",
"loadingOverlay",
"message ",
"error",
"success",
"#ef4444",
"#10b981",
"0 4px 12px rgba(0,0,0,0.15)",
"14px",
"9999",
"white",
"8px",
"12px 20px",
"20px",
"fixed",
"div",
"Programa executado com sucesso (sem saída).",
"Nenhuma saída gerada.",
"error-tab",
"Nenhum erro encontrado.",
"errorsContent",
"bytecodeContent",
"astContent",
"outputContent",
"Código fonte vazio",
"imprimir",
"imprimir\\s+\"([^\"]*)\"",
"imprimir\\s+(\\w+)",
" = [valor da variável]",
"[saída da impressão]",
"var",
"funcao",
"erro",
"Erro detectado na linha: ",
"=== Bytecode Gerado ===\n",
"CONST",
"\n=== Constantes ===",
"[0] \"Hello\"",
"[1] 42",
"[2] verdadeiro",
"[3] \"Mundo\"",
"PUSH_CONST 0",
"PUSH_CONST 1",
"ADD",
"PRINT",
"POP",
"LOAD_GLOBAL nome",
"STORE_GLOBAL valor",
"JUMP_IF_FALSE 10",
"JUMP 5",
"CALL 2",
"RETURN",
"=== Árvore Sintática Abstrata (AST) ===\n",
". VarDeclStmt:",
"    name: ",
"    initializer: LiteralExpr([valor])",
". PrintStmt:",
"    expression: ",
". FunctionStmt:",
"    params: [",
"se",
". IfStmt:",
"    condition: BinaryExpr([condição])",
"    thenBranch: BlockStmt([corpo])",
"enquanto",
". WhileStmt:",
"    body: BlockStmt([corpo])",
"para",
". ForStmt:",
"    initializer: VarDeclStmt([init])",
"    update: AssignExpr([update])",
". ExpressionStmt:",
"    expression: [expressão]",
"\\(([^)]*)\\)",
"funcao\\s+(\\w+)",
"\"",
"LiteralExpr(string)",
"VariableExpr(nome)",
"var\\s+(\\w+)",
"variavel",
"Expected integer value, but was not integer.",
"m",
"i",
"u",
"s",
"g",
"Illegal RegExp pattern (",
" (at line ",
", character ",
")\n",
" (at character ",
"^\n",
"RegExp/",
"/",
"🔴 Fechando modal...",
"🔴 Modal classList após fechar: ",
"keydown",
"modalAbout",
"  ",
"input",
"change",
"examples",
"Too few arguments passed. Expected 1 or more, got ",
" instead.",
"call",
"NoSuchMethodError: method not found: '",
"'\n",
"Receiver: ",
"Arguments: [",
"key",
"Symbol(\"",
"\")",
"@",
",",
"=",
"Type argument '",
"' is not a ",
"subtype of type parameter bound '",
"???",
"click",
"Clique no modal - target: ",
", modalAbout: ",
"Fechando modal via overlay",
"Botão X (via modal) clicado",
"Botão X clicado",
"Link \"Sobre\" clicado",
"🔵 Abrindo modal...",
"🔵 Modal classList após abrir: ",
"hello",
"calculator",
"conditions",
"loops",
"functions",
"complex",
"// Exemplo: Olá Mundo\nvar nome = \"Mundo\";\nimprimir \"Olá, \";\nimprimir nome;\nimprimir \"!\";",
"// Exemplo: Calculadora Simples\nvar a = 10;\nvar b = 5;\n\nimprimir \"Soma: \";\nimprimir a + b;\n\nimprimir \"Subtração: \";\nimprimir a - b;\n\nimprimir \"Multiplicação: \";\nimprimir a * b;\n\nimprimir \"Divisão: \";\nimprimir a / b;",
"// Exemplo: Estruturas de Controle\nvar idade = 18;\n\nse (idade >= 18) {\n    imprimir \"Maior de idade\";\n} senao {\n    imprimir \"Menor de idade\";\n}\n\nvar nota = 8.5;\nse (nota >= 9) {\n    imprimir \"Excelente!\";\n} senao se (nota >= 7) {\n    imprimir \"Bom!\";\n} senao {\n    imprimir \"Pode melhorar.\";\n}",
"// Exemplo: Loops\nimprimir \"Contagem de 1 a 5:\";\npara (var i = 1; i <= 5; i = i + 1) {\n    imprimir i;\n}\n\nimprimir \"Contagem regressiva:\";\nvar j = 3;\nenquanto (j > 0) {\n    imprimir j;\n    j = j - 1;\n}\nimprimir \"Fim!\";",
"// Exemplo: Funções\nfuncao somar(a, b) {\n    retornar a + b;\n}\n\nfuncao saudar(nome) {\n    imprimir \"Olá, \";\n    imprimir nome;\n    imprimir \"!\";\n}\n\n// Chamadas das funções\nvar resultado = somar(10, 5);\nimprimir \"Resultado: \";\nimprimir resultado;\n\nsaudar(\"MiniDart\");",
"// Exemplo: Programa Complexo\nfuncao fatorial(n) {\n    se (n <= 1) {\n        retornar 1;\n    } senao {\n        retornar n * fatorial(n - 1);\n    }\n}\n\nfuncao fibonacci(n) {\n    se (n <= 1) {\n        retornar n;\n    } senao {\n        retornar fibonacci(n - 1) + fibonacci(n - 2);\n    }\n}\n\n// Calcular fatorial de 5\nvar fat = fatorial(5);\nimprimir \"Fatorial de 5: \";\nimprimir fat;\n\n// Sequência de Fibonacci\nimprimir \"Fibonacci de 0 a 7:\";\npara (var i = 0; i <= 7; i = i + 1) {\n    var fib = fibonacci(i);\n    imprimir fib;\n}",
"copy",
"Copiado para a área de transferência!",
"Erro ao copiar texto",
"Erro ao copiar: ",
"-999999px",
"textarea",
"Clique em \"Executar\" para ver a saída do seu programa...",
"AST será gerada quando você executar o código...",
"Bytecode será gerado quando você executar o código...",
"Digite algum código para ver o bytecode!",
"Digite algum código para ver a AST!",
"#code-editor",
"#output-content",
"#ast-content",
"#bytecode-content",
"#errors-content",
"#examples",
"#loading",
"#modal-about",
"#line-count",
"#char-count",
".tab",
"data-tab",
"#tab-",
"' has already been initialized."
      ],

    };

    const jsStringPolyfill = {
      "charCodeAt": (s, i) => s.charCodeAt(i),
      "compare": (s1, s2) => {
        if (s1 < s2) return -1;
        if (s1 > s2) return 1;
        return 0;
      },
      "concat": (s1, s2) => s1 + s2,
      "equals": (s1, s2) => s1 === s2,
      "fromCharCode": (i) => String.fromCharCode(i),
      "length": (s) => s.length,
      "substring": (s, a, b) => s.substring(a, b),
      "fromCharCodeArray": (a, start, end) => {
        if (end <= start) return '';

        const read = dartInstance.exports.$wasmI16ArrayGet;
        let result = '';
        let index = start;
        const chunkLength = Math.min(end - index, 500);
        let array = new Array(chunkLength);
        while (index < end) {
          const newChunkLength = Math.min(end - index, 500);
          for (let i = 0; i < newChunkLength; i++) {
            array[i] = read(a, index++);
          }
          if (newChunkLength < chunkLength) {
            array = array.slice(0, newChunkLength);
          }
          result += String.fromCharCode(...array);
        }
        return result;
      },
      "intoCharCodeArray": (s, a, start) => {
        if (s == '') return 0;

        const write = dartInstance.exports.$wasmI16ArraySet;
        for (var i = 0; i < s.length; ++i) {
          write(a, start++, s.charCodeAt(i));
        }
        return s.length;
      },
    };


    

    dartInstance = await WebAssembly.instantiate(this.module, {
      ...baseImports,
      ...additionalImports,
      
      "wasm:js-string": jsStringPolyfill,
    });

    return new InstantiatedApp(this, dartInstance);
  }
}

class InstantiatedApp {
  constructor(compiledApp, instantiatedModule) {
    this.compiledApp = compiledApp;
    this.instantiatedModule = instantiatedModule;
  }

  // Call the main function with the given arguments.
  invokeMain(...args) {
    this.instantiatedModule.exports.$invokeMain(args);
  }
}
