@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

echo === LIPO RELEASE COM INSTALADOR ===
echo.

REM Extrair versão do pubspec.yaml
echo Extraindo versão do pubspec.yaml...
set "version="
for /f "tokens=2 delims=: " %%a in ('findstr /r "^version:" pubspec.yaml') do (
    set "version=%%a"
)

if "!version!"=="" (
    echo Erro: Não foi possível extrair a versão do pubspec.yaml
    exit /b 1
)

echo Versão detectada: v!version!
echo.

REM Verifica se o Inno Setup está instalado
set "INNO_PATH=C:\Program Files (x86)\Inno Setup 6\ISCC.exe"
echo Verificando Inno Setup em: %INNO_PATH%
if not exist "%INNO_PATH%" (
    echo Inno Setup não encontrado
    echo.
    echo Baixe e instale o Inno Setup 6:
    echo Instale de: https://jrsoftware.org/isdl.php
    pause
    exit /b 1
)

REM Executar build básico
echo Executando build básico...
call build_release.bat
if %ERRORLEVEL% NEQ 0 (
    echo Erro no build básico
    exit /b 1
)

REM Copiar documentação adicional para release
echo Copiando documentação adicional...
if exist LICENSE copy LICENSE release\ >nul
if exist CHANGELOG.md copy CHANGELOG.md release\ >nul
if exist README.md copy README.md release\ >nul

REM Compila o instalador
echo Compilando instalador Windows...
"%INNO_PATH%" "/DVERSION=!version!" "installer.iss"
if %ERRORLEVEL% NEQ 0 (
    echo Erro ao criar instalador
    exit /b 1
)
echo Instalador compilado com versão v!version!

REM Mover instalador para pasta release
if exist "LiPo-Installer-v!version!.exe" (
    move "LiPo-Installer-v!version!.exe" release\ >nul
    echo Instalador criado: release/LiPo-Installer-v!version!.exe
)

REM Mostrar resumo final
echo.
echo === RELEASE COMPLETO CRIADO ===
echo Arquivos em release/:
dir release /B
echo.
echo Release contém:
echo    - lipo.exe (executável)
echo    - LiPo-Installer-v!version!.exe (instalador)
echo    - VERSION.txt (informações de versão)
echo    - LICENSE (Arquivo de Licença)
echo    - CHANGELOG.md (Registro de alterações)
echo    - README.md (Leia-me)
echo.
echo Próximos passos para GitHub Release:
echo    1. git add .
echo    2. git commit -m "Release v!version!"
echo    3. git tag v!version!
echo    4. git push origin v!version!
echo    5. Criar release no GitHub e enviar arquivos da pasta release/
echo.
REM pause