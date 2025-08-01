// config.js: configuração básica para o docmd

module.exports = {
  // Metadados principais do site
  siteTitle: 'LIPO | DOC',
  siteUrl: 'https://karlaycosta.github.io/minidart_compiler', // Sem barra no final
  favicon: '/assets/icon/favico.svg',
  // Configuração do logo
  logo: {
    light: '',  // Caminho vazio para não carregar imagem no modo claro
    dark: '',   // Caminho vazio para não carregar imagem no modo escuro
    alt: 'LiPo Docs',
    href: '/',
  },

  // Diretórios
  srcDir: 'docs',       // Pasta dos arquivos .md
  outputDir: 'site',    // Pasta de saída

  // Configuração da barra lateral
  sidebar: {
    collapsible: true,
    defaultCollapsed: false,
  },

  // Tema
  theme: {
    name: 'sky',
    defaultMode: 'light',
    enableModeToggle: true,
    positionMode: 'top',
    customCss: [
      // Adicione caminhos para arquivos CSS personalizados aqui
    ],
  },

  // Scripts JS personalizados
  customJs: [
    '/assets/js/docmd-image-lightbox.js',
  ],

  // Processamento de conteúdo
  autoTitleFromH1: false,

  // Servidor local de desenvolvimento
  devServer: {
    host: '0.0.0.0',
    port: 3000,
  },

  // Plugins
  plugins: {
    seo: {
      defaultDescription: '',
      openGraph: {
        defaultImage: '/assets/images/logo2.png',
      },
      twitter: {
        cardType: 'summary_large_image',
      },
    },
    analytics: {
      googleV4: {
        measurementId: 'G-8QVBDQ4KM1',
      },
    },
    sitemap: {
      defaultChangefreq: 'weekly',
      defaultPriority: 0.8,
    },
  },

  // Navegação lateral (sidebar)
  navigation: [

  {
    title: 'Início',
    path: '/',
    icon: 'book-open', // Página inicial
  },
  {
    title: 'Estrutura Léxica',
    path: '/estrutura_lexica',
    icon: 'file-code', // Representa código e sintaxe
  },
  {
    title: 'Identificadores',
    path: '/identificadores',
    icon: 'tag', // Ícone clássico para identificadores
  },
  {
    title: 'Palavra Reservada', 
    path: '/palavra_reservada', 
    icon: 'key', // Palavra-chave
  },
  {
    title: 'Tipos de Dados',
    path: '/tipo_de_dados',
    icon: 'database', // Dado/armazenamento
  },
  {
    title: 'Conversão',
    path: '/conversao',
    icon: 'shuffle', // Conversão entre tipos
  },
  {
    title: 'Variáveis e Constantes',
    path: '/variaveis_constantes',
    icon: 'box', // Representa armazenamento fixo ou variável
    children: [
      {
        title: 'Declaração de Variáveis',
        path: '/declaracao_variaveis',
        icon: 'file-plus', // Adição de variável
      },
      {
        title: 'Declaração de Constantes',
        path: '/declaracao_constantes',
        icon: 'lock', // Constante = valor fixo
      },
    ],
  },
  {
    title: 'Operadores',
    path: '/operadores',
    icon: 'function-square', // Representa operação lógica ou matemática
    children: [
      {
        title: 'Operadores Aritméticos',
        path: '/operadores_aritmeticos',
        icon: 'divide', // Operação matemática
      },
      {
        title: 'Comparação',
        path: '/comparacao',
        icon: 'equal', // Comparações
      },
      {
        title: 'Lógicos',
        path: '/logicos',
        icon: 'circuit-board', // Lógica/eletrônica
      },
      {
        title: 'Atribuição',
        path: '/atribuicao',
        icon: 'arrow-right-left', // Transferência de valor
      },
      {
        title: 'Incremento/Decremento',
        path: '/incremento_decremento',
        icon: 'plus-minus', // Aumentar/diminuir
      },
      {
        title: 'Operador typeof',
        path: '/operador_tipode',
        icon: 'info', // Informação sobre o tipo
      },
      {
        title: 'Precedência de Operadores',
        path: '/precedencia_operadores',
        icon: 'list-order', // Ordem de prioridade
      },
    ],
  },
  {
    title: 'Estruturas de Controle',
    path: '/estruturas_de_controle',
    icon: 'git-branch', // Fluxo/decisão
    children: [
      {
        title: 'Condicional',
        path: '/condicional',
        icon: 'help-circle', // Decisão binária
      },
      {
        title: 'Condicional Ternária',
        path: '/condicional_ternaria',
        icon: 'circle-split', // 3 caminhos possíveis
      },
      {
        title: 'Loop While',
        path: '/loop_while',
        icon: 'repeat-1', // Repetição
      },
      {
        title: 'Loop Do While',
        path: '/loop_do_while',
        icon: 'refresh-ccw', // Repetição garantida ao menos uma vez
      },
      {
        title: 'Loop For',
        path: '/loop_for',
        icon: 'repeat', // Loop fixo
      },
      {
        title: 'Loop For Incremento',
        path: '/loop_for_incremento',
        icon: 'arrow-up-circle', // Incremento
      },
      {
        title: 'Loop For Decremento',
        path: '/loop_for_decremento',
        icon: 'arrow-down-circle', // Decremento
      },
      {
        title: 'Loop For estilo C',
        path: '/loop_for_estiloC',
        icon: 'code-2', // Estilo sintático
      },
    {
        title: 'Switch Case',
        path: '/switch_case',
        icon: 'toggle-left', // Alternância entre casos (switch)
      },
      {
        title: 'Controle de Loop',
        path: '/controle_loop',
        icon: 'square', // Representa interrupção (ex: break/stop)
      },
      {
        title: 'Break',
        path: '/break',
        icon: 'square', // Representa interrupção (ex: break/stop)
      },
       {
        title: 'Continue',
        path: '/continue',
        icon: 'square', // Representa interrupção (ex: break/stop)
      },
      { title: 'GitHub', path: 'https://github.com/karlaycosta/lipo_compiler', icon: 'github', external: true },
    ],
    
  },
],


    
  

  // Faixa de patrocínio (desativada)
  /*
  Sponsor: {
    enabled: false,
    title: 'Support docmd',
    link: 'https://github.com/sponsors/mgks',
  },
  */

  // Rodapé
  footer: '© ' + new Date().getFullYear() + ' LiPo Docs — Desenvolvido com ❤️',

  // Ícone de aba (favicon)
  favicon: '/assets/icon/favico.svg',
};
