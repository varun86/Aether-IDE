# install-windows.ps1 — Aether IDE installer for Windows
# Usage: irm https://raw.githubusercontent.com/varun86/Aether-IDE/main/install-windows.ps1 | iex

$ErrorActionPreference = "Stop"
$REPO = "varun86/Aether-IDE"

Write-Host "Aether IDE - Installation Windows" -ForegroundColor Cyan
Write-Host ""

# --- Check for Administrator ---
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $isAdmin) {
    Write-Host "ERREUR: Ce script doit être exécuté en tant qu'Administrateur." -ForegroundColor Red
    Write-Host "Fermez cette fenêtre et relancez PowerShell en tant qu'Administrateur." -ForegroundColor Yellow
    Write-Host "Appuyez sur une touche pour quitter..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

# --- GitHub API avec User-Agent (évite le rate limiting) ---
$headers = @{ "User-Agent" = "Aether-IDE-Installer" }
if ($env:GITHUB_TOKEN) {
    $headers["Authorization"] = "token $env:GITHUB_TOKEN"
}

Write-Host "-> Récupération de la dernière version..." -ForegroundColor Gray
try {
    $release = Invoke-RestMethod -Uri "https://api.github.com/repos/$REPO/releases/latest" -Headers $headers -ErrorAction Stop
} catch {
    Write-Host "ERREUR : Impossible de contacter GitHub API. Vérifiez votre connexion." -ForegroundColor Red
    Write-Host "Détail : $_" -ForegroundColor Gray
    exit 1
}

# Vérifier si une release existe
if (-not $release -or -not $release.tag_name) {
    Write-Host "ERREUR : Aucune release trouvée dans le dépôt $REPO" -ForegroundColor Red
    Write-Host "Veuillez demander à l'auteur de créer une release contenant un installateur Windows." -ForegroundColor Yellow
    Write-Host "Dépôt : https://github.com/$REPO/releases" -ForegroundColor Cyan
    exit 1
}

$version = $release.tag_name
Write-Host "OK Version : $version" -ForegroundColor Green

# --- Trouver l'installateur (patterns : setup, installer, .exe) ---
$asset = $release.assets | Where-Object { $_.name -match "setup|installer" -and $_.name -like "*.exe" } | Select-Object -First 1
if (-not $asset) {
    $asset = $release.assets | Where-Object { $_.name -like "*.exe" } | Select-Object -First 1
}
if (-not $asset) {
    Write-Host "ERREUR : Aucun fichier .exe trouvé dans la release $version." -ForegroundColor Red
    Write-Host "Assets disponibles : $($release.assets.name -join ', ')" -ForegroundColor Gray
    Write-Host "Téléchargez manuellement : https://github.com/$REPO/releases/latest"
    exit 1
}

$url = $asset.browser_download_url
$tmpFile = Join-Path $env:TEMP "aether-ide-setup.exe"

# --- Téléchargement ---
Write-Host "-> Téléchargement de $($asset.name)..." -ForegroundColor Gray
try {
    Invoke-WebRequest -Uri $url -OutFile $tmpFile -UseBasicParsing -Headers $headers -ErrorAction Stop
} catch {
    Write-Host "ERREUR : Échec du téléchargement : $_" -ForegroundColor Red
    exit 1
}
Write-Host "OK Téléchargé ($([math]::Round((Get-Item $tmpFile).Length / 1MB, 2)) Mo)" -ForegroundColor Green

# --- Débloquer le fichier (ignore si non bloqué) ---
Unblock-File -Path $tmpFile -ErrorAction SilentlyContinue

# --- Installation silencieuse ---
Write-Host "-> Installation (cela peut prendre une minute)..." -ForegroundColor Gray
$process = Start-Process -FilePath $tmpFile -ArgumentList "/S" -Wait -PassThru
Remove-Item $tmpFile -Force -ErrorAction SilentlyContinue

if ($process.ExitCode -ne 0) {
    Write-Host "ERREUR : L'installateur a échoué avec le code $($process.ExitCode)." -ForegroundColor Red
    Write-Host "Essayez de télécharger et d'exécuter manuellement : $url" -ForegroundColor Yellow
    exit $process.ExitCode
}

Write-Host ""
Write-Host "Aether IDE installé avec succès !" -ForegroundColor Green
Write-Host "Lance-le depuis le menu Démarrer ou le raccourci Bureau."
Write-Host ""
Write-Host "Recommandations :" -ForegroundColor Cyan
Write-Host "  - IA locale : winget install Ollama.Ollama" -ForegroundColor Gray
Write-Host "  - Debugger Python : pip install debugpy" -ForegroundColor Gray
