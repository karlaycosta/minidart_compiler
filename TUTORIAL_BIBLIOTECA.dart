/*
 * TUTORIAL PRÁTICO: Como Adicionar uma Nova Biblioteca ao MiniDart
 * 
 * Este arquivo contém instruções passo-a-passo para implementar
 * uma biblioteca de utilitários gerais como exemplo.
 */

// =============================================================================
// PASSO 1: ADICIONAR NO ARQUIVO lib/src/standard_library.dart
// =============================================================================

// No construtor StandardLibrary(), adicione:
/*
StandardLibrary() {
  _registerMathLibrary();
  _registerStringLibrary();
  _registerIOLibrary();
  _registerUtilLibrary(); // ← ADICIONAR ESTA LINHA
}
*/

// Adicione este método ao final da classe StandardLibrary:
/*
/// Registra as funções da biblioteca de utilitários gerais
void _registerUtilLibrary() {
  // ===== FUNÇÕES DE VALIDAÇÃO =====
  
  // Verificar se um número é par
  register('util.ehPar', 1, (args) {
    final numero = _toInt(args[0]);
    return numero % 2 == 0;
  });
  
  // Verificar se um número é ímpar
  register('util.ehImpar', 1, (args) {
    final numero = _toInt(args[0]);
    return numero % 2 != 0;
  });
  
  // Verificar se um número é primo
  register('util.ehPrimo', 1, (args) {
    final numero = _toInt(args[0]);
    
    if (numero < 2) return false;
    if (numero == 2) return true;
    if (numero % 2 == 0) return false;
    
    for (int i = 3; i * i <= numero; i += 2) {
      if (numero % i == 0) return false;
    }
    return true;
  });
  
  // ===== FUNÇÕES MATEMÁTICAS =====
  
  // Calcular fatorial
  register('util.fatorial', 1, (args) {
    final n = _toInt(args[0]);
    
    if (n < 0) {
      throw Exception('Fatorial não definido para números negativos');
    }
    
    int resultado = 1;
    for (int i = 2; i <= n; i++) {
      resultado *= i;
    }
    return resultado;
  });
  
  // Calcular Fibonacci
  register('util.fibonacci', 1, (args) {
    final n = _toInt(args[0]);
    
    if (n < 0) {
      throw Exception('Fibonacci não definido para números negativos');
    }
    if (n <= 1) return n;
    
    int a = 0, b = 1;
    for (int i = 2; i <= n; i++) {
      int temp = a + b;
      a = b;
      b = temp;
    }
    return b;
  });
  
  // Máximo Divisor Comum (MDC)
  register('util.mdc', 2, (args) {
    int a = _toInt(args[0]);
    int b = _toInt(args[1]);
    
    a = a.abs();
    b = b.abs();
    
    while (b != 0) {
      int temp = b;
      b = a % b;
      a = temp;
    }
    return a;
  });
  
  // ===== FUNÇÕES DE CONVERSÃO =====
  
  // Converter Celsius para Fahrenheit
  register('util.celsiusParaFahrenheit', 1, (args) {
    final celsius = _toDouble(args[0]);
    return (celsius * 9 / 5) + 32;
  });
  
  // Converter Fahrenheit para Celsius
  register('util.fahrenheitParaCelsius', 1, (args) {
    final fahrenheit = _toDouble(args[0]);
    return (fahrenheit - 32) * 5 / 9;
  });
  
  // Converter número para binário (como string)
  register('util.paraBinario', 1, (args) {
    final numero = _toInt(args[0]);
    return numero.toRadixString(2);
  });
  
  // Converter número para hexadecimal (como string)
  register('util.paraHexadecimal', 1, (args) {
    final numero = _toInt(args[0]);
    return numero.toRadixString(16).toUpperCase();
  });
  
  // ===== FUNÇÕES DE LISTA/ARRAY SIMULADAS =====
  
  // Somar uma sequência de números (simulando array com string)
  register('util.somarSequencia', 3, (args) {
    final inicio = _toInt(args[0]);
    final fim = _toInt(args[1]);
    final passo = _toInt(args[2]);
    
    if (passo <= 0) {
      throw Exception('Passo deve ser positivo');
    }
    
    int soma = 0;
    for (int i = inicio; i <= fim; i += passo) {
      soma += i;
    }
    return soma;
  });
  
  // Contar números primos em um intervalo
  register('util.contarPrimos', 2, (args) {
    final inicio = _toInt(args[0]);
    final fim = _toInt(args[1]);
    
    int contador = 0;
    for (int i = inicio; i <= fim; i++) {
      // Verificar se é primo (código duplicado para exemplo)
      if (i >= 2) {
        bool primo = true;
        if (i > 2 && i % 2 == 0) {
          primo = false;
        } else {
          for (int j = 3; j * j <= i; j += 2) {
            if (i % j == 0) {
              primo = false;
              break;
            }
          }
        }
        if (primo) contador++;
      }
    }
    return contador;
  });
  
  // ===== FUNÇÕES DE FORMATAÇÃO =====
  
  // Formatar número com zeros à esquerda
  register('util.formatarComZeros', 2, (args) {
    final numero = _toInt(args[0]);
    final largura = _toInt(args[1]);
    
    return numero.toString().padLeft(largura, '0');
  });
  
  // Gerar string aleatória de caracteres
  register('util.stringAleatoria', 1, (args) {
    final tamanho = _toInt(args[0]);
    
    if (tamanho <= 0) return '';
    
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = math.Random();
    
    return String.fromCharCodes(
      List.generate(tamanho, (index) => chars.codeUnitAt(random.nextInt(chars.length)))
    );
  });
}
*/

// =============================================================================
// PASSO 2: ADICIONAR NO ARQUIVO lib/src/semantic_analyzer.dart
// =============================================================================

// No método visitImportStmt, na linha com validLibraries, adicione 'util':
/*
final validLibraries = {'math', 'string', 'io', 'util'}; // ← Adicionar 'util'
*/

// =============================================================================
// PASSO 3: ARQUIVO DE TESTE - Criar exemplos/teste_util.mdart
// =============================================================================

/*
// Exemplo de uso da biblioteca util
importar util;
importar io como saida;

saida.imprimir("=== TESTANDO BIBLIOTECA UTIL ===");

// Testes de validação
saida.imprimir("--- Validação ---");
saida.escrever("10 é par? ");
saida.escrever(util.ehPar(10));
saida.novaLinha();

saida.escrever("7 é primo? ");
saida.escrever(util.ehPrimo(7));
saida.novaLinha();

// Testes matemáticos
saida.imprimir("--- Matemática ---");
saida.escrever("Fatorial de 5: ");
saida.escrever(util.fatorial(5));
saida.novaLinha();

saida.escrever("Fibonacci de 8: ");
saida.escrever(util.fibonacci(8));
saida.novaLinha();

saida.escrever("MDC de 48 e 18: ");
saida.escrever(util.mdc(48, 18));
saida.novaLinha();

// Testes de conversão
saida.imprimir("--- Conversão ---");
saida.escrever("25°C em Fahrenheit: ");
saida.escrever(util.celsiusParaFahrenheit(25));
saida.novaLinha();

saida.escrever("10 em binário: ");
saida.escrever(util.paraBinario(10));
saida.novaLinha();

saida.escrever("255 em hexadecimal: ");
saida.escrever(util.paraHexadecimal(255));
saida.novaLinha();

// Testes de sequência
saida.imprimir("--- Sequências ---");
saida.escrever("Soma de 1 a 10: ");
saida.escrever(util.somarSequencia(1, 10, 1));
saida.novaLinha();

saida.escrever("Primos entre 1 e 20: ");
saida.escrever(util.contarPrimos(1, 20));
saida.novaLinha();

// Testes de formatação
saida.imprimir("--- Formatação ---");
saida.escrever("42 com 5 dígitos: ");
saida.escrever(util.formatarComZeros(42, 5));
saida.novaLinha();

saida.escrever("String aleatória (8 chars): ");
saida.escrever(util.stringAleatoria(8));
saida.novaLinha();

saida.imprimir("=== TESTE CONCLUÍDO ===");
*/

// =============================================================================
// PASSO 4: COMO TESTAR
// =============================================================================

/*
1. Copie o código do PASSO 1 para o arquivo lib/src/standard_library.dart
2. Adicione a linha do PASSO 2 no arquivo lib/src/semantic_analyzer.dart
3. Crie o arquivo exemplos/teste_util.mdart com o código do PASSO 3
4. Execute: dart run bin/compile.dart exemplos/teste_util.mdart
*/

// =============================================================================
// RESULTADO ESPERADO
// =============================================================================

/*
=== TESTANDO BIBLIOTECA UTIL ===
--- Validação ---
10 é par? true
7 é primo? true
--- Matemática ---
Fatorial de 5: 120
Fibonacci de 8: 21
MDC de 48 e 18: 6
--- Conversão ---
25°C em Fahrenheit: 77.0
10 em binário: 1010
255 em hexadecimal: FF
--- Sequências ---
Soma de 1 a 10: 55
Primos entre 1 e 20: 8
--- Formatação ---
42 com 5 dígitos: 00042
String aleatória (8 chars): K7M9X2P1
=== TESTE CONCLUÍDO ===
*/

// =============================================================================
// PRÓXIMOS PASSOS
// =============================================================================

/*
Após implementar a biblioteca 'util', você pode:

1. Criar outras bibliotecas seguindo o mesmo padrão
2. Expandir a biblioteca util com mais funções
3. Implementar bibliotecas mais complexas como:
   - 'data' para manipulação de datas
   - 'arquivo' para operações com arquivos
   - 'rede' para requisições HTTP básicas
   - 'json' para parsing de JSON
   - 'crypto' para funções de hash

4. Contribuir com o projeto submetendo suas bibliotecas
*/
