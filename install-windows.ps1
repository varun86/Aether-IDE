# PowerShell script to install Aether IDE on Windows

# Error handling
try {
    # Validate if the necessary prerequisites are met
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        throw "Git is not installed. Please install Git before running this script."
    }
    
    # Validation of repository name
    $repoName = "Aether-IDE"
    # Example: Replace with actual logic to validate the repository
    if (-not (Test-Path "https://github.com/varun86/$repoName")) {
        throw "Repository '$repoName' does not exist."
    }
    
    # Downloading the installer
    Write-Host "Downloading Aether IDE..."
    Invoke-WebRequest -Uri "https://github.com/varun86/$repoName/releases/latest/download/installer.exe" -OutFile "installer.exe"

    # Install the application
    Write-Host "Installing Aether IDE..."
    Start-Process -FilePath "installer.exe" -ArgumentList '/S' -Wait
    
    # Cleanup temporary files
    Remove-Item -Path "installer.exe" -Force
    Write-Host "Installation completed. Temporary files removed." 
} catch {
    Write-Host "An error occurred: $_.Exception.Message"
}