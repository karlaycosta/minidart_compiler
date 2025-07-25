# 📚 **Resumo Completo das Funcionalidades do MiniDart**

**Versão:** v1.12.3  
**Data:** 25 de julho de 2025  
**Linguagem:** Dart  

---

## 🎯 **Visão Geral**

O **MiniDart** é uma linguagem de programação educacional com sintaxe em português, projetada para ensinar conceitos de compilação e programação. Possui um compilador completo que implementa todas as fases: análise léxica, sintática, semântica, geração de código e execução em máquina virtual.

---

## 🏗️ **Arquitetura do Compilador**

```
Código Fonte (.mdart) → Lexer → Parser → Semantic Analyzer → Code Generator → VM → Resultado
```

### **Componentes Principais:**
- **Lexer** (`lexer.dart`): Análise léxica e tokenização
- **Parser** (`parser.dart`): Análise sintática e geração da AST
- **Semantic Analyzer** (`semantic_analyzer.dart`): Verificação de tipos e escopo
- **Code Generator** (`code_generator.dart`): Geração de bytecode
- **Virtual Machine** (`vm.dart`): Execução via stack-based VM
- **Symbol Table** (`symbol_table.dart`): Gerenciamento de escopo

---

## 🔤 **Sistema de Tipos**

### **Tipos Primitivos:**
- `inteiro` - Números inteiros (42, -10, 0)
- `real` - Números decimais (3.14, -2.5, 0.0)
- `texto` - Strings ("Olá", 'mundo', "")
- `logico` - Booleanos (verdadeiro, falso)
- `vazio` - Tipo de retorno void para funções

### **Declaração de Variáveis:**
```dart
// Inferência de tipo
var nome = "João";
var idade = 25;

// Tipagem explícita
inteiro numero = 42;
real pi = 3.14159;
texto mensagem = "Olá mundo";
logico ativo = verdadeiro;
```

---

## 📝 **Palavras-Chave (Sintaxe em Português)**

### **Estruturas de Controle:**
- `se` - Condicional if
- `senao` - Condicional else
- `enquanto` - Loop while
- `para` - Loop for
- `faca` - Do-while / For body
- `ate` - Until (usado em for)

### **Declarações:**
- `var` - Declaração de variável com inferência
- `constante` - Declaração de constante imutável
- `vazio` - Tipo de retorno void

### **Operadores Lógicos:**
- `e` - AND lógico (&&)
- `ou` - OR lógico (||)
- `verdadeiro` - Literal true
- `falso` - Literal false
- `nulo` - Literal null

### **Funções:**
- `retorne` - Return statement
- `imprima` - Print statement

### **Modificadores de Loop:**
- `incremente` - Incremento personalizado no for
- `decremente` - Decremento personalizado no for

---

## 🔧 **Operadores**

### **Aritméticos:**
- `+` - Adição / Concatenação de strings
- `-` - Subtração
- `*` - Multiplicação
- `/` - Divisão
- `%` - Módulo

### **Comparação:**
- `==` - Igual
- `!=` - Diferente
- `<` - Menor que
- `>` - Maior que
- `<=` - Menor ou igual
- `>=` - Maior ou igual

### **Lógicos:**
- `e` (`&&`) - AND
- `ou` (`||`) - OR
- `!` - NOT

### **Atribuição:**
- `=` - Atribuição simples
- `+=` - Soma e atribui
- `-=` - Subtrai e atribui
- `*=` - Multiplica e atribui
- `/=` - Divide e atribui
- `%=` - Módulo e atribui

### **Incremento/Decremento:**
- `++` - Incremento (pré e pós)
- `--` - Decremento (pré e pós)

### **Ternário:**
- `? :` - Operador ternário condicional

---

## 🔄 **Estruturas de Controle**

### **1. Condicionais:**
```dart
se (idade >= 18) {
    imprima "Maior de idade";
} senao {
    imprima "Menor de idade";
}

// Ternário
var status = idade >= 18 ? "adulto" : "jovem";
```

### **2. Loop While:**
```dart
var contador = 1;
enquanto (contador <= 5) {
    imprima contador;
    contador = contador + 1;
}
```

### **3. Loop Do-While:**
```dart
var num = 5;
faca {
    imprima num;
    num = num - 1;
} enquanto (num > 0);
```

### **4. Loop For Básico:**
```dart
para i = 1 ate 10 faca {
    imprima i;
}
```

### **5. Loop For com Incremento:**
```dart
para i = 0 ate 20 incremente 2 faca {
    imprima i; // 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20
}
```

### **6. Loop For com Decremento:**
```dart
para i = 10 ate 0 decremente 2 faca {
    imprima i; // 10, 8, 6, 4, 2, 0
}
```

---

## 🎯 **Funções**

### **Função Void:**
```dart
vazio saudar() {
    imprima "Olá mundo!";
}

saudar(); // Chama a função
```

### **Função com Retorno:**
```dart
inteiro somar(inteiro a, inteiro b) {
    retorne a + b;
}

var resultado = somar(5, 3); // resultado = 8
```

### **Função com Tipos Múltiplos:**
```dart
texto formatarNome(texto nome, texto sobrenome) {
    retorne nome + " " + sobrenome;
}

real calcularMedia(real nota1, real nota2) {
    retorne (nota1 + nota2) / 2;
}
```

---

## 🔗 **Concatenação de Strings**

### **Suporte Completo:**
```dart
// Básica
texto nome = "João";
texto sobrenome = "Silva";
texto completo = nome + " " + sobrenome;

// Com literais
texto saudacao = "Olá, " + nome + "!";

// Múltipla
texto abc = "A" + "B" + "C";

// Em loops
texto lista = "";
para i = 1 ate 3 faca {
    lista = lista + "Item " + i + " ";
}

// Verificação de tipos (erro em tempo de execução)
// texto erro = "texto" + 123; // ERRO: tipos incompatíveis
```

---

## 📊 **Operadores Compostos e Incremento**

### **Operadores Compostos:**
```dart
var x = 10;
x += 5;  // x = 15
x -= 3;  // x = 12
x *= 2;  // x = 24
x /= 4;  // x = 6
x %= 4;  // x = 2
```

### **Incremento e Decremento:**
```dart
var y = 5;
imprima y++; // 5 (pós-incremento, usa depois incrementa)
imprima y;   // 6

imprima ++y; // 7 (pré-incremento, incrementa depois usa)
imprima y--; // 7 (pós-decremento)
imprima y;   // 6
```

---

## 🎨 **Recursos Avançados**

### **1. Blocos e Escopo:**
```dart
var global = "variável global";
{
    var local = "variável local";
    imprima global; // Acessível
    imprima local;  // Acessível
}
// local não é mais acessível aqui
```

### **2. Expressões Complexas:**
```dart
var resultado = (10 + 5) * 2 - 3;
var condicao = (idade >= 18) e (nome != "");
var calculo = altura * peso + (idade / 2);
```

### **3. Calls Aninhadas:**
```dart
inteiro multiplicar(inteiro a, inteiro b) {
    retorne a * b;
}

inteiro elevar(inteiro base, inteiro exp) {
    retorne multiplicar(base, base); // Simplified
}

var resultado = elevar(multiplicar(2, 3), 2);
```

---

## 🔍 **Sistema de Verificação de Tipos**

### **Análise Semântica:**
- Verificação de tipos em tempo de compilação
- Detecção de variáveis não declaradas
- Verificação de escopo de variáveis
- Validação de tipos de parâmetros e retornos
- Detecção de operações inválidas entre tipos

### **Exemplo de Erros Detectados:**
```dart
// Erro: Variável não declarada
imprima nome_inexistente;

// Erro: Tipos incompatíveis
texto nome = "João";
inteiro idade = nome; // ERRO

// Erro: Operação inválida
texto resultado = "texto" + 123; // ERRO em execução
```

---

## 💾 **Máquina Virtual (VM)**

### **Características:**
- **Stack-based**: Operações baseadas em pilha
- **Call Stack**: Suporte a chamadas de função aninhadas
- **Bytecode**: Execução de código intermediário otimizado
- **Garbage Collection**: Gerenciamento automático de memória

### **Instruções Suportadas:**
- Operações aritméticas e lógicas
- Manipulação de stack (push/pop)
- Saltos condicionais e incondicionais
- Chamadas de função e retornos
- Acesso a variáveis locais e globais

---

## 🛠️ **Ferramentas de Desenvolvimento**

### **Compilador CLI:**
```bash
# Execução normal
dart run bin/compile.dart arquivo.mdart

# Gerar apenas AST (Graphviz)
dart run bin/compile.dart arquivo.mdart --ast-only

# Mostrar bytecode
dart run bin/compile.dart arquivo.mdart --bytecode

# Versão
dart run bin/compile.dart --version
```

### **Recursos de Debug:**
- Geração de AST em formato Graphviz
- Visualização de bytecode gerado
- Relatórios detalhados de erro com linha e coluna
- Análise de performance da VM

---

## 📂 **Estrutura de Arquivos**

### **Extensão:** `.mdart`

### **Estrutura Típica:**
```dart
// Comentários de linha com //

// Declarações globais
var mensagem = "Olá mundo";
constante PI = 3.14159;

// Funções
inteiro factorial(inteiro n) {
    se (n <= 1) {
        retorne 1;
    } senao {
        retorne n * factorial(n - 1);
    }
}

// Código principal
para i = 1 ate 5 faca {
    imprima "Factorial de " + i + " = " + factorial(i);
}
```

---

## 🎓 **Casos de Uso Educacionais**

### **1. Ensino de Programação:**
- Sintaxe em português facilita o aprendizado
- Estruturas fundamentais de programação
- Conceitos de tipos e verificação

### **2. Estudo de Compiladores:**
- Implementação completa de todas as fases
- Padrões de design (Visitor, AST)
- Geração de código intermediário

### **3. Análise de Linguagens:**
- Semântica de operadores
- Sistema de tipos estático/dinâmico
- Gerenciamento de memória

---

## 🚀 **Exemplos Práticos Completos**

### **Calculadora:**
```dart
// Calculadora simples
real somar(real a, real b) { retorne a + b; }
real subtrair(real a, real b) { retorne a - b; }
real multiplicar(real a, real b) { retorne a * b; }
real dividir(real a, real b) { retorne a / b; }

var num1 = 10.5;
var num2 = 3.2;

imprima "Soma: " + somar(num1, num2);
imprima "Subtração: " + subtrair(num1, num2);
imprima "Multiplicação: " + multiplicar(num1, num2);
imprima "Divisão: " + dividir(num1, num2);
```

### **Sistema de Notas:**
```dart
// Sistema de avaliação de notas
texto avaliarNota(real nota) {
    se (nota >= 9.0) {
        retorne "Excelente";
    } senao se (nota >= 7.0) {
        retorne "Bom";
    } senao se (nota >= 5.0) {
        retorne "Regular";
    } senao {
        retorne "Insuficiente";
    }
}

var nota_aluno = 8.5;
var conceito = avaliarNota(nota_aluno);
imprima "Nota: " + nota_aluno + " - Conceito: " + conceito;
```

---

## 📈 **Performance e Limitações**

### **Otimizações:**
- Análise semântica em passe único
- Geração de bytecode otimizado
- VM stack-based eficiente

### **Limitações Atuais:**
- Sem suporte a arrays/listas
- Sem structs/classes
- Sem imports/modules
- Sem tratamento de exceções

---

## 🔮 **Extensibilidade**

### **Facilmente Extensível Para:**
- Novos tipos de dados (arrays, objects)
- Novos operadores
- Estruturas de controle adicionais
- Sistema de módulos
- Bibliotecas padrão

---

## 📋 **Resumo das Capacidades**

✅ **Tipos:** inteiro, real, texto, logico, vazio  
✅ **Operadores:** Aritméticos, lógicos, comparação, atribuição  
✅ **Controle:** if/else, while, do-while, for (com incremento/decremento)  
✅ **Funções:** Com parâmetros e retorno tipados  
✅ **Strings:** Concatenação completa e segura  
✅ **Escopo:** Blocos aninhados com verificação  
✅ **Tipos:** Verificação estática e dinâmica  
✅ **VM:** Execução eficiente via bytecode  
✅ **Erros:** Relatórios detalhados e precisos  
✅ **Debug:** AST visualization e bytecode dump  

---

**MiniDart v1.12.3** - Uma linguagem completa para educação em programação e compiladores! 🎯
