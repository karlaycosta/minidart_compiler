/// Arquivo central de versionamento do MiniDart Compiler
/// 
/// Todas as referências à versão do projeto devem usar esta constante
/// para manter consistência e facilitar atualizações.
/// 
/// Versão atual do MiniDart Compiler
/// 
/// Formato: MAJOR.MINOR.PATCH seguindo Semantic Versioning
/// - MAJOR: Mudanças incompatíveis na API
/// - MINOR: Funcionalidades adicionadas de forma compatível
/// - PATCH: Correções de bugs compatíveis
const String version = r'1.17.1';

/// Obter versão formatada para exibição
String get versionString => 'v$version';

/// Obter versão completa com prefixo
String get fullVersionString => 'MiniDart Compiler v$version';