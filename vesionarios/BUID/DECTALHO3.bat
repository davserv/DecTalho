@echo off

title DECTALHO CRIADOR DE ATALHO
echo ------------------------------
echo  DECTALHO CRIADOR DE ATALHO 
echo ------------------------------
setlocal
set /p "NOME=NOME DO ATALHO: "
echo ------------------------------------------------------
set /p "URL=ENDERECO DO SITE: "
echo ------------------------------------------------------

:: Executa PowerShell automaticamente
powershell -ExecutionPolicy Bypass -File .\criar-atalho-app.ps1 -Nome "%NOME%" -Url "%URL%"

pause