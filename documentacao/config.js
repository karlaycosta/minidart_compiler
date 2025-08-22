/* ═══════════════════════════════════════════════════════════════════════════════
   config.js - Configuração Principal do DocMD para o Projeto LiPo Docs
═══════════════════════════════════════════════════════════════════════════════ */

module.exports = {
  /* ─────────────────────────────────────────────────────────────────────────────
     METADADOS DO SITE
     Informações básicas de identificação e SEO
  ───────────────────────────────────────────────────────────────────────────── */
  siteTitle: "LiPo | DOC", // Título do site
  siteUrl: "https://karlaycosta.github.io/minidart_compiler", // URL pública
  favicon: "/assets/icon/favico.svg", // Ícone da aba do navegador

  /* ─────────────────────────────────────────────────────────────────────────────
     LOGOTIPO
     Configura o logo para diferentes temas e estilos
  ───────────────────────────────────────────────────────────────────────────── */
  logo: {
    light: "./assets/imagens/Logo_horzontal_preto.svg", // Logo para tema claro
    dark: "./assets/imagens/Logo_horzontal_branco.png", // Logo para tema escuro
    alt: "LiPo Docs", // Texto alternativo
    href: "/", // Link ao clicar no logo
    style: {
      width: "100px", // Largura do logo
    },
  },

  /* ─────────────────────────────────────────────────────────────────────────────
     ESTRUTURA DE DIRETÓRIOS
     Define onde estão os arquivos fonte e onde será gerado o site
  ───────────────────────────────────────────────────────────────────────────── */
  srcDir: "docs", // Pasta contendo arquivos .md
  outputDir: "site", // Pasta onde será gerado o build

  /* ─────────────────────────────────────────────────────────────────────────────
     SIDEBAR / BARRA LATERAL
     Configura o comportamento da navegação lateral
  ───────────────────────────────────────────────────────────────────────────── */
  sidebar: {
    collapsible: false, // Permite colapsar/expandir seções
    defaultCollapsed: false, // Estado inicial das seções
  },

  /* ─────────────────────────────────────────────────────────────────────────────
     TEMA E APARÊNCIA
     Configurações visuais do site, modo claro/escuro e CSS customizado
  ───────────────────────────────────────────────────────────────────────────── */
  theme: {
    name: "ruby", // Nome do tema
    defaultMode: "light", // Modo padrão
    enableModeToggle: true, // Permite trocar entre claro/escuro
    positionMode: "top", // Posição do seletor de tema
    customCss: ["assets/css/style.css"], // Arquivos CSS customizados
  },

  /* ─────────────────────────────────────────────────────────────────────────────
     SCRIPTS PERSONALIZADOS
     JavaScript customizado para funcionalidades extras
  ───────────────────────────────────────────────────────────────────────────── */
  customJs: [
  
  ],

  /* ─────────────────────────────────────────────────────────────────────────────
     CONFIGURAÇÕES DE CONTEÚDO
     Controle de título automático e cópia de código
  ───────────────────────────────────────────────────────────────────────────── */
  autoTitleFromH1: true, // Não gera título automaticamente do H1
  copyCode: true, // Habilita botão de copiar código

  /* ─────────────────────────────────────────────────────────────────────────────
     SERVIDOR DE DESENVOLVIMENTO
     Configurações para ambiente local
  ───────────────────────────────────────────────────────────────────────────── */
  devServer: {
    host: "0.0.0.0", // Permite acesso externo (rede local)
    port: 3000, // Porta do servidor local
  },

  /* ─────────────────────────────────────────────────────────────────────────────
     NAVEGAÇÃO PRINCIPAL (SIDEBAR)
     Estrutura hierárquica da documentação, com ícones e links
  ───────────────────────────────────────────────────────────────────────────── */

 navigation: [
  // PÁGINA INICIAL
  { title: "Início", path: "/", icon: "book-open" },

  // ESTRUTURA BÁSICA DA LINGUAGEM
  { title: "Estrutura Léxica", path: "/estrutura_lexica", icon: "file-code" },

  // SISTEMA DE IDENTIFICAÇÃO
  { title: "Identificadores", path: "/identificadores", icon: "tag" },

  // PALAVRAS RESERVADAS
  { title: "Palavra Reservada", path: "/palavra_reservada", icon: "key" },

  // SISTEMA DE TIPOS
  { title: "Tipos de Dados", path: "/tipo_de_dados", icon: "database" },

  // CONVERSÃO
  { title: "Conversão", path: "/conversao", icon: "shuffle" },

  // VARIÁVEIS E CONSTANTES
  {
    title: "Variáveis e Constantes",
    path: "/variaveis_constantes",
    icon: "box",
    children: [
      { title: "Declaração de Variáveis", path: "/declaracao_variaveis", icon: "file-plus" },
      { title: "Declaração de Constantes", path: "/declaracao_constantes", icon: "lock" },
    ],
  },

  // OPERADORES
  {
    title: "Operadores",
    path: "/operadores",
    icon: "function-square",
    children: [
      { title: "Aritméticos", path: "/operadores_aritmeticos", icon: "divide" },
      { title: "Comparação", path: "/comparacao", icon: "equal" },
      { title: "Lógicos", path: "/logicos", icon: "circuit-board" },
      { title: "Atribuição", path: "/atribuicao", icon: "arrow-right-left" },
      { title: "Incremento / Decremento", path: "/incremento_decremento", icon: "plus" },
      { title: "Operador typeof", path: "/operador_tipode", icon: "info" },
      { title: "Precedência", path: "/precedencia_operadores", icon: "list" },
    ],
  },

  // ESTRUTURAS DE CONTROLE
  {
    title: "Estruturas de Controle",
    path: "/estruturas_de_controle",
    icon: "git-branch",
    children: [
      { title: "Condicional", path: "/condicional", icon: "help-circle" },
      { title: "Condicional Ternária", path: "/condicional_ternaria", icon: "circle" },
      { title: "Loop While", path: "/loop_while", icon: "repeat-1" },
      { title: "Loop Do While", path: "/loop_do_while", icon: "repeat" },
      { title: "Loop For", path: "/loop_for", icon: "repeat" },
      { title: "Loop For Incremento", path: "/loop_for_incremento", icon: "arrow-up-circle" },
      { title: "Loop For Decremento", path: "/loop_for_decremento", icon: "arrow-down-circle" },
      { title: "Loop For estilo C", path: "/loop_for_estiloC", icon: "code-2" },
      { title: "Switch Case", path: "/switch_case", icon: "toggle-left" },
      { title: "Controle de Loop", path: "/controle_loop", icon: "sliders" },
      { title: "Break", path: "/break", icon: "corner-up-left" },
      { title: "Continue", path: "/continue", icon: "corner-up-right" },
    ],
  },

  // FUNÇÕES
  {
    title: "Funções",
    path: "/funcoes",
    icon: "function-square",
    children: [
      { title: "Função Vazia", path: "/funcao_vazia", icon: "circle" },
      { title: "Função com Retorno", path: "/funcao_retorno", icon: "arrow-right-circle" },
      { title: "Função Recursiva", path: "/funcao_recursiva", icon: "repeat" },
      { title: "Função Mista", path: "/funcao_mista", icon: "code-square" },
    ],
  },

  // SISTEMA DE IMPORTS
  {
    title: "Sistema de Imports",
    path: "/sistema_imports",
    icon: "file-import",
    children: [
      { title: "Importação Básica", path: "/importacao_basico", icon: "file-plus" },
      { title: "Importação com Alias", path: "/importacao_alias", icon: "file-minus" },
      { title: "Exemplos de Import", path: "/import_exemplos", icon: "file-text" },
    ],
  },

  // ITENS GERAIS
  { title: "Biblioteca", path: "/biblioteca", icon: "layers" },
  { title: "Comentários", path: "/comentarios", icon: "message-square" },

  // GRAMÁTICA FORMAL
  {
    title: "Gramática Formal",
    path: "/gramatica_formal",
    icon: "file-text",
    children: [
      { title: "Estrutura Geral Programa", path: "/estrutura_geral_programa", icon: "file" },
      { title: "Instruções (Statements)", path: "/instrucoes_statements", icon: "file-text" },
      { title: "Expressões", path: "/expressoes", icon: "file-code" },
      { title: "Literais e Tokens", path: "/literais_tokens", icon: "file-text" },
    ],
  },

  // EXEMPLOS PRÁTICOS
  {
    title: "Exemplos Práticos",
    path: "/exemplos_praticos",
    icon: "code",
    children: [
      { title: "Programa Básico", path: "/exemplo1_programa_basico", icon: "terminal" },
      { title: "Estruturas de Controle", path: "/exemplo2_estruturas_de_controle", icon: "code-square" },
      { title: "Funções", path: "/exemplo3_funcoes", icon: "function-square" },
      { title: "Switch/Case", path: "/exemplo4_switch_case", icon: "git-branch" },
      { title: "Sistema de Imports", path: "/exemplo5_imports", icon: "file-import" },
      { title: "Recursividade", path: "/exemplo6_recursividade", icon: "repeat" },
    ],
  },

  // CONTRIBUIÇÃO
  { title: "Como Contribuir", path: "/como_contribuir", icon: "heart" },
  { title: "Licença", path: "/licenca", icon: "gavel" },
  { title: "Sobre", path: "/sobre", icon: "info" },

],

  /* ─────────────────────────────────────────────────────────────────────────────
     PATROCÍNIO / SPONSOR / GITHUB

  ───────────────────────────────────────────────────────────────────────────── */
  sponsor: {
    enabled: true, // Habilita botão de patrocínio
    title: "Github LiPo",
    link: "https://github.com/karlaycosta/lipo_compiler",
  },

  /* ─────────────────────────────────────────────────────────────────────────────
     RODAPÉ
     Texto exibido no final de todas as páginas
  ───────────────────────────────────────────────────────────────────────────── */
  footer: `© ${new Date().getFullYear()} LiPo Docs — Desenvolvido com todo carinho`,

  /* ─────────────────────────────────────────────────────────────────────────────
     FAVICON
     Ícone exibido na aba do navegador (redundante para segurança)
  ───────────────────────────────────────────────────────────────────────────── */
  favicon: "/assets/icon/favico.svg",
};
