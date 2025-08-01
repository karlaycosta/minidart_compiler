// config.js: basic config for docmd
module.exports = {
  // Core Site Metadata
  siteTitle: 'Lipo',
  // Define a base URL for your site, crucial for SEO and absolute paths
  // No trailing slash
  siteUrl: 'https://karlaycosta.github.io/minidart_compiler', // Replace with your actual deployed URL

  // Logo Configuration
  logo: {
    light: '/assets/images/docmd-logo-light.png', // Path relative to outputDir root
    dark: '/assets/images/docmd-logo-dark.png',   // Path relative to outputDir root
    alt: 'lipo  logo',                      // Alt text for the logo
    href: '/',                              // Link for the logo, defaults to site root
  },

  // Directory Configuration
  srcDir: 'docs',       // Source directory for Markdown files
  outputDir: 'site',    // Directory for generated static site

  // Sidebar Configuration
  sidebar: {
    collapsible: true,        // or false to disable
    defaultCollapsed: false,  // or true to start collapsed
  },

  // Theme Configuration
  theme: {
    name: 'ruby',            // Themes: 'default', 'sky'
    defaultMode: 'light',   // Initial color mode: 'light' or 'dark'
    enableModeToggle: true, // Show UI button to toggle light/dark modes
    positionMode: 'bottom', // 'top' or 'bottom' for the theme toggle
    customCss: [            // Array of paths to custom CSS files
      // '/assets/css/custom.css', // Custom TOC styles
    ]
  },

  // Custom JavaScript Files
  customJs: [  // Array of paths to custom JS files, loaded at end of body
    // '/assets/js/custom-script.js', // Paths relative to outputDir root
    '/assets/js/docmd-image-lightbox.js', // Image lightbox functionality
  ],

  // Content Processing
  autoTitleFromH1: true, // Set to true to automatically use the first H1 as page title

  // Plugins Configuration
  // Plugins are configured here. docmd will look for these keys.
  plugins: {
    // SEO Plugin Configuration
    // Most SEO data is pulled from page frontmatter (title, description, image, etc.)
    // These are fallbacks or site-wide settings.
    seo: {
      // Default meta description if a page doesn't have one in its frontmatter
      defaultDescription: 'docmd is a Node.js command-line tool for generating beautiful, lightweight static documentation sites from Markdown files.',
      openGraph: { // For Facebook, LinkedIn, etc.
        // siteName: 'docmd Documentation', // Optional, defaults to config.siteTitle
        // Default image for og:image if not specified in page frontmatter
        // Path relative to outputDir root
        defaultImage: '/assets/images/docmd-preview.png',
      },
      twitter: { // For Twitter Cards
        cardType: 'summary_large_image',     // 'summary', 'summary_large_image'
        // siteUsername: '@docmd_handle',    // Your site's Twitter handle (optional)
        // creatorUsername: '@your_handle',  // Default author handle (optional, can be overridden in frontmatter)
      }
    },
    // Analytics Plugin Configuration
    analytics: {
      // Google Analytics 4 (GA4)
      googleV4: {
        measurementId: 'G-8QVBDQ4KM1' // Replace with your actual GA4 Measurement ID
      }
    },
    // Enable Sitemap plugin
    sitemap: {
      defaultChangefreq: 'weekly',
      defaultPriority: 0.8
    }
    // Add other future plugin configurations here by their key
  },

  // Navigation Structure (Sidebar)
  // Icons are kebab-case names from Lucide Icons (https://lucide.dev/)
  navigation: [
      { title: 'Welcome', path: '/', icon: 'home' }, // Corresponds to docs/index.md
      { title: 'Tipos ', path: '/tipo_dados', icon: 'list' },

      {
        title: 'Getting Started',
        icon: 'rocket',
        path: '#',
        children: [
          { title: 'Documentation', path: 'https://docmd.mgks.dev', icon: 'scroll', external: true },
          { title: 'Installation', path: 'https://docmd.mgks.dev/getting-started/installation', icon: 'download', external: true },
          { title: 'Basic Usage', path: 'https://docmd.mgks.dev/getting-started/basic-usage', icon: 'play', external: true },
          { title: 'Content', path: 'https://docmd.mgks.dev/content', icon: 'layout-template', external: true },
        ],
      },
      // External links:
      { title: 'GitHub', path: 'https://github.com/mgks/docmd', icon: 'github', external: true },
      { title: 'Support the Project', path: 'https://github.com/sponsors/mgks', icon: 'heart', external: true },
    ],

  // Sponsor Ribbon Configuration
  Sponsor: {
    enabled: false,
    title: 'Support docmd',
    link: 'https://github.com/sponsors/mgks',
  },

  // Footer Configuration
  // Markdown is supported here.
  footer: '© ' + new Date().getFullYear() + ' Project.',

  // Favicon Configuration
  // Path relative to outputDir root
  favicon: '/assets/favicon.ico',
};
