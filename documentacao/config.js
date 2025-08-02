/* ═══════════════════════════════════════════════════════════════════════════════
   config.js - Configuração Principal do DocMD para o Projeto LiPo Docs
═══════════════════════════════════════════════════════════════════════════════ */

module.exports = {

  /* ─────────────────────────────────────────────────────────────────────────────
     METADADOS DO SITE
     Configurações básicas de identificação e SEO do site
  ───────────────────────────────────────────────────────────────────────────── */
  siteTitle: 'LiPo | DOC',
  siteUrl: 'https://karlaycosta.github.io/minidart_compiler',
  favicon: '/assets/icon/favico.svg',

  /* ─────────────────────────────────────────────────────────────────────────────
     CONFIGURAÇÃO DO LOGOTIPO
     Define as imagens do logo para diferentes temas
  ───────────────────────────────────────────────────────────────────────────── */
  logo: {
    light: '',              /* Caminho para logo no modo claro */
    dark: '',               /* Caminho para logo no modo escuro */
    alt: 'LiPo Docs',       /* Texto alternativo para acessibilidade */
    href: '/',              /* Link de redirecionamento (geralmente para home) */
  },

  /* ─────────────────────────────────────────────────────────────────────────────
     ESTRUTURA DE DIRETÓRIOS
     Define onde estão os arquivos fonte e onde será gerado o build
  ───────────────────────────────────────────────────────────────────────────── */
  srcDir: 'docs',           /* Pasta contendo os arquivos .md de documentação */
  outputDir: 'site',        /* Pasta onde será gerado o site após o build */

  /* ─────────────────────────────────────────────────────────────────────────────
     CONFIGURAÇÃO DA BARRA LATERAL (SIDEBAR)
     Controla o comportamento da navegação lateral
  ───────────────────────────────────────────────────────────────────────────── */
  sidebar: {
    collapsible: false,       /* Permite colapsar/expandir seções */
    defaultCollapsed: false, /* Estado inicial das seções (expandidas por padrão) */
  },

  /* ──────────────────────────────────────────────────s───────────────────────────
     TEMA E APARÊNCIA
     Configurações visuais e de tema do site
  ───────────────────────────────────────────────────────────────────────────── */
  theme: {
    name: 'sky',                    /* Tema visual ('default', 'sky', 'ruby', 'retro') */
    defaultMode: 'light',           /* Modo padrão de exibição ('light' ou 'dark') */
    enableModeToggle: true,         /* Habilita botão para alternar entre temas */
    positionMode: 'top',            /* Posição do botão de tema ('top' ou 'bottom') */
    customCss: [
      /* Adicione aqui caminhos para arquivos CSS personalizados */
      /* Exemplo: '/assets/css/custom.css' */
    ],
  },

  /* ─────────────────────────────────────────────────────────────────────────────
     SCRIPTS PERSONALIZADOS
     JavaScript customizado para funcionalidades extras
  ───────────────────────────────────────────────────────────────────────────── */
  customJs: [
    '/assets/js/docmd-image-lightbox.js', /* Lightbox para visualização de imagens */
  ],

  /* ─────────────────────────────────────────────────────────────────────────────
     CONFIGURAÇÕES DE CONTEÚDO
     Controla como o conteúdo é processado e exibido
  ───────────────────────────────────────────────────────────────────────────── */
  autoTitleFromH1: false, /* Não gerar título automaticamente do H1 */


/* ─────────────────────────────────────────────────────────────────────────────
    SERVIDOR DE DESENVOLVIMENTO
   Configurações para o ambiente local de desenvolvimento
───────────────────────────────────────────────────────────────────────────── */

devServer: {
  host: '0.0.0.0',     // Permite acesso externo (útil para testes em rede)
  port: 3000           // Porta do servidor local
},

/* ─────────────────────────────────────────────────────────────────────────────
   COMPARTILHAMENTO REMOTO COM NGROK

   O Ngrok cria um túnel seguro do localhost para a internet, permitindo que 
   outras pessoas acessem seu projeto local por uma URL pública.

    ETAPAS PARA CONFIGURAR:
   ──────────────────────────────────────────────────────────────
   1. INSTALAÇÃO:
      • Via npm:             npm install -g ngrok
      • Ou via site:         https://ngrok.com/download

   2. CONFIGURAR CONTA (obrigatório):
      • Criar conta grátis:  https://dashboard.ngrok.com/signup
      • Obter seu token:     https://dashboard.ngrok.com/get-started/your-authtoken
      • Aplicar token:       ngrok config add-authtoken SEU_TOKEN_AQUI

   3. USO:
      • Rodar projeto:       npm run dev (na porta 3000)
      • Em outro terminal:   ngrok http 3000
      • Compartilhar a URL pública gerada (ex: https://abc123.ngrok.io)

   OBS;  POSSÍVEIS ERROS:
      • "authtoken required" → Execute o passo 2
      • "tunnel not found"   → Verifique se o servidor local está rodando
───────────────────────────────────────────────────────────────────────────── */

/* ─────────────────────────────────────────────────────────────────────────────
    PLUGINS E INTEGRAÇÕES
   Configurações extras como SEO, analytics, sitemap, etc.
───────────────────────────────────────────────────────────────────────────── */

plugins: {
  seo: {
    defaultTitle: 'LiPo | DOC',
    defaultDescription: 'Documentação oficial da linguagem LiPo.',
    titleTemplate: 'LiPo | DOC', // <-- isso força o título fixo
  },



  
      
       /* Twitter Cards   
      twitter: {
        cardType: 'summary_large_image', 
      },
    },
    */

    /* Analytics - Rastreamento de visitantes
    analytics: {
      googleV4: {
        measurementId: 'G-8QVBDQ4KM1', ID do Google Analytics 4 
      },
    }, */

    /* Sitemap - Mapa do site para SEO */ 

    sitemap: {
      defaultChangefreq: 'weekly',  /* Frequência de atualização das páginas */ 
      defaultPriority: 0.8,         /* Prioridade padrão das páginas (0.0 a 1.0) */   
    },
  },

  /*─────────────────────────────────────────────────────────────────────────────
   NAVEGAÇÃO PRINCIPAL (SIDEBAR)
   Estrutura hierárquica da documentação com ícones e links
   ─────────────────────────────────────────────────────────────────────────────    */ 

  navigation: [
    
    /* Página inicial */
    {
      title: 'Início',
      path: '/',
      icon: 'book-open', 
    },

    /* Estrutura básica da linguagem */
    {
      title: 'Estrutura Léxica',
      path: '/estrutura_lexica',
      icon: 'file-code', 
    },

    /* Sistema de identificação */
    {
      title: 'Identificadores',
      path: '/identificadores',
      icon: 'tag',  
    },

    /* Palavras reservadas da linguagem */ 
    {
      title: 'Palavra Reservada',
      path: '/palavra_reservada',
      icon: 'key',  
    },

   /* Sistema de tipos */
    {
      title: 'Tipos de Dados',
      path: '/tipo_de_dados',
      icon: 'database', 
    },

    /* Conversão entre tipos */
    {
      title: 'Conversão',
      path: '/conversao',
      icon: 'shuffle', 
    },

      /* Armazenamento de dados */ 
    {
      title: 'Variáveis e Constantes',
      path: '/variaveis_constantes',
      icon: 'box', 
      children: [
        {
          title: 'Declaração de Variáveis',
          path: '/declaracao_variaveis',
          icon: 'file-plus', 
        },
        {
          title: 'Declaração de Constantes',
          path: '/declaracao_constantes',
          icon: 'lock', 
        },
      ],
    },

    /* Sistema de operadores */
    {
      title: 'Operadores',
      path: '/operadores',
      icon: 'function-square',
      children: [
        {
          title: 'Operadores Aritméticos',
          path: '/operadores_aritmeticos',
          icon: 'divide', 
        },
        {
          title: 'Comparação',
          path: '/comparacao',
          icon: 'equal', 
        },
        {
          title: 'Lógicos',
          path: '/logicos',
          icon: 'circuit-board', 
        },
        {
          title: 'Atribuição',
          path: '/atribuicao',
          icon: 'arrow-right-left',
        },
        {
          title: 'Incremento/Decremento',
          path: '/incremento_decremento',
          icon: 'plus-minus', 
        },
        {
          title: 'Operador typeof',
          path: '/operador_tipode',
          icon: 'info', 
        },
        {
          title: 'Precedência de Operadores',
          path: '/precedencia_operadores',
          icon: 'list-order', 
        },
      ],
    },

    // Controle de fluxo
    {
      title: 'Estruturas de Controle',
      path: '/estruturas_de_controle',
      icon: 'git-branch', 
      children: [
        {
          title: 'Condicional',
          path: '/condicional',
          icon: 'help-circle',
        },
        {
          title: 'Condicional Ternária',
          path: '/condicional_ternaria',
          icon: 'circle-split',
        },
        {
          title: 'Loop While',
          path: '/loop_while',
          icon: 'repeat-1',
        },
        {
          title: 'Loop Do While',
          path: '/loop_do_while',
          icon: 'refresh-ccw', 
        },
        {
          title: 'Loop For',
          path: '/loop_for',
          icon: 'repeat', 
        },
        {
          title: 'Loop For Incremento',
          path: '/loop_for_incremento',
          icon: 'arrow-up-circle', 
        },
        {
          title: 'Loop For Decremento',
          path: '/loop_for_decremento',
          icon: 'arrow-down-circle', 
        },
        {
          title: 'Loop For estilo C',
          path: '/loop_for_estiloC',
          icon: 'code-2', 
        },
        {
          title: 'Switch Case',
          path: '/switch_case',
          icon: 'toggle-left', 
        },
        {
          title: 'Controle de Loop',
          path: '/controle_loop',
          icon: 'square', 
        },
        {
          title: 'Break',
          path: '/break',
          icon: 'square', 
        },
        {
          title: 'Continue',
          path: '/continue',
          icon: 'square', 
        },
        
        // Link externo para repositório
        {
          title: 'GitHub',
          path: 'https://github.com/karlaycosta/lipo_compiler',
          icon: 'github',
          external: true, 
        },
      ],
    },
  ],

   /* ─────────────────────────────────────────────────────────────────────────────
   FAIXA DE PATROCÍNIO (DESATIVADA)
   Seção para solicitar apoio financeiro ao projeto
   ─────────────────────────────────────────────────────────────────────────────

 
  sponsor: {
    enabled: false,                                    // Desabilitado por padrão
    title: 'Apoie o DocMD',                           // Texto do botão
    link: 'https://github.com/sponsors/mgks',         // Link para página de patrocínio
  },
  */

  /* ─────────────────────────────────────────────────────────────────────────────
   RODAPÉ
   Texto exibido no final de todas as páginas
   ───────────────────────────────────────────────────────────────────────────── */
  
  footer: `© ${new Date().getFullYear()} LiPo Docs — Desenvolvido com ❤️`,

  /*─────────────────────────────────────────────────────────────────────────────
  ÍCONE DA ABA (FAVICON)
  Ícone exibido na aba do navegador (definido novamente por segurança)
  ───────────────────────────────────────────────────────────────────────────── */
  favicon: '/assets/icon/favico.svg',
  }