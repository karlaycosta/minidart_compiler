; Script do Inno Setup para LiPo Compiler
; Corrigido e melhorado - Versão dinâmica via parâmetro

; Permite versão dinâmica via parâmetro /DVERSION="x.x.x"
#ifndef VERSION
  #define VERSION "0.0.0"
#endif

#define MyAppName "LiPo Compiler"
#define MyAppVersion VERSION
#define MyAppPublisher "Deriks Karlay Dias Costa"
#define MyAppURL "https://github.com/karlaycosta/minidart_compiler"
#define MyAppExeName "lipo.exe"

[Setup]
AppId={{A7B2C4D6-E8F0-1234-5678-9ABCDEF01234}}
AppName={#MyAppName} v{#MyAppVersion}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} v{#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
AppCopyright=© 2025 {#MyAppPublisher}
VersionInfoVersion={#MyAppVersion}
VersionInfoCompany={#MyAppPublisher}
VersionInfoDescription=Compilador para linguagem LiPo - Linguagem Portugol
VersionInfoCopyright=© 2025 {#MyAppPublisher}
VersionInfoProductName={#MyAppName}
VersionInfoProductVersion={#MyAppVersion}

DefaultDirName={autopf64}\lipo
DefaultGroupName=LiPo
AllowNoIcons=yes
LicenseFile=LICENSE
OutputDir=.
OutputBaseFilename=LiPo-Installer-v{#MyAppVersion}
SetupIconFile=icons\favicon.ico
UninstallDisplayIcon={app}\{#MyAppExeName}
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=admin
ArchitecturesInstallIn64BitMode=x64os

WizardImageFile=icons\welcome.bmp
WizardSmallImageFile=icons\header.bmp
WizardImageStretch=yes
DisableWelcomePage=no
MinVersion=10.0
CloseApplications=yes
RestartApplications=yes

[Languages]
Name: "portuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Tasks]
Name: "addtopath"; Description: "Adicionar LiPo ao PATH do sistema (recomendado)"; GroupDescription: "Opções do sistema:"

[Files]
Source: "release\lipo.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "release\VERSION.txt"; DestDir: "{app}"; Flags: ignoreversion
Source: "README.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "CHANGELOG.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "LICENSE"; DestDir: "{app}"; Flags: ignoreversion

[Registry]
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\{#MyAppExeName}"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName}"; Flags: uninsdeletekey
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\{#MyAppExeName}"; ValueType: string; ValueName: "Path"; ValueData: "{app}"; Flags: uninsdeletekey

[Code]
procedure AddToPath();
var
  Path, AppDir: string;
begin
  AppDir := ExpandConstant('{app}');
  if RegQueryStringValue(HKEY_LOCAL_MACHINE, 'SYSTEM\CurrentControlSet\Control\Session Manager\Environment', 'Path', Path) then
  begin
    if Copy(Path, Length(Path), 1) <> ';' then
      Path := Path + ';';
    if Pos(UpperCase(AppDir), UpperCase(Path)) = 0 then
    begin
      Path := Path + AppDir;
      RegWriteStringValue(HKEY_LOCAL_MACHINE, 'SYSTEM\CurrentControlSet\Control\Session Manager\Environment', 'Path', Path);
    end;
  end;
end;

procedure RemoveFromPath();
var
  Path, AppDir, NewPath: string;
  P: Integer;
begin
  AppDir := ExpandConstant('{app}');
  if RegQueryStringValue(HKEY_LOCAL_MACHINE, 'SYSTEM\CurrentControlSet\Control\Session Manager\Environment', 'Path', Path) then
  begin
    NewPath := Path;
    repeat
      P := Pos(UpperCase(';' + AppDir), UpperCase(NewPath));
      if P > 0 then
        Delete(NewPath, P, Length(AppDir) + 1)
      else
      begin
        P := Pos(UpperCase(AppDir + ';'), UpperCase(NewPath));
        if P > 0 then
          Delete(NewPath, P, Length(AppDir) + 1)
        else
        begin
          P := Pos(UpperCase(AppDir), UpperCase(NewPath));
          if P = 1 then
            Delete(NewPath, P, Length(AppDir));
        end;
      end;
    until P = 0;
    RegWriteStringValue(HKEY_LOCAL_MACHINE, 'SYSTEM\CurrentControlSet\Control\Session Manager\Environment', 'Path', NewPath);
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if (CurStep = ssPostInstall) and WizardIsTaskSelected('addtopath') then
    AddToPath();
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usPostUninstall then
    RemoveFromPath();
end;

[UninstallDelete]
Type: files; Name: "{app}\*.log"
Type: files; Name: "{app}\*.tmp"

[Messages]
WelcomeLabel1=Bem-vindo ao Assistente de Instalação do [name]
WelcomeLabel2=Este programa instalará o [name/ver] em seu computador.%n%nO LiPo é uma linguagem de programação educacional em português, ideal para aprender programação.%n%nÉ recomendado que você feche todos os outros aplicativos antes de continuar.
ClickNext=Clique em Avançar para continuar, ou Cancelar para sair da instalação.
BeveledLabel=LiPo Compiler - Linguagem educacional em português
