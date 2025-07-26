<h1 align="center" id="topo">
  🚀 MiniDart Compiler: Uma Linguagem de Programação Educacional em Português
</h1>

<p align="center">
  <!-- Linguagens utilizadas no projeto -->
  <img src="https://img.shields.io/static/v1?label=Linguagem&message=Dart&color=0175C2&style=for-the-badge&logo=dart&logoColor=white" />
  <img src="https://img.shields.io/static/v1?label=Linguagem&message=HTML&color=E34F26&style=for-the-badge&logo=html5&logoColor=white" />
  <img src="https://img.shields.io/static/v1?label=Linguagem&message=CSS&color=1572B6&style=for-the-badge&logo=css3&logoColor=white" />
  <img src="https://img.shields.io/static/v1?label=Linguagem&message=JavaScript&color=F7DF1E&style=for-the-badge&logo=javascript&logoColor=black" />

  <!-- Informacoes adicionais sobre o projeto -->
  <img src="https://img.shields.io/static/v1?label=Vers%C3%A3o&message=1.6.0&color=brightgreen&style=for-the-badge" />
  <img src="https://img.shields.io/static/v1?label=Licen%C3%A7a&message=MIT&color=green&style=for-the-badge" />
  <img src="https://img.shields.io/static/v1?label=Status&message=Est%C3%A1vel&color=success&style=for-the-badge" />

  <!-- Propósito do projeto -->
  <img src="https://img.shields.io/static/v1?label=Prop%C3%B3sito&message=Educacional%20-%20Compiladores&color=purple&style=for-the-badge" />
</p>

<hr>

<!-- Sumário com links para seções do README -->
<h2>📚 Sumário</h2>
<ul>
  <li><a href="#titulo-e-descricao">📖 Descrição</a></li>
  <li><a href="#objetivos">🎯 Objetivos</a></li>
  <li><a href="#documentacao-arquivos">🗂️ Documentação</a></li>
  <li><a href="#funcionalidades-principais">⚙️ Funcionalidades Principais</a></li>
  <li><a href="#instalacao">📦 Instalação</a></li>
  <li><a href="#deploy">🚀 Deploy</a></li>
  <li><a href="#licenca">📝 Licença</a></li>
  <li><a href="#autor">👤 Autor</a></li>
  <li><a href="#colaboradores">🤝 Colaboradores</a></li>
</ul>

<hr>

<h2 id="titulo-e-descricao">📖 Descrição</h2>
<p>
  Um compilador educacional completo desenvolvido em <strong>Dart</strong>, que interpreta a linguagem <strong>MiniDart</strong> — uma linguagem de programação com sintaxe em português, projetada para facilitar o ensino de algoritmos e estruturas de linguagem. O MiniDart percorre todas as etapas de um compilador real: análise léxica, sintática, semântica, geração de bytecode e execução em máquina virtual.
</p>

<hr>

<h2 id="objetivos">🎯 Objetivos</h2>
<p>
  Apresentar o funcionamento, estrutura e modo de uso de um compilador educacional que interpreta uma linguagem de programação simplificada com sintaxe em português. O projeto visa facilitar o ensino de lógica de programação e estruturas de linguagem para iniciantes, eliminando barreiras linguísticas.
</p>

<hr>

<h2 id="documentacao-arquivos">🗂️ Documentação</h2>

<hr>

<h2 id="funcionalidades-principais">⚙️ Funcionalidades Principais</h2>

<h4>📋 Análise Semântica</h4>
<ul>
  <li> Verifica o <strong>significado</strong> do código</li>
  <li> Verifica se variáveis são <strong>declaradas antes de usar</strong></li>
  <li> Garante <strong>tipagem correta</strong> e compatibilidade entre operações</li>
  <li> Detecta <strong>erros semânticos</strong> como:
    <ul>
      <li>Uso de variáveis não declaradas</li>
      <li>Atribuições inválidas</li>
    </ul>
  </li>
</ul>

<h4>🛠️ Geração de Código Intermediário / Bytecode</h4>
<ul>
  <li> Traduz o código em português para uma <strong>representação intermediária</strong></li>
  <li> Representação como <strong>bytecode</strong> ou <strong>árvore de instruções</strong></li>
  <li>⚙ Pode ser interpretado por uma <strong>máquina virtual personalizada</strong></li>
</ul>

<h4>🧾 Entrada e Saída de Dados</h4>
<ul>
  <li> <strong>leia</strong> (input): leitura do usuário</li>
  <li> <strong>escreva</strong> (print): exibição no terminal</li>
  <li> Suporte a entrada via <strong>terminal ou interface gráfica (opcional)</strong></li>
</ul>

<h4>📝 Suporte a Algoritmos Básicos</h4>
<ul>
  <li> <strong>Variáveis</strong> e <strong>expressões</strong></li>
  <li> Estruturas de controle:
    <ul>
      <li><code>se</code>, <code>senao</code></li>
      <li><code>enquanto</code>, <code>para</code></li>
    </ul>
  </li>
  <li> Suporte a <strong>funções</strong> (se implementado)</li>
</ul>

<h4>🌐 Sintaxe em Português</h4>
<p>Exemplo de código:</p>

```dart
inteiro x
x = 10
se (x > 5) {
  escreva("Maior que 5")
}

```

<hr>

<h2 id="instalacao">📦 Instalação</h2>

<ul>
  <li>✅ Requer: <a href="https://dart.dev/get-dart" target="_blank">Dart SDK</a> <strong>3.8.1</strong> ou superior</li>
</ul>

<h4>🔧 Clone e Setup</h4>

<pre><code># Clone o repositório
git clone https://github.com/seu-usuario/minidart_compiler.git
cd minidart_compiler

# Instale as dependências
dart pub get

# Compile o projeto (opcional)
dart compile exe bin/compile.dart -o minidart
</code></pre>

---

<h3 id="uso">⚡ Uso Rápido</h3>

<h4>1️⃣ Crie um arquivo MiniDart</h4>

<pre><code>// exemplo.mdart
var nome = "Mundo";
var numero = 42;

se (numero > 10) {
    imprimir "Número grande: ";
    imprimir numero;
} senao {
    imprimir "Número pequeno";
}

imprimir "Olá, ";
imprimir nome;
</code></pre>

<h4>2️⃣ Execute o compilador</h4>

<pre><code># Rodar diretamente via Dart
dart run bin/compile.dart exemplos/exemplo.mdart

# Ou use o executável gerado
./minidart exemplos/exemplo.mdart

# 🔍 Com opções:
dart run bin/compile.dart exemplos/exemplo.mdart --ast-only    # ou -a
dart run bin/compile.dart exemplos/exemplo.mdart --bytecode    # ou -b
dart run bin/compile.dart --version                            # ou -v
</code></pre>

<h4>3️⃣ Saída esperada</h4>

<pre><code>Número grande: 
42
Olá, 
Mundo
</code></pre>

---

<h3>🎯 Sistema de Erros Avançado</h3>

<p>O compilador exibe mensagens de erro com alta precisão:</p>

<pre><code># Exemplo com erro intencional
echo 'imprimir "texto" + 123;' > erro_exemplo.mdart
dart run bin/compile.dart erro_exemplo.mdart
</code></pre>

<details>
<summary>💥 Exemplo de erro:</summary>

<pre><code>Erro de Execução: Operandos devem ser dois números ou duas strings.
[linha 1, coluna 18]
</code></pre>
</details>


<hr>

<h2 id="deploy"> 🚀 De deploy</h2>

<hr>

<h2 id="licenca"> 📝 Licença</h2>

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para detalhes.

<hr>
<h2 id="autor">Autor</h2>
 
<table>
  <tr>
    <td align="center">
      <a href="https://github.com/karlaycosta" title="Aline Cely">
        <img src="https://github.com/karlaycosta.png" width="100px" alt="Foto da Dericks Karlay no GitHub" /><br />
        <sub><b>karlay costa</b></sub>
      </a>
    </td>
</table>

<h2 id="colaboradores">Colaboradores</h2>
<p>Agradecemos às seguintes pessoas que contribuíram para este projeto:</p>

<table>
  <tr>
    <td align="center">
      <a href="https://github.com/AlineCely" title="Aline Cely">
        <img src="https://github.com/AlineCely.png" width="100px" alt="Foto da Aline Cely no GitHub" /><br />
        <sub><b>Aline Cely</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/filipepak" title="Filipe">
        <img src="https://github.com/filipepak.png" width="100px" alt="Foto do filipepak no GitHub" /><br />
        <sub><b>Filipe</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/Gab0701" title="João Gabriel">
        <img src="https://github.com/Gab0701.png" width="100px" alt="Foto do Gab0701 no GitHub" /><br />
        <sub><b>João Gabriel</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/JoaoPedroCavalcante" title="João Pedro">
        <img src="https://github.com/JoaoPedroCavalcante.png" width="100px" alt="Foto do JoaoPedroCavalcante no GitHub" /><br />
        <sub><b>João Pedro</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/Jhonefer" title="Jhonefer Vinicius">
        <img src="https://github.com/jhony996358.png" width="100px" alt="Foto do Jhonefer no GitHub" /><br />
        <sub><b>Jhonefer Vinicius</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/Igormachado90" title="Igor Machado">
        <img src="https://github.com/Igormachado90.png" width="100px" alt="Foto do Igormachado90 no GitHub" /><br />
        <sub><b>Igor Machado</b></sub>
      </a>
    </td>
  </tr>
  <tr>
    <td align="center">
      <a href="https://github.com/italo-assuncao" title="Ítalo Assunção">
        <img src="https://github.com/italo-assuncao.png" width="100px" alt="Foto do italo-assuncao no GitHub" /><br />
        <sub><b>Ítalo Assunção</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/JKLModesto" title="Pedro Modesto">
        <img src="https://github.com/JKLModesto.png" width="100px" alt="Foto do JKLModesto no GitHub" /><br />
        <sub><b>Pedro Modesto</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/LeoGuile" title="Leo Guile">
        <img src="https://github.com/LeoGuile.png" width="100px" alt="Foto do LeoGuile no GitHub" /><br />
        <sub><b>Leo Guile</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/Luitinho147" title="Luiz">
        <img src="https://github.com/Luitinho147.png" width="100px" alt="Foto do Luiz no GitHub" /><br />
        <sub><b>Luiz</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/NoanMoreira" title="Noan Moreira">
        <img src="https://github.com/NoanMoreira.png" width="100px" alt="Foto do NoanMoreira no GitHub" /><br />
        <sub><b>Noan Moreira</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/StellaKarolinaNunes" title="Stella Karolina">
        <img src="https://github.com/StellaKarolinaNunes.png" width="100px" alt="Foto do StellaKarolinaNunes no GitHub" /><br />
        <sub><b>Stella Karolina</b></sub>
      </a>
    </td>
  </tr>
  <tr>
    <td align="center">
      <a href="https://github.com/thaissoliveira" title="Thais Oliveira">
        <img src="https://github.com/thaissoliveira.png" width="100px" alt="Foto do thaissoliveira no GitHub" /><br />
        <sub><b>Thais Oliveira</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/Vitoralmeidaf" title="Vitor Almeida">
        <img src="https://github.com/Vitoralmeidaf.png" width="100px" alt="Foto do Vitoralmeidaf no GitHub" /><br />
        <sub><b>Vitor Almeida</b></sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/vitormezz" title="Vitor Mezzomo">
        <img src="https://github.com/vitormezz.png" width="100px" alt="Foto do vitormezz no GitHub" /><br />
        <sub><b>Vitor Mezzomo</b></sub>
      </a>
    </td>
    <td colspan="3"></td>
  </tr>
</table>

<hr>
# minidart-compiler
# minidart
