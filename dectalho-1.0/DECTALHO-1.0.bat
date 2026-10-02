@echo off

title DECTALHO CRIADOR DE ATALHO 1.0
echo --------------------------------------------------------------------
echo                 DECTALHO CRIADOR DE ATALHO 1.0                     
echo --------------------------------------------------------------------
setlocal
set /p "NOME=NOME DO ATALHO: "
echo --------------------------------------------------------------------
set /p "URL=ENDERECO DO SITE: "
echo --------------------------------------------------------------------

powershell -NoProfile -Command "$ws = New-Object -ComObject WScript.Shell; $lnk = $ws.CreateShortcut([Environment]::GetFolderPath('Desktop') + '\%NOME%.lnk'); $lnk.TargetPath = 'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe'; $lnk.Arguments = '--app=%URL%'; $lnk.Save()"

echo.
echo FAVICON NAO ENCONTRADO - USANDO ICONE DO NAVEGADOR!
echo.
echo ATALHO "%NOME%" CRIADO NA AREA DE TRABALHO!
echo.
pause