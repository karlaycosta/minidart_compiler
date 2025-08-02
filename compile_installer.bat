@echo off
echo Compilando instalador LiPo...
echo.

REM Verificar se NSIS esta instalado
where makensis >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo NSIS nao encontrado!
    pause
    exit /b 1
)

echo Criando instalador...
makensis installer.nsi
if %ERRORLEVEL% NEQ 0 (
    echo Erro ao compilar o instalador
    pause
    exit /b 1
)

echo Instalador compilado com sucesso!
pause
