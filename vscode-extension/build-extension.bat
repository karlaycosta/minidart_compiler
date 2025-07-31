@echo off
echo.
echo ========================================
echo  MiniDart VS Code Extension Builder
echo ========================================
echo.

REM Verificar se vsce está instalado
where vsce >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [INFO] Instalando @vscode/vsce...
    npm install -g @vscode/vsce
    if %ERRORLEVEL% NEQ 0 (
        echo [ERRO] Falha ao instalar vsce
        pause
        exit /b 1
    )
)

echo [INFO] Compilando extensão...
call npm run compile
if %ERRORLEVEL% NEQ 0 (
    echo [ERRO] Falha na compilação
    pause
    exit /b 1
)

echo.
echo [INFO] Gerando pacote VSIX...
vsce package --allow-missing-repository
if %ERRORLEVEL% NEQ 0 (
    echo [ERRO] Falha ao gerar pacote VSIX
    pause
    exit /b 1
)

echo.
echo [SUCESSO] Pacote VSIX gerado com sucesso!
echo.
echo Para instalar a extensão:
echo   code --install-extension minidart-2.1.0.vsix
echo.
echo Para publicar no marketplace:
echo   vsce login your-publisher-name
echo   vsce publish
echo.
pause
