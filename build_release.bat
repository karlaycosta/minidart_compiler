@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

echo === LIPO COMPILER RELEASE BUILD ===
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

REM Criar diretório de release
if not exist "release" mkdir release

REM Compilar para Windows
echo Compilando LiPo para Windows x64...
dart compile exe bin/compile.dart -o release/lipo.exe
if %ERRORLEVEL% NEQ 0 (
    echo Erro na compilação para Windows
    exit /b 1
)
echo Executável Windows gerado: release/lipo.exe

REM Criar arquivo de versão
echo Criando arquivo de versão...
dart bin/compile.dart --version > release/VERSION.txt
echo Arquivo de versão criado: release/VERSION.txt

REM Mostrar resumo do release
echo.
echo === RELEASE BUILD CONCLUÍDO ===
echo Versão: v!version!
echo Arquivos gerados em: release/
echo.
echo Conteúdo do release:
dir release /B
echo.
echo  Para criar o release no GitHub:
echo    1. git tag v!version!
echo    2. git push origin v!version!
echo    3. Enviar arquivos da pasta release/
echo.
REM pause
