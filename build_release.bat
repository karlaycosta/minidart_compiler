@echo off
echo 🚀 === MINIDART COMPILER RELEASE BUILD ===
echo.

REM Criar diretório de release
if not exist "release" mkdir release

REM Compilar para Windows
echo 🏗️ Compilando MiniDart para Windows x64...
dart compile exe bin/compile.dart -o release/minidart-windows-x64.exe
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Erro na compilação para Windows
    exit /b 1
)
echo ✅ Executável Windows gerado: release/minidart-windows-x64.exe

REM Criar arquivo de versão
echo 📝 Criando arquivo de versão...
dart bin/compile.dart --version > release/VERSION.txt
echo ✅ Arquivo de versão criado: release/VERSION.txt

REM Copiar documentação
echo 📚 Copiando documentação...
copy README.md release/ >nul
copy DOCUMENTACAO_SINTAXE_MINIDART.md release/ >nul
copy CHANGELOG.md release/ >nul
echo ✅ Documentação copiada

REM Copiar exemplos
echo 📋 Copiando exemplos...
if exist exemplos (
    xcopy exemplos release\exemplos\ /E /I /Q >nul
    echo ✅ Exemplos copiados: release/exemplos/
) else (
    echo ⚠️  Pasta exemplos não encontrada - pulando...
)

REM Mostrar resumo do release
echo.
echo ✅ === RELEASE BUILD CONCLUÍDO ===
echo 📁 Arquivos gerados em: release/
echo.
echo 📦 Conteúdo do release:
dir release /B
echo.
echo 🎯 Para criar o release no GitHub:
echo    1. git tag v0.18.1
echo    2. git push origin v0.18.1
echo    3. Enviar arquivos da pasta release/
echo.
pause
