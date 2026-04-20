# install-windows.ps1 — Aether IDE installer for Windows (varun86/Aether-IDE)
# Usage: irm https://raw.githubusercontent.com/varun86/Aether-IDE/main/install-windows.ps1 | iex

$ErrorActionPreference = "Stop"
$REPO = "varun86/Aether-IDE"

Write-Host "Aether IDE - Installation Windows" -ForegroundColor Cyan
Write-Host ""

# --- Self-elevation if not running as Administrator ---
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Elevation requise. Relance en tant qu'administrateur..." -ForegroundColor Yellow
    $scriptPath = "-File `"$PSCommandPath`""
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass $scriptPath"
    exit 0
}

# --- GitHub API with user-agent (avoid rate limiting) ---
$headers = @{ "User-Agent" = "Aether-IDE-Installer" }
if ($env:GITHUB_TOKEN) {
    $headers["Authorization"] = "token $env:GITHUB_TOKEN"
}

Write-Host "-> Récupération de la dernière version..." -ForegroundColor Gray
try {
    $release = Invoke-RestMethod -Uri "https://api.github.com/repos/$REPO/releases/latest" -Headers $headers
} catch {
    Write-Host "ERREUR : Impossible de contacter GitHub API. Vérifiez votre connexion." -ForegroundColor Red
    exit 1
}
$version = $release.tag_name
Write-Host "OK Version : $version" -ForegroundColor Green

# --- Trouver l'installeur (patterns : setup, installer, .exe) ---
$asset = $release.assets | Where-Object { $_.name -match "setup|installer" -and $_.name -like "*.exe" } | Select-Object -First 1
if (-not $asset) {
    $asset = $release.assets | Where-Object { $_.name -like "*.exe" } | Select-Object -First 1
}
if (-not $asset) {
    Write-Host "ERREUR : Aucun fichier .exe trouvé dans la dernière release." -ForegroundColor Red
    Write-Host "Téléchargez manuellement : https://github.com/$REPO/releases/latest"
    exit 1
}

$url = $asset.browser_download_url
$tmpFile = Join-Path $env:TEMP "aether-ide-setup.exe"

# --- Téléchargement ---
Write-Host "-> Téléchargement de $($asset.name)..." -ForegroundColor Gray
try {
    Invoke-WebRequest -Uri $url -OutFile $tmpFile -UseBasicParsing -Headers $headers
} catch {
    Write-Host "ERREUR : Échec du téléchargement : $_" -ForegroundColor Red
    exit 1
}
Write-Host "OK Téléchargé" -ForegroundColor Green

# --- Débloquer (ignore si non bloqué) ---
Unblock-File -Path $tmpFile -ErrorAction SilentlyContinue
Write-Host "OK Fichier débloqué (si nécessaire)" -ForegroundColor Green

# --- Installation silencieuse ---
Write-Host "-> Installation (cela peut prendre une minute)..." -ForegroundColor Gray
$process = Start-Process -FilePath $tmpFile -ArgumentList "/S" -Wait -PassThru
Remove-Item $tmpFile -Force

if ($process.ExitCode -ne 0) {
    Write-Host "ERREUR : L'installeur a échoué avec le code $($process.ExitCode)." -ForegroundColor Red
    Write-Host "Essayez de télécharger et d'exécuter manuellement : $url" -ForegroundColor Yellow
    exit $process.ExitCode
}

Write-Host ""
Write-Host "Aether IDE installé avec succès !" -ForegroundColor Green
Write-Host "Lance-le depuis le menu Démarrer ou le raccourci Bureau."
Write-Host ""
Write-Host "IA locale : winget install Ollama.Ollama" -ForegroundColor Gray
Write-Host "Debugger Python : pip install debugpy" -ForegroundColor Gray
