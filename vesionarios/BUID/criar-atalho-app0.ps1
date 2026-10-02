param(
    [Parameter(Mandatory)] [string]$Nome,
    [Parameter(Mandatory)] [string]$Url,
    [ValidateSet('chrome','edge')] [string]$Navegador = 'edge'
)

if ($Navegador -eq 'edge') {
    $Exe = @(
        "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe",
        "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe"
    ) | Where-Object { Test-Path $_ } | Select-Object -First 1
}
else {
    $Exe = @(
        "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
        "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe"
    ) | Where-Object { Test-Path $_ } | Select-Object -First 1
}

if (-not $Exe) { Write-Error 'Navegador não encontrado.'; exit 1 }

 $Desktop = [Environment]::GetFolderPath('Desktop')
 $ws  = New-Object -ComObject WScript.Shell
 $lnk = $ws.CreateShortcut("$Desktop\$Nome.lnk")
 $lnk.TargetPath   = $Exe
 $lnk.Arguments    = "--app=$Url"
 $lnk.IconLocation = "$Exe,0"
 $lnk.Description  = "Modo aplicativo: $Url"
 $lnk.Save()

Write-Host "Atalho '$Nome' criado em: $Desktop\$Nome.lnk" -ForegroundColor Green