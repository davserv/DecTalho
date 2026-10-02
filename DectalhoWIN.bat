@echo off
title DECTALHO CRIADOR DE ATALHO

echo Iniciando...

:: Executa PowerShell automaticamente
powershell -NoProfile -ExecutionPolicy Bypass -Command "& '%~dp0dectalho.ps1'"

pause