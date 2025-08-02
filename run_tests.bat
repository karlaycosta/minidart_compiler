@echo off
chcp 65001 > nul
title Testes da Linguagem LiPo
echo Executando Testes da Linguagem LiPo
echo =======================================

echo.
echo 1. Instalando dependências...
call dart pub get

echo.
echo 2. Executando testes unitários...
call dart test

echo.
echo 3. Executando testes completos...
call dart run test/run_tests.dart

echo.
echo Testes concluídos!
