# irm https://github.com/varun86/Aether-IDE/blob/main/install-windows.ps1 | iex
# install-windows.ps1

# Error handling for GitHub API calls

function Invoke-GitHubApiCall {
    param(
        [string]$endpoint,
        [string]$method = "GET",
        [string]$body = $null
    )

    $url = "https://api.github.com/$endpoint"
    $headers = @{ "User-Agent" = "PowerShell" }
    $response = $null

    try {
        if ($method -eq "GET") {
            $response = Invoke-RestMethod -Uri $url -Method GET -Headers $headers
        } else {
            $response = Invoke-RestMethod -Uri $url -Method $method -Headers $headers -Body $body
        }
    } catch {
        Write-Error "API call failed: $_"
        exit 1
    }

    return $response
}

# File validation
function Validate-File {
    param(
        [string]$filePath
    )

    if (-Not (Test-Path $filePath)) {
        Write-Error "File not found: $filePath"
        exit 1
    }
}

# Unblock files if needed
function Unblock-File {
    param(
        [string]$filePath
    )

    if (Get-Item $filePath | Select-Object -ExpandProperty Attributes -ErrorAction SilentlyContinue -eq "ReadOnly") {
        Write-Host "Unblocking file: $filePath"
        Unblock-File -Path $filePath
    }
}

# Exit code verification
function Verify-ExitCode {
    param(
        [int]$exitCode
    )

    if ($exitCode -ne 0) {
        Write-Error "Process exited with code: $exitCode"
        exit $exitCode
    }
}

# Automatic cleanup on failures
function Cleanup {
    param(
        [string]$tempDir
    )

    if (Test-Path $tempDir) {
        Remove-Item -Path $tempDir -Recurse -Force
        Write-Host "Cleaned up temporary directory: $tempDir"
    }
}

# Main script starts here
$tempDir = "C:\Temp\AetherIDE"

# Validate and unblock files
Validate-File -filePath "$tempDir\install-windows.ps1"
Unblock-File -filePath "$tempDir\install-windows.ps1"

# Perform actions, e.g., invoking GitHub API
$response = Invoke-GitHubApiCall -endpoint "user/repos" -method "GET"
Verify-ExitCode -exitCode $LASTEXITCODE

# Cleanup on completion
Cleanup -tempDir $tempDir