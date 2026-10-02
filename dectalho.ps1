Clear-Host

$items = @(
    "DecTalho-2.0",
    "DecTalho-1.0",
    "DecTalho-1.1",
    "Funcionalidade",
    "Sair"
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
Write-Host "Selecionado: $selected" -ForegroundColor Green

switch ($selected) {

    "DecTalho-2.0" {
        & ".\dectalho-2.0\dectalho-app.ps1"
    }

    "DecTalho-1.0" {
        & ".\dectalho-1.0\DECTALHO-1.0.bat"
    }

    "Funcionalidade" {
        Start-Process "https://github.com/davserv/DecTalho"
        exit
    }

    "Sair" {
        exit
    }
}

Read-Host "Pressione ENTER para sair"
Funcionalidade