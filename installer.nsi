; MiniDart Compiler Installer
; Instala o compilador MiniDart para Windows

;--------------------------------
; Configurações gerais

!define PRODUCT_NAME "MiniDart Compiler"
!define PRODUCT_VERSION "0.18.1"
!define PRODUCT_PUBLISHER "Deriks Karlay Dias Costa"
!define PRODUCT_WEB_SITE "https://github.com/karlaycosta/minidart_compiler"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\minidart.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

Name "${PRODUCT_NAME} v${PRODUCT_VERSION}"
OutFile "MiniDart-Installer-v${PRODUCT_VERSION}.exe"
InstallDir "$PROGRAMFILES\MiniDart"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
DirText "Escolha o diretório onde deseja instalar o ${PRODUCT_NAME}:"
ShowInstDetails show
ShowUnInstDetails show
RequestExecutionLevel admin

;--------------------------------
; Interface moderna
!include "MUI2.nsh"

; Configurações da interface
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

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
!insertmacro MUI_LANGUAGE "Portuguese"

;--------------------------------
; Seções de instalação

Section "MiniDart Compiler (Obrigatório)" SEC01
  SectionIn RO
  
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  File "release\minidart-windows-x64.exe"
  CreateShortCut "$INSTDIR\minidart.exe" "$INSTDIR\minidart-windows-x64.exe"
  File "release\VERSION.txt"
  File "README.md"
  File "DOCUMENTACAO_SINTAXE_MINIDART.md"
  
  SetOutPath "$INSTDIR\exemplos"
  File /r "release\exemplos\*.*"
SectionEnd

Section "Adicionar ao PATH do Sistema" SEC02
  ; Adicionar ao PATH do sistema
  nsExec::ExecToLog 'powershell -Command "$env:PATH += \";$INSTDIR\"; [Environment]::SetEnvironmentVariable(\"PATH\", $env:PATH, \"Machine\")"'
SectionEnd

Section "Atalhos no Menu Iniciar" SEC03
  CreateDirectory "$SMPROGRAMS\MiniDart"
  CreateShortCut "$SMPROGRAMS\MiniDart\MiniDart Compiler.lnk" "$INSTDIR\minidart.exe"
  CreateShortCut "$SMPROGRAMS\MiniDart\Documentação.lnk" "$INSTDIR\DOCUMENTACAO_SINTAXE_MINIDART.md"
  CreateShortCut "$SMPROGRAMS\MiniDart\Exemplos.lnk" "$INSTDIR\exemplos"
  CreateShortCut "$SMPROGRAMS\MiniDart\Desinstalar.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section "Atalho na Área de Trabalho" SEC04
  CreateShortCut "$DESKTOP\MiniDart Compiler.lnk" "$INSTDIR\minidart.exe"
SectionEnd

;--------------------------------
; Descrições das seções

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC01} "Instala o compilador MiniDart e documentação essencial."
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC02} "Adiciona MiniDart ao PATH do sistema para uso global."
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC03} "Cria atalhos no Menu Iniciar."
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC04} "Cria atalho na Área de Trabalho."
!insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
; Pós-instalação

Section -AdditionalIcons
  WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateShortCut "$SMPROGRAMS\MiniDart\Website.lnk" "$INSTDIR\${PRODUCT_NAME}.url"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\minidart.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\minidart.exe"
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
  Delete "$INSTDIR\minidart.exe"
  Delete "$INSTDIR\minidart-windows-x64.exe"
  Delete "$INSTDIR\VERSION.txt"
  Delete "$INSTDIR\README.md"
  Delete "$INSTDIR\DOCUMENTACAO_SINTAXE_MINIDART.md"

  Delete "$SMPROGRAMS\MiniDart\MiniDart Compiler.lnk"
  Delete "$SMPROGRAMS\MiniDart\Documentação.lnk"
  Delete "$SMPROGRAMS\MiniDart\Exemplos.lnk"
  Delete "$SMPROGRAMS\MiniDart\Website.lnk"
  Delete "$SMPROGRAMS\MiniDart\Desinstalar.lnk"
  Delete "$DESKTOP\MiniDart Compiler.lnk"

  RMDir /r "$INSTDIR\exemplos"
  RMDir "$SMPROGRAMS\MiniDart"
  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd
