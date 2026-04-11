# install-windows.ps1 — Aether IDE installer for Windows
# Usage: irm https://raw.githubusercontent.com/USERNAME/aether-ide/main/install-windows.ps1 | iex

$ErrorActionPreference = "Stop"
$REPO = "USERNAME/aether-ide"

Write-Host "Aether IDE - Installation Windows" -ForegroundColor Cyan
Write-Host ""

# Récupérer la dernière release
Write-Host "-> Récupération de la dernière version..." -ForegroundColor Gray
$release = Invoke-RestMethod "https://api.github.com/repos/$REPO/releases/latest"
$version = $release.tag_name
Write-Host "OK Version : $version" -ForegroundColor Green

# Trouver l'installeur NSIS (.exe)
$asset = $release.assets | Where-Object { $_.name -like "*x64-setup.exe" } | Select-Object -First 1
if (-not $asset) {
    $asset = $release.assets | Where-Object { $_.name -like "*.exe" } | Select-Object -First 1
}

if (-not $asset) {
    Write-Host "ERREUR : Impossible de trouver l'installeur" -ForegroundColor Red
    Write-Host "Téléchargez manuellement : https://github.com/$REPO/releases/latest"
    exit 1
}

$url = $asset.browser_download_url
$tmpFile = Join-Path $env:TEMP "aether-ide-setup.exe"

# Télécharger
Write-Host "-> Téléchargement de $($asset.name)..." -ForegroundColor Gray
Invoke-WebRequest -Uri $url -OutFile $tmpFile -UseBasicParsing
Write-Host "OK Téléchargé" -ForegroundColor Green

# Débloquer le fichier (contourne SmartScreen pour les fichiers téléchargés)
Unblock-File -Path $tmpFile
Write-Host "OK Fichier débloqué" -ForegroundColor Green

# Installer silencieusement
Write-Host "-> Installation..." -ForegroundColor Gray
Start-Process -FilePath $tmpFile -ArgumentList "/S" -Wait
Remove-Item $tmpFile -Force

Write-Host ""
Write-Host "Aether IDE installé avec succès !" -ForegroundColor Green
Write-Host "Lance-le depuis le menu Démarrer ou le raccourci Bureau."
Write-Host ""
Write-Host "IA locale : winget install Ollama.Ollama" -ForegroundColor Gray
Write-Host "Debugger Python : pip install debugpy" -ForegroundColor Gray
