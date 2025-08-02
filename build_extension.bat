@echo off
echo Compilando extensao LiPo...

cd vscode-extension

echo Instalando dependencias...
npm install

echo Compilando TypeScript...
npm run compile

echo Empacotando extensao...
vsce package

echo.
echo ========================================
echo   Extensao LiPo compilada com sucesso!
echo ========================================
echo.
echo Arquivo gerado: lipo-2.2.0.vsix
echo.
echo Para instalar:
echo   code --install-extension lipo-2.2.0.vsix
echo.
pause
