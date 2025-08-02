; LiPo Compiler Installer
; Instala o compilador LiPo para Windows

Unicode True

;--------------------------------
; Configurações gerais

!define PRODUCT_NAME "LiPo Compiler"
!define PRODUCT_VERSION "0.18.1"
!define PRODUCT_PUBLISHER "Deriks Karlay Dias Costa"
!define PRODUCT_WEB_SITE "https://github.com/karlaycosta/minidart_compiler"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\lipo.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

Name "${PRODUCT_NAME} v${PRODUCT_VERSION}"
OutFile "LiPo-Installer-v${PRODUCT_VERSION}.exe"
InstallDir "$PROGRAMFILES64\lipo"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
DirText "Escolha o diretório onde deseja instalar o ${PRODUCT_NAME}:"
ShowInstDetails show
ShowUnInstDetails show
RequestExecutionLevel admin

; Configurações para reduzir falsos positivos
SetCompressor /SOLID lzma
SetCompressorDictSize 32
SetDatablockOptimize on
CRCCheck on

; Assinatura digital (descomente e configure quando tiver certificado)
;!finalize 'signtool.exe sign /f "certificado.p12" /p "senha" /t http://timestamp.comodoca.com/authenticode "%1"'

; Informações do instalador
VIProductVersion "0.18.1.0"
VIAddVersionKey "ProductName" "${PRODUCT_NAME}"
VIAddVersionKey "Comments" "Compilador para linguagem LiPo - Linguagem educacional em português"
VIAddVersionKey "CompanyName" "${PRODUCT_PUBLISHER}"
VIAddVersionKey "LegalCopyright" "© 2025 ${PRODUCT_PUBLISHER}"
VIAddVersionKey "FileDescription" "Instalador do LiPo Compiler"
VIAddVersionKey "FileVersion" "${PRODUCT_VERSION}"
VIAddVersionKey "ProductVersion" "${PRODUCT_VERSION}"
VIAddVersionKey "InternalName" "LiPoInstaller"
VIAddVersionKey "OriginalFilename" "LiPo-Installer-v${PRODUCT_VERSION}.exe"
VIAddVersionKey "LegalTrademarks" ""

;--------------------------------
; Interface moderna
!include "MUI2.nsh"

; Configurações da interface
!define MUI_ABORTWARNING

; Usar ícones padrão do sistema (mais compatível)
!define MUI_ICON "icons\favicon.ico"
!define MUI_UNICON "icons\favicon.ico"

; Imagens do cabeçalho (usar bitmaps padrão por compatibilidade)
;!define MUI_HEADERIMAGE 
;!define MUI_HEADERIMAGE_RIGHT 
;!define MUI_HEADERIMAGE_BITMAP 
!define MUI_WELCOMEFINISHPAGE_BITMAP "icons\welcome.bmp"

; Customização da página de boas-vindas
!define MUI_WELCOMEPAGE_TITLE "Bem-vindo ao Instalador do LiPo Compiler"
!define MUI_WELCOMEPAGE_TEXT "Este assistente irá guiá-lo através da instalação do LiPo Compiler.$\r$\n$\r$\nO LiPo é uma linguagem de programação educacional em português, ideal para aprender programação.$\r$\n$\r$\nClique em Avançar para continuar."

; Customização da página final
!define MUI_FINISHPAGE_TITLE "Instalação Concluída"
!define MUI_FINISHPAGE_TEXT "O LiPo Compiler foi instalado com sucesso em seu computador.$\r$\n$\r$\nClique em Concluir para fechar este assistente."
;!define MUI_FINISHPAGE_RUN "$INSTDIR\lipo.exe"
;!define MUI_FINISHPAGE_RUN_TEXT "Executar LiPo Compiler"
!define MUI_FINISHPAGE_LINK "Visite o site do projeto"
!define MUI_FINISHPAGE_LINK_LOCATION "${PRODUCT_WEB_SITE}"

; Páginas
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "LICENSE"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

; Páginas do desinstalador
!insertmacro MUI_UNPAGE_INSTFILES

; Idiomas
!insertmacro MUI_LANGUAGE "PortugueseBR"

;--------------------------------
; Seções de instalação

Section "LiPo Compiler (Obrigatório)" SEC01
  SectionIn RO
  
  SetRegView 64
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  File "release\lipo.exe"
  File "release\VERSION.txt"
  File "README.md"
  File "CHANGELOG.md"
  File "LICENSE"
  
;  SetOutPath "$INSTDIR\exemplos"
;  File /r "release\exemplos\*.*"
SectionEnd

Section "Adicionar ao PATH do Sistema" SEC02
  ; Adicionar ao PATH do sistema
  nsExec::ExecToLog 'powershell -Command "[Environment]::SetEnvironmentVariable(\"PATH\", [Environment]::GetEnvironmentVariable(\"PATH\", \"Machine\") + \";$INSTDIR\", \"Machine\")"'
SectionEnd

Section "Atalhos no Menu Iniciar" SEC03
  CreateDirectory "$SMPROGRAMS\lipo"
  CreateShortCut "$SMPROGRAMS\lipo\LiPo Compiler.lnk" "$INSTDIR\lipo.exe"
;  CreateShortCut "$SMPROGRAMS\lipo\Documentação.lnk" "$INSTDIR\DOCUMENTACAO_SINTAXE_MINIDART.md"
;  CreateShortCut "$SMPROGRAMS\lipo\Exemplos.lnk" "$INSTDIR\exemplos"
  CreateShortCut "$SMPROGRAMS\lipo\Desinstalar.lnk" "$INSTDIR\uninst.exe"
SectionEnd

;--------------------------------
; Descrições das seções

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC01} "Instala o compilador LiPo e documentação essencial."
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC02} "Adiciona LiPo ao PATH do sistema para uso global."
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC03} "Cria atalhos no Menu Iniciar."
!insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
; Pós-instalação

Section -AdditionalIcons
  WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateShortCut "$SMPROGRAMS\lipo\Website.lnk" "$INSTDIR\${PRODUCT_NAME}.url"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\lipo.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\lipo.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

;--------------------------------
; Desinstalador

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) foi removido com sucesso do seu computador."
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Tem certeza que deseja remover completamente $(^Name) e todos os seus componentes?" IDYES +2
  Abort
FunctionEnd

Section Uninstall
  Delete "$INSTDIR\${PRODUCT_NAME}.url"
  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR\lipo.exe"
  Delete "$INSTDIR\VERSION.txt"
  Delete "$INSTDIR\README.md"
  Delete "$INSTDIR\CHANGELOG.md"
  Delete "$INSTDIR\LICENSE"

  Delete "$SMPROGRAMS\lipo\LiPo Compiler.lnk"
;  Delete "$SMPROGRAMS\lipo\Documentação.lnk"
;  Delete "$SMPROGRAMS\lipo\Exemplos.lnk"
  Delete "$SMPROGRAMS\lipo\Website.lnk"
  Delete "$SMPROGRAMS\lipo\Desinstalar.lnk"

 ; RMDir /r "$INSTDIR\exemplos"
  RMDir "$SMPROGRAMS\lipo"
  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd