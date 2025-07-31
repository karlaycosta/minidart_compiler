# MiniDart VS Code Extension v2.1.0

## 🎯 Como usar a extensão

### 1. Desenvolvimento local
```bash
# 1. Navegue até a pasta da extensão
cd vscode-extension

# 2. Instale as dependências
npm install

# 3. Compile a extensão
npm run compile

# 4. Pressione F5 no VS Code para testar
# Isso abrirá uma nova janela com a extensão carregada
```

### 2. Instalação manual (VSIX)
```bash
# 1. Instalar o vsce (VS Code Extension manager)
npm install -g @vscode/vsce

# 2. Gerar o pacote VSIX
vsce package

# 3. Instalar a extensão
code --install-extension minidart-2.1.0.vsix
```

### 3. Publicação no Marketplace (Opcional)
```bash
# 1. Criar conta no Visual Studio Marketplace
# Acesse: https://marketplace.visualstudio.com/manage

# 2. Criar Personal Access Token
# Azure DevOps > User Settings > Personal Access Tokens

# 3. Login no vsce
vsce login <publisher-name>

# 4. Publicar a extensão
vsce publish
```

### 4. Ícone da Extensão
A extensão agora inclui um ícone personalizado:
- **Arquivo**: `icon.png` (128x128 pixels)
- **Formato**: PNG com transparência
- **Design**: Logo MiniDart com cores vibrantes
- **Configuração**: Adicionado no `package.json` como `"icon": "icon.png"`

# 3. Instalar a extensão
code --install-extension minidart-1.1.1.vsix
```

### 5. Configuração no workspace
1. Abra o projeto MiniDart no VS Code
2. Configure o caminho do compilador em Settings:
   - `minidart.compilerPath`: `bin/compile.dart`
   - `minidart.autoCompile`: `false` (padrão - desabilitado)
   - `minidart.autoFormat`: `true` (formatação automática)
   - `minidart.enableLinting`: `true` (análise de código)

### 6. Funcionalidades disponíveis
- ✅ **Syntax highlighting completo** para arquivos `.mdart`
- ✅ **50+ Snippets inteligentes** para estruturas da linguagem
- ✅ **Sistema de listas tipadas**: `lista<tipo>` com métodos
- ✅ **Sistema de imports**: `importar biblioteca como alias`
- ✅ **Bibliotecas padrão**: `math`, `string`, `data`, `io`
- ✅ **Comandos de compilação e execução** integrados
- ✅ **Debug visual** com breakpoints e watch variables
- ✅ **Geração automática de AST** com visualização
- ✅ **Templates para novos arquivos** com estrutura completa
- ✅ **Operadores avançados**: Ternário (`?:`), typeof (`tipode`)
- ✅ **Função principal**: `inteiro principal() { ... }`

### 7. Atalhos de teclado
- `Ctrl+F5`: ▶️ Executar arquivo MiniDart
- `F5`: 🐛 Debug MiniDart
- `Ctrl+Shift+B`: 🚀 Compilar arquivo
- `Ctrl+Shift+A`: 🌳 Gerar AST
- `Ctrl+Shift+S`: ✅ Verificar Sintaxe
- `Ctrl+Shift+F`: 💫 Formatar Código
- `F1`: 📚 Documentação

### 8. Sistema de Listas Completo
O sistema de listas foi completamente implementado:

#### Tipos de listas suportados:
```minidart
lista<inteiro> numeros = [1, 2, 3, 4, 5];
lista<real> precos = [29.99, 15.50, 42.00];
lista<texto> nomes = ["Ana", "Bruno", "Carlos"];
lista<logico> estados = [verdadeiro, falso, verdadeiro];
```

#### Métodos integrados:
```minidart
// Tamanho da lista
inteiro tamanho = numeros.tamanho();

// Adicionar elemento
numeros.adicionar(6);

// Remover último elemento
inteiro removido = numeros.remover();

// Verificar se está vazia
logico vazia = numeros.vazio();

// Acesso por índice
inteiro primeiro = numeros[0];
numeros[1] = 100;  // Modificar elemento
```

#### Snippets para listas:
- `listainteiro` - Lista de números inteiros
- `listatexto` - Lista de strings
- `listareal` - Lista de números reais
- `listavazia` - Lista vazia com verificação
- `listoperacoes` - Operações completas com listas

### 9. Sistema de Imports e Bibliotecas
```minidart
// Import básico
importar math;
real resultado = math.sqrt(16);

// Import com alias
importar string como str;
texto maiuscula = str.maiuscula("minidart");

// Múltiplas bibliotecas
importar data;
importar io;
texto hoje = data.hoje();
io.imprimir("Data: " + hoje);
```

#### Bibliotecas disponíveis:
- **math**: `sqrt()`, `pow()`, `sin()`, `cos()`, `abs()`, `max()`, `min()`
- **string**: `maiuscula()`, `minuscula()`, `tamanho()`, `contem()`, `substituir()`
- **data**: `hoje()`, `horaAtual()`, `diferenca()`, `formatar()`
- **io**: `imprimir()`, `escrever()`, `novaLinha()`

### 10. Estruturas de Controle Avançadas

#### Switch/Case (escolha/caso):
```minidart
escolha (dia) {
    caso 1:
        imprima "Segunda-feira";
        parar;
    caso 2:
        imprima "Terça-feira";
        parar;
    contrario:
        imprima "Outro dia";
}
```

#### Do-While (faca...enquanto):
```minidart
inteiro contador = 0;
faca {
    imprima "Contador: " + paraTexto(contador);
    contador++;
} enquanto (contador < 5);
```

#### Operador Ternário:
```minidart
texto status = idade >= 18 ? "adulto" : "menor";
inteiro maximo = a > b ? a : b;
```

## 📁 Estrutura da extensão
```
vscode-extension/
├── package.json                    # Manifest da extensão
├── tsconfig.json                   # Configuração TypeScript
├── icon.png                        # Ícone da extensão (128x128)
├── README.md                       # Documentação principal
├── CHANGELOG.md                    # Histórico de versões
├── RECURSOS_EXTENSAO.md           # Documentação completa
├── USAGE.md                       # Guia de uso
├── src/
│   ├── extension.ts               # Código principal da extensão
│   ├── debugAdapter.ts            # Debug adapter
│   └── debugMain*.ts              # Variações do debugger
├── syntaxes/
│   └── minidart.tmLanguage.json   # Gramática para highlighting
├── language/
│   └── minidart-configuration.json # Configuração da linguagem
├── snippets/
│   └── minidart.json              # 50+ Snippets de código
└── out/                           # Arquivos compilados TypeScript
    ├── extension.js
    └── debug*.js
```

## 🎨 Sobre o Ícone da Extensão

O ícone foi criado especificamente para a extensão MiniDart:

### 📋 **Especificações Técnicas**
- **Formato**: PNG com transparência
- **Dimensões**: 128x128 pixels
- **Cores**: Azul (#007ACC) e branco
- **Design**: Logo MiniDart estilizado

### 🎯 **Características do Design**
- **Símbolo**: Representa a linguagem MiniDart
- **Cores**: Compatíveis com o tema do VS Code
- **Estilo**: Moderno e profissional
- **Visibilidade**: Otimizado para diferentes tamanhos

### 🔧 **Como Personalizar o Ícone**
Para usar seu próprio ícone:

1. **Criar arquivo de ícone**:
   - Formato: PNG
   - Tamanho: 128x128 pixels
   - Nome: `icon.png`

2. **Colocar na raiz da extensão**:
   ```
   vscode-extension/
   ├── icon.png          # Seu ícone personalizado
   ├── package.json
   └── ...
   ```

3. **Configurar no package.json**:
   ```json
   {
     "name": "minidart",
     "icon": "icon.png",
     ...
   }
   ```

4. **Recompilar e testar**:
   ```bash
   npm run compile
   # Pressione F5 para testar
   ```

## 🚀 **Comandos de Build e Deploy**

### 📦 **Gerar Pacote VSIX**
```bash
# Instalar ferramenta de empacotamento
npm install -g @vscode/vsce

# Gerar pacote para distribuição
vsce package

# Resultado: minidart-2.1.0.vsix
```

### 🔍 **Validar Extensão**
```bash
# Verificar se todos os arquivos estão inclusos
vsce ls

# Validar manifest
vsce package --allow-missing-repository
```

### 📤 **Instalar Localmente**
```bash
# Instalar a extensão empacotada
code --install-extension minidart-2.1.0.vsix

# Ou pelo VS Code: Command Palette > Install from VSIX
```

### 🌐 **Publicar no Marketplace**
```bash
# Fazer login (necessário Personal Access Token)
vsce login your-publisher-name

# Publicar versão
vsce publish

# Ou publicar diretamente o VSIX
vsce publish minidart-2.1.0.vsix
```

## ✅ **Checklist de Publicação**

### 📋 **Antes de Publicar**
- [ ] ✅ Ícone adicionado (128x128 PNG)
- [ ] ✅ README.md atualizado
- [ ] ✅ CHANGELOG.md com histórico
- [ ] ✅ package.json com versão correta
- [ ] ✅ Todos os snippets testados
- [ ] ✅ Syntax highlighting funcionando
- [ ] ✅ Comandos e atalhos operacionais
- [ ] ✅ Debug adapter testado
- [ ] ✅ Configurações validadas
- [ ] ✅ Exemplos de código funcionais

### 🧪 **Testes Realizados**
- [ ] ✅ Extensão carrega sem erros
- [ ] ✅ Syntax highlighting para todos os elementos
- [ ] ✅ Snippets se expandem corretamente
- [ ] ✅ Comandos executam sem falhas
- [ ] ✅ Atalhos de teclado funcionam
- [ ] ✅ Configurações são aplicadas
- [ ] ✅ Debug com breakpoints operacional
- [ ] ✅ Geração de AST funcional

A extensão MiniDart v2.1.0 está pronta para uso e distribuição! 🚀✨
