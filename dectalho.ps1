Clear-Host

$items = @(
    "DECTALHO-2.0",
    "DECTALHO-1.0",
    "DECTALHO-1.1",
    "FUNCIONALIDADE",
    "SAIR"
)

$index = 0
$selected = $null

while ($null -eq $selected) {

Clear-Host

Write-Host ""
Write-Host "
█████   ███████  █████  ███████   ███   ██      ██   ██  █████ 
██  ██  ██      ██   ██   ███    ██ ██  ██      ██   ██ ██   ██
██   ██ █████   ██        ███   ███████ ██      ███████ ██   ██
██  ██  ██      ██   ██   ███   ██   ██ ██      ██   ██ ██   ██
█████   ███████  █████    ███   ██   ██ ███████ ██   ██  █████ 
" -ForegroundColor Green

    Write-Host ""
    Write-Host "             GERADOR DE ATALHOS PARA APLICATIVOS WEB                " -ForegroundColor Cyan
    Write-Host ""

    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkCyan

    Write-Host "MENU PRINCIPAL" -ForegroundColor Cyan
    Write-Host ""

    for ($i = 0; $i -lt $items.Count; $i++) {
        if ($i -eq $index) {
            Write-Host "➜ $($items[$i])" -ForegroundColor Cyan
        }
        else {
            Write-Host "  $($items[$i])"
        }
    }

    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkCyan

    $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

    switch ($key.VirtualKeyCode) {

        38 { # ↑
            if ($index -gt 0) {
                $index--
            }
        }

        40 { # ↓
            if ($index -lt ($items.Count - 1)) {
                $index++
            }
        }

        13 { # Enter
            $selected = $items[$index]
        }
    }
}

Clear-Host
Write-Host "SELECIONADO: $selected" -ForegroundColor Green

switch ($selected) {

    "DECTALHO-2.0" {

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

        & ".\dectalho-2.0\dectalho-app.ps1"
    }

    "DECTALHO-1.0" {

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

        & ".\dectalho-1.0\DECTALHO-1.0.bat"
    }

    "DECTALHO-1.1" {
        & ".\dectalho-1.1\dectalho.bat"
    }

    "FUNCIONALIDADE" {
        Start-Process "https://github.com/davserv/DecTalho"
        exit
    }

    "SAIR" {
        exit
    }
}

Read-Host "PRESSIONE ENTER PARA SAIR"
