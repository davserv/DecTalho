
Write-Host ""
Write-Host "
█████   ███████  █████  ███████   ███   ██      ██   ██  █████ 
██  ██  ██      ██   ██   ███    ██ ██  ██      ██   ██ ██   ██
██   ██ █████   ██        ███   ███████ ██      ███████ ██   ██
██  ██  ██      ██   ██   ███   ██   ██ ██      ██   ██ ██   ██
█████   ███████  █████    ███   ██   ██ ███████ ██   ██  █████ 
" -ForegroundColor Green


Write-Host ""
Write-Host "           GERADOR DE ATALHOS PARA APLICATIVOS WEB" -ForegroundColor Cyan
Write-Host ""

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkCyan

Write-Host "Atalho '$Nome' criado em: $Desktop\$Nome.lnk" -ForegroundColor Green
if ($temIcone) { Write-Host "Icone aplicado: $lnkIcon" -ForegroundColor Green }
else { Write-Host "Favicon nao encontrado - usando icone do navegador." -ForegroundColor Yellow }