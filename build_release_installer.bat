@echo off
echo 🚀 === MINIDART RELEASE COM INSTALADOR ===
echo.

REM Verificar se NSIS está instalado
where makensis >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ NSIS não encontrado!
    echo 📥 Instale o NSIS de: https://nsis.sourceforge.io/Download
    echo 💡 Ou use: choco install nsis
    pause
    exit /b 1
)

REM Executar build básico
echo 🔨 Executando build básico...
call build_release.bat
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Erro no build básico
    exit /b 1
)

REM Copiar documentação adicional para release
echo 📚 Copiando documentação adicional...
copy LICENSE release\ >nul
if exist CHANGELOG.md copy CHANGELOG.md release\ >nul
if exist README.md copy README.md release\ >nul

REM Criar o instalador NSIS
echo 🛠️  Criando instalador Windows...
makensis installer.nsi
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Erro ao criar instalador
    exit /b 1
)

REM Mover instalador para pasta release
if exist "MiniDart-Installer-v0.18.1.exe" (
    move "MiniDart-Installer-v0.18.1.exe" release\ >nul
    echo ✅ Instalador criado: release/MiniDart-Installer-v0.18.1.exe
)

REM Mostrar resumo final
echo.
echo ✅ === RELEASE COMPLETO CRIADO ===
echo 📁 Arquivos em release/:
dir release /B
echo.
echo 📦 Release contém:
echo    ✅ minidart-windows-x64.exe (executável)
echo    ✅ MiniDart-Installer-v0.18.1.exe (instalador)
echo    ✅ VERSION.txt (informações de versão)
echo    ✅ exemplos/ (códigos de exemplo)
echo    ✅ documentação completa
echo.
echo 🎯 Próximos passos para GitHub Release:
echo    1. git add .
echo    2. git commit -m "Release v0.18.1"
echo    3. git tag v0.18.1
echo    4. git push origin v0.18.1
echo    5. Criar release no GitHub e enviar arquivos da pasta release/
echo.
pause
