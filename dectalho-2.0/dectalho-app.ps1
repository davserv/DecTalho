param(

    [Parameter(Mandatory)] [string]$Nome,
    [Parameter(Mandatory)] [string]$Url,
    [ValidateSet('chrome','edge')] [string]$Navegador = 'edge',
    [string]$Icono
)

 $ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# ---------- localiza o navegador ----------
if ($Navegador -eq 'edge') {
    $Exe = @("$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe",
             "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe") |
           Where-Object { Test-Path $_ } | Select-Object -First 1
} else {
    $Exe = @("$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
             "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe") |
           Where-Object { Test-Path $_ } | Select-Object -First 1
}
if (-not $Exe) { Write-Error 'Navegador nao encontrado.'; exit 1 }

# ---------- pastas e funcoes de icone ----------
 $IcoDir  = Join-Path $env:LOCALAPPDATA 'AtalhosApp\icones'
New-Item -ItemType Directory -Force -Path $IcoDir | Out-Null
 $IcoPath = Join-Path $IcoDir "$Nome.ico"
 $lnkIcon = $null

function Get-BytesSeguros($content) {
    if ($content -is [string]) { return [System.Text.Encoding]::UTF8.GetBytes($content) }
    return [byte[]]$content
}

function Test-EhIco($bytes) {
    $bytes.Length -ge 4 -and $bytes[0] -eq 0 -and $bytes[1] -eq 0 -and $bytes[2] -eq 1 -and $bytes[3] -eq 0
}

function Convert-ParaIco($bytes, $destino) {
    $bytes = Get-BytesSeguros $bytes
    $ms  = New-Object System.IO.MemoryStream(,$bytes)
    $img = [System.Drawing.Image]::FromStream($ms)
    $bmp = New-Object System.Drawing.Bitmap $img, 64, 64
    $ico = [System.Drawing.Icon]::FromHandle($bmp.GetHicon())
    $fs  = [System.IO.File]::Create($destino)
    $ico.Save($fs); $fs.Close()
    $ico.Dispose(); $bmp.Dispose(); $img.Dispose(); $ms.Dispose()
}

function Get-FaviconDoSite($url) {
    $dominio = ([uri]$url).Host
    try {
        $r = Invoke-WebRequest "$($url.TrimEnd('/'))/favicon.ico" -UseBasicParsing -TimeoutSec 10
        $b = Get-BytesSeguros $r.Content
        if (Test-EhIco $b) { return $b }
    } catch {}
    try {
        $r = Invoke-WebRequest "https://icons.duckduckgo.com/ip3/$dominio.ico" -UseBasicParsing -TimeoutSec 10
        $b = Get-BytesSeguros $r.Content
        if (Test-EhIco $b) { return $b }
    } catch {}
    try {
        $r = Invoke-WebRequest "https://www.google.com/s2/favicons?domain=https://$dominio&sz=64" -UseBasicParsing -TimeoutSec 10
       #-- $r = Invoke-WebRequest "https://www.google.com/s2/favicons?domain=$dominio&sz=64" -UseBasicParsing -TimeoutSec 10
        $b = Get-BytesSeguros $r.Content
        if ($b.Length -gt 0) { return $b }
    } catch {}
    return $null
}

# ---------- obtem o icone ----------
 $temIcone = $false
try {
    if ($Icono) {
        if ($Icono -match '^https?://') {
            $r = Invoke-WebRequest $Icono -UseBasicParsing -TimeoutSec 15
            $b = Get-BytesSeguros $r.Content
            if (Test-EhIco $b) { [IO.File]::WriteAllBytes($IcoPath, $b) }
            else { Convert-ParaIco $b $IcoPath }
            $lnkIcon = $IcoPath; $temIcone = $true
        }
        elseif (Test-Path $Icono) {
            if ($Icono -match '\.(ico|exe|dll)$') { $lnkIcon = $Icono }
            else { Convert-ParaIco ([IO.File]::ReadAllBytes($Icono)) $IcoPath; $lnkIcon = $IcoPath }
            $temIcone = $true
        }
    } else {
        $bytes = Get-FaviconDoSite $Url
        if ($bytes) {
            if (Test-EhIco $bytes) { [IO.File]::WriteAllBytes($IcoPath, $bytes) }
            else { Convert-ParaIco $bytes $IcoPath }
            $lnkIcon = $IcoPath; $temIcone = $true
        }
    }
} catch { Write-Warning "NAO FOI POSSIVEL OBTER O ICONE: $_" }

# ---------- cria o atalho ----------
 $Desktop = [Environment]::GetFolderPath('Desktop')
 $ws  = New-Object -ComObject WScript.Shell
 $lnk = $ws.CreateShortcut("$Desktop\$Nome.lnk")
 $lnk.TargetPath   = $Exe
 $lnk.Arguments    = "--app=$Url"
 $lnk.Description  = "Modo aplicativo: $Url"
 $lnk.IconLocation = if ($temIcone) { "$lnkIcon,0" } else { "$Exe,0" }
 $lnk.Save()


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

Write-Host "ATALHO '$Nome' CRIADO EM: $Desktop\$Nome.lnk" -ForegroundColor Green
if ($temIcone) { Write-Host "ICONE APLICADO: $lnkIcon" -ForegroundColor Green }
else { Write-Host "FAVICON NAO ENCONTRADO - USANDO ICONE DO NAVEGADOR." -ForegroundColor Yellow }