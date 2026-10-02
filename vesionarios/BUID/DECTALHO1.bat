@echo off
chcp 65001 >nul
set /p "NOME=Nome do atalho: "
set /p "URL=Endereco do site: "
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0criar-atalho-app.ps1" -Nome "%NOME%" -Url "%URL%"
pause