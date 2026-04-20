# Debug installer for varun86/Aether-IDE
$ErrorActionPreference = "Stop"
$REPO = "varun86/Aether-IDE"

Write-Host "Aether IDE - Installation Windows (debug)" -ForegroundColor Cyan
Write-Host ""

# Check if running as admin
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $isAdmin) {
    Write-Host "ERREUR: Ce script doit être exécuté en tant qu'Administrateur." -ForegroundColor Red
    Write-Host "Fermez cette fenêtre et relancez PowerShell en tant qu'Administrateur." -ForegroundColor Yellow
    exit 1
}

# GitHub API call
Write-Host "-> Récupération de la dernière release..." -ForegroundColor Gray
try {
    $release = Invoke-RestMethod -Uri "https://api.github.com/repos/$REPO/releases/latest" -Headers @{"User-Agent"="Aether-IDE-Installer"}
} catch {
    Write-Host "ERREUR: Impossible d'accéder à GitHub API." -ForegroundColor Red
    Write-Host "Détails: $_" -ForegroundColor Red
    exit 1
}

if (-not $release -or -not $release.tag_name) {
    Write-Host "ERREUR: Aucune release trouvée dans le dépôt $REPO" -ForegroundColor Red
    Write-Host "Vérifiez que des releases existent: https://github.com/$REPO/releases" -ForegroundColor Yellow
    exit 1
}

$version = $release.tag_name
Write-Host "OK Dernière version: $version" -ForegroundColor Green

# Find installer asset
$asset = $release.assets | Where-Object { $_.name -match "setup|installer" -and $_.name -like "*.exe" } | Select-Object -First 1
if (-not $asset) {
    $asset = $release.assets | Where-Object { $_.name -like "*.exe" } | Select-Object -First 1
}
if (-not $asset) {
    Write-Host "ERREUR: Aucun fichier .exe trouvé dans la release." -ForegroundColor Red
    Write-Host "Assets disponibles: $($release.assets.name -join ', ')" -ForegroundColor Gray
    exit 1
}

Write-Host "-> Fichier trouvé: $($asset.name)" -ForegroundColor Gray
$url = $asset.browser_download_url
$tmpFile = Join-Path $env:TEMP "aether-ide-setup.exe"

# Download
Write-Host "-> Téléchargement..." -ForegroundColor Gray
Invoke-WebRequest -Uri $url -OutFile $tmpFile -UseBasicParsing
Unblock-File -Path $tmpFile -ErrorAction SilentlyContinue
Write-Host "OK Téléchargé: $tmpFile" -ForegroundColor Green

# Install silently
Write-Host "-> Exécution de l'installateur (peut prendre une minute)..." -ForegroundColor Gray
$proc = Start-Process -FilePath $tmpFile -ArgumentList "/S" -Wait -PassThru
Remove-Item $tmpFile -Force

if ($proc.ExitCode -ne 0) {
    Write-Host "ERREUR: L'installateur a échoué avec le code $($proc.ExitCode)" -ForegroundColor Red
    Write-Host "Essayez de l'exécuter manuellement: $url" -ForegroundColor Yellow
    exit $proc.ExitCode
}

Write-Host ""
Write-Host "Aether IDE installé avec succès !" -ForegroundColor Green
Write-Host "Lance-le depuis le menu Démarrer ou le raccourci Bureau."
